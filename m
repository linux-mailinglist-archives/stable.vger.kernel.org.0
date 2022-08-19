Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A655759A5A7
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349847AbiHSSPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 14:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350397AbiHSSP1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 14:15:27 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256E51C92C;
        Fri, 19 Aug 2022 11:14:39 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id x23so4784587pll.7;
        Fri, 19 Aug 2022 11:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=pftLU29xMcYVd4FlVJDw7N6M2k1bSEeTfLrx5irx0dE=;
        b=StOsznHxXSwtAmfQ1OuRRZjX5sJ8iYXa3jlwHdJgayOv3kNDis15T6dLfYImDV/4rE
         Gq/7kfBFLmNmO4sh0qPWZZuZTebji9r4ySKuXEhbDqa8OjHZMzeRD1312rE5Jm4D6dfp
         +mh+ibaGXm94UITwZzfvOpq2xU57OOSVHD8fb2bq/JIRKPUjClNyhLDyHBOy0eYBt11e
         uED1I3LrFPxoe/zNtGy5eBGCUdqUdIScPfp+p6eCIWbYJ+Wr4iIUt6NzsB01jeyv07/G
         XTC84egAamLjgeqgOnLGj0jJ9JCrZ5TmctQmnaRJ7bwGdHooIWBRMi6y/gaigFaKEz+s
         ECXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=pftLU29xMcYVd4FlVJDw7N6M2k1bSEeTfLrx5irx0dE=;
        b=U7PCIt8aSF4y4kKRz8RKD2nsH0hXb4wU1F8zTn+eL3Psm7NHpVh1sTtMZ+NSUnXcO6
         V6ViLLqsR5JRw+Aihb9oomwsrXs4KNzynJQNknLguTsjcQ5C/ld7JFYf9IEut9t1wRJe
         6RBQaMqD8VyNXV5E/+gmP1krA1s6ZGj240Z18UqPe6ATwAkfyPtEOsT0vsEQVgKvevF/
         6Mid2PvcyWoemWMdBZCxl7c6xpbCOYL8LW6Baj0qg7kUMpNxm2lZ/ijW5GDZ5QWWnMqm
         7ah9JGu3lQDZyUqn3hFCeTQ5RIOxADVsNHNZERtG3KRAW6/yeKrziCxotXkjhjErW4A2
         sXsQ==
X-Gm-Message-State: ACgBeo17Tp/EwBVTr9y/KZdtRo5FHtYDOLcxMYiUZ1gxYGugZQoJmAmu
        AlBvDDZ9mT96RQhQvxDyVEcYr/UPFaqyLA==
X-Google-Smtp-Source: AA6agR4X16QF3zT5pcI1/z4USbvMsLDqicRXRZXly7VpHXXc2nBYGpENm7D8hozbbUs9TlSvVYBOAQ==
X-Received: by 2002:a17:90a:5d8a:b0:1f7:3c7a:9cc7 with SMTP id t10-20020a17090a5d8a00b001f73c7a9cc7mr9761216pji.207.1660932878328;
        Fri, 19 Aug 2022 11:14:38 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:3995:f9b1:1e6b:e373])
        by smtp.gmail.com with ESMTPSA id t14-20020a170902e84e00b0015ee60ef65bsm3460918plg.260.2022.08.19.11.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 11:14:38 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 1/9] xfs: flush inodegc workqueue tasks before cancel
Date:   Fri, 19 Aug 2022 11:14:23 -0700
Message-Id: <20220819181431.4113819-2-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
In-Reply-To: <20220819181431.4113819-1-leah.rumancik@gmail.com>
References: <20220819181431.4113819-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 6191cf3ad59fda5901160633fef8e41b064a5246 ]

The xfs_inodegc_stop() helper performs a high level flush of pending
work on the percpu queues and then runs a cancel_work_sync() on each
of the percpu work tasks to ensure all work has completed before
returning.  While cancel_work_sync() waits for wq tasks to complete,
it does not guarantee work tasks have started. This means that the
_stop() helper can queue and instantly cancel a wq task without
having completed the associated work. This can be observed by
tracepoint inspection of a simple "rm -f <file>; fsfreeze -f <mnt>"
test:

	xfs_destroy_inode: ... ino 0x83 ...
	xfs_inode_set_need_inactive: ... ino 0x83 ...
	xfs_inodegc_stop: ...
	...
	xfs_inodegc_start: ...
	xfs_inodegc_worker: ...
	xfs_inode_inactivating: ... ino 0x83 ...

The first few lines show that the inode is removed and need inactive
state set, but the inactivation work has not completed before the
inodegc mechanism stops. The inactivation doesn't actually occur
until the fs is unfrozen and the gc mechanism starts back up. Note
that this test requires fsfreeze to reproduce because xfs_freeze
indirectly invokes xfs_fs_statfs(), which calls xfs_inodegc_flush().

When this occurs, the workqueue try_to_grab_pending() logic first
tries to steal the pending bit, which does not succeed because the
bit has been set by queue_work_on(). Subsequently, it checks for
association of a pool workqueue from the work item under the pool
lock. This association is set at the point a work item is queued and
cleared when dequeued for processing. If the association exists, the
work item is removed from the queue and cancel_work_sync() returns
true. If the pwq association is cleared, the remove attempt assumes
the task is busy and retries (eventually returning false to the
caller after waiting for the work task to complete).

To avoid this race, we can flush each work item explicitly before
cancel. However, since the _queue_all() already schedules each
underlying work item, the workqueue level helpers are sufficient to
achieve the same ordering effect. E.g., the inodegc enabled flag
prevents scheduling any further work in the _stop() case. Use the
drain_workqueue() helper in this particular case to make the intent
a bit more self explanatory.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index f2210d927481..5e44d7bbd8fc 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1872,28 +1872,20 @@ xfs_inodegc_worker(
 }
 
 /*
- * Force all currently queued inode inactivation work to run immediately, and
- * wait for the work to finish. Two pass - queue all the work first pass, wait
- * for it in a second pass.
+ * Force all currently queued inode inactivation work to run immediately and
+ * wait for the work to finish.
  */
 void
 xfs_inodegc_flush(
 	struct xfs_mount	*mp)
 {
-	struct xfs_inodegc	*gc;
-	int			cpu;
-
 	if (!xfs_is_inodegc_enabled(mp))
 		return;
 
 	trace_xfs_inodegc_flush(mp, __return_address);
 
 	xfs_inodegc_queue_all(mp);
-
-	for_each_online_cpu(cpu) {
-		gc = per_cpu_ptr(mp->m_inodegc, cpu);
-		flush_work(&gc->work);
-	}
+	flush_workqueue(mp->m_inodegc_wq);
 }
 
 /*
@@ -1904,18 +1896,12 @@ void
 xfs_inodegc_stop(
 	struct xfs_mount	*mp)
 {
-	struct xfs_inodegc	*gc;
-	int			cpu;
-
 	if (!xfs_clear_inodegc_enabled(mp))
 		return;
 
 	xfs_inodegc_queue_all(mp);
+	drain_workqueue(mp->m_inodegc_wq);
 
-	for_each_online_cpu(cpu) {
-		gc = per_cpu_ptr(mp->m_inodegc, cpu);
-		cancel_work_sync(&gc->work);
-	}
 	trace_xfs_inodegc_stop(mp, __return_address);
 }
 
-- 
2.37.1.595.g718a3a8f04-goog

