Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D621647979
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 00:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiLHXGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 18:06:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiLHXGK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 18:06:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1C898EB1;
        Thu,  8 Dec 2022 15:05:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 736EFB82664;
        Thu,  8 Dec 2022 23:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE75C433D2;
        Thu,  8 Dec 2022 23:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670540755;
        bh=dmPOv76KkvnxepE7k7KJGDs0L6fyPRiQij0kVYrhW/o=;
        h=Date:To:From:Subject:From;
        b=JRZHEgVA5XDytsZQvoi3F3qvdfNlYbLH5noAvT3tbVZTAXOOCifi1Q8B6eyu/mewU
         dpsIrt6mvMuETelwo+SScILgz9lYfWiGuS/fHdetR4mJI7XH4cxMOyKLgCr/Fh2Ivj
         x3WgNhs0yY5prd0W5UmcgIgWDOWcOTW0nXVlPAEg=
Date:   Thu, 08 Dec 2022 15:05:52 -0800
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        stable@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@kernel.org,
        jannh@google.com, hannes@cmpxchg.org, tj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-fix-possible-use-after-free-in-memcg_write_event_control.patch added to mm-hotfixes-unstable branch
Message-Id: <20221208230555.0AE75C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: memcg: fix possible use-after-free in memcg_write_event_control()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     memcg-fix-possible-use-after-free-in-memcg_write_event_control.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-fix-possible-use-after-free-in-memcg_write_event_control.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

memcg-fix-possible-use-after-free-in-memcg_write_event_control.patch

