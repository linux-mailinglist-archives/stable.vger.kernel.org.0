Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C29353FB5
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238787AbhDEJNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:13:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239571AbhDEJNt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:13:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1ED861398;
        Mon,  5 Apr 2021 09:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614024;
        bh=SMleM6nJzzA3WMPDL9+Hqmf2DvnayDh6Sa8h2XI5KQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nnkZQdPn0w82Wgj1nthFb8r8CTck2Xvy0vk2xrLVDWGG7tHbTd42+3oHgT+oeSeWw
         SjvCqC6vFipPSVu+JFxPN44KPXTNBDfC5gppwTpk4KOlzsqsGT4IKxGztTXByCCTx3
         SaG5n7JA6T0NiViiws6XIztt/EhH3aqelHWM61XU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Gong <wgong@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 055/152] ath11k: add ieee80211_unregister_hw to avoid kernel crash caused by NULL pointer
Date:   Mon,  5 Apr 2021 10:53:24 +0200
Message-Id: <20210405085036.063945082@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Gong <wgong@codeaurora.org>

[ Upstream commit 0d96968315d7ffbd70d608b29e9bea084210b96d ]

When function return fail to __ath11k_mac_register after success called
ieee80211_register_hw, then it set wiphy->dev.parent to NULL by
SET_IEEE80211_DEV(ar->hw, NULL) in end of __ath11k_mac_register, then
cfg80211_get_drvinfo will be called by below call stack, but the
wiphy->dev.parent is NULL, so kernel crash.

Call stack to cfg80211_get_drvinfo:
NetworkManager   826 [001]  6696.731371:    probe:cfg80211_get_drvinfo: (ffffffffc107d8f0)
        ffffffffc107d8f1 cfg80211_get_drvinfo+0x1 (/lib/modules/5.10.0-rc1-wt-ath+/kernel/net/wireless-back/cfg80211.ko)
        ffffffff9d8fc529 ethtool_get_drvinfo+0x99 (vmlinux)
        ffffffff9d90080e dev_ethtool+0x1dbe (vmlinux)
        ffffffff9d8b88f7 dev_ioctl+0xb7 (vmlinux)
        ffffffff9d8668de sock_do_ioctl+0xae (vmlinux)
        ffffffff9d866d60 sock_ioctl+0x350 (vmlinux)
        ffffffff9d2ca30e __x64_sys_ioctl+0x8e (vmlinux)
        ffffffff9da0dda3 do_syscall_64+0x33 (vmlinux)
        ffffffff9dc0008c entry_SYSCALL_64_after_hwframe+0x44 (vmlinux)
            7feb5f673007 __GI___ioctl+0x7 (/lib/x86_64-linux-gnu/libc-2.23.so)
                       0 [unknown] ([unknown])

