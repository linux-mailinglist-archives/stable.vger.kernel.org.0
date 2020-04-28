Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542EC1BC994
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730635AbgD1SnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:43:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730267AbgD1SnC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:43:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A657120730;
        Tue, 28 Apr 2020 18:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099381;
        bh=6ZiCrabj7jaz6YAEv2OmfSuumL8Fdn5Sr+f6z74vnzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T22MwZurTm63r2MHyMKu5RqHU70sI/kyF2EkMsx5btSb8p6vGmxgHCZ8cYIGoZR8M
         CqSvjPadUFMVtsk1WJLmK5emu82L8faq9Bg8MuZCnEMdklRkOZU/VNeOpoirzWmcmb
         /c2vc+O0zErcadhz1ddcPAWwaI8Wev24gAmFpehk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jouni Malinen <j@w1.fi>,
        kernel test robot <rong.a.chen@intel.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Sumit Garg <sumit.garg@linaro.org>
Subject: [PATCH 5.4 126/168] mac80211: populate debugfs only after cfg80211 init
Date:   Tue, 28 Apr 2020 20:25:00 +0200
Message-Id: <20200428182248.196894627@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 6cb5f3ea4654faf8c28b901266e960b1a4787b26 upstream.

When fixing the initialization race, we neglected to account for
the fact that debugfs is initialized in wiphy_register(), and
some debugfs things went missing (or rather were rerooted to the
global debugfs root).

Fix this by adding debugfs entries only after wiphy_register().
This requires some changes in the rate control code since it
currently adds debugfs at alloc time, which can no longer be
done after the reordering.

Reported-by: Jouni Malinen <j@w1.fi>
Reported-by: kernel test robot <rong.a.chen@intel.com>
Reported-by: Hauke Mehrtens <hauke@hauke-m.de>
Reported-by: Felix Fietkau <nbd@nbd.name>
Cc: stable@vger.kernel.org
Fixes: 52e04b4ce5d0 ("mac80211: fix race in ieee80211_register_hw()")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Sumit Garg <sumit.garg@linaro.org>
Link: https://lore.kernel.org/r/20200423111344.0e00d3346f12.Iadc76a03a55093d94391fc672e996a458702875d@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlegacy/3945-rs.c |    2 +-
 drivers/net/wireless/intel/iwlegacy/4965-rs.c |    2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c   |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c   |    2 +-
 drivers/net/wireless/realtek/rtlwifi/rc.c     |    2 +-
 include/net/mac80211.h                        |    4 +++-
 net/mac80211/main.c                           |    5 +++--
 net/mac80211/rate.c                           |   15 ++++-----------
 net/mac80211/rate.h                           |   23 +++++++++++++++++++++++
 net/mac80211/rc80211_minstrel_ht.c            |   19 +++++++++++++------
 10 files changed, 51 insertions(+), 25 deletions(-)

--- a/drivers/net/wireless/intel/iwlegacy/3945-rs.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-rs.c
@@ -374,7 +374,7 @@ out:
 }
 
 static void *
-il3945_rs_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
+il3945_rs_alloc(struct ieee80211_hw *hw)
 {
 	return hw->priv;
 }
--- a/drivers/net/wireless/intel/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
@@ -2474,7 +2474,7 @@ il4965_rs_fill_link_cmd(struct il_priv *
 }
 
 static void *
-il4965_rs_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
+il4965_rs_alloc(struct ieee80211_hw *hw)
 {
 	return hw->priv;
 }
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
@@ -3019,7 +3019,7 @@ static void rs_fill_link_cmd(struct iwl_
 			cpu_to_le16(priv->lib->bt_params->agg_time_limit);
 }
 
-static void *rs_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
+static void *rs_alloc(struct ieee80211_hw *hw)
 {
 	return hw->priv;
 }
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -3663,7 +3663,7 @@ static void rs_fill_lq_cmd(struct iwl_mv
 			cpu_to_le16(iwl_mvm_coex_agg_time_limit(mvm, sta));
 }
 
-static void *rs_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
+static void *rs_alloc(struct ieee80211_hw *hw)
 {
 	return hw->priv;
 }
