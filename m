Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F377D4A82C
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 19:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbfFRRWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 13:22:25 -0400
Received: from foss.arm.com ([217.140.110.172]:51360 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728572AbfFRRWZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jun 2019 13:22:25 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 30859CFC;
        Tue, 18 Jun 2019 10:22:24 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.105])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB47B3F738;
        Tue, 18 Jun 2019 10:22:22 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org
Cc:     Fenghua Yu <fenghua.yu@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>, x86@kernel.org,
        James Morse <james.morse@arm.com>
Subject: [PATCH stable v4.19.52] x86/resctrl: Don't stop walking closids when a locksetup group is found
Date:   Tue, 18 Jun 2019 18:22:03 +0100
Message-Id: <20190618172203.262098-1-james.morse@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 87d3aa28f345bea77c396855fa5d5fec4c24461f upstream.

When a new control group is created __init_one_rdt_domain() walks all
the other closids to calculate the sets of used and unused bits.

If it discovers a pseudo_locksetup group, it breaks out of the loop.  This
means any later closid doesn't get its used bits added to used_b.  These
bits will then get set in unused_b, and added to the new control group's
configuration, even if they were marked as exclusive for a later closid.

When encountering a pseudo_locksetup group, we should continue. This is
because "a resource group enters 'pseudo-locked' mode after the schemata is
written while the resource group is in 'pseudo-locksetup' mode." When we
find a pseudo_locksetup group, its configuration is expected to be
overwritten, we can skip it.

Fixes: dfe9674b04ff6 ("x86/intel_rdt: Enable entering of pseudo-locksetup mode")
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H Peter Avin <hpa@zytor.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20190603172531.178830-1-james.morse@arm.com
[Dropped comment due to lack space]
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
index 643670fb8943..274d220d0a83 100644
--- a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
+++ b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
@@ -2379,7 +2379,7 @@ static int rdtgroup_init_alloc(struct rdtgroup *rdtgrp)
 				if (closid_allocated(i) && i != closid) {
 					mode = rdtgroup_mode_by_closid(i);
 					if (mode == RDT_MODE_PSEUDO_LOCKSETUP)
-						break;
+						continue;
 					used_b |= *ctrl;
 					if (mode == RDT_MODE_SHAREABLE)
 						d->new_ctrl |= *ctrl;
-- 
2.20.1

