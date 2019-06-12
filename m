Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8B9425AA
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 14:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732372AbfFLM0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 08:26:38 -0400
Received: from terminus.zytor.com ([198.137.202.136]:50905 "EHLO
        terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726941AbfFLM0h (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 08:26:37 -0400
Received: from terminus.zytor.com (localhost [127.0.0.1])
        by terminus.zytor.com (8.15.2/8.15.2) with ESMTPS id x5CCQBEP684669
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 12 Jun 2019 05:26:11 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x5CCQBEP684669
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2019051801; t=1560342372;
        bh=RIOx94uVGjoMX+pwFiQ9jhG0RUv4R1Tnc+ptNY6+mmQ=;
        h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
        b=Yy9qQOEplWOR/bXZYPlJ89855eIc8CdmWT/YoUm0lejePqc8Z4x0Jj+ieXVRvlCh+
         DsnvTpbZQ7JEgodrT3QUhTnSg3Ue2hJUsUu4OqLcl9c1ne8h3thAOE06RMzr1i5ioN
         4FwqohU8WVvMw/D+tKfxubB4dOCiACd2sJ483ZFGsbKWycehcc3Ik0a/NTgyjUhz6V
         vCQc/e2BkOev7jvsVXcafwZWFnRMKajsl5w9ahOajQJJ9dTq05ewLaKE9VDSCpv8/6
         Lz4XaRgO7Ex/RGpP1yjZUSi2bQMvfpJLwaQw8kohTRiajHJop67I5W5WcMdKvn/W5m
         Edrqge3HwbHng==
Received: (from tipbot@localhost)
        by terminus.zytor.com (8.15.2/8.15.2/Submit) id x5CCQB5K684666;
        Wed, 12 Jun 2019 05:26:11 -0700
Date:   Wed, 12 Jun 2019 05:26:11 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
From:   tip-bot for James Morse <tipbot@zytor.com>
Message-ID: <tip-87d3aa28f345bea77c396855fa5d5fec4c24461f@git.kernel.org>
Cc:     stable@vger.kernel.org, fenghua.yu@intel.com, james.morse@arm.com,
        hpa@zytor.com, reinette.chatre@intel.com, mingo@kernel.org,
        bp@alien8.de, tglx@linutronix.de, linux-kernel@vger.kernel.org
Reply-To: tglx@linutronix.de, linux-kernel@vger.kernel.org,
          mingo@kernel.org, bp@alien8.de, reinette.chatre@intel.com,
          james.morse@arm.com, hpa@zytor.com, fenghua.yu@intel.com,
          stable@vger.kernel.org
In-Reply-To: <20190603172531.178830-1-james.morse@arm.com>
References: <20190603172531.178830-1-james.morse@arm.com>
To:     linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/resctrl: Don't stop walking closids when a
 locksetup group is found
Git-Commit-ID: 87d3aa28f345bea77c396855fa5d5fec4c24461f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from
 these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Spam-Status: No, score=-1.2 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DATE_IN_FUTURE_96_Q,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF
        autolearn=no autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on terminus.zytor.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit-ID:  87d3aa28f345bea77c396855fa5d5fec4c24461f
Gitweb:     https://git.kernel.org/tip/87d3aa28f345bea77c396855fa5d5fec4c24461f
Author:     James Morse <james.morse@arm.com>
AuthorDate: Mon, 3 Jun 2019 18:25:31 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 12 Jun 2019 10:31:50 +0200

x86/resctrl: Don't stop walking closids when a locksetup group is found

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

---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 333c177a2471..869cbef5da81 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -2542,7 +2542,12 @@ static int __init_one_rdt_domain(struct rdt_domain *d, struct rdt_resource *r,
 		if (closid_allocated(i) && i != closid) {
 			mode = rdtgroup_mode_by_closid(i);
 			if (mode == RDT_MODE_PSEUDO_LOCKSETUP)
-				break;
+				/*
+				 * ctrl values for locksetup aren't relevant
+				 * until the schemata is written, and the mode
+				 * becomes RDT_MODE_PSEUDO_LOCKED.
+				 */
+				continue;
 			/*
 			 * If CDP is active include peer domain's
 			 * usage to ensure there is no overlap