--- a/drivers/net/wireless/realtek/rtlwifi/rc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rc.c
@@ -261,7 +261,7 @@ static void rtl_rate_update(void *ppriv,
 {
 }
 
-static void *rtl_rate_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
+static void *rtl_rate_alloc(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	return rtlpriv;
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5933,7 +5933,9 @@ enum rate_control_capabilities {
 struct rate_control_ops {
 	unsigned long capa;
 	const char *name;
-	void *(*alloc)(struct ieee80211_hw *hw, struct dentry *debugfsdir);
+	void *(*alloc)(struct ieee80211_hw *hw);
+	void (*add_debugfs)(struct ieee80211_hw *hw, void *priv,
+			    struct dentry *debugfsdir);
 	void (*free)(void *priv);
 
 	void *(*alloc_sta)(void *priv, struct ieee80211_sta *sta, gfp_t gfp);
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1155,8 +1155,6 @@ int ieee80211_register_hw(struct ieee802
 	local->tx_headroom = max_t(unsigned int , local->hw.extra_tx_headroom,
 				   IEEE80211_TX_STATUS_HEADROOM);
 
-	debugfs_hw_add(local);
-
 	/*
 	 * if the driver doesn't specify a max listen interval we
 	 * use 5 which should be a safe default
@@ -1248,6 +1246,9 @@ int ieee80211_register_hw(struct ieee802
 	if (result < 0)
 		goto fail_wiphy_register;
 
+	debugfs_hw_add(local);
+	rate_control_add_debugfs(local);
+
 	rtnl_lock();
 
 	/* add one default STA interface if supported */
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -214,17 +214,16 @@ static ssize_t rcname_read(struct file *
 				       ref->ops->name, len);
 }
 
-static const struct file_operations rcname_ops = {
+const struct file_operations rcname_ops = {
 	.read = rcname_read,
 	.open = simple_open,
 	.llseek = default_llseek,
 };
 #endif
 
-static struct rate_control_ref *rate_control_alloc(const char *name,
-					    struct ieee80211_local *local)
+static struct rate_control_ref *
+rate_control_alloc(const char *name, struct ieee80211_local *local)
 {
-	struct dentry *debugfsdir = NULL;
 	struct rate_control_ref *ref;
 
 	ref = kmalloc(sizeof(struct rate_control_ref), GFP_KERNEL);
@@ -234,13 +233,7 @@ static struct rate_control_ref *rate_con
 	if (!ref->ops)
 		goto free;
 
-#ifdef CONFIG_MAC80211_DEBUGFS
-	debugfsdir = debugfs_create_dir("rc", local->hw.wiphy->debugfsdir);
-	local->debugfs.rcdir = debugfsdir;
-	debugfs_create_file("name", 0400, debugfsdir, ref, &rcname_ops);
-#endif
-
-	ref->priv = ref->ops->alloc(&local->hw, debugfsdir);
+	ref->priv = ref->ops->alloc(&local->hw);
 	if (!ref->priv)
 		goto free;
 	return ref;
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -60,6 +60,29 @@ static inline void rate_control_add_sta_
 #endif
 }
 
+extern const struct file_operations rcname_ops;
+
+static inline void rate_control_add_debugfs(struct ieee80211_local *local)
+{
+#ifdef CONFIG_MAC80211_DEBUGFS
+	struct dentry *debugfsdir;
+
+	if (!local->rate_ctrl)
+		return;
+
+	if (!local->rate_ctrl->ops->add_debugfs)
+		return;
+
+	debugfsdir = debugfs_create_dir("rc", local->hw.wiphy->debugfsdir);
+	local->debugfs.rcdir = debugfsdir;
+	debugfs_create_file("name", 0400, debugfsdir,
+			    local->rate_ctrl, &rcname_ops);
+
+	local->rate_ctrl->ops->add_debugfs(&local->hw, local->rate_ctrl->priv,
+					   debugfsdir);
+#endif
+}
+
 void ieee80211_check_rate_mask(struct ieee80211_sub_if_data *sdata);
 
 /* Get a reference to the rate control algorithm. If `name' is NULL, get the
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -1631,7 +1631,7 @@ minstrel_ht_init_cck_rates(struct minstr
 }
 
 static void *
-minstrel_ht_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
+minstrel_ht_alloc(struct ieee80211_hw *hw)
 {
 	struct minstrel_priv *mp;
 
@@ -1668,18 +1668,24 @@ minstrel_ht_alloc(struct ieee80211_hw *h
 	mp->hw = hw;
 	mp->update_interval = 100;
 
+	minstrel_ht_init_cck_rates(mp);
+
+	return mp;
+}
+
 #ifdef CONFIG_MAC80211_DEBUGFS
+static void minstrel_ht_add_debugfs(struct ieee80211_hw *hw, void *priv,
+				    struct dentry *debugfsdir)
+{
+	struct minstrel_priv *mp = priv;
+
 	mp->fixed_rate_idx = (u32) -1;
 	debugfs_create_u32("fixed_rate_idx", S_IRUGO | S_IWUGO, debugfsdir,
 			   &mp->fixed_rate_idx);
 	debugfs_create_u32("sample_switch", S_IRUGO | S_IWUSR, debugfsdir,
 			   &mp->sample_switch);
-#endif
-
-	minstrel_ht_init_cck_rates(mp);
-
-	return mp;
 }
+#endif
 
 static void
 minstrel_ht_free(void *priv)
@@ -1718,6 +1724,7 @@ static const struct rate_control_ops mac
 	.alloc = minstrel_ht_alloc,
 	.free = minstrel_ht_free,
 #ifdef CONFIG_MAC80211_DEBUGFS
+	.add_debugfs = minstrel_ht_add_debugfs,
 	.add_sta_debugfs = minstrel_ht_add_sta_debugfs,
 #endif
 	.get_expected_throughput = minstrel_ht_get_expected_throughput,


