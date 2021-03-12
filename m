Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C63F33849A
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 05:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbhCLERG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 23:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbhCLERF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 23:17:05 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D97C061574
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 20:17:05 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so2666571pjb.0
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 20:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=psCwVt+HMpuF/3ueFUvJ3Kzy08liF94PegpIe6jUsIw=;
        b=k1X7gN79bF4A1DpE1plL6Cx86EhbOg4f5q1LzqlVl0/MzLs9k1G/w/f596T7c0jS3E
         GF3qr9n0aWxWQ9nj7NcNbQ0lbHY2igl+pl0JnN8QltHk1TdCjTUc0EGUpxEqc7PAZSkZ
         BHaq0mJ8EAArvE+aXmIPVBJvvoYl15SWgKYcoqqoAZdCNnwBfgHNj+I29Zh9TOVDp8I9
         Jo1RXdlFWfgasLPPy+cG/J1c3aSjez8jLMIyNVbQUaZRuRBblbRnNG1lXH0GOdYe7knR
         41insHDKPDGpLM6vBt8JJUTBDMQSkJQGpgkJPt4ssiLJ9iZEWqVgoC7hVeS8JxFm9c9k
         ZFZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=psCwVt+HMpuF/3ueFUvJ3Kzy08liF94PegpIe6jUsIw=;
        b=UwBkHFBTwI5dKxP9MUOQP/hhpTJ/FTX39wwEbt/YI3TR2F9pX2MYo7lpvUXRBxA5YV
         v+b+5zPKYH4O2QcWL2iFFESHTNzwTKAVs12MnnVBqEXkPAueW2Ok+MascLbXZSm9DBiU
         2Hp23IWnEVkEyupID/os8Bg9sm4RD6QNw42Gz7Yqm/zYbLArv5VpOvMxG0k6+qExQh1N
         Ve3asMLwPTIZZxFa2T4Ipe12jrbTVAFA+6tUjgj5/Giyk3b7RE8Ddh969ITm5OSxcvmY
         XOlhO4b5IXrTmL6Hvhq1xo/4Q/mo95OtMdFLjLP5dRr4EWyiaG6sKInQYq8mQKoblHdl
         XGJg==
X-Gm-Message-State: AOAM530RRXSHWqDehZXKF8+ULEO2QS3GXIoTvJX1nNXePxOaSFwzEuhx
        GC2zdanxxfbNOI5elIi/kUbSzQ==
X-Google-Smtp-Source: ABdhPJzV3jrLtEVNUi5lwDCIC7DmsJCHSkc5a3oEP4IMn/Op0uBDmPnajqJ6vyIEfI4ti6TbR1kYVw==
X-Received: by 2002:a17:90a:bb02:: with SMTP id u2mr8027389pjr.175.1615522624606;
        Thu, 11 Mar 2021 20:17:04 -0800 (PST)
Received: from localhost ([122.171.124.15])
        by smtp.gmail.com with ESMTPSA id b3sm3507535pgd.48.2021.03.11.20.17.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Mar 2021 20:17:03 -0800 (PST)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>,
        Stephen Boyd <sboyd@kernel.org>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Rafael Wysocki <rjw@rjwysocki.net>,
        Beata Michalska <beata.michalska@arm.com>,
        "v5 . 11+" <stable@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH V2] opp: Don't drop extra references to OPPs accidentally
Date:   Fri, 12 Mar 2021 09:46:59 +0530
Message-Id: <606a5d4227e4610399c61086ac55c46068a90b03.1615522590.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.25.0.rc1.19.g042ed3e048af
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Beata Michalska <beata.michalska@arm.com>

We are required to call dev_pm_opp_put() from outside of the
opp_table->lock as debugfs removal needs to happen lock-less to avoid
circular dependency issues.

