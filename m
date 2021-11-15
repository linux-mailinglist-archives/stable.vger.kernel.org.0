Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A742A451DEE
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344004AbhKPAed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:34:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344006AbhKOTXH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7151633A9;
        Mon, 15 Nov 2021 18:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002199;
        bh=PMCUqF9vurBqj+h+7PPkSXjzQ2/2zTs6z01L2iua1wQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YDGeOucivKrgDhUcWpY/RFZHK0XI/kwkF4c7wPDJchxqQ1BHuwg87e7V4wY74VSBc
         ZdI6dDTLVa5ujIp/5uhEjRWQeEcqiRjpnZmNz1UQx7j36LaOvgUzaIkaXdDvfZt8Go
         Twm1oG0MSBic+NA7YW+ZzcKUAdNxORs6z0WEn0CQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 475/917] mt76: mt7921: always wake device if necessary in debugfs
Date:   Mon, 15 Nov 2021 17:59:30 +0100
Message-Id: <20211115165444.882834918@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 569008744178b672ea3ad9047fa3098f1b73ca55 ]

Add missing device wakeup in debugfs code if we are accessing chip
registers.

Fixes: 1d8efc741df8 ("mt76: mt7921: introduce Runtime PM support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
index 4c89c4ac8031a..30f3b3085c786 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
@@ -95,6 +95,8 @@ mt7921_tx_stats_show(struct seq_file *file, void *data)
 	struct mt7921_dev *dev = file->private;
 	int stat[8], i, n;
 
+	mt7921_mutex_acquire(dev);
+
 	mt7921_ampdu_stat_read_phy(&dev->phy, file);
 
 	/* Tx amsdu info */
@@ -104,6 +106,8 @@ mt7921_tx_stats_show(struct seq_file *file, void *data)
 		n += stat[i];
 	}
 
+	mt7921_mutex_release(dev);
+
 	for (i = 0; i < ARRAY_SIZE(stat); i++) {
 		seq_printf(file, "AMSDU pack count of %d MSDU in TXD: 0x%x ",
 			   i + 1, stat[i]);
@@ -124,6 +128,8 @@ mt7921_queues_acq(struct seq_file *s, void *data)
 	struct mt7921_dev *dev = dev_get_drvdata(s->private);
 	int i;
 
+	mt7921_mutex_acquire(dev);
+
 	for (i = 0; i < 16; i++) {
 		int j, acs = i / 4, index = i % 4;
 		u32 ctrl, val, qlen = 0;
@@ -143,6 +149,8 @@ mt7921_queues_acq(struct seq_file *s, void *data)
 		seq_printf(s, "AC%d%d: queued=%d\n", acs, index, qlen);
 	}
 
+	mt7921_mutex_release(dev);
+
 	return 0;
 }
 
-- 
2.33.0



