Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446CE56FC26
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbiGKJj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233391AbiGKJje (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:39:34 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDA78AEC2;
        Mon, 11 Jul 2022 02:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 960E3CE1260;
        Mon, 11 Jul 2022 09:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4792C34115;
        Mon, 11 Jul 2022 09:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531217;
        bh=rbumori8la7PN8tsc2VKer19837spjva39ScaQYHsfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EWd2x3VQW092ubChjKEQrqdwtswPKN70ZMmVjlaM+cyM/HeBjkkwRmR0dk1YIhbI5
         VCNpOdosDnXM8OrrBwXNl/x6IufuCwDNO5HpW3Wb0fDEV6dzRM5mmPjpjthhJueyMk
         /4NR2J9GalQ8y6zL1H8/aaTpxmAANUhBGPVSrGOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bastien Nocera <hadess@hadess.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/230] Input: goodix - change goodix_i2c_write() len parameter type to int
Date:   Mon, 11 Jul 2022 11:04:41 +0200
Message-Id: <20220711090604.790267156@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 31ae0102a34ed863c7d32b10e768036324991679 ]

Change the type of the goodix_i2c_write() len parameter to from 'unsigned'
to 'int' to avoid bare use of 'unsigned', changing it to 'int' makes
goodix_i2c_write()' prototype consistent with goodix_i2c_read().

Reviewed-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210920150643.155872-2-hdegoede@redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/goodix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index 5051a1766aac..1eb776abe562 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -246,7 +246,7 @@ static int goodix_i2c_read(struct i2c_client *client,
  * @len: length of the buffer to write
  */
 static int goodix_i2c_write(struct i2c_client *client, u16 reg, const u8 *buf,
-			    unsigned len)
+			    int len)
 {
 	u8 *addr_buf;
 	struct i2c_msg msg;
-- 
2.35.1



