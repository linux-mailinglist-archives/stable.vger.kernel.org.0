Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53158F66D3
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfKJDQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 22:16:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727187AbfKJClD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:41:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A121C214E0;
        Sun, 10 Nov 2019 02:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353662;
        bh=VHiTryP+MU+PLdWreCOV2vP2vxJ3anEvXl6BhTjOKbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PEMdlO6wRyUZOiiZ7TFFB5V7IQmoMrPpt+4xWlRessOKHAEwGy9D/GOpD4YHoXJ5x
         fWPnxLrnuzl9jrzlTdcivDzveXwK+4Cf7y4myHyR/tMsqCwrWlMeHVrjlkwnmkVnOh
         ZWTJbw5a9PXloewg9f7zGUjoeoHZWWKFChFaea6A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Niklas Cassel <niklas.cassel@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 034/191] OPP: Protect dev_list with opp_table lock
Date:   Sat,  9 Nov 2019 21:37:36 -0500
Message-Id: <20191110024013.29782-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 3d2556992a878a2210d3be498416aee39e0c32aa ]

The dev_list needs to be protected with a lock, else we may have
simultaneous access (addition/removal) to it and that would be racy.
Extend scope of the opp_table lock to protect dev_list as well.

Tested-by: Niklas Cassel <niklas.cassel@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c | 21 +++++++++++++++++++--
 drivers/opp/cpu.c  |  2 ++
 drivers/opp/opp.h  |  2 +-
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index f3433bf47b100..14d4ef5943741 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -48,9 +48,14 @@ static struct opp_device *_find_opp_dev(const struct device *dev,
 static struct opp_table *_find_opp_table_unlocked(struct device *dev)
 {
 	struct opp_table *opp_table;
+	bool found;
 
 	list_for_each_entry(opp_table, &opp_tables, node) {
-		if (_find_opp_dev(dev, opp_table)) {
+		mutex_lock(&opp_table->lock);
+		found = !!_find_opp_dev(dev, opp_table);
+		mutex_unlock(&opp_table->lock);
+
+		if (found) {
 			_get_opp_table_kref(opp_table);
 
 			return opp_table;
@@ -766,6 +771,8 @@ struct opp_device *_add_opp_dev(const struct device *dev,
 
 	/* Initialize opp-dev */
 	opp_dev->dev = dev;
+
+	mutex_lock(&opp_table->lock);
 	list_add(&opp_dev->node, &opp_table->dev_list);
 
 	/* Create debugfs entries for the opp_table */
@@ -773,6 +780,7 @@ struct opp_device *_add_opp_dev(const struct device *dev,
 	if (ret)
 		dev_err(dev, "%s: Failed to register opp debugfs (%d)\n",
 			__func__, ret);
+	mutex_unlock(&opp_table->lock);
 
 	return opp_dev;
 }
@@ -791,6 +799,7 @@ static struct opp_table *_allocate_opp_table(struct device *dev)
 	if (!opp_table)
 		return NULL;
 
+	mutex_init(&opp_table->lock);
 	INIT_LIST_HEAD(&opp_table->dev_list);
 
 	opp_dev = _add_opp_dev(dev, opp_table);
@@ -812,7 +821,6 @@ static struct opp_table *_allocate_opp_table(struct device *dev)
 
 	BLOCKING_INIT_NOTIFIER_HEAD(&opp_table->head);
 	INIT_LIST_HEAD(&opp_table->opp_list);
-	mutex_init(&opp_table->lock);
 	kref_init(&opp_table->kref);
 
 	/* Secure the device table modification */
@@ -854,6 +862,10 @@ static void _opp_table_kref_release(struct kref *kref)
 	if (!IS_ERR(opp_table->clk))
 		clk_put(opp_table->clk);
 
+	/*
+	 * No need to take opp_table->lock here as we are guaranteed that no
+	 * references to the OPP table are taken at this point.
+	 */
 	opp_dev = list_first_entry(&opp_table->dev_list, struct opp_device,
 				   node);
 
@@ -1719,6 +1731,9 @@ void _dev_pm_opp_remove_table(struct opp_table *opp_table, struct device *dev,
 {
 	struct dev_pm_opp *opp, *tmp;
 
+	/* Protect dev_list */
+	mutex_lock(&opp_table->lock);
+
 	/* Find if opp_table manages a single device */
 	if (list_is_singular(&opp_table->dev_list)) {
 		/* Free static OPPs */
@@ -1736,6 +1751,8 @@ void _dev_pm_opp_remove_table(struct opp_table *opp_table, struct device *dev,
 	} else {
 		_remove_opp_dev(_find_opp_dev(dev, opp_table), opp_table);
 	}
+
+	mutex_unlock(&opp_table->lock);
 }
 
 void _dev_pm_opp_find_and_remove_table(struct device *dev, bool remove_all)
diff --git a/drivers/opp/cpu.c b/drivers/opp/cpu.c
index 0c09107094350..2868a022a0407 100644
--- a/drivers/opp/cpu.c
+++ b/drivers/opp/cpu.c
@@ -222,8 +222,10 @@ int dev_pm_opp_get_sharing_cpus(struct device *cpu_dev, struct cpumask *cpumask)
 	cpumask_clear(cpumask);
 
 	if (opp_table->shared_opp == OPP_TABLE_ACCESS_SHARED) {
+		mutex_lock(&opp_table->lock);
 		list_for_each_entry(opp_dev, &opp_table->dev_list, node)
 			cpumask_set_cpu(opp_dev->dev->id, cpumask);
+		mutex_unlock(&opp_table->lock);
 	} else {
 		cpumask_set_cpu(cpu_dev->id, cpumask);
 	}
diff --git a/drivers/opp/opp.h b/drivers/opp/opp.h
index 7c540fd063b2d..e0866b1c1f1b2 100644
--- a/drivers/opp/opp.h
+++ b/drivers/opp/opp.h
@@ -126,7 +126,7 @@ enum opp_table_access {
  * @dev_list:	list of devices that share these OPPs
  * @opp_list:	table of opps
  * @kref:	for reference count of the table.
- * @lock:	mutex protecting the opp_list.
+ * @lock:	mutex protecting the opp_list and dev_list.
  * @np:		struct device_node pointer for opp's DT node.
  * @clock_latency_ns_max: Max clock latency in nanoseconds.
  * @shared_opp: OPP is shared between multiple devices.
-- 
2.20.1