commit cf1fac943c63 ("opp: Reduce the size of critical section in
_opp_kref_release()") tried to fix that introducing a new routine
_opp_get_next() which keeps returning OPPs that can be freed by the
callers and this routine shall be called without holding the
opp_table->lock.

Though the commit overlooked the fact that the OPPs can be referenced by
other users as well and this routine will end up dropping references
which were taken by other users and hence freeing the OPPs prematurely.

In effect, other users of the OPPs will end up having invalid pointers
at hand. We didn't see any crash reports earlier as the exact situation
never happened, though it is certainly possible.

We need a way to mark which OPPs are no longer referenced by the OPP
core, so we don't drop extra references to them accidentally.

This commit adds another OPP flag, "removed", which is used to track
this. And now we should never end up dropping extra references to the
OPPs.

Cc: v5.11+ <stable@vger.kernel.org> # v5.11+
Fixes: cf1fac943c63 ("opp: Reduce the size of critical section in _opp_kref_release()")
Signed-off-by: Beata Michalska <beata.michalska@arm.com>
[ Viresh: Almost rewrote entire patch, added new "removed" field,
	  rewrote commit log and added the correct Fixes tag. ]
Co-developed-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Sending it formally again so others don't miss it.

 drivers/opp/core.c | 48 ++++++++++++++++++++++++----------------------
 drivers/opp/opp.h  |  2 ++
 2 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index c2689386a906..1556998425d5 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -1492,7 +1492,11 @@ static struct dev_pm_opp *_opp_get_next(struct opp_table *opp_table,
 
 	mutex_lock(&opp_table->lock);
 	list_for_each_entry(temp, &opp_table->opp_list, node) {
-		if (dynamic == temp->dynamic) {
+		/*
+		 * Refcount must be dropped only once for each OPP by OPP core,
+		 * do that with help of "removed" flag.
+		 */
+		if (!temp->removed && dynamic == temp->dynamic) {
 			opp = temp;
 			break;
 		}
@@ -1502,10 +1506,27 @@ static struct dev_pm_opp *_opp_get_next(struct opp_table *opp_table,
 	return opp;
 }
 
-bool _opp_remove_all_static(struct opp_table *opp_table)
+/*
+ * Can't call dev_pm_opp_put() from under the lock as debugfs removal needs to
+ * happen lock less to avoid circular dependency issues. This routine must be
+ * called without the opp_table->lock held.
+ */
+static void _opp_remove_all(struct opp_table *opp_table, bool dynamic)
 {
 	struct dev_pm_opp *opp;
 
+	while ((opp = _opp_get_next(opp_table, dynamic))) {
+		opp->removed = true;
+		dev_pm_opp_put(opp);
+
+		/* Drop the references taken by dev_pm_opp_add() */
+		if (dynamic)
+			dev_pm_opp_put_opp_table(opp_table);
+	}
+}
+
+bool _opp_remove_all_static(struct opp_table *opp_table)
+{
 	mutex_lock(&opp_table->lock);
 
 	if (!opp_table->parsed_static_opps) {
@@ -1520,13 +1541,7 @@ bool _opp_remove_all_static(struct opp_table *opp_table)
 
 	mutex_unlock(&opp_table->lock);
 
-	/*
-	 * Can't remove the OPP from under the lock, debugfs removal needs to
-	 * happen lock less to avoid circular dependency issues.
-	 */
-	while ((opp = _opp_get_next(opp_table, false)))
-		dev_pm_opp_put(opp);
-
+	_opp_remove_all(opp_table, false);
 	return true;
 }
 
@@ -1539,25 +1554,12 @@ bool _opp_remove_all_static(struct opp_table *opp_table)
 void dev_pm_opp_remove_all_dynamic(struct device *dev)
 {
 	struct opp_table *opp_table;
-	struct dev_pm_opp *opp;
-	int count = 0;
 
 	opp_table = _find_opp_table(dev);
 	if (IS_ERR(opp_table))
 		return;
 
-	/*
-	 * Can't remove the OPP from under the lock, debugfs removal needs to
-	 * happen lock less to avoid circular dependency issues.
-	 */
-	while ((opp = _opp_get_next(opp_table, true))) {
-		dev_pm_opp_put(opp);
-		count++;
-	}
-
-	/* Drop the references taken by dev_pm_opp_add() */
-	while (count--)
-		dev_pm_opp_put_opp_table(opp_table);
+	_opp_remove_all(opp_table, true);
 
 	/* Drop the reference taken by _find_opp_table() */
 	dev_pm_opp_put_opp_table(opp_table);
diff --git a/drivers/opp/opp.h b/drivers/opp/opp.h
index 50fb9dced3c5..407c3bfe51d9 100644
--- a/drivers/opp/opp.h
+++ b/drivers/opp/opp.h
@@ -56,6 +56,7 @@ extern struct list_head opp_tables, lazy_opp_tables;
  * @dynamic:	not-created from static DT entries.
  * @turbo:	true if turbo (boost) OPP
  * @suspend:	true if suspend OPP
+ * @removed:	flag indicating that OPP's reference is dropped by OPP core.
  * @pstate: Device's power domain's performance state.
  * @rate:	Frequency in hertz
  * @level:	Performance level
@@ -78,6 +79,7 @@ struct dev_pm_opp {
 	bool dynamic;
 	bool turbo;
 	bool suspend;
+	bool removed;
 	unsigned int pstate;
 	unsigned long rate;
 	unsigned int level;
-- 
2.25.0.rc1.19.g042ed3e048af

