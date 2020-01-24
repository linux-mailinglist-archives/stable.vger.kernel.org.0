Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C846F14845E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbgAXLCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:02:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:36046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731019AbgAXLCb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:02:31 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 968EE2075D;
        Fri, 24 Jan 2020 11:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863750;
        bh=1p9ROvcEKXiT3pQd3v0LUyWd1bIzQeqDdQQBqmZSLYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LS1tlXbeZvF4GCNCS5rNCFHzkvy9ru5r+sr4DSJxfVXRrL/zXuDd6pCA9R01kdvqz
         MAbrLXtolcGQfsYwXDNBwdK4vzyPVNabuzHWm7AYl3Spnth90+gqY3TZ0MXeXgL/tT
         gdQUfRcNySTOgabMs2E1PcwEkfeuFm+VVHUvYe5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Perret <quentin.perret@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 078/639] OPP: Fix missing debugfs supply directory for OPPs
Date:   Fri, 24 Jan 2020 10:24:08 +0100
Message-Id: <20200124093057.160632639@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 46f48aca2e5aef3f430e95d1a5fb68227ec8ec85 ]

There is one case where we may end up with no "supply" directory for the
OPPs in debugfs. That happens when the OPP core isn't managing the
regulators for the device and the device's OPP do have microvolt
property. It happens because the opp_table->regulator_count remains set
to 0 and the debugfs routines don't add any supply directory in such a
case.

This commit fixes that by setting opp_table->regulator_count to 1 in
that particular case. But to make everything work nicely and not break
other parts of the core, regulator_count is defined as "int" now instead
of "unsigned int" and it can have different special values now. It is
set to -1 initially to mark it "uninitialized" and later only we set it
to 0 or positive values after checking how many supplies are there.

This also helps in finding the bugs where only few of the OPPs have the
"opp-microvolt" property set and not all.

Fixes: 1fae788ed640 ("PM / OPP: Don't create debugfs "supply-0" directory unnecessarily")
Reported-by: Quentin Perret <quentin.perret@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c | 12 +++++++++---
 drivers/opp/of.c   | 20 ++++++++++++++++----
 drivers/opp/opp.h  |  6 ++++--
 3 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index 1e80f9ec1aa6a..34515f4323755 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -793,6 +793,9 @@ static struct opp_table *_allocate_opp_table(struct device *dev)
 
 	INIT_LIST_HEAD(&opp_table->dev_list);
 
+	/* Mark regulator count uninitialized */
+	opp_table->regulator_count = -1;
+
 	opp_dev = _add_opp_dev(dev, opp_table);
 	if (!opp_dev) {
 		kfree(opp_table);
@@ -955,7 +958,7 @@ struct dev_pm_opp *_opp_allocate(struct opp_table *table)
 	int count, supply_size;
 
 	/* Allocate space for at least one supply */
-	count = table->regulator_count ? table->regulator_count : 1;
+	count = table->regulator_count > 0 ? table->regulator_count : 1;
 	supply_size = sizeof(*opp->supplies) * count;
 
 	/* allocate new OPP node and supplies structures */
@@ -1363,7 +1366,7 @@ free_regulators:
 
 	kfree(opp_table->regulators);
 	opp_table->regulators = NULL;
-	opp_table->regulator_count = 0;
+	opp_table->regulator_count = -1;
 err:
 	dev_pm_opp_put_opp_table(opp_table);
 
@@ -1392,7 +1395,7 @@ void dev_pm_opp_put_regulators(struct opp_table *opp_table)
 
 	kfree(opp_table->regulators);
 	opp_table->regulators = NULL;
-	opp_table->regulator_count = 0;
+	opp_table->regulator_count = -1;
 
 put_opp_table:
 	dev_pm_opp_put_opp_table(opp_table);
@@ -1545,6 +1548,9 @@ int dev_pm_opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
 	if (!opp_table)
 		return -ENOMEM;
 
+	/* Fix regulator count for dynamic OPPs */
+	opp_table->regulator_count = 1;
+
 	ret = _opp_add_v1(opp_table, dev, freq, u_volt, true);
 
 	dev_pm_opp_put_opp_table(opp_table);
diff --git a/drivers/opp/of.c b/drivers/opp/of.c
index 20988c4266501..d64a13d7881b9 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -113,12 +113,10 @@ static int opp_parse_supplies(struct dev_pm_opp *opp, struct device *dev,
 			      struct opp_table *opp_table)
 {
 	u32 *microvolt, *microamp = NULL;
-	int supplies, vcount, icount, ret, i, j;
+	int supplies = opp_table->regulator_count, vcount, icount, ret, i, j;
 	struct property *prop = NULL;
 	char name[NAME_MAX];
 
-	supplies = opp_table->regulator_count ? opp_table->regulator_count : 1;
-
 	/* Search for "opp-microvolt-<name>" */
 	if (opp_table->prop_name) {
 		snprintf(name, sizeof(name), "opp-microvolt-%s",
@@ -133,7 +131,13 @@ static int opp_parse_supplies(struct dev_pm_opp *opp, struct device *dev,
 
 		/* Missing property isn't a problem, but an invalid entry is */
 		if (!prop) {
-			if (!opp_table->regulator_count)
+			if (unlikely(supplies == -1)) {
+				/* Initialize regulator_count */
+				opp_table->regulator_count = 0;
+				return 0;
+			}
+
+			if (!supplies)
 				return 0;
 
 			dev_err(dev, "%s: opp-microvolt missing although OPP managing regulators\n",
@@ -142,6 +146,14 @@ static int opp_parse_supplies(struct dev_pm_opp *opp, struct device *dev,
 		}
 	}
 
+	if (unlikely(supplies == -1)) {
+		/* Initialize regulator_count */
+		supplies = opp_table->regulator_count = 1;
+	} else if (unlikely(!supplies)) {
+		dev_err(dev, "%s: opp-microvolt wasn't expected\n", __func__);
+		return -EINVAL;
+	}
+
 	vcount = of_property_count_u32_elems(opp->np, name);
 	if (vcount < 0) {
 		dev_err(dev, "%s: Invalid %s property (%d)\n",
diff --git a/drivers/opp/opp.h b/drivers/opp/opp.h
index 7c540fd063b2d..c9e65964ed848 100644
--- a/drivers/opp/opp.h
+++ b/drivers/opp/opp.h
@@ -136,7 +136,9 @@ enum opp_table_access {
  * @prop_name: A name to postfix to many DT properties, while parsing them.
  * @clk: Device's clock handle
  * @regulators: Supply regulators
- * @regulator_count: Number of power supply regulators
+ * @regulator_count: Number of power supply regulators. Its value can be -1
+ * (uninitialized), 0 (no opp-microvolt property) or > 0 (has opp-microvolt
+ * property).
  * @genpd_performance_state: Device's power domain support performance state.
  * @set_opp: Platform specific set_opp callback
  * @set_opp_data: Data to be passed to set_opp callback
@@ -172,7 +174,7 @@ struct opp_table {
 	const char *prop_name;
 	struct clk *clk;
 	struct regulator **regulators;
-	unsigned int regulator_count;
+	int regulator_count;
 	bool genpd_performance_state;
 
 	int (*set_opp)(struct dev_pm_set_opp_data *data);
-- 
2.20.1



