Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E17B4B20AE
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 09:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235690AbiBKIxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 03:53:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348276AbiBKIxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 03:53:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EB3E8A;
        Fri, 11 Feb 2022 00:53:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5DE461E40;
        Fri, 11 Feb 2022 08:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A504C340EE;
        Fri, 11 Feb 2022 08:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644569601;
        bh=gqsFhcBgEzN3vzVtJwIcCchz72fhqIPtNDrPLZ+ElIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WYeCvHYPrEA1gdIZCJoTMXQQxW/FMe3C1N/7cTGXJq1muiIx1hzRPLw6CCSscSNXX
         d+YHamn9TjhuNRqExcWJa96Br1vBLMwD77SIDn0VJnGat0sA6WBQ/XWhYY+/HaCItq
         ArCmGTJ5VtcaEuDuQZoNUvlk4hBQQp9pChW92g7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.19.229
Date:   Fri, 11 Feb 2022 09:53:11 +0100
Message-Id: <164456959118554@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <164456959130183@kroah.com>
References: <164456959130183@kroah.com>
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
index 1779149108cf..e8be2ea115da 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 228
+SUBLEVEL = 229
 EXTRAVERSION =
 NAME = "People's Front"
 
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
index 5456611874eb..ced2b3f3547c 100644
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
@@ -1048,6 +1056,7 @@ static int cgroup1_remount(struct kernfs_root *kf_root, int *flags, char *data)
 {
 	int ret = 0;
 	struct cgroup_root *root = cgroup_root_from_kf(kf_root);
+	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
 	struct cgroup_sb_opts opts;
 	u16 added_mask, removed_mask;
 
@@ -1061,6 +1070,12 @@ static int cgroup1_remount(struct kernfs_root *kf_root, int *flags, char *data)
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
@@ -1224,6 +1239,15 @@ struct dentry *cgroup1_mount(struct file_system_type *fs_type, int flags,
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
index bd28ac7f2195..0d2ee4eb131f 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1579,13 +1579,16 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 	u16 peers_tol = msg_link_tolerance(hdr);
 	u16 peers_prio = msg_linkprio(hdr);
 	u16 rcv_nxt = l->rcv_nxt;
-	u16 dlen = msg_data_sz(hdr);
+	u32 dlen = msg_data_sz(hdr);
 	int mtyp = msg_type(hdr);
 	bool reply = msg_probe(hdr);
 	void *data;
 	char *if_name;
 	int rc = 0;
 
+	if (dlen > U16_MAX)
+		goto exit;
+
 	if (tipc_link_is_blocked(l) || !xmitq)
 		goto exit;
 
diff --git a/net/tipc/monitor.c b/net/tipc/monitor.c
index 23706ee16607..7b6c1c5c30dc 100644
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
