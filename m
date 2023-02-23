Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B17E6A0A2F
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234501AbjBWNN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:13:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234508AbjBWNNU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:13:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577921B4
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:12:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC60A61709
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAAD9C4339B;
        Thu, 23 Feb 2023 13:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157909;
        bh=7jxKKtyJ7kM/gAdl0rgmVHVyRp0IQzTuAI2o2iyUy/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mSsJhlW2lR5Jc5xkvR9FtKvW1iiCt1JtFTtnbvYVABHlVdMjU2bINIvrr1h7OxGkz
         y2UqoNmC67NanLmucj7Z3WP9Nq6pJYws53pnyT4hdogXra/RpSzEESdOI40gcu0qYB
         UPCvVOM3Feg3a5aedEs/3ee2/PFpveAHrZBezAvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 02/36] wifi: rtl8xxxu: gen2: Turn on the rate control
Date:   Thu, 23 Feb 2023 14:06:38 +0100
Message-Id: <20230223130429.187533490@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130429.072633724@linuxfoundation.org>
References: <20230223130429.072633724@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit 791082ec0ab843e0be07c8ce3678e4c2afd2e33d ]

Re-enable the function rtl8xxxu_gen2_report_connect.

It informs the firmware when connecting to a network. This makes the
firmware enable the rate control, which makes the upload faster.

It also informs the firmware when disconnecting from a network. In the
past this made reconnecting impossible because it was sending the
auth on queue 0x7 (TXDESC_QUEUE_VO) instead of queue 0x12
(TXDESC_QUEUE_MGNT):

wlp0s20f0u3: send auth to 90:55:de:__:__:__ (try 1/3)
wlp0s20f0u3: send auth to 90:55:de:__:__:__ (try 2/3)
wlp0s20f0u3: send auth to 90:55:de:__:__:__ (try 3/3)
wlp0s20f0u3: authentication with 90:55:de:__:__:__ timed out

Probably the firmware disables the unnecessary TX queues when it
knows it's disconnected.

However, this was fixed in commit edd5747aa12e ("wifi: rtl8xxxu: Fix
skb misuse in TX queue selection").

Fixes: c59f13bbead4 ("rtl8xxxu: Work around issue with 8192eu and 8723bu devices not reconnecting")
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/43200afc-0c65-ee72-48f8-231edd1df493@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 7370d92a3bdad..3d3fa2b616a86 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4369,12 +4369,9 @@ void rtl8xxxu_gen1_report_connect(struct rtl8xxxu_priv *priv,
 void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
 				  u8 macid, bool connect)
 {
-#ifdef RTL8XXXU_GEN2_REPORT_CONNECT
 	/*
-	 * Barry Day reports this causes issues with 8192eu and 8723bu
-	 * devices reconnecting. The reason for this is unclear, but
-	 * until it is better understood, leave the code in place but
-	 * disabled, so it is not lost.
+	 * The firmware turns on the rate control when it knows it's
+	 * connected to a network.
 	 */
 	struct h2c_cmd h2c;
 
@@ -4387,7 +4384,6 @@ void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
 		h2c.media_status_rpt.parm &= ~BIT(0);
 
 	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.media_status_rpt));
-#endif
 }
 
 void rtl8xxxu_gen1_init_aggregation(struct rtl8xxxu_priv *priv)
-- 
2.39.0



