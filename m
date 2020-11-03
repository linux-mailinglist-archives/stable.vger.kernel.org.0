Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A4C2A598D
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730295AbgKCWIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 17:08:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:52682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730297AbgKCUlE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:41:04 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 542372224E;
        Tue,  3 Nov 2020 20:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436063;
        bh=G0561EGDU0jdgRLc6Zrt3jW89WRU5ZZHXbK8ak3vzoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ogt3eVPk7ilwSTneb7CX9a1aGrqjEVB/x8CAgC086CR4sRPu08BcC/31cHWH+PHxX
         2aJVD5CaCr0d4W8J9cWKFkgO1FhrelY8snPaHHP6UmgjHhf6kDPMrDFcU+7GIyu65k
         ydMXN7hmJWDEcD1Bk4C5BKlL3oUK2sSE9BY2eVD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 086/391] staging: wfx: fix potential use before init
Date:   Tue,  3 Nov 2020 21:32:17 +0100
Message-Id: <20201103203352.826216298@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7dace7c17bf5c..536c62001c709 100644
--- a/drivers/staging/wfx/sta.c
+++ b/drivers/staging/wfx/sta.c
@@ -761,17 +761,6 @@ int wfx_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
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
@@ -788,12 +777,22 @@ int wfx_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
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
@@ -825,6 +824,7 @@ void wfx_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	wvif->vif = NULL;
 
 	mutex_unlock(&wdev->conf_mutex);
+
 	wvif = NULL;
 	while ((wvif = wvif_iterate(wdev, wvif)) != NULL) {
 		// Combo mode does not support Block Acks. We can re-enable them
-- 
2.27.0



