Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8806BBFF8
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 23:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbjCOWom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 18:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjCOWom (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 18:44:42 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7361714EA3;
        Wed, 15 Mar 2023 15:44:40 -0700 (PDT)
Date:   Wed, 15 Mar 2023 22:44:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1678920278;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=GjmlrFQTqGturbIE+fgewqog6NLlHfnD7mWRE0jhQv8=;
        b=nMhDrjSJUw9bqF/tIXTVi8+ftXNoYlgUXzLg72prueoXkTzqyzT0ERLkgWMYQ7r4oq7HIx
        1P5vFoy8rUjxIRRsj/xrP4ULAoGaTqrDsw3gO9HYg3e1yu55btoptvYSPMJzeqA8Or/ohC
        9bsWRn4zVqqjOWdCbJMfB7yGrte8lqVGadGi6UPcSZVtLJNBIC2K0JOeaRFhLgCiPmeaWp
        RlzpZn2gkBZzg8vNGO8xKFBPY7cc+LAWHv+jDGXgvT+b8WInzTYlwF0BCdK+8xl7FY5V2+
        Mkcjvhh8Qfv+tWhTnDNe/vHkfY/fbrGmOrSOpWeT3WzH7XhotL4xA84H6hSV+A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1678920278;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=GjmlrFQTqGturbIE+fgewqog6NLlHfnD7mWRE0jhQv8=;
        b=zIgROjbG15WKCvx1h/VK2V7yaE7w7oTHNpC3HVSHpo9lWHh55jYYk57rKZhc1hfRot8PTY
        ingboI/CmGYG28CQ==
From:   "tip-bot2 for Shawn Wang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/resctrl: Clear staged_config[] before and after
 it is used
Cc:     Xin Hao <xhao@linux.alibaba.com>,
        Shawn Wang <shawnwang@linux.alibaba.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <167892027751.5837.1271275229889484859.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     0424a7dfe9129b93f29b277511a60e87f052ac6b
Gitweb:        https://git.kernel.org/tip/0424a7dfe9129b93f29b277511a60e87f052ac6b
Author:        Shawn Wang <shawnwang@linux.alibaba.com>
AuthorDate:    Tue, 17 Jan 2023 13:14:50 -08:00
Committer:     Dave Hansen <dave.hansen@linux.intel.com>
CommitterDate: Wed, 15 Mar 2023 15:19:43 -07:00

x86/resctrl: Clear staged_config[] before and after it is used

As a temporary storage, staged_config[] in rdt_domain should be cleared
before and after it is used. The stale value in staged_config[] could
cause an MSR access error.

Here is a reproducer on a system with 16 usable CLOSIDs for a 15-way L3
Cache (MBA should be disabled if the number of CLOSIDs for MB is less than
16.) :
	mount -t resctrl resctrl -o cdp /sys/fs/resctrl
	mkdir /sys/fs/resctrl/p{1..7}
	umount /sys/fs/resctrl/
	mount -t resctrl resctrl /sys/fs/resctrl
	mkdir /sys/fs/resctrl/p{1..8}

An error occurs when creating resource group named p8:
    unchecked MSR access error: WRMSR to 0xca0 (tried to write 0x00000000000007ff) at rIP: 0xffffffff82249142 (cat_wrmsr+0x32/0x60)
    Call Trace:
     <IRQ>
     __flush_smp_call_function_queue+0x11d/0x170
     __sysvec_call_function+0x24/0xd0
     sysvec_call_function+0x89/0xc0
     </IRQ>
     <TASK>
     asm_sysvec_call_function+0x16/0x20

When creating a new resource control group, hardware will be configured
by the following process:
    rdtgroup_mkdir()
      rdtgroup_mkdir_ctrl_mon()
        rdtgroup_init_alloc()
          resctrl_arch_update_domains()

resctrl_arch_update_domains() iterates and updates all resctrl_conf_type
whose have_new_ctrl is true. Since staged_config[] holds the same values as
when CDP was enabled, it will continue to update the CDP_CODE and CDP_DATA
configurations. When group p8 is created, get_config_index() called in
resctrl_arch_update_domains() will return 16 and 17 as the CLOSIDs for
CDP_CODE and CDP_DATA, which will be translated to an invalid register -
0xca0 in this scenario.

Fix it by clearing staged_config[] before and after it is used.

[reinette: re-order commit tags]

Fixes: 75408e43509e ("x86/resctrl: Allow different CODE/DATA configurations to be staged")
Suggested-by: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: Shawn Wang <shawnwang@linux.alibaba.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Tested-by: Reinette Chatre <reinette.chatre@intel.com>
Cc:stable@vger.kernel.org
Link: https://lore.kernel.org/all/2fad13f49fbe89687fc40e9a5a61f23a28d1507a.1673988935.git.reinette.chatre%40intel.com
---
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c |  7 +-----
 arch/x86/kernel/cpu/resctrl/internal.h    |  1 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 25 ++++++++++++++++++----
 3 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
index eb07d44..b44c487 100644
--- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
+++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
@@ -368,7 +368,6 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
 {
 	struct resctrl_schema *s;
 	struct rdtgroup *rdtgrp;
-	struct rdt_domain *dom;
 	struct rdt_resource *r;
 	char *tok, *resname;
 	int ret = 0;
@@ -397,10 +396,7 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
 		goto out;
 	}
 
-	list_for_each_entry(s, &resctrl_schema_all, list) {
-		list_for_each_entry(dom, &s->res->domains, list)
-			memset(dom->staged_config, 0, sizeof(dom->staged_config));
-	}
+	rdt_staged_configs_clear();
 
 	while ((tok = strsep(&buf, "\n")) != NULL) {
 		resname = strim(strsep(&tok, ":"));
@@ -445,6 +441,7 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
 	}
 
 out:
+	rdt_staged_configs_clear();
 	rdtgroup_kn_unlock(of->kn);
 	cpus_read_unlock();
 	return ret ?: nbytes;
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 8edecc5..85ceaf9 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -555,5 +555,6 @@ void __check_limbo(struct rdt_domain *d, bool force_free);
 void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 void __init thread_throttle_mode_init(void);
 void __init mbm_config_rftype_init(const char *config);
+void rdt_staged_configs_clear(void);
 
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 884b6e9..6ad33f3 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -78,6 +78,19 @@ void rdt_last_cmd_printf(const char *fmt, ...)
 	va_end(ap);
 }
 
