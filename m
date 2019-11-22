Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0B55106F9F
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfKVLQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:16:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:60874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728071AbfKVKun (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:50:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 887D22072D;
        Fri, 22 Nov 2019 10:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419842;
        bh=cXAOcHjLd1/RQ7fJxPeGZ3pBpX0jJa7FqH4WtnMadCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AP0X2FvkovPI2Vsimb7xBv9AN/7FG1T7XyFsAB9o6LkEE4QLlI3Dk4VvX0eVKnogB
         zU6+cnI0vKZ7u8nbCLGHhNvLQgUqZ+bZyePTS5zK3Fs1NpNRikb23slK1kiNzJoBkF
         XJ2hxqdOq/DfbAieAdgRMc7TpYwZsG+4wQohiMqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        "kernelci.org bot" <bot@kernelci.org>,
        Niklas Cassel <niklas.cassel@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 003/122] Revert "OPP: Protect dev_list with opp_table lock"
Date:   Fri, 22 Nov 2019 11:27:36 +0100
Message-Id: <20191122100723.867534497@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 714ab224a8db6e8255c61a42613de9349ceb0bba which is
commit 3d2556992a878a2210d3be498416aee39e0c32aa upstream.

Turns out to break the build on the odroid machines, so it needs to be
reverted.

Reported-by: Viresh Kumar <viresh.kumar@linaro.org>
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Cc: Niklas Cassel <niklas.cassel@linaro.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/opp/core.c |   21 ++-------------------
 drivers/base/power/opp/cpu.c  |    2 --
 drivers/base/power/opp/opp.h  |    2 +-
 3 files changed, 3 insertions(+), 22 deletions(-)

--- a/drivers/base/power/opp/core.c
+++ b/drivers/base/power/opp/core.c
@@ -49,14 +49,9 @@ static struct opp_device *_find_opp_dev(
 static struct opp_table *_find_opp_table_unlocked(struct device *dev)
 {
 	struct opp_table *opp_table;
-	bool found;
 
 	list_for_each_entry(opp_table, &opp_tables, node) {
-		mutex_lock(&opp_table->lock);
-		found = !!_find_opp_dev(dev, opp_table);
-		mutex_unlock(&opp_table->lock);
-
-		if (found) {
+		if (_find_opp_dev(dev, opp_table)) {
 			_get_opp_table_kref(opp_table);
 
 			return opp_table;
@@ -716,8 +711,6 @@ struct opp_device *_add_opp_dev(const st
 
 	/* Initialize opp-dev */
 	opp_dev->dev = dev;
-
-	mutex_lock(&opp_table->lock);
 	list_add(&opp_dev->node, &opp_table->dev_list);
 
 	/* Create debugfs entries for the opp_table */
@@ -725,7 +718,6 @@ struct opp_device *_add_opp_dev(const st
 	if (ret)
 		dev_err(dev, "%s: Failed to register opp debugfs (%d)\n",
 			__func__, ret);
-	mutex_unlock(&opp_table->lock);
 
 	return opp_dev;
 }
@@ -744,7 +736,6 @@ static struct opp_table *_allocate_opp_t
 	if (!opp_table)
 		return NULL;
 
-	mutex_init(&opp_table->lock);
 	INIT_LIST_HEAD(&opp_table->dev_list);
 
 	opp_dev = _add_opp_dev(dev, opp_table);
@@ -766,6 +757,7 @@ static struct opp_table *_allocate_opp_t
 
 	BLOCKING_INIT_NOTIFIER_HEAD(&opp_table->head);
 	INIT_LIST_HEAD(&opp_table->opp_list);
+	mutex_init(&opp_table->lock);
 	kref_init(&opp_table->kref);
 
 	/* Secure the device table modification */
@@ -807,10 +799,6 @@ static void _opp_table_kref_release(stru
 	if (!IS_ERR(opp_table->clk))
 		clk_put(opp_table->clk);
 
-	/*
-	 * No need to take opp_table->lock here as we are guaranteed that no
-	 * references to the OPP table are taken at this point.
-	 */
 	opp_dev = list_first_entry(&opp_table->dev_list, struct opp_device,
 				   node);
 
@@ -1714,9 +1702,6 @@ void _dev_pm_opp_remove_table(struct opp
 {
 	struct dev_pm_opp *opp, *tmp;
 
-	/* Protect dev_list */
-	mutex_lock(&opp_table->lock);
-
 	/* Find if opp_table manages a single device */
 	if (list_is_singular(&opp_table->dev_list)) {
 		/* Free static OPPs */
@@ -1727,8 +1712,6 @@ void _dev_pm_opp_remove_table(struct opp
 	} else {
 		_remove_opp_dev(_find_opp_dev(dev, opp_table), opp_table);
 	}
-
-	mutex_unlock(&opp_table->lock);
 }
 
 void _dev_pm_opp_find_and_remove_table(struct device *dev, bool remove_all)
--- a/drivers/base/power/opp/cpu.c
+++ b/drivers/base/power/opp/cpu.c
@@ -222,10 +222,8 @@ int dev_pm_opp_get_sharing_cpus(struct d
 	cpumask_clear(cpumask);
 
 	if (opp_table->shared_opp == OPP_TABLE_ACCESS_SHARED) {
-		mutex_lock(&opp_table->lock);
 		list_for_each_entry(opp_dev, &opp_table->dev_list, node)
 			cpumask_set_cpu(opp_dev->dev->id, cpumask);
-		mutex_unlock(&opp_table->lock);
 	} else {
 		cpumask_set_cpu(cpu_dev->id, cpumask);
 	}
--- a/drivers/base/power/opp/opp.h
+++ b/drivers/base/power/opp/opp.h
@@ -124,7 +124,7 @@ enum opp_table_access {
  * @dev_list:	list of devices that share these OPPs
  * @opp_list:	table of opps
  * @kref:	for reference count of the table.
- * @lock:	mutex protecting the opp_list and dev_list.
+ * @lock:	mutex protecting the opp_list.
  * @np:		struct device_node pointer for opp's DT node.
  * @clock_latency_ns_max: Max clock latency in nanoseconds.
  * @shared_opp: OPP is shared between multiple devices.


