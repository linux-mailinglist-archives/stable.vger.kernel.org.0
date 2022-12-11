Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D86C64935E
	for <lists+stable@lfdr.de>; Sun, 11 Dec 2022 10:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiLKJr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Dec 2022 04:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLKJr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Dec 2022 04:47:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1A326FE
        for <stable@vger.kernel.org>; Sun, 11 Dec 2022 01:47:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97554B8095C
        for <stable@vger.kernel.org>; Sun, 11 Dec 2022 09:47:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70BCC433EF;
        Sun, 11 Dec 2022 09:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670752043;
        bh=ssaNy5DXAJPtplQC/lazMZ6GSmw4ZhaghHdO3n3+7as=;
        h=Subject:To:Cc:From:Date:From;
        b=QLB0NhRU/N8V307ECOZFKXWpKffKKD1fSQNO7rBQ6PW8REQc3WBGFWjDBGTkdbjdX
         Tm/XnC4m1Uw22+w8c6FWEz9RU9cvUWcNWjK+ZZ2tSwTQ1GZfxUPJ1FqM0theIzbGUh
         Xh00wuiODeTMCw6pAruhof7XVsTS/+C+3jvxsF+4=
Subject: FAILED: patch "[PATCH] memcg: fix possible use-after-free in" failed to apply to 4.9-stable tree
To:     tj@kernel.org, akpm@linux-foundation.org, hannes@cmpxchg.org,
        jannh@google.com, mhocko@kernel.org, roman.gushchin@linux.dev,
        shakeelb@google.com, songmuchun@bytedance.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Dec 2022 10:47:20 +0100
Message-ID: <1670752040123141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

4a7ba45b1a43 ("memcg: fix possible use-after-free in memcg_write_event_control()")
0a268dbd7932 ("cgroup: move cgroup v1 specific code to kernel/cgroup/cgroup-v1.c")
201af4c0fab0 ("cgroup: move cgroup files under kernel/cgroup/")
5f617ebbdf10 ("cgroup: reorder css_set fields")
2fae98634334 ("cgroup: remove cgroup_pid_fry() and friends")
b4b90a8e86f2 ("cgroup: reimplement reading "cgroup.procs" on cgroup v2")
3007098494be ("cgroup: add support for eBPF programs")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4a7ba45b1a435e7097ca0f79a847d0949d0eb088 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Wed, 7 Dec 2022 16:53:15 -1000
Subject: [PATCH] memcg: fix possible use-after-free in
 memcg_write_event_control()

memcg_write_event_control() accesses the dentry->d_name of the specified
control fd to route the write call.  As a cgroup interface file can't be
renamed, it's safe to access d_name as long as the specified file is a
regular cgroup file.  Also, as these cgroup interface files can't be
removed before the directory, it's safe to access the parent too.

Prior to 347c4a874710 ("memcg: remove cgroup_event->cft"), there was a
call to __file_cft() which verified that the specified file is a regular
cgroupfs file before further accesses.  The cftype pointer returned from
__file_cft() was no longer necessary and the commit inadvertently dropped
the file type check with it allowing any file to slip through.  With the
invarients broken, the d_name and parent accesses can now race against
renames and removals of arbitrary files and cause use-after-free's.

Fix the bug by resurrecting the file type check in __file_cft().  Now that
cgroupfs is implemented through kernfs, checking the file operations needs
to go through a layer of indirection.  Instead, let's check the superblock
and dentry type.

Link: https://lkml.kernel.org/r/Y5FRm/cfcKPGzWwl@slm.duckdns.org
Fixes: 347c4a874710 ("memcg: remove cgroup_event->cft")
Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Jann Horn <jannh@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: <stable@vger.kernel.org>	[3.14+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 528bd44b59e2..2b7d077de7ef 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -68,6 +68,7 @@ struct css_task_iter {
 	struct list_head		iters_node;	/* css_set->task_iters */
 };
 
+extern struct file_system_type cgroup_fs_type;
 extern struct cgroup_root cgrp_dfl_root;
 extern struct css_set init_css_set;
 
diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index fd4020835ec6..367b0a42ada9 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -167,7 +167,6 @@ struct cgroup_mgctx {
 extern spinlock_t css_set_lock;
 extern struct cgroup_subsys *cgroup_subsys[];
 extern struct list_head cgroup_roots;
-extern struct file_system_type cgroup_fs_type;
 
 /* iterate across the hierarchies */
 #define for_each_root(root)						\
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a1a35c12635e..266a1ab05434 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4832,6 +4832,7 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 	unsigned int efd, cfd;
 	struct fd efile;
 	struct fd cfile;
+	struct dentry *cdentry;
 	const char *name;
 	char *endp;
 	int ret;
@@ -4885,6 +4886,16 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 	if (ret < 0)
 		goto out_put_cfile;
 
+	/*
+	 * The control file must be a regular cgroup1 file. As a regular cgroup
+	 * file can't be renamed, it's safe to access its name afterwards.
+	 */
+	cdentry = cfile.file->f_path.dentry;
+	if (cdentry->d_sb->s_type != &cgroup_fs_type || !d_is_reg(cdentry)) {
+		ret = -EINVAL;
+		goto out_put_cfile;
+	}
+
 	/*
 	 * Determine the event callbacks and set them in @event.  This used
 	 * to be done via struct cftype but cgroup core no longer knows
@@ -4893,7 +4904,7 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 	 *
 	 * DO NOT ADD NEW FILES.
 	 */
-	name = cfile.file->f_path.dentry->d_name.name;
+	name = cdentry->d_name.name;
 
 	if (!strcmp(name, "memory.usage_in_bytes")) {
 		event->register_event = mem_cgroup_usage_register_event;
@@ -4917,7 +4928,7 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 	 * automatically removed on cgroup destruction but the removal is
 	 * asynchronous, so take an extra ref on @css.
 	 */
-	cfile_css = css_tryget_online_from_dir(cfile.file->f_path.dentry->d_parent,
+	cfile_css = css_tryget_online_from_dir(cdentry->d_parent,
 					       &memory_cgrp_subsys);
 	ret = -EINVAL;
 	if (IS_ERR(cfile_css))

