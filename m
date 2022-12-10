Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55847648C90
	for <lists+stable@lfdr.de>; Sat, 10 Dec 2022 03:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiLJCmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 21:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiLJCmE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 21:42:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A897A7A1B1;
        Fri,  9 Dec 2022 18:42:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 461F9623D6;
        Sat, 10 Dec 2022 02:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BBFC433EF;
        Sat, 10 Dec 2022 02:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670640122;
        bh=iX4b5AcrvWVmxdvS76LgsOFACLWc4BieGVYqAzEtim0=;
        h=Date:To:From:Subject:From;
        b=JdGaoTKUKqeaDTNO1fX4SzjVcJaEp4pl2bpUHFMVVQrFDHbV8XJUOTnRMGDPJjn9b
         8wKQ5jD7VifDXW3HvYJJmuEruMCJ7OQHHoe1oe1+S4RvAu/KlaGaGWoTlCOsjb5yAQ
         fQ8/3luAWsEoz/KJ1w/QFc6w8BF22qw3NzGguXNQ=
Date:   Fri, 09 Dec 2022 18:42:01 -0800
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        stable@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@kernel.org,
        jannh@google.com, hannes@cmpxchg.org, tj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] memcg-fix-possible-use-after-free-in-memcg_write_event_control.patch removed from -mm tree
Message-Id: <20221210024202.97BBFC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: memcg: fix possible use-after-free in memcg_write_event_control()
has been removed from the -mm tree.  Its filename was
     memcg-fix-possible-use-after-free-in-memcg_write_event_control.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: memcg: fix possible use-after-free in memcg_write_event_control()
Date: Wed, 7 Dec 2022 16:53:15 -1000

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
---

 include/linux/cgroup.h          |    1 +
 kernel/cgroup/cgroup-internal.h |    1 -
 mm/memcontrol.c                 |   15 +++++++++++++--
 3 files changed, 14 insertions(+), 3 deletions(-)

--- a/include/linux/cgroup.h~memcg-fix-possible-use-after-free-in-memcg_write_event_control
+++ a/include/linux/cgroup.h
@@ -68,6 +68,7 @@ struct css_task_iter {
 	struct list_head		iters_node;	/* css_set->task_iters */
 };
 
+extern struct file_system_type cgroup_fs_type;
 extern struct cgroup_root cgrp_dfl_root;
 extern struct css_set init_css_set;
 
--- a/kernel/cgroup/cgroup-internal.h~memcg-fix-possible-use-after-free-in-memcg_write_event_control
+++ a/kernel/cgroup/cgroup-internal.h
@@ -167,7 +167,6 @@ struct cgroup_mgctx {
 extern spinlock_t css_set_lock;
 extern struct cgroup_subsys *cgroup_subsys[];
 extern struct list_head cgroup_roots;
-extern struct file_system_type cgroup_fs_type;
 
 /* iterate across the hierarchies */
 #define for_each_root(root)						\
--- a/mm/memcontrol.c~memcg-fix-possible-use-after-free-in-memcg_write_event_control
+++ a/mm/memcontrol.c
@@ -4832,6 +4832,7 @@ static ssize_t memcg_write_event_control
 	unsigned int efd, cfd;
 	struct fd efile;
 	struct fd cfile;
+	struct dentry *cdentry;
 	const char *name;
 	char *endp;
 	int ret;
@@ -4886,6 +4887,16 @@ static ssize_t memcg_write_event_control
 		goto out_put_cfile;
 
 	/*
+	 * The control file must be a regular cgroup1 file. As a regular cgroup
+	 * file can't be renamed, it's safe to access its name afterwards.
+	 */
+	cdentry = cfile.file->f_path.dentry;
+	if (cdentry->d_sb->s_type != &cgroup_fs_type || !d_is_reg(cdentry)) {
+		ret = -EINVAL;
+		goto out_put_cfile;
+	}
+
+	/*
 	 * Determine the event callbacks and set them in @event.  This used
 	 * to be done via struct cftype but cgroup core no longer knows
 	 * about these events.  The following is crude but the whole thing
@@ -4893,7 +4904,7 @@ static ssize_t memcg_write_event_control
 	 *
 	 * DO NOT ADD NEW FILES.
 	 */
-	name = cfile.file->f_path.dentry->d_name.name;
+	name = cdentry->d_name.name;
 
 	if (!strcmp(name, "memory.usage_in_bytes")) {
 		event->register_event = mem_cgroup_usage_register_event;
@@ -4917,7 +4928,7 @@ static ssize_t memcg_write_event_control
 	 * automatically removed on cgroup destruction but the removal is
 	 * asynchronous, so take an extra ref on @css.
 	 */
-	cfile_css = css_tryget_online_from_dir(cfile.file->f_path.dentry->d_parent,
+	cfile_css = css_tryget_online_from_dir(cdentry->d_parent,
 					       &memory_cgrp_subsys);
 	ret = -EINVAL;
 	if (IS_ERR(cfile_css))
_

Patches currently in -mm which might be from tj@kernel.org are


