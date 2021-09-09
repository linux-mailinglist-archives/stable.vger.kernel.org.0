Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425E3404F67
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345390AbhIIMS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:18:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:52734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349188AbhIIMQL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:16:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B57A61A7E;
        Thu,  9 Sep 2021 11:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188181;
        bh=3ZMTULSPQXOdZ/di0LDOj5yFcZBORx8HuF+cqb/vYl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SD7G6adKj1ByyPnPwankkXQojKjfG50NVM1/tAWKUPW5s4/uHLcUHSWlXiz/MoHWk
         nV7B3LDpeofZBriB5hSu/sKmswOX/GSzWDt80EEM89quIsuAd8+vNEBVvsKDsEU3QB
         tPlh5bpyLz5g3EvjlAk9RybmTv8Km8ZWGJSXHh4UAECwrqa4lOKzXGK7V2dg1wese9
         Y2A4M2fqJPuumyMMr2b5LQoxtqYCHs9bCOccV4TKJS8u3PDdzLCfF9mV596ut7OjSL
         ps9nJXqLxIkver70qlqKsHshsBWpCt2khNFEX862gSn6nRhOuGqSkyqj5M8Wmk+48g
         mkEmxIKcAdmHw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rajendra Nayak <rnayak@codeaurora.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 143/219] opp: Don't print an error if required-opps is missing
Date:   Thu,  9 Sep 2021 07:45:19 -0400
Message-Id: <20210909114635.143983-143-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rajendra Nayak <rnayak@codeaurora.org>

[ Upstream commit 020d86fc0df8b865f6dc168d88a7c2dccabd0a9e ]

The 'required-opps' property is considered optional, hence remove
the pr_err() in of_parse_required_opp() when we find the property is
missing.
While at it, also fix the return value of
of_get_required_opp_performance_state() when of_parse_required_opp()
fails, return a -ENODEV instead of the -EINVAL.

Signed-off-by: Rajendra Nayak <rnayak@codeaurora.org>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/of.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/opp/of.c b/drivers/opp/of.c
index 01feeba78426..de550ee48e77 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -95,15 +95,7 @@ static struct dev_pm_opp *_find_opp_of_np(struct opp_table *opp_table,
 static struct device_node *of_parse_required_opp(struct device_node *np,
 						 int index)
 {
-	struct device_node *required_np;
-
-	required_np = of_parse_phandle(np, "required-opps", index);
-	if (unlikely(!required_np)) {
-		pr_err("%s: Unable to parse required-opps: %pOF, index: %d\n",
-		       __func__, np, index);
-	}
-
-	return required_np;
+	return of_parse_phandle(np, "required-opps", index);
 }
 
 /* The caller must call dev_pm_opp_put_opp_table() after the table is used */
@@ -1349,7 +1341,7 @@ int of_get_required_opp_performance_state(struct device_node *np, int index)
 
 	required_np = of_parse_required_opp(np, index);
 	if (!required_np)
-		return -EINVAL;
+		return -ENODEV;
 
 	opp_table = _find_table_of_opp_np(required_np);
 	if (IS_ERR(opp_table)) {
-- 
2.30.2

