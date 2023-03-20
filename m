Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576616C1992
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbjCTPfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233060AbjCTPe0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:34:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8EB39CF5
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:27:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DB9EB80ED6
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78B5C433D2;
        Mon, 20 Mar 2023 15:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326036;
        bh=K32Ip4ckcogBFQaI4xwDfstOw7DQCWszrDIUFAfhSdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c2orvpmmxum7sNl+9GWRgzTL62b/8xy7VnLtsrxAf0RxFQWiQu2LXr4RD9g9IOd39
         zUWTlkPeEsAgGHCh+S11roMIl0ti+XbjwfySmmOrbDcg6G+6ZbcR93qfSajeAto26Y
         IX8YGBnDEeYzMr3ktu1IbmiXqG6YNzLsx9iD+Pwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xin Hao <xhao@linux.alibaba.com>,
        Shawn Wang <shawnwang@linux.alibaba.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.1 189/198] x86/resctrl: Clear staged_config[] before and after it is used
Date:   Mon, 20 Mar 2023 15:55:27 +0100
Message-Id: <20230320145515.388535907@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shawn Wang <shawnwang@linux.alibaba.com>

commit 0424a7dfe9129b93f29b277511a60e87f052ac6b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c |    7 ++-----
 arch/x86/kernel/cpu/resctrl/internal.h    |    1 +
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    |   25 +++++++++++++++++++++----
 3 files changed, 24 insertions(+), 9 deletions(-)

--- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
+++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
@@ -374,7 +374,6 @@ ssize_t rdtgroup_schemata_write(struct k
 {
 	struct resctrl_schema *s;
 	struct rdtgroup *rdtgrp;
-	struct rdt_domain *dom;
 	struct rdt_resource *r;
 	char *tok, *resname;
 	int ret = 0;
@@ -403,10 +402,7 @@ ssize_t rdtgroup_schemata_write(struct k
 		goto out;
 	}
 
-	list_for_each_entry(s, &resctrl_schema_all, list) {
-		list_for_each_entry(dom, &s->res->domains, list)
-			memset(dom->staged_config, 0, sizeof(dom->staged_config));
-	}
+	rdt_staged_configs_clear();
 
 	while ((tok = strsep(&buf, "\n")) != NULL) {
 		resname = strim(strsep(&tok, ":"));
@@ -451,6 +447,7 @@ ssize_t rdtgroup_schemata_write(struct k
 	}
 
 out:
+	rdt_staged_configs_clear();
 	rdtgroup_kn_unlock(of->kn);
 	cpus_read_unlock();
 	return ret ?: nbytes;
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -537,5 +537,6 @@ bool has_busy_rmid(struct rdt_resource *
 void __check_limbo(struct rdt_domain *d, bool force_free);
 void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 void __init thread_throttle_mode_init(void);
+void rdt_staged_configs_clear(void);
 
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -78,6 +78,19 @@ void rdt_last_cmd_printf(const char *fmt
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
@@ -2851,7 +2864,9 @@ static int rdtgroup_init_alloc(struct rd
 {
 	struct resctrl_schema *s;
 	struct rdt_resource *r;
-	int ret;
+	int ret = 0;
+
+	rdt_staged_configs_clear();
 
 	list_for_each_entry(s, &resctrl_schema_all, list) {
 		r = s->res;
@@ -2862,20 +2877,22 @@ static int rdtgroup_init_alloc(struct rd
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


