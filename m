Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 365343A0285
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235456AbhFHTGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:06:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235918AbhFHTDH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:03:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C93F613EF;
        Tue,  8 Jun 2021 18:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177915;
        bh=ch1vEVQ71xI48AXdEkUKvg0OTmsLsoATs65g00hhRFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cQe765u2OtFntR/3jTzr5UyQDEEqGBgdexRzxerOm0tZOBbWhcr0RDK4BenunrWEJ
         kCJFqnPpfVL9Ze3NXTG8zVyGADEa0kVdZ0x9XHvQ2lwKFZXYsaR2rx5lnvyiuD3HVV
         z8F0AKR1uie0j3pnREm1Msim/SyLr5vN0drIjus0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 001/161] mt76: mt7921: add rcu section in mt7921_mcu_tx_rate_report
Date:   Tue,  8 Jun 2021 20:25:31 +0200
Message-Id: <20210608175945.526448245@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 481fc927c8289919cc0be58666fcd1b7da187a0c ]

Introduce rcu section in mt7921_mcu_tx_rate_report before dereferencing
wcid pointer otherwise loockdep will report the following issue:

[  115.245740] =============================
[  115.245754] WARNING: suspicious RCU usage
[  115.245771] 5.10.20 #0 Not tainted
[  115.245784] -----------------------------
[  115.245816] other info that might help us debug this:
[  115.245830] rcu_scheduler_active = 2, debug_locks = 1
[  115.245845] 3 locks held by kworker/u4:1/20:
[  115.245858]  #0: ffffff80065ab138 ((wq_completion)phy0){+.+.}-{0:0}, at: process_one_work+0x1f8/0x6b8
[  115.245948]  #1: ffffffc01198bdd8 ((work_completion)(&(&dev->mphy.mac_work)->work)){+.+.}-{0:0}, at: process_one_8
[  115.246027]  #2: ffffff8006543ce8 (&dev->mutex#2){+.+.}-{3:3}, at: mt7921_mac_work+0x60/0x2b0 [mt7921e]
[  115.246125]
[  115.246125] stack backtrace:
[  115.246142] CPU: 1 PID: 20 Comm: kworker/u4:1 Not tainted 5.10.20 #0
[  115.246152] Hardware name: MediaTek MT7622 RFB1 board (DT)
[  115.246168] Workqueue: phy0 mt7921_mac_work [mt7921e]
[  115.246188] Call trace:
[  115.246201]  dump_backtrace+0x0/0x1a8
[  115.246213]  show_stack+0x14/0x30
[  115.246228]  dump_stack+0xec/0x134
[  115.246240]  lockdep_rcu_suspicious+0xcc/0xdc
[  115.246255]  mt7921_get_wtbl_info+0x2a4/0x310 [mt7921e]
[  115.246269]  mt7921_mac_work+0x284/0x2b0 [mt7921e]
[  115.246281]  process_one_work+0x2a0/0x6b8
[  115.246293]  worker_thread+0x40/0x440
[  115.246305]  kthread+0x144/0x148
[  115.246317]  ret_from_fork+0x10/0x18

Fixes: 1c099ab44727c ("mt76: mt7921: add MCU support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 62afbad77596..9a140e4734b5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -404,9 +404,12 @@ mt7921_mcu_tx_rate_report(struct mt7921_dev *dev, struct sk_buff *skb,
 
 	if (wlan_idx >= MT76_N_WCIDS)
 		return;
+
+	rcu_read_lock();
+
 	wcid = rcu_dereference(dev->mt76.wcid[wlan_idx]);
 	if (!wcid)
-		return;
+		goto out;
 
 	msta = container_of(wcid, struct mt7921_sta, wcid);
 	stats = &msta->stats;
@@ -414,6 +417,8 @@ mt7921_mcu_tx_rate_report(struct mt7921_dev *dev, struct sk_buff *skb,
 	/* current rate */
 	mt7921_mcu_tx_rate_parse(mphy, &peer, &rate, curr);
 	stats->tx_rate = rate;
+out:
+	rcu_read_unlock();
 }
 
 static void
-- 
2.30.2



