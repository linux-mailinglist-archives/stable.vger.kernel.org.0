Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D0D586E32
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 18:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbiHAQAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 12:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiHAQAH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 12:00:07 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E24D3343D
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 09:00:06 -0700 (PDT)
Received: from localhost.localdomain (unknown [95.31.173.239])
        by mail.ispras.ru (Postfix) with ESMTPSA id 3B2E840D403D;
        Mon,  1 Aug 2022 16:00:04 +0000 (UTC)
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        ldv-project@linuxtesting.org,
        syzbot <syzbot+31d54c60c5b254d6f75b@syzkaller.appspotmail.com>,
        Fedor Pchelkin <pchelkin@ispras.ru>
Subject: [PATCH 5.10 2/2] ath9k_htc: fix NULL pointer dereference at ath9k_htc_tx_get_packet()
Date:   Mon,  1 Aug 2022 18:59:08 +0300
Message-Id: <20220801155908.1539833-3-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220801155908.1539833-1-pchelkin@ispras.ru>
References: <20220801155908.1539833-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 8b3046abc99eefe11438090bcc4ec3a3994b55d0 upstream.

syzbot is reporting lockdep warning at ath9k_wmi_event_tasklet() followed
by kernel panic at get_htc_epid_queue() from ath9k_htc_tx_get_packet() from
ath9k_htc_txstatus() [1], for ath9k_wmi_event_tasklet(WMI_TXSTATUS_EVENTID)
depends on spin_lock_init() from ath9k_init_priv() being already completed.

Since ath9k_wmi_event_tasklet() is set by ath9k_init_wmi() from
ath9k_htc_probe_device(), it is possible that ath9k_wmi_event_tasklet() is
called via tasklet interrupt before spin_lock_init() from ath9k_init_priv()
 from ath9k_init_device() from ath9k_htc_probe_device() is called.

Let's hold ath9k_wmi_event_tasklet(WMI_TXSTATUS_EVENTID) no-op until
ath9k_tx_init() completes.

Link: https://syzkaller.appspot.com/bug?extid=31d54c60c5b254d6f75b [1]
Reported-by: syzbot <syzbot+31d54c60c5b254d6f75b@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: syzbot <syzbot+31d54c60c5b254d6f75b@syzkaller.appspotmail.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/77b76ac8-2bee-6444-d26c-8c30858b8daa@i-love.sakura.ne.jp
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 drivers/net/wireless/ath/ath9k/htc.h          | 1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 5 +++++
 drivers/net/wireless/ath/ath9k/wmi.c          | 4 ++++
 3 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 4f71e962279a..6b45e63fae4b 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -306,6 +306,7 @@ struct ath9k_htc_tx {
 	DECLARE_BITMAP(tx_slot, MAX_TX_BUF_NUM);
 	struct timer_list cleanup_timer;
 	spinlock_t tx_lock;
+	bool initialized;
 };
 
 struct ath9k_htc_tx_ctl {
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 592034ea4b68..43a743ec9d9e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -808,6 +808,11 @@ int ath9k_tx_init(struct ath9k_htc_priv *priv)
 	skb_queue_head_init(&priv->tx.data_vi_queue);
 	skb_queue_head_init(&priv->tx.data_vo_queue);
 	skb_queue_head_init(&priv->tx.tx_failed);
+
+	/* Allow ath9k_wmi_event_tasklet(WMI_TXSTATUS_EVENTID) to operate. */
+	smp_wmb();
+	priv->tx.initialized = true;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index fe29ad4b9023..f315c54bd3ac 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -169,6 +169,10 @@ void ath9k_wmi_event_tasklet(struct tasklet_struct *t)
 					     &wmi->drv_priv->fatal_work);
 			break;
 		case WMI_TXSTATUS_EVENTID:
+			/* Check if ath9k_tx_init() completed. */
+			if (!data_race(priv->tx.initialized))
+				break;
+
 			spin_lock_bh(&priv->tx.tx_lock);
 			if (priv->tx.flags & ATH9K_HTC_OP_TX_DRAIN) {
 				spin_unlock_bh(&priv->tx.tx_lock);
-- 
2.25.1

