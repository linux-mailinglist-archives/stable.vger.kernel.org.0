Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2CA69700
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733279AbfGOPIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 11:08:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733120AbfGON6S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:58:18 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56884217D9;
        Mon, 15 Jul 2019 13:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199097;
        bh=pZYgTxZBhlV4zkeYOyQJylLILoJ83z/GR/3CqaetBTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=THYyPTgW/obmuU/dPSm99zLcoGYj/DKPrDwyG00o5ddd3R9iMuxAr5DpnlHpOznRc
         lRNKmvCfR6byhDHs2oNxmgg96oSHD0Sq1bCyDaEh2eVa2MIFury4s8moBdKOu34JBi
         LmLfLkZYxZ6FacweJHU6ExHLXtTZTXa2L7AmwGzY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 191/249] cpufreq: Don't skip frequency validation for has_target() drivers
Date:   Mon, 15 Jul 2019 09:45:56 -0400
Message-Id: <20190715134655.4076-191-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 9801522840cc1073f8064b4c979b7b6995c74bca ]

CPUFREQ_CONST_LOOPS was introduced in a very old commit from pre-2.6
kernel release by commit 6a4a93f9c0d5 ("[CPUFREQ] Fix 'out of sync'
issue").

Basically, that commit does two things:

 - It adds the frequency verification code (which is quite similar to
   what we have today as well).

 - And it sets the CPUFREQ_CONST_LOOPS flag only for setpolicy drivers,
   rightly so based on the code we had then. The idea was to avoid
   frequency validation for setpolicy drivers as the cpufreq core doesn't
   know what frequency the hardware is running at and so no point in
   doing frequency verification.

The problem happened when we started to use the same CPUFREQ_CONST_LOOPS
flag for constant loops-per-jiffy thing as well and many has_target()
drivers started using the same flag and unknowingly skipped the
verification of frequency. There is no logical reason behind skipping
frequency validation because of the presence of CPUFREQ_CONST_LOOPS
flag otherwise.

Fix this issue by skipping frequency validation only for setpolicy
drivers and always doing it for has_target() drivers irrespective of
the presence or absence of CPUFREQ_CONST_LOOPS flag.

cpufreq_notify_transition() is only called for has_target() type driver
and not for set_policy type, and the check is simply redundant. Remove
it as well.

Also remove () around freq comparison statement as they aren't required
and checkpatch also warns for them.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 876a4cb09de3..7d37efb43621 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -356,12 +356,10 @@ static void cpufreq_notify_transition(struct cpufreq_policy *policy,
 		 * which is not equal to what the cpufreq core thinks is
 		 * "old frequency".
 		 */
-		if (!(cpufreq_driver->flags & CPUFREQ_CONST_LOOPS)) {
-			if (policy->cur && (policy->cur != freqs->old)) {
-				pr_debug("Warning: CPU frequency is %u, cpufreq assumed %u kHz\n",
-					 freqs->old, policy->cur);
-				freqs->old = policy->cur;
-			}
+		if (policy->cur && policy->cur != freqs->old) {
+			pr_debug("Warning: CPU frequency is %u, cpufreq assumed %u kHz\n",
+				 freqs->old, policy->cur);
+			freqs->old = policy->cur;
 		}
 
 		srcu_notifier_call_chain(&cpufreq_transition_notifier_list,
@@ -1627,8 +1625,7 @@ static unsigned int __cpufreq_get(struct cpufreq_policy *policy)
 	if (policy->fast_switch_enabled)
 		return ret_freq;
 
-	if (ret_freq && policy->cur &&
-		!(cpufreq_driver->flags & CPUFREQ_CONST_LOOPS)) {
+	if (has_target() && ret_freq && policy->cur) {
 		/* verify no discrepancy between actual and
 					saved value exists */
 		if (unlikely(ret_freq != policy->cur)) {
-- 
2.20.1

