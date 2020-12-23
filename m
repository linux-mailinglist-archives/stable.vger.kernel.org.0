Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1574A2E155E
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbgLWCVP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:21:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:46354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729264AbgLWCVP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:21:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2530123159;
        Wed, 23 Dec 2020 02:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690057;
        bh=0d00F80+U8kMZ21VJjFI0YdSZN9PalaSgFSCylhm5tY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RV70dsEvxmXoD/wpl5GECkVlxpZH75KBMrpTx5h1F9kXI9NUkYmRd2dvNQGU92pgS
         JlpWg6DZag6I0UW1EZbbcITTDw0ANEoQQvAqtwTqikXDXxZilAkqCugofHyucgfp5v
         WpvNuMJIG2Y98BfIouUxmG3gDWFJlb6TO5R1L11fvHBDNhegbHOOoa/IvTWrtbLDt5
         zSSpMaZXqVFzxwqx4849esS/dIof8lIT/HQwJOXIg8d6aa5p1UbhGMg5ic6JZDaCOY
         HfIrzu45h7fAQ1PCCOkHhQB9vCnXNkmefEx/TW3pqwAYwNIh1H1Sqq+QrG5Mnuhdx1
         X7PCOWMRdbxpw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang ShaoBo <bobo.shaobowang@huawei.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 127/130] cpufreq: Fix cpufreq_online() return value on errors
Date:   Tue, 22 Dec 2020 21:18:10 -0500
Message-Id: <20201223021813.2791612-127-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang ShaoBo <bobo.shaobowang@huawei.com>

[ Upstream commit b96f038432362a20b96d4c52cefeb2936e2cfd2f ]

Make cpufreq_online() return negative error codes on all errors that
cause the policy to be destroyed, as appropriate.

Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 194a6587a1de1..1178ac323a9e0 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1384,8 +1384,10 @@ static int cpufreq_online(unsigned int cpu)
 
 		policy->min_freq_req = kzalloc(2 * sizeof(*policy->min_freq_req),
 					       GFP_KERNEL);
-		if (!policy->min_freq_req)
+		if (!policy->min_freq_req) {
+			ret = -ENOMEM;
 			goto out_destroy_policy;
+		}
 
 		ret = freq_qos_add_request(&policy->constraints,
 					   policy->min_freq_req, FREQ_QOS_MIN,
@@ -1422,6 +1424,7 @@ static int cpufreq_online(unsigned int cpu)
 	if (cpufreq_driver->get && has_target()) {
 		policy->cur = cpufreq_driver->get(policy->cpu);
 		if (!policy->cur) {
+			ret = -EIO;
 			pr_err("%s: ->get() failed\n", __func__);
 			goto out_destroy_policy;
 		}
-- 
2.27.0

