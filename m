Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418DA488406
	for <lists+stable@lfdr.de>; Sat,  8 Jan 2022 15:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234468AbiAHOoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jan 2022 09:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234470AbiAHOoP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jan 2022 09:44:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E34FC061401
        for <stable@vger.kernel.org>; Sat,  8 Jan 2022 06:44:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D327F60BB5
        for <stable@vger.kernel.org>; Sat,  8 Jan 2022 14:44:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F73C36AE9;
        Sat,  8 Jan 2022 14:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641653054;
        bh=6Ol+kKh51qTXCLAh96gPtIpFH/+ZOdTNP7KN28+Idn8=;
        h=Subject:To:Cc:From:Date:From;
        b=F8NZr2K29bY3aAwFrcoGGScvTnqR30uXkMB0SC1BSdXUBrKdMKUv+smfKzr2cYx1/
         7N72PrKGVuLP6GGSVPMewp4uRuHTfBliSVVZf1VUEfO+aKTGaRuxhJkRkk65ApIxgL
         +ntMU6C91SuKoXWzoxIMOr3nbTH7KVMblT1vKg2s=
Subject: FAILED: patch "[PATCH] cgroup: Use open-time credentials for process migraton perm" failed to apply to 4.19-stable tree
To:     tj@kernel.org, ebiederm@xmission.com, mkoutny@suse.com,
        torvalds@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 08 Jan 2022 15:44:05 +0100
Message-ID: <164165304529100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1756d7994ad85c2479af6ae5a9750b92324685af Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 6 Jan 2022 11:02:28 -1000
Subject: [PATCH] cgroup: Use open-time credentials for process migraton perm
 checks
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

cgroup process migration permission checks are performed at write time as
whether a given operation is allowed or not is dependent on the content of
the write - the PID. This currently uses current's credentials which is a
potential security weakness as it may allow scenarios where a less
privileged process tricks a more privileged one into writing into a fd that
it created.

This patch makes both cgroup2 and cgroup1 process migration interfaces to
use the credentials saved at the time of open (file->f_cred) instead of
current's.

Reported-by: "Eric W. Biederman" <ebiederm@xmission.com>
Suggested-by: Linus Torvalds <torvalds@linuxfoundation.org>
Fixes: 187fe84067bd ("cgroup: require write perm on common ancestor when moving processes on the default hierarchy")
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 81c9e0685948..0e7369103ba6 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -504,10 +504,11 @@ static ssize_t __cgroup1_procs_write(struct kernfs_open_file *of,
 		goto out_unlock;
 
 	/*
-	 * Even if we're attaching all tasks in the thread group, we only
-	 * need to check permissions on one of them.
+	 * Even if we're attaching all tasks in the thread group, we only need
+	 * to check permissions on one of them. Check permissions using the
+	 * credentials from file open to protect against inherited fd attacks.
 	 */
-	cred = current_cred();
+	cred = of->file->f_cred;
 	tcred = get_task_cred(task);
 	if (!uid_eq(cred->euid, GLOBAL_ROOT_UID) &&
 	    !uid_eq(cred->euid, tcred->uid) &&
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 919194de39c8..2632e46da1d4 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4892,6 +4892,7 @@ static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 {
 	struct cgroup *src_cgrp, *dst_cgrp;
 	struct task_struct *task;
+	const struct cred *saved_cred;
 	ssize_t ret;
 	bool locked;
 
@@ -4909,9 +4910,15 @@ static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 	src_cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
 	spin_unlock_irq(&css_set_lock);
 
-	/* process and thread migrations follow same delegation rule */
+	/*
+	 * Process and thread migrations follow same delegation rule. Check
+	 * permissions using the credentials from file open to protect against
+	 * inherited fd attacks.
+	 */
+	saved_cred = override_creds(of->file->f_cred);
 	ret = cgroup_attach_permissions(src_cgrp, dst_cgrp,
 					of->file->f_path.dentry->d_sb, threadgroup);
+	revert_creds(saved_cred);
 	if (ret)
 		goto out_finish;
 

