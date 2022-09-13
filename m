Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE145B70C4
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbiIMO0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbiIMOY3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:24:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFF861B3E;
        Tue, 13 Sep 2022 07:16:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3354D614AA;
        Tue, 13 Sep 2022 14:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D038C433C1;
        Tue, 13 Sep 2022 14:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078481;
        bh=tK8jLGZFxiUqU/KoBQfv11nDAqZn1XjBbRjfZ2PNCcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IPGyl6M1xVp0Zr1sF/aCGLL8WMYm4XjI0xw3tzwrNRDDSbgjtOvBaOcstMDu03PoT
         rYcdAuwBrL8j3SjRWgCTC9AJO0wtgsbi9j1Fa13GROBPjC1ck3HHbJm6lwlWTCOnXN
         T0MhjWP2WWn3AwZ39dqiWJ8s8G3+e3r8b33exy94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandru Gagniuc <mr.nuke.me@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.19 156/192] hwmon: (tps23861) fix byte order in resistance register
Date:   Tue, 13 Sep 2022 16:04:22 +0200
Message-Id: <20220913140417.798773592@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Gagniuc <mr.nuke.me@gmail.com>

commit 1f05f65bddd6958d25b133f886da49c1d4bff3fa upstream.

The tps23861 registers are little-endian, and regmap_read_bulk() does
not do byte order conversion. On BE machines, the bytes were swapped,
and the interpretation of the resistance value was incorrect.

To make it work on both big and little-endian machines, use
le16_to_cpu() to convert the resitance register to host byte order.

Signed-off-by: Alexandru Gagniuc <mr.nuke.me@gmail.com>
Fixes: fff7b8ab22554 ("hwmon: add Texas Instruments TPS23861 driver")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220905142806.110598-1-mr.nuke.me@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/tps23861.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/hwmon/tps23861.c
+++ b/drivers/hwmon/tps23861.c
@@ -489,18 +489,20 @@ static char *tps23861_port_poe_plus_stat
 
 static int tps23861_port_resistance(struct tps23861_data *data, int port)
 {
-	u16 regval;
+	unsigned int raw_val;
+	__le16 regval;
 
 	regmap_bulk_read(data->regmap,
 			 PORT_1_RESISTANCE_LSB + PORT_N_RESISTANCE_LSB_OFFSET * (port - 1),
 			 &regval,
 			 2);
 
-	switch (FIELD_GET(PORT_RESISTANCE_RSN_MASK, regval)) {
+	raw_val = le16_to_cpu(regval);
+	switch (FIELD_GET(PORT_RESISTANCE_RSN_MASK, raw_val)) {
 	case PORT_RESISTANCE_RSN_OTHER:
-		return (FIELD_GET(PORT_RESISTANCE_MASK, regval) * RESISTANCE_LSB) / 10000;
+		return (FIELD_GET(PORT_RESISTANCE_MASK, raw_val) * RESISTANCE_LSB) / 10000;
 	case PORT_RESISTANCE_RSN_LOW:
-		return (FIELD_GET(PORT_RESISTANCE_MASK, regval) * RESISTANCE_LSB_LOW) / 10000;
+		return (FIELD_GET(PORT_RESISTANCE_MASK, raw_val) * RESISTANCE_LSB_LOW) / 10000;
 	case PORT_RESISTANCE_RSN_SHORT:
 	case PORT_RESISTANCE_RSN_OPEN:
 	default:


