Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A26426F1AD
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgIRCxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:53:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727339AbgIRCHy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DAF52389E;
        Fri, 18 Sep 2020 02:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394874;
        bh=8MljDeggPdi9vFj6AXRrmOaExwKwArRNdb/1KDKnZxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVxYH2/Xpko9lsr7U60YsKMn2dXQlBbUJ7LKweI1YsRHkfDBOqs8HzVELn7xXaM/B
         chITWNPfkd+fa32LfqjATK7CHUmbx7aZztSfqUhqudEPDctjZcZp/hgfCWGqSOv7eg
         1EkqWeIR39HKr1pW5t78oMWIHNuYncx1Pe/7OJ6c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Walter Lozano <walter.lozano@collabora.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 325/330] opp: Increase parsed_static_opps in _of_add_opp_table_v1()
Date:   Thu, 17 Sep 2020 22:01:05 -0400
Message-Id: <20200918020110.2063155-325-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Walter Lozano <walter.lozano@collabora.com>

[ Upstream commit 6544abc520f0fff701e9da382110dc29676c683a ]

Currently, when using _of_add_opp_table_v2 parsed_static_opps is
increased and this value is used in _opp_remove_all_static() to
check if there are static opp entries that need to be freed.
Unfortunately this does not happen when using _of_add_opp_table_v1(),
which leads to warnings.

This patch increases parsed_static_opps in _of_add_opp_table_v1() in a
similar way as in _of_add_opp_table_v2().

Fixes: 03758d60265c ("opp: Replace list_kref with a local counter")
Cc: v5.6+ <stable@vger.kernel.org> # v5.6+
Signed-off-by: Walter Lozano <walter.lozano@collabora.com>
[ Viresh: Do the operation with lock held and set the value to 1 instead
	  of incrementing it ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/of.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/opp/of.c b/drivers/opp/of.c
index 9cd8f0adacae4..249738e1e0b7a 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -733,6 +733,10 @@ static int _of_add_opp_table_v1(struct device *dev, struct opp_table *opp_table)
 		return -EINVAL;
 	}
 
+	mutex_lock(&opp_table->lock);
+	opp_table->parsed_static_opps = 1;
+	mutex_unlock(&opp_table->lock);
+
 	val = prop->value;
 	while (nr) {
 		unsigned long freq = be32_to_cpup(val++) * 1000;
-- 
2.25.1

