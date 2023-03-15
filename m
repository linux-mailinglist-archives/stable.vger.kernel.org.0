Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDDA36BB04B
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjCOMRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbjCOMQs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:16:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0448FBEE
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:16:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DC0DB81DF8
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EACC433D2;
        Wed, 15 Mar 2023 12:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882601;
        bh=oh7bUmYU8BvxO0wWyyaYbmFA3o0shhnjHA/vDXs+hfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kKfVHaoLOVQIlRodUgymqSrPzCho1h5idJpMOE95BCUmnU5YzpVDDqnlAeWIF5mme
         RAdg52Ayh2bg6onvexomaJkO6hDpy3dbYJvAo3WTSCJcFO3MAGywDGzlX34+eERElN
         8H4GU9zouYk9y2KQcrRv538th/TjYrfOCiSHAHBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot <syzbot+29d3a3b4d86c8136ad9e@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Tejun Heo <tj@kernel.org>, Cai Xinchen <caixinchen1@huawei.com>
Subject: [PATCH 4.19 39/39] cgroup: Add missing cpus_read_lock() to cgroup_attach_task_all()
Date:   Wed, 15 Mar 2023 13:12:53 +0100
Message-Id: <20230315115722.693891532@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
References: <20230315115721.234756306@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cgroup-v1.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -13,6 +13,7 @@
 #include <linux/delayacct.h>
 #include <linux/pid_namespace.h>
 #include <linux/cgroupstats.h>
+#include <linux/cpu.h>
 
 #include <trace/events/cgroup.h>
 
@@ -55,6 +56,7 @@ int cgroup_attach_task_all(struct task_s
 	int retval = 0;
 
 	mutex_lock(&cgroup_mutex);
+	get_online_cpus();
 	percpu_down_write(&cgroup_threadgroup_rwsem);
 	for_each_root(root) {
 		struct cgroup *from_cgrp;
@@ -71,6 +73,7 @@ int cgroup_attach_task_all(struct task_s
 			break;
 	}
 	percpu_up_write(&cgroup_threadgroup_rwsem);
+	put_online_cpus();
 	mutex_unlock(&cgroup_mutex);
 
 	return retval;


