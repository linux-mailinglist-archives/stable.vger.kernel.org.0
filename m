Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0E129A187
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502280AbgJ0Amf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:42:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408991AbgJZXuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:50:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8196421707;
        Mon, 26 Oct 2020 23:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756202;
        bh=FkpRkYZDBHzgwCdDMC+6K5UDKJIXKq4ENQKu9yOeDbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N/S22EE2JAtZj6cK9S/Vwl7gGXirdsxU9jcDn16DZe5suOyub5eN4yiA6f3vxw5Oe
         PzyvBnEVXm96Hl/JzLg0y/YiyveCo6SARprb+eedgK/XvTfqvA+pglkJLsmG00aMnw
         Z2+uJcxBKnFkypuwAYxVNmzxvH/zu+a6xunDCaaU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.9 045/147] staging: wfx: fix potential use before init
Date:   Mon, 26 Oct 2020 19:47:23 -0400
Message-Id: <20201026234905.1022767-45-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jérôme Pouiller <jerome.pouiller@silabs.com>

[ Upstream commit ce3653a8d3db096aa163fc80239d8ec1305c81fa ]

The trace below can appear:

    [83613.832200] INFO: trying to register non-static key.
    [83613.837248] the code is fine but needs lockdep annotation.
    [83613.842808] turning off the locking correctness validator.
    [83613.848375] CPU: 3 PID: 141 Comm: kworker/3:2H Tainted: G           O      5.6.13-silabs15 #2
    [83613.857019] Hardware name: BCM2835
    [83613.860605] Workqueue: events_highpri bh_work [wfx]
    [83613.865552] Backtrace:
    [83613.868041] [<c010f2cc>] (dump_backtrace) from [<c010f7b8>] (show_stack+0x20/0x24)
    [83613.881463] [<c010f798>] (show_stack) from [<c0d82138>] (dump_stack+0xe8/0x114)
    [83613.888882] [<c0d82050>] (dump_stack) from [<c01a02ec>] (register_lock_class+0x748/0x768)
    [83613.905035] [<c019fba4>] (register_lock_class) from [<c019da04>] (__lock_acquire+0x88/0x13dc)
    [83613.924192] [<c019d97c>] (__lock_acquire) from [<c019f6a4>] (lock_acquire+0xe8/0x274)
    [83613.942644] [<c019f5bc>] (lock_acquire) from [<c0daa5dc>] (_raw_spin_lock_irqsave+0x58/0x6c)
    [83613.961714] [<c0daa584>] (_raw_spin_lock_irqsave) from [<c0ab3248>] (skb_dequeue+0x24/0x78)
    [83613.974967] [<c0ab3224>] (skb_dequeue) from [<bf330db0>] (wfx_tx_queues_get+0x96c/0x1294 [wfx])
    [83613.989728] [<bf330444>] (wfx_tx_queues_get [wfx]) from [<bf320454>] (bh_work+0x454/0x26d8 [wfx])
    [83614.009337] [<bf320000>] (bh_work [wfx]) from [<c014c920>] (process_one_work+0x23c/0x7ec)
    [83614.028141] [<c014c6e4>] (process_one_work) from [<c014cf1c>] (worker_thread+0x4c/0x55c)
    [83614.046861] [<c014ced0>] (worker_thread) from [<c0154c04>] (kthread+0x138/0x168)
    [83614.064876] [<c0154acc>] (kthread) from [<c01010b4>] (ret_from_fork+0x14/0x20)
    [83614.072200] Exception stack(0xecad3fb0 to 0xecad3ff8)
    [83614.077323] 3fa0:                                     00000000 00000000 00000000 00000000
    [83614.085620] 3fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
    [83614.093914] 3fe0: 00000000 00000000 00000000 00000000 00000013 00000000

Indeed, the code of wfx_add_interface() shows that the interface is
enabled to early. So, the spinlock associated with some skb_queue may
not yet initialized when wfx_tx_queues_get() is called.

Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Link: https://lore.kernel.org/r/20200825085828.399505-8-Jerome.Pouiller@silabs.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wfx/sta.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wfx/sta.c b/drivers/staging/wfx/sta.c
index 4e30ab17a93d4..b96c83671caeb 100644
--- a/drivers/staging/wfx/sta.c
+++ b/drivers/staging/wfx/sta.c
@@ -760,17 +760,6 @@ int wfx_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 		return -EOPNOTSUPP;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(wdev->vif); i++) {
-		if (!wdev->vif[i]) {
-			wdev->vif[i] = vif;
-			wvif->id = i;
-			break;
-		}
-	}
-	if (i == ARRAY_SIZE(wdev->vif)) {
-		mutex_unlock(&wdev->conf_mutex);
-		return -EOPNOTSUPP;
-	}
 	// FIXME: prefer use of container_of() to get vif
 	wvif->vif = vif;
 	wvif->wdev = wdev;
@@ -787,12 +776,22 @@ int wfx_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	init_completion(&wvif->scan_complete);
 	INIT_WORK(&wvif->scan_work, wfx_hw_scan_work);
 
-	mutex_unlock(&wdev->conf_mutex);
+	wfx_tx_queues_init(wvif);
+	wfx_tx_policy_init(wvif);
+
+	for (i = 0; i < ARRAY_SIZE(wdev->vif); i++) {
+		if (!wdev->vif[i]) {
+			wdev->vif[i] = vif;
+			wvif->id = i;
+			break;
+		}
+	}
+	WARN(i == ARRAY_SIZE(wdev->vif), "try to instantiate more vif than supported");
 
 	hif_set_macaddr(wvif, vif->addr);
 
-	wfx_tx_queues_init(wvif);
-	wfx_tx_policy_init(wvif);
+	mutex_unlock(&wdev->conf_mutex);
+
 	wvif = NULL;
 	while ((wvif = wvif_iterate(wdev, wvif)) != NULL) {
 		// Combo mode does not support Block Acks. We can re-enable them
@@ -824,6 +823,7 @@ void wfx_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	wvif->vif = NULL;
 
 	mutex_unlock(&wdev->conf_mutex);
+
 	wvif = NULL;
 	while ((wvif = wvif_iterate(wdev, wvif)) != NULL) {
 		// Combo mode does not support Block Acks. We can re-enable them
-- 
2.25.1

