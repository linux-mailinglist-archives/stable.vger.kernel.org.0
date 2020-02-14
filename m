Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B62015EDE2
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389528AbgBNRgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:36:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:55060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389779AbgBNQFW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:05:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 787312187F;
        Fri, 14 Feb 2020 16:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696322;
        bh=pkzmAGkgONH4rFn4Kchybr1EOFbP5fb3Z/OEklRicnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AXL7ygHtkma4OBYbpdsjIYBTaYbiLNcxq54bN2gaP/DtI3HLVqV14owCVDuBqZiXT
         J0pQDOGADPeIzw8LAfeKRPvd6tAIQsVGP4sfwCD5a4e8SVzLKbp0By5M1uYgJmZh6H
         ceOlQcityVFTnL2kbUhg0qGtcGwt9b3dGAu54Acc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 162/459] opp: Free static OPPs on errors while adding them
Date:   Fri, 14 Feb 2020 10:56:52 -0500
Message-Id: <20200214160149.11681-162-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit ba0033192145cbd4e70ef64552958b13d597eb9e ]

The static OPPs aren't getting freed properly, if errors occur while
adding them. Fix that by calling _put_opp_list_kref() and putting their
reference on failures.

Fixes: 11e1a1648298 ("opp: Don't decrement uninitialized list_kref")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/of.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/opp/of.c b/drivers/opp/of.c
index 1cbb58240b801..1e5fcdee043c4 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -678,15 +678,17 @@ static int _of_add_opp_table_v2(struct device *dev, struct opp_table *opp_table)
 			dev_err(dev, "%s: Failed to add OPP, %d\n", __func__,
 				ret);
 			of_node_put(np);
-			return ret;
+			goto put_list_kref;
 		} else if (opp) {
 			count++;
 		}
 	}
 
 	/* There should be one of more OPP defined */
-	if (WARN_ON(!count))
-		return -ENOENT;
+	if (WARN_ON(!count)) {
+		ret = -ENOENT;
+		goto put_list_kref;
+	}
 
 	list_for_each_entry(opp, &opp_table->opp_list, node)
 		pstate_count += !!opp->pstate;
@@ -695,7 +697,8 @@ static int _of_add_opp_table_v2(struct device *dev, struct opp_table *opp_table)
 	if (pstate_count && pstate_count != count) {
 		dev_err(dev, "Not all nodes have performance state set (%d: %d)\n",
 			count, pstate_count);
-		return -ENOENT;
+		ret = -ENOENT;
+		goto put_list_kref;
 	}
 
 	if (pstate_count)
@@ -704,6 +707,11 @@ static int _of_add_opp_table_v2(struct device *dev, struct opp_table *opp_table)
 	opp_table->parsed_static_opps = true;
 
 	return 0;
+
+put_list_kref:
+	_put_opp_list_kref(opp_table);
+
+	return ret;
 }
 
 /* Initializes OPP tables based on old-deprecated bindings */
@@ -738,6 +746,7 @@ static int _of_add_opp_table_v1(struct device *dev, struct opp_table *opp_table)
 		if (ret) {
 			dev_err(dev, "%s: Failed to add OPP %ld (%d)\n",
 				__func__, freq, ret);
+			_put_opp_list_kref(opp_table);
 			return ret;
 		}
 		nr -= 2;
-- 
2.20.1

