Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5682649FC4
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbiLLNOr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:14:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232408AbiLLNO2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:14:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65FE1B5B
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:14:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CAF4B80D39
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36468C433D2;
        Mon, 12 Dec 2022 13:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670850864;
        bh=ikE4n4IFDONf/Je5LzvBSosk8Gj/j6KFJapIb+zTrkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=blmJM61fSzkK5cC3tt1Lk9fC5Fx6KhzF7ueDOlBqtX1pDwevZafw9KjrlUxD2FNYW
         VjZT7EejbHel34X+mLJPr7DviUrj3sz/J0CzBtptttXOBTX1rjchywLinKB5a+LcBc
         wQi/f5Ic/67ybs5yNF7aKFkaQkAuenxBSqZEkaxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tejun Heo <tj@kernel.org>,
        Jann Horn <jannh@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Shakeel Butt <shakeelb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 048/106] memcg: fix possible use-after-free in memcg_write_event_control()
Date:   Mon, 12 Dec 2022 14:09:51 +0100
Message-Id: <20221212130926.950784256@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit 4a7ba45b1a435e7097ca0f79a847d0949d0eb088 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cgroup.h          |    1 +
 kernel/cgroup/cgroup-internal.h |    1 -
 mm/memcontrol.c                 |   15 +++++++++++++--
 3 files changed, 14 insertions(+), 3 deletions(-)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -68,6 +68,7 @@ struct css_task_iter {
 	struct list_head		iters_node;	/* css_set->task_iters */
 };
 
+extern struct file_system_type cgroup_fs_type;
 extern struct cgroup_root cgrp_dfl_root;
 extern struct css_set init_css_set;
 
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -169,7 +169,6 @@ extern struct mutex cgroup_mutex;
 extern spinlock_t css_set_lock;
 extern struct cgroup_subsys *cgroup_subsys[];
 extern struct list_head cgroup_roots;
-extern struct file_system_type cgroup_fs_type;
 
 /* iterate across the hierarchies */
 #define for_each_root(root)						\
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4866,6 +4866,7 @@ static ssize_t memcg_write_event_control
 	unsigned int efd, cfd;
 	struct fd efile;
 	struct fd cfile;
+	struct dentry *cdentry;
 	const char *name;
 	char *endp;
 	int ret;
@@ -4917,6 +4918,16 @@ static ssize_t memcg_write_event_control
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
@@ -4924,7 +4935,7 @@ static ssize_t memcg_write_event_control
 	 *
 	 * DO NOT ADD NEW FILES.
 	 */
-	name = cfile.file->f_path.dentry->d_name.name;
+	name = cdentry->d_name.name;
 
 	if (!strcmp(name, "memory.usage_in_bytes")) {
 		event->register_event = mem_cgroup_usage_register_event;
@@ -4948,7 +4959,7 @@ static ssize_t memcg_write_event_control
 	 * automatically removed on cgroup destruction but the removal is
 	 * asynchronous, so take an extra ref on @css.
 	 */
-	cfile_css = css_tryget_online_from_dir(cfile.file->f_path.dentry->d_parent,
+	cfile_css = css_tryget_online_from_dir(cdentry->d_parent,
 					       &memory_cgrp_subsys);
 	ret = -EINVAL;
 	if (IS_ERR(cfile_css))


