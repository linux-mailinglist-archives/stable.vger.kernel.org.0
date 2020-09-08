Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABDF2261C57
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731189AbgIHTSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:18:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731146AbgIHQCx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:02:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E89523D99;
        Tue,  8 Sep 2020 15:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579457;
        bh=q3vBjvCt0Cagzm5812yCqvqral+gB1OvdBKbPXl4hk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gr/X4SBLuLeeqs13Acc+0tVNgMzY7HRRIWoqSpB+NmsE4FnxUCMsrm6dcDA3ByaR0
         YQDHXChoo5FP6VInJATwwLkKTNfBa4QMHod6tS32gm42PIZQUqXQCP8NO4BIrgAwRJ
         vYMySb0vtmHPRNpaBHNyt0usySPbVT0PYZzs+FKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 086/186] opp: Dont drop reference for an OPP table that was never parsed
Date:   Tue,  8 Sep 2020 17:23:48 +0200
Message-Id: <20200908152245.811400583@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 922ff0759a16299e24cacfc981ac07914d8f1826 ]

dev_pm_opp_remove_table() should drop a reference to the OPP table only
if the DT OPP table was parsed earlier with a call to
dev_pm_opp_of_add_table() earlier. Else it may end up dropping the
reference to the OPP table, which was added as a result of other calls
like dev_pm_opp_set_clkname(). And would hence result in undesirable
behavior later on when caller would try to free the resource again.

Fixes: 03758d60265c ("opp: Replace list_kref with a local counter")
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: Anders Roxell <anders.roxell@linaro.org>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c | 22 ++++++++++++++++------
 drivers/opp/opp.h  |  2 +-
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index 8c90f78717723..91dcad982d362 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -1265,13 +1265,19 @@ void dev_pm_opp_remove(struct device *dev, unsigned long freq)
 }
 EXPORT_SYMBOL_GPL(dev_pm_opp_remove);
 
-void _opp_remove_all_static(struct opp_table *opp_table)
+bool _opp_remove_all_static(struct opp_table *opp_table)
 {
 	struct dev_pm_opp *opp, *tmp;
+	bool ret = true;
 
 	mutex_lock(&opp_table->lock);
 
-	if (!opp_table->parsed_static_opps || --opp_table->parsed_static_opps)
+	if (!opp_table->parsed_static_opps) {
+		ret = false;
+		goto unlock;
+	}
+
+	if (--opp_table->parsed_static_opps)
 		goto unlock;
 
 	list_for_each_entry_safe(opp, tmp, &opp_table->opp_list, node) {
@@ -1281,6 +1287,8 @@ void _opp_remove_all_static(struct opp_table *opp_table)
 
 unlock:
 	mutex_unlock(&opp_table->lock);
+
+	return ret;
 }
 
 /**
@@ -2382,13 +2390,15 @@ void _dev_pm_opp_find_and_remove_table(struct device *dev)
 		return;
 	}
 
-	_opp_remove_all_static(opp_table);
+	/*
+	 * Drop the extra reference only if the OPP table was successfully added
+	 * with dev_pm_opp_of_add_table() earlier.
+	 **/
+	if (_opp_remove_all_static(opp_table))
+		dev_pm_opp_put_opp_table(opp_table);
 
 	/* Drop reference taken by _find_opp_table() */
 	dev_pm_opp_put_opp_table(opp_table);
-
-	/* Drop reference taken while the OPP table was added */
-	dev_pm_opp_put_opp_table(opp_table);
 }
 
 /**
diff --git a/drivers/opp/opp.h b/drivers/opp/opp.h
index e51646ff279eb..c3fcd571e446d 100644
--- a/drivers/opp/opp.h
+++ b/drivers/opp/opp.h
@@ -212,7 +212,7 @@ struct opp_table {
 
 /* Routines internal to opp core */
 void dev_pm_opp_get(struct dev_pm_opp *opp);
-void _opp_remove_all_static(struct opp_table *opp_table);
+bool _opp_remove_all_static(struct opp_table *opp_table);
 void _get_opp_table_kref(struct opp_table *opp_table);
 int _get_opp_count(struct opp_table *opp_table);
 struct opp_table *_find_opp_table(struct device *dev);
-- 
2.25.1



