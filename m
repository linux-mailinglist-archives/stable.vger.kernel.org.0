Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFD594B20A6
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 09:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348256AbiBKIxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 03:53:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbiBKIxT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 03:53:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4AE6E6C;
        Fri, 11 Feb 2022 00:53:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FDB961E16;
        Fri, 11 Feb 2022 08:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34217C340E9;
        Fri, 11 Feb 2022 08:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644569597;
        bh=W8P8u1CNThLpBy8CT07j/PmPM4RD+MEbiw89ugd3VGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uDmhUsBVP2pkGu8VasetaAONZ5O3kGr/3SO4APWP0vjzUL6YWlv2XFit/lHRWqJud
         YICbq5CP44T5vhZp3mj7q/ppyZJd0P5WPJ2KSXXQkewdsM4oGExb96YPKxmTjrhqXf
         EHSUIf7Py/xEMfzuHwGnTpqoF9AfyxvyxLw04UrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.266
Date:   Fri, 11 Feb 2022 09:53:06 +0100
Message-Id: <1644569586114196@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <164456958616076@kroah.com>
References: <164456958616076@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index bc98aa57a6fa..1fe02d57d6a7 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 265
+SUBLEVEL = 266
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 95c09db1bba2..d8399a689165 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -589,7 +589,7 @@ static int srao_decode_notifier(struct notifier_block *nb, unsigned long val,
 
 	if (mce_usable_address(mce) && (mce->severity == MCE_AO_SEVERITY)) {
 		pfn = mce->addr >> PAGE_SHIFT;
-		if (memory_failure(pfn, MCE_VECTOR, 0))
+		if (!memory_failure(pfn, MCE_VECTOR, 0))
 			mce_unmap_kpfn(pfn);
 	}
 
diff --git a/drivers/mmc/host/moxart-mmc.c b/drivers/mmc/host/moxart-mmc.c
index 5553a5643f40..5c81dc7371db 100644
--- a/drivers/mmc/host/moxart-mmc.c
+++ b/drivers/mmc/host/moxart-mmc.c
@@ -696,12 +696,12 @@ static int moxart_remove(struct platform_device *pdev)
 		if (!IS_ERR(host->dma_chan_rx))
 			dma_release_channel(host->dma_chan_rx);
 		mmc_remove_host(mmc);
-		mmc_free_host(mmc);
 
 		writel(0, host->base + REG_INTERRUPT_MASK);
 		writel(0, host->base + REG_POWER_CONTROL);
 		writel(readl(host->base + REG_CLOCK_CONTROL) | CLK_OFF,
 		       host->base + REG_CLOCK_CONTROL);
+		mmc_free_host(mmc);
 	}
 	return 0;
 }
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 5602bd81caa9..105f5b2f5978 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -577,6 +577,14 @@ static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
 
 	BUILD_BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX);
 
+	/*
+	 * Release agent gets called with all capabilities,
+	 * require capabilities to set release agent.
+	 */
+	if ((of->file->f_cred->user_ns != &init_user_ns) ||
+	    !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!cgrp)
 		return -ENODEV;
@@ -1060,6 +1068,7 @@ static int cgroup1_remount(struct kernfs_root *kf_root, int *flags, char *data)
 {
 	int ret = 0;
 	struct cgroup_root *root = cgroup_root_from_kf(kf_root);
+	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
 	struct cgroup_sb_opts opts;
 	u16 added_mask, removed_mask;
 
@@ -1073,6 +1082,12 @@ static int cgroup1_remount(struct kernfs_root *kf_root, int *flags, char *data)
 	if (opts.subsys_mask != root->subsys_mask || opts.release_agent)
 		pr_warn("option changes via remount are deprecated (pid=%d comm=%s)\n",
 			task_tgid_nr(current), current->comm);
+	/* See cgroup1_mount release_agent handling */
+	if (opts.release_agent &&
+	    ((ns->user_ns != &init_user_ns) || !capable(CAP_SYS_ADMIN))) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
 
 	added_mask = opts.subsys_mask & ~root->subsys_mask;
 	removed_mask = root->subsys_mask & ~opts.subsys_mask;
@@ -1236,6 +1251,15 @@ struct dentry *cgroup1_mount(struct file_system_type *fs_type, int flags,
 		ret = -EPERM;
 		goto out_unlock;
 	}
+	/*
+	 * Release agent gets called with all capabilities,
+	 * require capabilities to set release agent.
+	 */
+	if (opts.release_agent &&
+	    ((ns->user_ns != &init_user_ns) || !capable(CAP_SYS_ADMIN))) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
 
 	root = kzalloc(sizeof(*root), GFP_KERNEL);
 	if (!root) {
diff --git a/net/tipc/link.c b/net/tipc/link.c
index 0b44427e29ec..d3017811b67a 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1462,12 +1462,15 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 	u16 peers_tol = msg_link_tolerance(hdr);
 	u16 peers_prio = msg_linkprio(hdr);
 	u16 rcv_nxt = l->rcv_nxt;
-	u16 dlen = msg_data_sz(hdr);
+	u32 dlen = msg_data_sz(hdr);
 	int mtyp = msg_type(hdr);
 	void *data;
 	char *if_name;
 	int rc = 0;
 
+	if (dlen > U16_MAX)
+		goto exit;
+
 	if (tipc_link_is_blocked(l) || !xmitq)
 		goto exit;
 
diff --git a/net/tipc/monitor.c b/net/tipc/monitor.c
index 254ddc2c3914..c6496da9392d 100644
--- a/net/tipc/monitor.c
+++ b/net/tipc/monitor.c
@@ -457,6 +457,8 @@ void tipc_mon_rcv(struct net *net, void *data, u16 dlen, u32 addr,
 	state->probing = false;
 
 	/* Sanity check received domain record */
+	if (new_member_cnt > MAX_MON_DOMAIN)
+		return;
 	if (dlen < dom_rec_len(arrv_dom, 0))
 		return;
 	if (dlen != dom_rec_len(arrv_dom, new_member_cnt))
