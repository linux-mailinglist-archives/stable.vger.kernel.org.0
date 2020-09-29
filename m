Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38DD327C9B6
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730187AbgI2MNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:13:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730127AbgI2Lha (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F5B223B6E;
        Tue, 29 Sep 2020 11:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379264;
        bh=ENrtdao2x/Yj/T8njHBUIDIXCWXAKSFa91S8OZwOXyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K+bEs1vNIw8oMnf1na8PKaj5OkgzuXWVOjciZxIcL8MIBBUL2kidNaKEnsDYHMKl+
         9IV/jlAmS0c2J/phRwseNic9M/KZPS39L9cN8BdK6FISxPKTU6qYSobnLkUnVvP4EU
         s5UGM5NZt9gsOAA2UDfqH30DovRyUhXOEX46oWrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/388] opp: Replace list_kref with a local counter
Date:   Tue, 29 Sep 2020 12:56:55 +0200
Message-Id: <20200929110014.545612190@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 03758d60265c773e1d06d436b99ee338f2ac55d6 ]

A kref or refcount isn't the right tool to be used here for counting
number of devices that are sharing the static OPPs created for the OPP
table. For example, we are reinitializing the kref again, after it
reaches a value of 0 and frees the resources, if the static OPPs get
added for the same OPP table structure (as the OPP table structure was
never freed). That is messy and very unclear.

This patch makes parsed_static_opps an unsigned integer and uses it to
count the number of users of the static OPPs. The increment and
decrement to parsed_static_opps is done under opp_table->lock now to
make sure no races are possible if the OPP table is getting added and
removed in parallel (which doesn't happen in practice, but can in
theory).

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c | 48 ++++++++++++++++++----------------------------
 drivers/opp/of.c   | 26 +++++++++++--------------
 drivers/opp/opp.h  |  6 ++----
 3 files changed, 32 insertions(+), 48 deletions(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index 7b057c32e11b1..29dfaa591f8b0 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -990,7 +990,6 @@ static struct opp_table *_allocate_opp_table(struct device *dev, int index)
 	BLOCKING_INIT_NOTIFIER_HEAD(&opp_table->head);
 	INIT_LIST_HEAD(&opp_table->opp_list);
 	kref_init(&opp_table->kref);
-	kref_init(&opp_table->list_kref);
 
 	/* Secure the device table modification */
 	list_add(&opp_table->node, &opp_tables);
@@ -1074,33 +1073,6 @@ static void _opp_table_kref_release(struct kref *kref)
 	mutex_unlock(&opp_table_lock);
 }
 
