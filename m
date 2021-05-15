Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2C2381540
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 04:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbhEOCqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 22:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbhEOCqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 22:46:32 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F21C06174A
        for <stable@vger.kernel.org>; Fri, 14 May 2021 19:45:20 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id e18so295121plh.8
        for <stable@vger.kernel.org>; Fri, 14 May 2021 19:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eDL+c/QdtgD8r8VbwEvkT3lveRXwvBXnrSNmmwy0UmA=;
        b=jDedEm27tZgHLLfLtKgiGZLBdd+ltSyv0pkfzhgLsbMPM6Vj++PAjCKGpepipJwrOX
         dhG9vdZwgge3fpM/4K2wFf7+pWiepW3LYIViZXGDW20FZ+kHVglpZZVv5DryV1DMCuIk
         vSuPF7fuCPwXXED4fvPSl1Dpb/kXL/ZYZmKbI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eDL+c/QdtgD8r8VbwEvkT3lveRXwvBXnrSNmmwy0UmA=;
        b=ll3sfCRzG09LCg1KX/roKVNFOTL78QChuTrcpvAqrDandBGGsNZx1AY5lRo5s/WjbX
         w44phxuZIv312SPHjEvERaW3OBIrNWkWnLOX9i6//5zVd8Eh1l/SVwUXRFkMyFcaQBfT
         TJeeoiePlXZmQnsirImp/EIiKUPV4q9scJo2NzRi+/W2ol6FDtI2czJxXiwSaKRuh5sO
         97giPsDLC5AjAJdlWpXy6IIPikXoglqj0wldqff7lmXMiehhT/1pOxL8pqzXnFodUtGT
         Fh3r1AnvgeYQJ/ucXq2iPfbTl98qJa/DDbnwsVhZ7lfavtwjCzqIg6QWkUgyHnFAG44S
         VEsw==
X-Gm-Message-State: AOAM533A5Wd/4lBkiKSWBNLzJ7xVrf3cUWr5pXbmUG9lT3IqcJJFASit
        pr5YvhvUZtZrMXxGrDfjRejCIw==
X-Google-Smtp-Source: ABdhPJyefvd4F7MUdOKs5GwqCn6ILj79KSGJYMhFdq0OagVln+Zap6C0Q/X0HNfOM/YPeMmkwj0iUw==
X-Received: by 2002:a17:902:7d87:b029:ef:176:843b with SMTP id a7-20020a1709027d87b02900ef0176843bmr44138408plm.61.1621046719611;
        Fri, 14 May 2021 19:45:19 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:c853:454e:e506:af89])
        by smtp.gmail.com with ESMTPSA id a26sm4918037pff.149.2021.05.14.19.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 19:45:19 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     linux-wireless@vger.kernel.org
Cc:     <linux-kernel@vger.kernel.org>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        stable@vger.kernel.org, Maximilian Luz <luzmaximilian@gmail.com>,
        dave@bewaar.me, Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 5.13] mwifiex: bring down link before deleting interface
Date:   Fri, 14 May 2021 19:42:27 -0700
Message-Id: <20210515024227.2159311-1-briannorris@chromium.org>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/net/wireless/marvell/mwifiex/main.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 529dfd8b7ae8..17399d4aa129 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1445,11 +1445,18 @@ static void mwifiex_uninit_sw(struct mwifiex_adapter *adapter)
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
 
-- 