+void rdt_staged_configs_clear(void)
+{
+	struct rdt_resource *r;
+	struct rdt_domain *dom;
+
+	lockdep_assert_held(&rdtgroup_mutex);
+
+	for_each_alloc_capable_rdt_resource(r) {
+		list_for_each_entry(dom, &r->domains, list)
+			memset(dom->staged_config, 0, sizeof(dom->staged_config));
+	}
+}
+
 /*
  * Trivial allocator for CLOSIDs. Since h/w only supports a small number,
  * we can keep a bitmap of free CLOSIDs in a single integer.
@@ -3107,7 +3120,9 @@ static int rdtgroup_init_alloc(struct rdtgroup *rdtgrp)
 {
 	struct resctrl_schema *s;
 	struct rdt_resource *r;
-	int ret;
+	int ret = 0;
+
+	rdt_staged_configs_clear();
 
 	list_for_each_entry(s, &resctrl_schema_all, list) {
 		r = s->res;
@@ -3119,20 +3134,22 @@ static int rdtgroup_init_alloc(struct rdtgroup *rdtgrp)
 		} else {
 			ret = rdtgroup_init_cat(s, rdtgrp->closid);
 			if (ret < 0)
-				return ret;
+				goto out;
 		}
 
 		ret = resctrl_arch_update_domains(r, rdtgrp->closid);
 		if (ret < 0) {
 			rdt_last_cmd_puts("Failed to initialize allocations\n");
-			return ret;
+			goto out;
 		}
 
 	}
 
 	rdtgrp->mode = RDT_MODE_SHAREABLE;
 
-	return 0;
+out:
+	rdt_staged_configs_clear();
+	return ret;
 }
 
 static int mkdir_rdt_prepare(struct kernfs_node *parent_kn,
