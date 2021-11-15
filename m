Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D497451F32
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356052AbhKPAiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343982AbhKOTWl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56599619EA;
        Mon, 15 Nov 2021 18:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002188;
        bh=7Oa2YBDwtyfLKTLhzm80IhvRQ76tnVZgWzt0QREhhOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yIMR2HTDUUZgtOBhfe7/Y5Sg4X+10jFsGhZc6S6H6lGHfLnNPjafGDL8EF0w63xhL
         sCmjJYWs7eGliKq3nIQ3e18nkZ08wzHtVSQRySn6CuggjKL+3bQaZAQDdwLCIynIFr
         lnCmhe4CCHBpiRbb+L4qdOol7MIpprhfbLKUb0Tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 471/917] mt76: overwrite default reg_ops if necessary
Date:   Mon, 15 Nov 2021 17:59:26 +0100
Message-Id: <20211115165444.747115613@linuxfoundation.org>
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

[ Upstream commit f6e1f59885dae5a2553f8bbd328be2cb1c80ccb2 ]

Introduce mt76_register_debugfs_fops routine in order to
define per-driver regs file operations and make sure the
device is up before reading or writing its registers

Fixes: 1d8efc741df8 ("mt76: mt7921: introduce Runtime PM support")
Fixes: de5ff3c9d1a2 ("mt76: mt7615: introduce pm_power_save delayed work")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/debugfs.c  | 10 ++++---
 drivers/net/wireless/mediatek/mt76/mt76.h     |  8 ++++-
 .../wireless/mediatek/mt76/mt7615/debugfs.c   | 29 ++++++++++++++++++-
 .../wireless/mediatek/mt76/mt7921/debugfs.c   | 28 +++++++++++++++++-
 4 files changed, 68 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/debugfs.c b/drivers/net/wireless/mediatek/mt76/debugfs.c
index fa48cc3a7a8f7..ad97308c78534 100644
--- a/drivers/net/wireless/mediatek/mt76/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/debugfs.c
@@ -116,8 +116,11 @@ static int mt76_read_rate_txpower(struct seq_file *s, void *data)
 	return 0;
 }
 
-struct dentry *mt76_register_debugfs(struct mt76_dev *dev)
+struct dentry *
+mt76_register_debugfs_fops(struct mt76_dev *dev,
+			   const struct file_operations *ops)
 {
+	const struct file_operations *fops = ops ? ops : &fops_regval;
 	struct dentry *dir;
 
 	dir = debugfs_create_dir("mt76", dev->hw->wiphy->debugfsdir);
@@ -126,8 +129,7 @@ struct dentry *mt76_register_debugfs(struct mt76_dev *dev)
 
 	debugfs_create_u8("led_pin", 0600, dir, &dev->led_pin);
 	debugfs_create_u32("regidx", 0600, dir, &dev->debugfs_reg);
-	debugfs_create_file_unsafe("regval", 0600, dir, dev,
-				   &fops_regval);
+	debugfs_create_file_unsafe("regval", 0600, dir, dev, fops);
 	debugfs_create_file_unsafe("napi_threaded", 0600, dir, dev,
 				   &fops_napi_threaded);
 	debugfs_create_blob("eeprom", 0400, dir, &dev->eeprom);
@@ -140,4 +142,4 @@ struct dentry *mt76_register_debugfs(struct mt76_dev *dev)
 
 	return dir;
 }
-EXPORT_SYMBOL_GPL(mt76_register_debugfs);
+EXPORT_SYMBOL_GPL(mt76_register_debugfs_fops);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 25c5ceef52577..4d01fd85283df 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -869,7 +869,13 @@ struct mt76_phy *mt76_alloc_phy(struct mt76_dev *dev, unsigned int size,
 int mt76_register_phy(struct mt76_phy *phy, bool vht,
 		      struct ieee80211_rate *rates, int n_rates);
 
-struct dentry *mt76_register_debugfs(struct mt76_dev *dev);
+struct dentry *mt76_register_debugfs_fops(struct mt76_dev *dev,
+					  const struct file_operations *ops);
+static inline struct dentry *mt76_register_debugfs(struct mt76_dev *dev)
+{
+	return mt76_register_debugfs_fops(dev, NULL);
+}
+
 int mt76_queues_read(struct seq_file *s, void *data);
 void mt76_seq_puts_array(struct seq_file *file, const char *str,
 			 s8 *val, int len);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
index cb4659771fd97..bda22ca0bd714 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
@@ -2,6 +2,33 @@
 
 #include "mt7615.h"
 
+static int
+mt7615_reg_set(void *data, u64 val)
+{
+	struct mt7615_dev *dev = data;
+
+	mt7615_mutex_acquire(dev);
+	mt76_wr(dev, dev->mt76.debugfs_reg, val);
+	mt7615_mutex_release(dev);
+
+	return 0;
+}
+
+static int
+mt7615_reg_get(void *data, u64 *val)
+{
+	struct mt7615_dev *dev = data;
+
+	mt7615_mutex_acquire(dev);
+	*val = mt76_rr(dev, dev->mt76.debugfs_reg);
+	mt7615_mutex_release(dev);
+
+	return 0;
+}
+
+DEFINE_DEBUGFS_ATTRIBUTE(fops_regval, mt7615_reg_get, mt7615_reg_set,
+			 "0x%08llx\n");
+
 static int
 mt7615_radar_pattern_set(void *data, u64 val)
 {
@@ -506,7 +533,7 @@ int mt7615_init_debugfs(struct mt7615_dev *dev)
 {
 	struct dentry *dir;
 
-	dir = mt76_register_debugfs(&dev->mt76);
+	dir = mt76_register_debugfs_fops(&dev->mt76, &fops_regval);
 	if (!dir)
 		return -ENOMEM;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
index 77468bdae460b..4c89c4ac8031a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
@@ -4,6 +4,32 @@
 #include "mt7921.h"
 #include "eeprom.h"
 
+static int
+mt7921_reg_set(void *data, u64 val)
+{
+	struct mt7921_dev *dev = data;
+
+	mt7921_mutex_acquire(dev);
+	mt76_wr(dev, dev->mt76.debugfs_reg, val);
+	mt7921_mutex_release(dev);
+
+	return 0;
+}
+
+static int
+mt7921_reg_get(void *data, u64 *val)
+{
+	struct mt7921_dev *dev = data;
+
+	mt7921_mutex_acquire(dev);
+	*val = mt76_rr(dev, dev->mt76.debugfs_reg);
+	mt7921_mutex_release(dev);
+
+	return 0;
+}
+
+DEFINE_DEBUGFS_ATTRIBUTE(fops_regval, mt7921_reg_get, mt7921_reg_set,
+			 "0x%08llx\n");
 static int
 mt7921_fw_debug_set(void *data, u64 val)
 {
@@ -373,7 +399,7 @@ int mt7921_init_debugfs(struct mt7921_dev *dev)
 {
 	struct dentry *dir;
 
-	dir = mt76_register_debugfs(&dev->mt76);
+	dir = mt76_register_debugfs_fops(&dev->mt76, &fops_regval);
 	if (!dir)
 		return -ENOMEM;
 
-- 
2.33.0



