Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC50594A28
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242815AbiHOXRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353338AbiHOXQT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:16:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22B3147428;
        Mon, 15 Aug 2022 13:03:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF1E16068D;
        Mon, 15 Aug 2022 20:03:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029D9C433D6;
        Mon, 15 Aug 2022 20:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593784;
        bh=ZRVOLgopQgv/+zQaoA40b3/YGFhX9/yyPoY4VbifVdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qGCjWYdd9U3XDF6lNRomUOWB2tSEju1hVc+/Y2DY72JGRRwjj5nT69tihdwwdpOWv
         3TvLKfXaj5vmcuvPl/46St4zuAQYU1/MTyJJk65vaRsyHZjifJ9+HgrJ5SMdieS49o
         uW6oV+RC9QCIWmL5VPEHONfdpReKjg0Xnyz9VAP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0325/1157] ath11k: fix netdev open race
Date:   Mon, 15 Aug 2022 19:54:41 +0200
Message-Id: <20220815180452.652767486@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit d4ba1ff87b17e81686ada8f429300876f55f95ad ]

Make sure to allocate resources needed before registering the device.

This specifically avoids having a racing open() trigger a BUG_ON() in
mod_timer() when ath11k_mac_op_start() is called before the
mon_reap_timer as been set up.

I did not see this issue with next-20220310, but I hit it on every probe
with next-20220511. Perhaps some timing changed in between.

Here's the backtrace:

[   51.346947] kernel BUG at kernel/time/timer.c:990!
[   51.346958] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
...
[   51.578225] Call trace:
[   51.583293]  __mod_timer+0x298/0x390
[   51.589518]  mod_timer+0x14/0x20
[   51.595368]  ath11k_mac_op_start+0x41c/0x4a0 [ath11k]
[   51.603165]  drv_start+0x38/0x60 [mac80211]
[   51.610110]  ieee80211_do_open+0x29c/0x7d0 [mac80211]
[   51.617945]  ieee80211_open+0x60/0xb0 [mac80211]
[   51.625311]  __dev_open+0x100/0x1c0
[   51.631420]  __dev_change_flags+0x194/0x210
[   51.638214]  dev_change_flags+0x24/0x70
[   51.644646]  do_setlink+0x228/0xdb0
[   51.650723]  __rtnl_newlink+0x460/0x830
[   51.657162]  rtnl_newlink+0x4c/0x80
[   51.663229]  rtnetlink_rcv_msg+0x124/0x390
[   51.669917]  netlink_rcv_skb+0x58/0x130
[   51.676314]  rtnetlink_rcv+0x18/0x30
[   51.682460]  netlink_unicast+0x250/0x310
[   51.688960]  netlink_sendmsg+0x19c/0x3e0
[   51.695458]  ____sys_sendmsg+0x220/0x290
[   51.701938]  ___sys_sendmsg+0x7c/0xc0
[   51.708148]  __sys_sendmsg+0x68/0xd0
[   51.714254]  __arm64_sys_sendmsg+0x28/0x40
[   51.720900]  invoke_syscall+0x48/0x120

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Fixes: 840c36fa727a ("ath11k: dp: stop rx pktlog before suspend")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220517103436.15867-1-johan+linaro@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index 1e98ff9ff288..c8e0bc935838 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -1225,23 +1225,23 @@ static int ath11k_core_pdev_create(struct ath11k_base *ab)
 		return ret;
 	}
 
-	ret = ath11k_mac_register(ab);
+	ret = ath11k_dp_pdev_alloc(ab);
 	if (ret) {
-		ath11k_err(ab, "failed register the radio with mac80211: %d\n", ret);
+		ath11k_err(ab, "failed to attach DP pdev: %d\n", ret);
 		goto err_pdev_debug;
 	}
 
-	ret = ath11k_dp_pdev_alloc(ab);
+	ret = ath11k_mac_register(ab);
 	if (ret) {
-		ath11k_err(ab, "failed to attach DP pdev: %d\n", ret);
-		goto err_mac_unregister;
+		ath11k_err(ab, "failed register the radio with mac80211: %d\n", ret);
+		goto err_dp_pdev_free;
 	}
 
 	ret = ath11k_thermal_register(ab);
 	if (ret) {
 		ath11k_err(ab, "could not register thermal device: %d\n",
 			   ret);
-		goto err_dp_pdev_free;
+		goto err_mac_unregister;
 	}
 
 	ret = ath11k_spectral_init(ab);
@@ -1254,10 +1254,10 @@ static int ath11k_core_pdev_create(struct ath11k_base *ab)
 
 err_thermal_unregister:
 	ath11k_thermal_unregister(ab);
-err_dp_pdev_free:
-	ath11k_dp_pdev_free(ab);
 err_mac_unregister:
 	ath11k_mac_unregister(ab);
+err_dp_pdev_free:
+	ath11k_dp_pdev_free(ab);
 err_pdev_debug:
 	ath11k_debugfs_pdev_destroy(ab);
 
-- 
2.35.1



