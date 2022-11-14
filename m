Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF8D6280B5
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237866AbiKNNI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:08:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237868AbiKNNI0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:08:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4C82AE12
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:08:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC24761173
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD16C433D6;
        Mon, 14 Nov 2022 13:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431299;
        bh=1Le296MTu+nDrcM+GOOjQ4YMT0Od1j/6jGpnPSFBaLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=krDTtWJNnacQ5Xq4b9dQHLGZK3ZjS0VI7iwBYnV3OKoy6k+2ie/KrOGUYdBv3kGK7
         QAeTSP62Mib/L9W+IvV19SdR5FYCs/V6ZrM/7DU1U7bRKj/lOc0iq3bxDa+S+lV7uY
         YSDOlFJMP77Je/B+o9U7s7887jyiwpbSFfaXYWYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wen Gong <quic_wgong@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>
Subject: [PATCH 6.0 145/190] wifi: ath11k: avoid deadlock during regulatory update in ath11k_regd_update()
Date:   Mon, 14 Nov 2022 13:46:09 +0100
Message-Id: <20221114124505.136943532@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Wen Gong <quic_wgong@quicinc.com>

commit f45cb6b29cd36514e13f7519770873d8c0457008 upstream.

(cherry picked from commit d99884ad9e3673a12879bc2830f6e5a66cccbd78 in ath-next
as users are seeing this bug more now, also cc stable)

Running this test in a loop it is easy to reproduce an rtnl deadlock:

iw reg set FI
ifconfig wlan0 down

What happens is that thread A (workqueue) tries to update the regulatory:

    try to acquire the rtnl_lock of ar->regd_update_work

    rtnl_lock+0x17/0x20
    ath11k_regd_update+0x15a/0x260 [ath11k]
    ath11k_regd_update_work+0x15/0x20 [ath11k]
    process_one_work+0x228/0x670
    worker_thread+0x4d/0x440
    kthread+0x16d/0x1b0
    ret_from_fork+0x22/0x30

And thread B (ifconfig) tries to stop the interface:

    try to cancel_work_sync(&ar->regd_update_work) in ath11k_mac_op_stop().
    ifconfig  3109 [003]  2414.232506: probe:

    ath11k_mac_op_stop: (ffffffffc14187a0)
    drv_stop+0x30 ([mac80211])
    ieee80211_do_stop+0x5d2 ([mac80211])
    ieee80211_stop+0x3e ([mac80211])
    __dev_close_many+0x9e ([kernel.kallsyms])
    __dev_change_flags+0xbe ([kernel.kallsyms])
    dev_change_flags+0x23 ([kernel.kallsyms])
    devinet_ioctl+0x5e3 ([kernel.kallsyms])
    inet_ioctl+0x197 ([kernel.kallsyms])
    sock_do_ioctl+0x4d ([kernel.kallsyms])
    sock_ioctl+0x264 ([kernel.kallsyms])
    __x64_sys_ioctl+0x92 ([kernel.kallsyms])
    do_syscall_64+0x3a ([kernel.kallsyms])
    entry_SYSCALL_64_after_hwframe+0x63 ([kernel.kallsyms])
    __GI___ioctl+0x7 (/lib/x86_64-linux-gnu/libc-2.23.so)

The sequence of deadlock is:

1. Thread B calls rtnl_lock().

2. Thread A starts to run and calls rtnl_lock() from within
   ath11k_regd_update_work(), then enters wait state because the lock is owned by
   thread B.

3. Thread B continues to run and tries to call
   cancel_work_sync(&ar->regd_update_work), but thread A is in
   ath11k_regd_update_work() waiting for rtnl_lock(). So cancel_work_sync()
   forever waits for ath11k_regd_update_work() to finish and we have a deadlock.

Fix this by switching from using regulatory_set_wiphy_regd_sync() to
regulatory_set_wiphy_regd(). Now cfg80211 will schedule another workqueue which
handles the locking on it's own. So the ath11k workqueue can simply exit without
taking any locks, avoiding the deadlock.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3

Cc: <stable@vger.kernel.org>
Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
[kvalo: improve commit log]
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath11k/reg.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/net/wireless/ath/ath11k/reg.c
+++ b/drivers/net/wireless/ath/ath11k/reg.c
@@ -287,11 +287,7 @@ int ath11k_regd_update(struct ath11k *ar
 		goto err;
 	}
 
-	rtnl_lock();
-	wiphy_lock(ar->hw->wiphy);
-	ret = regulatory_set_wiphy_regd_sync(ar->hw->wiphy, regd_copy);
-	wiphy_unlock(ar->hw->wiphy);
-	rtnl_unlock();
+	ret = regulatory_set_wiphy_regd(ar->hw->wiphy, regd_copy);
 
 	kfree(regd_copy);
 


