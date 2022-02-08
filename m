Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63FA4AE0A6
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 19:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235351AbiBHSYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 13:24:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384827AbiBHSYP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 13:24:15 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE6EC061578
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 10:24:14 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E64C61F383;
        Tue,  8 Feb 2022 18:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644344652; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2cezhqvSYd03W2vEOIyADNeTfn7ceRR+wpiEBrOr2Bw=;
        b=HjpXOEqvuSgA+bziCImghLVg0D9FYtDymJHDIPmXjOaRLvAgCg80OEDalGGVzmbHTjN8Ve
        lsjVBsrCtNVkxRdvdN9/TeLdLrEYZSJM7OKe+FeVG42yixwWcKLWWjGgxx2xlbufiB1Njl
        rOceoJnXWQjdk7WmixTQMAlc1PYoANU=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D38E313CDC;
        Tue,  8 Feb 2022 18:24:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id y9UcM0y1AmKtfQAAMHmgww
        (envelope-from <mkoutny@suse.com>); Tue, 08 Feb 2022 18:24:12 +0000
From:   =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
To:     stable@vger.kernel.org
Cc:     Tabitha Sable <tabitha.c.sable@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH] cgroup-v1: Require capabilities to set release_agent (backport to v4.12)
Date:   Tue,  8 Feb 2022 19:24:02 +0100
Message-Id: <20220208182402.24674-1-mkoutny@suse.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

The cgroup release_agent is called with call_usermodehelper.  The function
call_usermodehelper starts the release_agent with a full set fo capabilities.
Therefore require capabilities when setting the release_agaent.

[ Upstream commit 24f6008564183aa120d07c03d9289519c2fe02af ]

Reported-by: Tabitha Sable <tabitha.c.sable@gmail.com>
Tested-by: Tabitha Sable <tabitha.c.sable@gmail.com>
Fixes: 81a6a5cdd2c5 ("Task Control Groups: automatic userspace notification of idle cgroups")
Cc: stable@vger.kernel.org # v2.6.24+
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[mkoutny: Adjust for pre-fs_context, duplicate mount/remount check, drop log messages.]
Acked-by: Michal Koutný <mkoutny@suse.com>
---

Hello,
FWIW, I'm sharing v4.12 backport of the aforementioned patch (v4.12 is not
actual stable but someone may find it useful).

Michal

 kernel/cgroup/cgroup-v1.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -531,6 +531,14 @@ static ssize_t cgroup_release_agent_writ
 
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
@@ -1004,6 +1012,7 @@ static int cgroup1_remount(struct kernfs
 {
 	int ret = 0;
 	struct cgroup_root *root = cgroup_root_from_kf(kf_root);
+	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
 	struct cgroup_sb_opts opts;
 	u16 added_mask, removed_mask;
 
@@ -1017,6 +1026,12 @@ static int cgroup1_remount(struct kernfs
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
@@ -1180,6 +1195,15 @@ struct dentry *cgroup1_mount(struct file
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