-void _opp_remove_all_static(struct opp_table *opp_table)
-{
-	struct dev_pm_opp *opp, *tmp;
-
-	list_for_each_entry_safe(opp, tmp, &opp_table->opp_list, node) {
-		if (!opp->dynamic)
-			dev_pm_opp_put(opp);
-	}
-
-	opp_table->parsed_static_opps = false;
-}
-
-static void _opp_table_list_kref_release(struct kref *kref)
-{
-	struct opp_table *opp_table = container_of(kref, struct opp_table,
-						   list_kref);
-
-	_opp_remove_all_static(opp_table);
-	mutex_unlock(&opp_table_lock);
-}
-
-void _put_opp_list_kref(struct opp_table *opp_table)
-{
-	kref_put_mutex(&opp_table->list_kref, _opp_table_list_kref_release,
-		       &opp_table_lock);
-}
-
 void dev_pm_opp_put_opp_table(struct opp_table *opp_table)
 {
 	kref_put_mutex(&opp_table->kref, _opp_table_kref_release,
@@ -1204,6 +1176,24 @@ void dev_pm_opp_remove(struct device *dev, unsigned long freq)
 }
 EXPORT_SYMBOL_GPL(dev_pm_opp_remove);
 
+void _opp_remove_all_static(struct opp_table *opp_table)
+{
+	struct dev_pm_opp *opp, *tmp;
+
+	mutex_lock(&opp_table->lock);
+
+	if (!opp_table->parsed_static_opps || --opp_table->parsed_static_opps)
+		goto unlock;
+
+	list_for_each_entry_safe(opp, tmp, &opp_table->opp_list, node) {
+		if (!opp->dynamic)
+			dev_pm_opp_put_unlocked(opp);
+	}
+
+unlock:
+	mutex_unlock(&opp_table->lock);
+}
+
 /**
  * dev_pm_opp_remove_all_dynamic() - Remove all dynamically created OPPs
  * @dev:	device for which we do this operation
@@ -2209,7 +2199,7 @@ void _dev_pm_opp_find_and_remove_table(struct device *dev)
 		return;
 	}
 
-	_put_opp_list_kref(opp_table);
+	_opp_remove_all_static(opp_table);
 
 	/* Drop reference taken by _find_opp_table() */
 	dev_pm_opp_put_opp_table(opp_table);
diff --git a/drivers/opp/of.c b/drivers/opp/of.c
index 1e5fcdee043c4..9cd8f0adacae4 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -658,17 +658,15 @@ static int _of_add_opp_table_v2(struct device *dev, struct opp_table *opp_table)
 	struct dev_pm_opp *opp;
 
 	/* OPP table is already initialized for the device */
+	mutex_lock(&opp_table->lock);
 	if (opp_table->parsed_static_opps) {
-		kref_get(&opp_table->list_kref);
+		opp_table->parsed_static_opps++;
+		mutex_unlock(&opp_table->lock);
 		return 0;
 	}
 
-	/*
-	 * Re-initialize list_kref every time we add static OPPs to the OPP
-	 * table as the reference count may be 0 after the last tie static OPPs
-	 * were removed.
-	 */
-	kref_init(&opp_table->list_kref);
+	opp_table->parsed_static_opps = 1;
+	mutex_unlock(&opp_table->lock);
 
 	/* We have opp-table node now, iterate over it and add OPPs */
 	for_each_available_child_of_node(opp_table->np, np) {
@@ -678,7 +676,7 @@ static int _of_add_opp_table_v2(struct device *dev, struct opp_table *opp_table)
 			dev_err(dev, "%s: Failed to add OPP, %d\n", __func__,
 				ret);
 			of_node_put(np);
-			goto put_list_kref;
+			goto remove_static_opp;
 		} else if (opp) {
 			count++;
 		}
@@ -687,7 +685,7 @@ static int _of_add_opp_table_v2(struct device *dev, struct opp_table *opp_table)
 	/* There should be one of more OPP defined */
 	if (WARN_ON(!count)) {
 		ret = -ENOENT;
-		goto put_list_kref;
+		goto remove_static_opp;
 	}
 
 	list_for_each_entry(opp, &opp_table->opp_list, node)
@@ -698,18 +696,16 @@ static int _of_add_opp_table_v2(struct device *dev, struct opp_table *opp_table)
 		dev_err(dev, "Not all nodes have performance state set (%d: %d)\n",
 			count, pstate_count);
 		ret = -ENOENT;
-		goto put_list_kref;
+		goto remove_static_opp;
 	}
 
 	if (pstate_count)
 		opp_table->genpd_performance_state = true;
 
-	opp_table->parsed_static_opps = true;
-
 	return 0;
 
-put_list_kref:
-	_put_opp_list_kref(opp_table);
+remove_static_opp:
+	_opp_remove_all_static(opp_table);
 
 	return ret;
 }
@@ -746,7 +742,7 @@ static int _of_add_opp_table_v1(struct device *dev, struct opp_table *opp_table)
 		if (ret) {
 			dev_err(dev, "%s: Failed to add OPP %ld (%d)\n",
 				__func__, freq, ret);
-			_put_opp_list_kref(opp_table);
+			_opp_remove_all_static(opp_table);
 			return ret;
 		}
 		nr -= 2;
diff --git a/drivers/opp/opp.h b/drivers/opp/opp.h
index 01a500e2c40a1..d14e27102730c 100644
--- a/drivers/opp/opp.h
+++ b/drivers/opp/opp.h
@@ -127,11 +127,10 @@ enum opp_table_access {
  * @dev_list:	list of devices that share these OPPs
  * @opp_list:	table of opps
  * @kref:	for reference count of the table.
- * @list_kref:	for reference count of the OPP list.
  * @lock:	mutex protecting the opp_list and dev_list.
  * @np:		struct device_node pointer for opp's DT node.
  * @clock_latency_ns_max: Max clock latency in nanoseconds.
- * @parsed_static_opps: True if OPPs are initialized from DT.
+ * @parsed_static_opps: Count of devices for which OPPs are initialized from DT.
  * @shared_opp: OPP is shared between multiple devices.
  * @suspend_opp: Pointer to OPP to be used during device suspend.
  * @genpd_virt_dev_lock: Mutex protecting the genpd virtual device pointers.
@@ -167,7 +166,6 @@ struct opp_table {
 	struct list_head dev_list;
 	struct list_head opp_list;
 	struct kref kref;
-	struct kref list_kref;
 	struct mutex lock;
 
 	struct device_node *np;
@@ -176,7 +174,7 @@ struct opp_table {
 	/* For backward compatibility with v1 bindings */
 	unsigned int voltage_tolerance_v1;
 
-	bool parsed_static_opps;
+	unsigned int parsed_static_opps;
 	enum opp_table_access shared_opp;
 	struct dev_pm_opp *suspend_opp;
 
-- 
2.25.1



