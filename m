Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54D93CAB07
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244534AbhGOTQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:16:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241618AbhGOTPR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:15:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6FED6115B;
        Thu, 15 Jul 2021 19:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376311;
        bh=XDEpYC+/jsEmStfFqNjejNaDqAnpPzqBIw5yUVgK4kQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZbFUUaAPRroc45bNHXkItvqxpmOiP6T51pKBFBR0e/fV4ujEb1BI+SD9nBxtWjU6L
         bDVTjmRsv+RFXkWvLkZdB09Nqth+mStdMAsJqgMY9n1jPk+Zh9eY5BSFrbR4iMSxeh
         7w/tJXKhAwd7viyY4Z1XcqR9+ZSvx0nufww287As=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maximilian Luz <luzmaximilian@gmail.com>,
        dave@bewaar.me, Johannes Berg <johannes@sipsolutions.net>,
        Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.13 218/266] mwifiex: bring down link before deleting interface
Date:   Thu, 15 Jul 2021 20:39:33 +0200
Message-Id: <20210715182647.945088420@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

commit 1f9482aa8d412b4ba06ce6ab8e333fb8ca29a06e upstream.

We can deadlock when rmmod'ing the driver or going through firmware
reset, because the cfg80211_unregister_wdev() has to bring down the link
for us, ... which then grab the same wiphy lock.

nl80211_del_interface() already handles a very similar case, with a nice
description:

        /*
         * We hold RTNL, so this is safe, without RTNL opencount cannot
         * reach 0, and thus the rdev cannot be deleted.
         *
         * We need to do it for the dev_close(), since that will call
         * the netdev notifiers, and we need to acquire the mutex there
         * but don't know if we get there from here or from some other
         * place (e.g. "ip link set ... down").
         */
        mutex_unlock(&rdev->wiphy.mtx);
...

Do similarly for mwifiex teardown, by ensuring we bring the link down
first.

Sample deadlock trace:

[  247.103516] INFO: task rmmod:2119 blocked for more than 123 seconds.
[  247.110630]       Not tainted 5.12.4 #5
[  247.115796] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  247.124557] task:rmmod           state:D stack:    0 pid: 2119 ppid:  2114 flags:0x00400208
[  247.133905] Call trace:
[  247.136644]  __switch_to+0x130/0x170
[  247.140643]  __schedule+0x714/0xa0c
[  247.144548]  schedule_preempt_disabled+0x88/0xf4
[  247.149714]  __mutex_lock_common+0x43c/0x750
[  247.154496]  mutex_lock_nested+0x5c/0x68
[  247.158884]  cfg80211_netdev_notifier_call+0x280/0x4e0 [cfg80211]
[  247.165769]  raw_notifier_call_chain+0x4c/0x78
[  247.170742]  call_netdevice_notifiers_info+0x68/0xa4
[  247.176305]  __dev_close_many+0x7c/0x138
[  247.180693]  dev_close_many+0x7c/0x10c
[  247.184893]  unregister_netdevice_many+0xfc/0x654
[  247.190158]  unregister_netdevice_queue+0xb4/0xe0
[  247.195424]  _cfg80211_unregister_wdev+0xa4/0x204 [cfg80211]
[  247.201816]  cfg80211_unregister_wdev+0x20/0x2c [cfg80211]
[  247.208016]  mwifiex_del_virtual_intf+0xc8/0x188 [mwifiex]
[  247.214174]  mwifiex_uninit_sw+0x158/0x1b0 [mwifiex]
[  247.219747]  mwifiex_remove_card+0x38/0xa0 [mwifiex]
[  247.225316]  mwifiex_pcie_remove+0xd0/0xe0 [mwifiex_pcie]
[  247.231451]  pci_device_remove+0x50/0xe0
[  247.235849]  device_release_driver_internal+0x110/0x1b0
[  247.241701]  driver_detach+0x5c/0x9c
[  247.245704]  bus_remove_driver+0x84/0xb8
[  247.250095]  driver_unregister+0x3c/0x60
[  247.254486]  pci_unregister_driver+0x2c/0x90
[  247.259267]  cleanup_module+0x18/0xcdc [mwifiex_pcie]

Fixes: a05829a7222e ("cfg80211: avoid holding the RTNL when calling the driver")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-wireless/98392296-40ee-6300-369c-32e16cff3725@gmail.com/
Link: https://lore.kernel.org/linux-wireless/ab4d00ce52f32bd8e45ad0448a44737e@bewaar.me/
Reported-by: Maximilian Luz <luzmaximilian@gmail.com>
Reported-by: dave@bewaar.me
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Tested-by: Maximilian Luz <luzmaximilian@gmail.com>
Tested-by: Dave Olsthoorn <dave@bewaar.me>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210515024227.2159311-1-briannorris@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/marvell/mwifiex/main.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1445,11 +1445,18 @@ static void mwifiex_uninit_sw(struct mwi
 		if (!priv)
 			continue;
 		rtnl_lock();
-		wiphy_lock(adapter->wiphy);
 		if (priv->netdev &&
-		    priv->wdev.iftype != NL80211_IFTYPE_UNSPECIFIED)
+		    priv->wdev.iftype != NL80211_IFTYPE_UNSPECIFIED) {
+			/*
+			 * Close the netdev now, because if we do it later, the
+			 * netdev notifiers will need to acquire the wiphy lock
+			 * again --> deadlock.
+			 */
+			dev_close(priv->wdev.netdev);
+			wiphy_lock(adapter->wiphy);
 			mwifiex_del_virtual_intf(adapter->wiphy, &priv->wdev);
-		wiphy_unlock(adapter->wiphy);
+			wiphy_unlock(adapter->wiphy);
+		}
 		rtnl_unlock();
 	}
 