Code of cfg80211_get_drvinfo, the pdev which is wiphy->dev.parent is
NULL when kernel crash:
void cfg80211_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
{
	struct wireless_dev *wdev = dev->ieee80211_ptr;
	struct device *pdev = wiphy_dev(wdev->wiphy);

	if (pdev->driver)
....

kernel crash log:
[  973.619550] ath11k_pci 0000:05:00.0: failed to perform regd update : -16
[  973.619555] ath11k_pci 0000:05:00.0: ath11k regd update failed: -16
[  973.619566] ath11k_pci 0000:05:00.0: failed register the radio with mac80211: -16
[  973.619618] ath11k_pci 0000:05:00.0: failed to create pdev core: -16
[  973.636035] BUG: kernel NULL pointer dereference, address: 0000000000000068
[  973.636046] #PF: supervisor read access in kernel mode
[  973.636050] #PF: error_code(0x0000) - not-present page
[  973.636054] PGD 800000012452e067 P4D 800000012452e067 PUD 12452d067 PMD 0
[  973.636064] Oops: 0000 [#1] SMP PTI
[  973.636072] CPU: 3 PID: 848 Comm: NetworkManager Kdump: loaded Tainted: G        W  OE     5.10.0-rc1-wt-ath+ #24
[  973.636076] Hardware name: LENOVO 418065C/418065C, BIOS 83ET63WW (1.33 ) 07/29/2011
[  973.636161] RIP: 0010:cfg80211_get_drvinfo+0x25/0xd0 [cfg80211]
[  973.636169] Code: e9 c9 fe ff ff 66 66 66 66 90 55 53 ba 20 00 00 00 48 8b af 08 03 00 00 48 89 f3 48 8d 7e 04 48 8b 45 00 48 8b 80 90 01 00 00 <48> 8b 40 68 48 85 c0 0f 84 8d 00 00 00 48 8b 30 e8 a6 cc 72 c7 48
[  973.636174] RSP: 0018:ffffaafb4040bbe0 EFLAGS: 00010286
[  973.636180] RAX: 0000000000000000 RBX: ffffaafb4040bbfc RCX: 0000000000000000
[  973.636184] RDX: 0000000000000020 RSI: ffffaafb4040bbfc RDI: ffffaafb4040bc00
[  973.636188] RBP: ffff8a84c9568950 R08: 722d302e30312e35 R09: 74612d74772d3163
[  973.636192] R10: 3163722d302e3031 R11: 2b6874612d74772d R12: ffffaafb4040bbfc
[  973.636196] R13: 00007ffe453707c0 R14: ffff8a84c9568000 R15: 0000000000000000
[  973.636202] FS:  00007fd3d179b940(0000) GS:ffff8a84fa2c0000(0000) knlGS:0000000000000000
[  973.636206] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  973.636211] CR2: 0000000000000068 CR3: 00000001153b6002 CR4: 00000000000606e0
[  973.636215] Call Trace:
[  973.636234]  ethtool_get_drvinfo+0x99/0x1f0
[  973.636246]  dev_ethtool+0x1dbe/0x2be0
[  973.636256]  ? mntput_no_expire+0x35/0x220
[  973.636264]  ? inet_ioctl+0x1ce/0x200
[  973.636274]  ? tomoyo_path_number_perm+0x68/0x1d0
[  973.636282]  ? kmem_cache_alloc+0x3cb/0x430
[  973.636290]  ? dev_ioctl+0xb7/0x570
[  973.636295]  dev_ioctl+0xb7/0x570
[  973.636307]  sock_do_ioctl+0xae/0x150
[  973.636315]  ? sock_ioctl+0x350/0x3c0
[  973.636319]  sock_ioctl+0x350/0x3c0
[  973.636332]  ? __x64_sys_ioctl+0x8e/0xd0
[  973.636339]  ? dlci_ioctl_set+0x30/0x30
[  973.636346]  __x64_sys_ioctl+0x8e/0xd0
[  973.636359]  do_syscall_64+0x33/0x80
[  973.636368]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Sequence of function call when wlan load for success case when function
__ath11k_mac_register return 0:

kworker/u16:3-e  2922 [001]  6696.729734:   probe:ieee80211_register_hw: (ffffffffc116ae60)
kworker/u16:3-e  2922 [001]  6696.730210:        probe:ieee80211_if_add: (ffffffffc1185cc0)
NetworkManager   826 [001]  6696.731345:     probe:ethtool_get_drvinfo: (ffffffff9d8fc490)
NetworkManager   826 [001]  6696.731371:    probe:cfg80211_get_drvinfo: (ffffffffc107d8f0)
NetworkManager   826 [001]  6696.731639:     probe:ethtool_get_drvinfo: (ffffffff9d8fc490)
NetworkManager   826 [001]  6696.731653:    probe:cfg80211_get_drvinfo: (ffffffffc107d8f0)
NetworkManager   826 [001]  6696.732866:     probe:ethtool_get_drvinfo: (ffffffff9d8fc490)
NetworkManager   826 [001]  6696.732893:    probe:cfg80211_get_drvinfo: (ffffffffc107d8f0)
systemd-udevd  3850 [003]  6696.737199:     probe:ethtool_get_drvinfo: (ffffffff9d8fc490)
systemd-udevd  3850 [003]  6696.737226:    probe:cfg80211_get_drvinfo: (ffffffffc107d8f0)
NetworkManager   826 [000]  6696.759950:     probe:ethtool_get_drvinfo: (ffffffff9d8fc490)
NetworkManager   826 [000]  6696.759967:    probe:cfg80211_get_drvinfo: (ffffffffc107d8f0)
NetworkManager   826 [000]  6696.760057:     probe:ethtool_get_drvinfo: (ffffffff9d8fc490)
NetworkManager   826 [000]  6696.760062:    probe:cfg80211_get_drvinfo: (ffffffffc107d8f0)

After apply this patch, kernel crash gone, and below is the test case's
sequence of function call and log when wlan load with fail by function
ath11k_regd_update, and __ath11k_mac_register return fail:

kworker/u16:5-e   192 [001]   215.174388:   probe:ieee80211_register_hw: (ffffffffc1131e60)
kworker/u16:5-e   192 [000]   215.174973:        probe:ieee80211_if_add: (ffffffffc114ccc0)
NetworkManager   846 [001]   215.175857:     probe:ethtool_get_drvinfo: (ffffffff928fc490)
kworker/u16:5-e   192 [000]   215.175867: probe:ieee80211_unregister_hw: (ffffffffc1131970)
NetworkManager   846 [001]   215.175880:    probe:cfg80211_get_drvinfo: (ffffffffc107f8f0)
NetworkManager   846 [001]   215.176105:     probe:ethtool_get_drvinfo: (ffffffff928fc490)
NetworkManager   846 [001]   215.176118:    probe:cfg80211_get_drvinfo: (ffffffffc107f8f0)
[  215.175859] ath11k_pci 0000:05:00.0: ath11k regd update failed: -16
NetworkManager   846 [001]   215.196420:     probe:ethtool_get_drvinfo: (ffffffff928fc490)
NetworkManager   846 [001]   215.196430:    probe:cfg80211_get_drvinfo: (ffffffffc107f8f0)
[  215.258598] ath11k_pci 0000:05:00.0: failed register the radio with mac80211: -16
[  215.258613] ath11k_pci 0000:05:00.0: failed to create pdev core: -16

When ath11k_regd_update or ath11k_debugfs_register return fail, function
ieee80211_unregister_hw of mac80211 will be called, then it will wait
untill cfg80211_get_drvinfo finished, the wiphy->dev.parent is not NULL
at this moment, after that, it set wiphy->dev.parent to NULL by
SET_IEEE80211_DEV(ar->hw, NULL) in end of __ath11k_mac_register, so
not happen kernel crash.

Tested-on: QCA6390 hw2.0 PCI WLAN.HST.1.0.1-01740-QCAHSTSWPLZ_V2_TO_X86-1
Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1608607824-16067-1-git-send-email-wgong@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 54bdef33f3f8..55ecf7f43735 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -6361,17 +6361,20 @@ static int __ath11k_mac_register(struct ath11k *ar)
 	ret = ath11k_regd_update(ar, true);
 	if (ret) {
 		ath11k_err(ar->ab, "ath11k regd update failed: %d\n", ret);
-		goto err_free_if_combs;
+		goto err_unregister_hw;
 	}
 
 	ret = ath11k_debugfs_register(ar);
 	if (ret) {
 		ath11k_err(ar->ab, "debugfs registration failed: %d\n", ret);
-		goto err_free_if_combs;
+		goto err_unregister_hw;
 	}
 
 	return 0;
 
+err_unregister_hw:
+	ieee80211_unregister_hw(ar->hw);
+
 err_free_if_combs:
 	kfree(ar->hw->wiphy->iface_combinations[0].limits);
 	kfree(ar->hw->wiphy->iface_combinations);
-- 
2.30.1



