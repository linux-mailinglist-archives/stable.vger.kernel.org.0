Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A9C49946B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350802AbiAXUlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:41:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40890 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388260AbiAXUiZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:38:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D1B5B811F9;
        Mon, 24 Jan 2022 20:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F97DC340E5;
        Mon, 24 Jan 2022 20:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056702;
        bh=XOsj6tMeo3byH1VXmZp4CqHcytz5W+S7VP6NCTNikdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C0yvE8JueFYNKtq7OmvIpo3QZ2vgtZVfk6dYlKyBkv40amAkIHhZxpIQMl7ntclgj
         AffTcPTt7k6IES7HfvUWJtaBRGV28ujbRwP3n+ypyb8MaPc+NvD/paJMgHEl36q8P/
         b5IZAQyqLbmrX1M2Xb2/90dkvVJvW6uFLzEoUifI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+31d54c60c5b254d6f75b@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 571/846] ath9k_htc: fix NULL pointer dereference at ath9k_htc_tx_get_packet()
Date:   Mon, 24 Jan 2022 19:41:28 +0100
Message-Id: <20220124184120.735990926@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

[ Upstream commit 8b3046abc99eefe11438090bcc4ec3a3994b55d0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/htc.h          | 1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 5 +++++
 drivers/net/wireless/ath/ath9k/wmi.c          | 4 ++++
 3 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 4f71e962279af..6b45e63fae4ba 100644
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
index e7a21eaf3a68d..6a850a0bfa8ad 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -813,6 +813,11 @@ int ath9k_tx_init(struct ath9k_htc_priv *priv)
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
index fe29ad4b9023c..f315c54bd3ac0 100644
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
2.34.1



