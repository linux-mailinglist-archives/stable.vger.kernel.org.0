Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5B25498C1
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235992AbiFMKTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242139AbiFMKRy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:17:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC37DEB2;
        Mon, 13 Jun 2022 03:15:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AF091CE1106;
        Mon, 13 Jun 2022 10:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C672C34114;
        Mon, 13 Jun 2022 10:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115344;
        bh=ijCvAG5D6KxVV9sw1XIyTUNpxJ2pxD5vlmvuuYWonXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5vhYobMVQ91+StLHbTulK04VjjTBP1MVKByl/ylL5jeV01+RBGT4wtX7eXOleaQj
         MuC4PrNkaa21CMNRFAwvwr/9Se0vddAYKMVzsC6bhM2tIpTT6MusiGwu7mVdiizPUW
         wBeFfi3E7yU4seXdABcCAqEkt9KxmEQ3zk16GN40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Teh <jonathan.teh@outlook.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 042/167] HID: hid-led: fix maximum brightness for Dream Cheeky
Date:   Mon, 13 Jun 2022 12:08:36 +0200
Message-Id: <20220613094850.790751050@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
References: <20220613094840.720778945@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Teh <jonathan.teh@outlook.com>

[ Upstream commit 116c3f4a78ebe478d5ad5a038baf931e93e7d748 ]

Increase maximum brightness for Dream Cheeky to 63. Emperically
determined based on testing in kernel 4.4 on this device:

Bus 003 Device 002: ID 1d34:0004 Dream Cheeky Webmail Notifier

Fixes: 6c7ad07e9e05 ("HID: migrate USB LED driver from usb misc to hid")
Signed-off-by: Jonathan Teh <jonathan.teh@outlook.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-led.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-led.c b/drivers/hid/hid-led.c
index d3e1ab162f7c..7fc5982a0ca4 100644
--- a/drivers/hid/hid-led.c
+++ b/drivers/hid/hid-led.c
@@ -369,7 +369,7 @@ static const struct hidled_config hidled_configs[] = {
 		.type = DREAM_CHEEKY,
 		.name = "Dream Cheeky Webmail Notifier",
 		.short_name = "dream_cheeky",
-		.max_brightness = 31,
+		.max_brightness = 63,
 		.num_leds = 1,
 		.report_size = 9,
 		.report_type = RAW_REQUEST,
-- 
2.35.1



