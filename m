Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F44461A032
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 19:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbiKDSmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 14:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiKDSme (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 14:42:34 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFE72FFF6
        for <stable@vger.kernel.org>; Fri,  4 Nov 2022 11:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1667587354; x=1699123354;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BAKwZtsDdo3bQ8//vFYosQIHnOyp86E3/xFlh4f5CJY=;
  b=rCjp0aOBJHjI7jy5MojvP2wYc+Z3ej7YQhHwko7b3as9DStRws4yA0Uq
   ap+ijbjTIQu+E5sz0ZeGmRBfkrJ5p7CV1cxEUes9YquFToBbct40OqZgQ
   og4T6XQ9Q1Lr8Mb9rTihlHnHCMIb7nwTcJNTjHdWTIje9u52Gfdwq1mac
   A=;
X-IronPort-AV: E=Sophos;i="5.96,138,1665446400"; 
   d="scan'208";a="238539435"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-47cc8a4c.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 18:42:27 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-m6i4x-47cc8a4c.us-east-1.amazon.com (Postfix) with ESMTPS id 15E27161515;
        Fri,  4 Nov 2022 18:42:17 +0000 (UTC)
Received: from EX19D028UEC003.ant.amazon.com (10.252.137.159) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.226) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 4 Nov 2022 18:42:15 +0000
Received: from dev-dsk-luizcap-1d-af6a6fef.us-east-1.amazon.com
 (10.43.160.223) by EX19D028UEC003.ant.amazon.com (10.252.137.159) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.15; Fri, 4 Nov
 2022 18:42:10 +0000
From:   Luiz Capitulino <luizcap@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <lcapitulino@gmail.com>, Vasily Averin <vvs@virtuozzo.com>,
        Shakeel Butt <shakeelb@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Alexey Dobriyan" <adobriyan@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        "Borislav Petkov" <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Jeff Layton <jlayton@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Jiri Slaby <jirislaby@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Michal Hocko <mhocko@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Roman Gushchin <guro@fb.com>,
        Serge Hallyn <serge@hallyn.com>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Yutian Yang <nglaive@gmail.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10, 5.4] memcg: enable accounting of ipc resources
Date:   Fri, 4 Nov 2022 18:41:31 +0000
Message-ID: <20221104184131.17797-1-luizcap@amazon.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.223]
X-ClientProxiedBy: EX13D29UWA002.ant.amazon.com (10.43.160.63) To
 EX19D028UEC003.ant.amazon.com (10.252.137.159)
X-Spam-Status: No, score=-12.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

Commit 18319498fdd4cdf8c1c2c48cd432863b1f915d6f upstream.

[ This backport fixes CVE-2021-3759 for 5.10 and 5.4. Please, note that
  it caused conflicts in all files being changed because upstream
  changed ipc object allocation to and from kvmalloc() & friends (eg.
  commits bc8136a543aa and fc37a3b8b4388e). However, I decided to keep
  this backport about the memcg accounting fix only. ]

When user creates IPC objects it forces kernel to allocate memory for
these long-living objects.

It makes sense to account them to restrict the host's memory consumption
from inside the memcg-limited container.

This patch enables accounting for IPC shared memory segments, messages
semaphores and semaphore's undo lists.

Link: https://lkml.kernel.org/r/d6507b06-4df6-78f8-6c54-3ae86e3b5339@virtuozzo.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Yutian Yang <nglaive@gmail.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luiz Capitulino <luizcap@amazon.com>
---
 ipc/msg.c | 2 +-
 ipc/sem.c | 9 +++++----
 ipc/shm.c | 2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

Reviewers,

Some important details:

o While doing this backport I realized that Vasily worked on a large accounting
overhaul which may include more instances of this problem (and possibly more
unfixed CVEs). This brings the question whether we should only fix concrete/reproducible
accounting issues or bring Vasily's entire overhaul. I'm choosing to fix
only concrete cases

