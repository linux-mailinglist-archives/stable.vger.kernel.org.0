Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0024AFD17
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 20:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbiBITPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 14:15:53 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbiBITPw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 14:15:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398CAC0045BE;
        Wed,  9 Feb 2022 11:15:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1192FB82390;
        Wed,  9 Feb 2022 19:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42808C340E7;
        Wed,  9 Feb 2022 19:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644434106;
        bh=w5dkYAz3sy98SI4aS3c2yCQau3NSXZfCNaqkaqy/TBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=muBZmCl1ssg9g0xoUpyW8v/HtQty3JmFvYPCIQYecg1GIm0B4nfFN3s1cRctwe6eU
         5/ZAmDtnd/4A9uX3wvFDeTrEm16Sjxfb4EE2/U0vWPaFVvjAOg/saCkPud55Av79EB
         VTa4YEgTaPYBUNX5jxFlhYc9hosfw/btAvR2teXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tabitha Sable <tabitha.c.sable@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Tejun Heo <tj@kernel.org>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Subject: [PATCH 4.14 1/3] cgroup-v1: Require capabilities to set release_agent
Date:   Wed,  9 Feb 2022 20:13:38 +0100
Message-Id: <20220209191248.708176141@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220209191248.659458918@linuxfoundation.org>
References: <20220209191248.659458918@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Eric W. Biederman <ebiederm@xmission.com>

commit 24f6008564183aa120d07c03d9289519c2fe02af upstream.

The cgroup release_agent is called with call_usermodehelper.  The function
call_usermodehelper starts the release_agent with a full set fo capabilities.
Therefore require capabilities when setting the release_agaent.

Reported-by: Tabitha Sable <tabitha.c.sable@gmail.com>
Tested-by: Tabitha Sable <tabitha.c.sable@gmail.com>
Fixes: 81a6a5cdd2c5 ("Task Control Groups: automatic userspace notification of idle cgroups")
Cc: stable@vger.kernel.org # v2.6.24+
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[mkoutny: Adjust for pre-fs_context, duplicate mount/remount check, drop log messages.]
Acked-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cgroup-v1.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -577,6 +577,14 @@ static ssize_t cgroup_release_agent_writ
 
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
@@ -1060,6 +1068,7 @@ static int cgroup1_remount(struct kernfs
 {
 	int ret = 0;
 	struct cgroup_root *root = cgroup_root_from_kf(kf_root);
+	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
 	struct cgroup_sb_opts opts;
 	u16 added_mask, removed_mask;
 
@@ -1073,6 +1082,12 @@ static int cgroup1_remount(struct kernfs
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
@@ -1236,6 +1251,15 @@ struct dentry *cgroup1_mount(struct file
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


