Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9A7328CBD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240773AbhCAS5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:57:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:58450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240551AbhCASwW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:52:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BF956534B;
        Mon,  1 Mar 2021 17:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620680;
        bh=IGbafg3/x6fH60vPeu1G56lScjNGHVynlVsoJeT/4SI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MXzES2+wOMTorM0QPY7RuxKOkmgQtjW/u2RxaA0HgsGUQmhcKLx/mPLh2oVUnMzRH
         RkvTd3mDBBcZjwV9GvlEYq2QBYwQ+dG5sEX48dQXbIEy8xzfrYhOMQWe7ZoC6bhtpP
         ULZMLcx2KJcxhL0kxNehppr8OOTplaH/13eCMJPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 241/775] perf/arm-cmn: Move IRQs when migrating context
Date:   Mon,  1 Mar 2021 17:06:49 +0100
Message-Id: <20210301161213.541658759@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 1c8147ea89c883d1f4e20f1b1d9c879291430102 ]

If we migrate the PMU context to another CPU, we need to remember to
retarget the IRQs as well.

Fixes: 0ba64770a2f2 ("perf: Add Arm CMN-600 PMU driver")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/e080640aea4ed8dfa870b8549dfb31221803eb6b.1611839564.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm-cmn.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index f3071b5ddaaef..46defb1dcf867 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -1150,7 +1150,7 @@ static int arm_cmn_commit_txn(struct pmu *pmu)
 static int arm_cmn_pmu_offline_cpu(unsigned int cpu, struct hlist_node *node)
 {
 	struct arm_cmn *cmn;
-	unsigned int target;
+	unsigned int i, target;
 
 	cmn = hlist_entry_safe(node, struct arm_cmn, cpuhp_node);
 	if (cpu != cmn->cpu)
@@ -1161,6 +1161,8 @@ static int arm_cmn_pmu_offline_cpu(unsigned int cpu, struct hlist_node *node)
 		return 0;
 
 	perf_pmu_migrate_context(&cmn->pmu, cpu, target);
+	for (i = 0; i < cmn->num_dtcs; i++)
+		irq_set_affinity_hint(cmn->dtc[i].irq, cpumask_of(target));
 	cmn->cpu = target;
 	return 0;
 }
-- 
2.27.0