o 4.19 and 4.9 should also have this issue, but I haven't tried the backport
there yet

o For testing, I did two things:

  1. Reproduced the issue as described in the link below, with and
     without this patch. Without the patch I can pretty clearly see
     the kernel allocating several gigas of memory that are not
     accounted for by memcg. With the patch the memory is accounted
     correctly

     Reproducer: https://lore.kernel.org/linux-mm/1626333284-1404-1-git-send-email-nglaive@gmail.com/

 2. I ran LTP's ipc test-cases (which simple, but hopefully good enough)

diff --git a/ipc/msg.c b/ipc/msg.c
index 6e6c8e0c9380..8ded6b8f10a2 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -147,7 +147,7 @@ static int newque(struct ipc_namespace *ns, struct ipc_params *params)
 	key_t key = params->key;
 	int msgflg = params->flg;
 
-	msq = kvmalloc(sizeof(*msq), GFP_KERNEL);
+	msq = kvmalloc(sizeof(*msq), GFP_KERNEL_ACCOUNT);
 	if (unlikely(!msq))
 		return -ENOMEM;
 
diff --git a/ipc/sem.c b/ipc/sem.c
index 7d9c06b0ad6e..d3b9b73cd9ca 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -511,7 +511,7 @@ static struct sem_array *sem_alloc(size_t nsems)
 	if (nsems > (INT_MAX - sizeof(*sma)) / sizeof(sma->sems[0]))
 		return NULL;
 
-	sma = kvzalloc(struct_size(sma, sems, nsems), GFP_KERNEL);
+	sma = kvzalloc(struct_size(sma, sems, nsems), GFP_KERNEL_ACCOUNT);
 	if (unlikely(!sma))
 		return NULL;
 
@@ -1852,7 +1852,7 @@ static inline int get_undo_list(struct sem_undo_list **undo_listp)
 
 	undo_list = current->sysvsem.undo_list;
 	if (!undo_list) {
-		undo_list = kzalloc(sizeof(*undo_list), GFP_KERNEL);
+		undo_list = kzalloc(sizeof(*undo_list), GFP_KERNEL_ACCOUNT);
 		if (undo_list == NULL)
 			return -ENOMEM;
 		spin_lock_init(&undo_list->lock);
@@ -1937,7 +1937,7 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
 	rcu_read_unlock();
 
 	/* step 2: allocate new undo structure */
-	new = kzalloc(sizeof(struct sem_undo) + sizeof(short)*nsems, GFP_KERNEL);
+	new = kzalloc(sizeof(struct sem_undo) + sizeof(short)*nsems, GFP_KERNEL_ACCOUNT);
 	if (!new) {
 		ipc_rcu_putref(&sma->sem_perm, sem_rcu_free);
 		return ERR_PTR(-ENOMEM);
@@ -2001,7 +2001,8 @@ static long do_semtimedop(int semid, struct sembuf __user *tsops,
 	if (nsops > ns->sc_semopm)
 		return -E2BIG;
 	if (nsops > SEMOPM_FAST) {
-		sops = kvmalloc_array(nsops, sizeof(*sops), GFP_KERNEL);
+		sops = kvmalloc_array(nsops, sizeof(*sops),
+				      GFP_KERNEL_ACCOUNT);
 		if (sops == NULL)
 			return -ENOMEM;
 	}
diff --git a/ipc/shm.c b/ipc/shm.c
index 471ac3e7498d..b418731d66e8 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -711,7 +711,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 			ns->shm_tot + numpages > ns->shm_ctlall)
 		return -ENOSPC;
 
-	shp = kvmalloc(sizeof(*shp), GFP_KERNEL);
+	shp = kvmalloc(sizeof(*shp), GFP_KERNEL_ACCOUNT);
 	if (unlikely(!shp))
 		return -ENOMEM;
 
-- 
2.24.4.AMZN

