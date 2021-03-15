Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D340333B983
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbhCOOGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233401AbhCOOBj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1999964D9E;
        Mon, 15 Mar 2021 14:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816873;
        bh=23+1Wofn/x43v8T4KE32t44L6MJUrXyBVUc35mfI5A8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yjt+heki6e3CRoTFw0LZqGgpQ1HKc36oAt5JxYkyDDqb5b5nqrjmKek7LsJA8v9wC
         NcKQSDD6Gsyi41JX2aBc43DFKqA13GyXeThIdepDGfNhotg/3Tsw433W6HK15xJ2IE
         rr8/WkSxXMP0kx7QSUq0TAyeIgzucNSL5anucRzE=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Beata Michalska <beata.michalska@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.11 176/306] opp: Dont drop extra references to OPPs accidentally
Date:   Mon, 15 Mar 2021 14:53:59 +0100
Message-Id: <20210315135513.562551333@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Beata Michalska <beata.michalska@arm.com>

commit 606a5d4227e4610399c61086ac55c46068a90b03 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/opp/core.c |   48 +++++++++++++++++++++++++-----------------------
 drivers/opp/opp.h  |    2 ++
 2 files changed, 27 insertions(+), 23 deletions(-)

--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -1335,7 +1335,11 @@ static struct dev_pm_opp *_opp_get_next(
 
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
@@ -1345,10 +1349,27 @@ static struct dev_pm_opp *_opp_get_next(
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
@@ -1363,13 +1384,7 @@ bool _opp_remove_all_static(struct opp_t
 
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
 
@@ -1382,25 +1397,12 @@ bool _opp_remove_all_static(struct opp_t
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
--- a/drivers/opp/opp.h
+++ b/drivers/opp/opp.h
@@ -56,6 +56,7 @@ extern struct list_head opp_tables;
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


