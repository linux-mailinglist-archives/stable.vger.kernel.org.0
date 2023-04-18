Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452526E6492
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbjDRMuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbjDRMuT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:50:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7901545A
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B606D6340D
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7488C433EF;
        Tue, 18 Apr 2023 12:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822217;
        bh=I6ga2qarMUTw/LBMWwkY72jb0CH+PxiO9wPzxj2uLZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dRajVXZDuem35WXcMZYpqcW4Sh1Rh5V6fr8TwlOYk4K7Ks1ybu72XFrjkhZINPi68
         eRNDI6gilKge5Twxicw/HhpnRpKKkwNvo30sZVmU/q6qYDbDlSRSyeCQyc3gPqLX6q
         83OAbTyoyI7c6tHqP2uArPAngdFgBP7A9NXiyl7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot <syzbot+c39682e86c9d84152f93@syzkaller.appspotmail.com>,
        Hillf Danton <hdanton@sina.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Mukesh Ojha <quic_mojha@quicinc.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 065/139] cgroup,freezer: hold cpu_hotplug_lock before freezer_mutex
Date:   Tue, 18 Apr 2023 14:22:10 +0200
Message-Id: <20230418120316.259134474@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 57dcd64c7e036299ef526b400a8d12b8a2352f26 ]

syzbot is reporting circular locking dependency between cpu_hotplug_lock
and freezer_mutex, for commit f5d39b020809 ("freezer,sched: Rewrite core
freezer logic") replaced atomic_inc() in freezer_apply_state() with
static_branch_inc() which holds cpu_hotplug_lock.

cpu_hotplug_lock => cgroup_threadgroup_rwsem => freezer_mutex

  cgroup_file_write() {
    cgroup_procs_write() {
      __cgroup_procs_write() {
        cgroup_procs_write_start() {
          cgroup_attach_lock() {
            cpus_read_lock() {
              percpu_down_read(&cpu_hotplug_lock);
            }
            percpu_down_write(&cgroup_threadgroup_rwsem);
          }
        }
        cgroup_attach_task() {
          cgroup_migrate() {
            cgroup_migrate_execute() {
              freezer_attach() {
                mutex_lock(&freezer_mutex);
                (...snipped...)
              }
            }
          }
        }
        (...snipped...)
      }
    }
  }

freezer_mutex => cpu_hotplug_lock

  cgroup_file_write() {
    freezer_write() {
      freezer_change_state() {
        mutex_lock(&freezer_mutex);
        freezer_apply_state() {
          static_branch_inc(&freezer_active) {
            static_key_slow_inc() {
              cpus_read_lock();
              static_key_slow_inc_cpuslocked();
              cpus_read_unlock();
            }
          }
        }
        mutex_unlock(&freezer_mutex);
      }
    }
  }

Swap locking order by moving cpus_read_lock() in freezer_apply_state()
to before mutex_lock(&freezer_mutex) in freezer_change_state().

Reported-by: syzbot <syzbot+c39682e86c9d84152f93@syzkaller.appspotmail.com>
Link: https://syzkaller.appspot.com/bug?extid=c39682e86c9d84152f93
Suggested-by: Hillf Danton <hdanton@sina.com>
Fixes: f5d39b020809 ("freezer,sched: Rewrite core freezer logic")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/legacy_freezer.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/legacy_freezer.c b/kernel/cgroup/legacy_freezer.c
index 1b6b21851e9d4..936473203a6b5 100644
--- a/kernel/cgroup/legacy_freezer.c
+++ b/kernel/cgroup/legacy_freezer.c
@@ -22,6 +22,7 @@
 #include <linux/freezer.h>
 #include <linux/seq_file.h>
 #include <linux/mutex.h>
+#include <linux/cpu.h>
 
 /*
  * A cgroup is freezing if any FREEZING flags are set.  FREEZING_SELF is
@@ -350,7 +351,7 @@ static void freezer_apply_state(struct freezer *freezer, bool freeze,
 
 	if (freeze) {
 		if (!(freezer->state & CGROUP_FREEZING))
-			static_branch_inc(&freezer_active);
+			static_branch_inc_cpuslocked(&freezer_active);
 		freezer->state |= state;
 		freeze_cgroup(freezer);
 	} else {
@@ -361,7 +362,7 @@ static void freezer_apply_state(struct freezer *freezer, bool freeze,
 		if (!(freezer->state & CGROUP_FREEZING)) {
 			freezer->state &= ~CGROUP_FROZEN;
 			if (was_freezing)
-				static_branch_dec(&freezer_active);
+				static_branch_dec_cpuslocked(&freezer_active);
 			unfreeze_cgroup(freezer);
 		}
 	}
@@ -379,6 +380,7 @@ static void freezer_change_state(struct freezer *freezer, bool freeze)
 {
 	struct cgroup_subsys_state *pos;
 
+	cpus_read_lock();
 	/*
 	 * Update all its descendants in pre-order traversal.  Each
 	 * descendant will try to inherit its parent's FREEZING state as
@@ -407,6 +409,7 @@ static void freezer_change_state(struct freezer *freezer, bool freeze)
 	}
 	rcu_read_unlock();
 	mutex_unlock(&freezer_mutex);
+	cpus_read_unlock();
 }
 
 static ssize_t freezer_write(struct kernfs_open_file *of,
-- 
2.39.2



