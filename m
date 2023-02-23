Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 744F56A0954
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234264AbjBWNEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233823AbjBWNEv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:04:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF2824107
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:04:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0F00B81A19
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:04:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFFDC433A1;
        Thu, 23 Feb 2023 13:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157487;
        bh=pRjeYyqkRsD7ib1XC5C/RYZbGtt+Xc4I9KqSKFMrI/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YpDZfNDUkpOPcuMyHBVh9XH5P87pov1sBiqJzDZ0Ub/5ZPAgbho6Dht+E76wt2CFp
         IulyhqFs7o3Tb8prqV+1RwRvOzF1gqmXtNRHerozIJDuBUfr506Q3xHkZUM2FX4jGF
         VzP3msHPBCLUkp1znxGV2pWj4YuWSgEdiYUj9P2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 1/7] wifi: rtl8xxxu: gen2: Turn on the rate control
Date:   Thu, 23 Feb 2023 14:04:38 +0100
Message-Id: <20230223130423.438223497@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130423.369876969@linuxfoundation.org>
References: <20230223130423.369876969@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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
index a287c28b38b5d..f7c879a7a1be3 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4375,12 +4375,9 @@ void rtl8xxxu_gen1_report_connect(struct rtl8xxxu_priv *priv,
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
 
@@ -4393,7 +4390,6 @@ void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
 		h2c.media_status_rpt.parm &= ~BIT(0);
 
 	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.media_status_rpt));
-#endif
 }
 
 void rtl8xxxu_gen1_init_aggregation(struct rtl8xxxu_priv *priv)
-- 
2.39.0



