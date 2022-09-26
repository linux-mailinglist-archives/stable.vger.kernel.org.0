Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF14C5EA05D
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236022AbiIZKge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236345AbiIZKez (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:34:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400CF52445;
        Mon, 26 Sep 2022 03:21:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9367B80930;
        Mon, 26 Sep 2022 10:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171C7C433C1;
        Mon, 26 Sep 2022 10:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187686;
        bh=Ji2r6XNoEewK9dXzBsIN8hQ9R8TMbrYeQHGZa3VUuHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1m2Q9jpRk4bFJrzVybIZ9DB/jOiOjy3owfUChDA9CMt/5pS3/OHyAZQbcMWHg9Ngb
         Fi5lMQS2/+QpvOI6z9O8kDzs70wjTAyOmSvPo6XBzlCxLU8at/pqO1WPa87nBb0n8b
         BHbhtkSpyZ/YnoZFE+RqhJbF+Vpr2vJYgCMeIYgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+29d3a3b4d86c8136ad9e@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.4 027/120] cgroup: Add missing cpus_read_lock() to cgroup_attach_task_all()
Date:   Mon, 26 Sep 2022 12:11:00 +0200
Message-Id: <20220926100751.633857388@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 43626dade36fa74d3329046f4ae2d7fdefe401c6 upstream.

syzbot is hitting percpu_rwsem_assert_held(&cpu_hotplug_lock) warning at
cpuset_attach() [1], for commit 4f7e7236435ca0ab ("cgroup: Fix
threadgroup_rwsem <-> cpus_read_lock() deadlock") missed that
cpuset_attach() is also called from cgroup_attach_task_all().
Add cpus_read_lock() like what cgroup_procs_write_start() does.

Link: https://syzkaller.appspot.com/bug?extid=29d3a3b4d86c8136ad9e [1]
Reported-by: syzbot <syzbot+29d3a3b4d86c8136ad9e@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: 4f7e7236435ca0ab ("cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock")
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cgroup-v1.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -15,6 +15,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/cgroupstats.h>
 #include <linux/fs_parser.h>
+#include <linux/cpu.h>
 
 #include <trace/events/cgroup.h>
 
@@ -62,6 +63,7 @@ int cgroup_attach_task_all(struct task_s
 	int retval = 0;
 
 	mutex_lock(&cgroup_mutex);
+	cpus_read_lock();
 	percpu_down_write(&cgroup_threadgroup_rwsem);
 	for_each_root(root) {
 		struct cgroup *from_cgrp;
@@ -78,6 +80,7 @@ int cgroup_attach_task_all(struct task_s
 			break;
 	}
 	percpu_up_write(&cgroup_threadgroup_rwsem);
+	cpus_read_unlock();
 	mutex_unlock(&cgroup_mutex);
 
 	return retval;


