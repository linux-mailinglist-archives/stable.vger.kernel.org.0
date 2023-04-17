Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F2D6E41F0
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 10:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbjDQIDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 04:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbjDQIDV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 04:03:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B507C1B1
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 01:03:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5076E61422
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 08:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E38C433EF;
        Mon, 17 Apr 2023 08:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681718598;
        bh=INt3npOLn+5BFHbYoEcGAgOpL7SwC8dwQ8fdGnquKRQ=;
        h=Subject:To:Cc:From:Date:From;
        b=gwW87fhGEqBKu6wDxePynVIDHZZOFGSA49LODfsJwzeMXFVSoQ3vi9AYl4agPatoK
         l63lTAwbWamaYT8j70b8iaPb+Dl6XVw1AMfhmS0IdZo32GgbWA3LFVxvlfWC8OVAiB
         fFgifGW6MUdLy5DmkudbBYzWrDG6p0p6wcgXYE30=
Subject: FAILED: patch "[PATCH] cgroup/cpuset: Wake up cpuset_attach_wq tasks in" failed to apply to 4.14-stable tree
To:     longman@redhat.com, mkoutny@suse.com, tj@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Apr 2023 10:03:04 +0200
Message-ID: <2023041704-banister-dreamt-9dfd@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.14.y
git checkout FETCH_HEAD
git cherry-pick -x ba9182a89626d5f83c2ee4594f55cb9c1e60f0e2
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041704-banister-dreamt-9dfd@gregkh' --subject-prefix 'PATCH 4.14.y' HEAD^..

Possible dependencies:

ba9182a89626 ("cgroup/cpuset: Wake up cpuset_attach_wq tasks in cpuset_cancel_attach()")
1243dc518c9d ("cgroup/cpuset: Convert cpuset_mutex to percpu_rwsem")
f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")
933a90bf4f35 ("Merge branch 'work.mount0' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ba9182a89626d5f83c2ee4594f55cb9c1e60f0e2 Mon Sep 17 00:00:00 2001
From: Waiman Long <longman@redhat.com>
Date: Tue, 11 Apr 2023 09:35:57 -0400
Subject: [PATCH] cgroup/cpuset: Wake up cpuset_attach_wq tasks in
 cpuset_cancel_attach()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

After a successful cpuset_can_attach() call which increments the
attach_in_progress flag, either cpuset_cancel_attach() or cpuset_attach()
will be called later. In cpuset_attach(), tasks in cpuset_attach_wq,
if present, will be woken up at the end. That is not the case in
cpuset_cancel_attach(). So missed wakeup is possible if the attach
operation is somehow cancelled. Fix that by doing the wakeup in
cpuset_cancel_attach() as well.

Fixes: e44193d39e8d ("cpuset: let hotplug propagation work wait for task attaching")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Cc: stable@vger.kernel.org # v3.11+
Signed-off-by: Tejun Heo <tj@kernel.org>

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index f310915d1257..ff7eb8e2efdc 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2502,11 +2502,15 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 static void cpuset_cancel_attach(struct cgroup_taskset *tset)
 {
 	struct cgroup_subsys_state *css;
+	struct cpuset *cs;
 
 	cgroup_taskset_first(tset, &css);
+	cs = css_cs(css);
 
 	percpu_down_write(&cpuset_rwsem);
-	css_cs(css)->attach_in_progress--;
+	cs->attach_in_progress--;
+	if (!cs->attach_in_progress)
+		wake_up(&cpuset_attach_wq);
 	percpu_up_write(&cpuset_rwsem);
 }
 

