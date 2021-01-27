Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27B9305D61
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 14:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235516AbhA0Nh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 08:37:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:52782 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238455AbhA0Nf4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 08:35:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0798DAF90;
        Wed, 27 Jan 2021 13:35:15 +0000 (UTC)
From:   Nicolai Stange <nstange@suse.de>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Nicolai Stange <nstange@suse.de>
Subject: [PATCH for stable 5.4] io_uring: Fix current->fs handling in io_sq_wq_submit_work()
Date:   Wed, 27 Jan 2021 14:34:43 +0100
Message-Id: <20210127133443.2413-1-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

No upstream commit, this is a fix to a stable 5.4 specific backport.

The intention of backport commit cac68d12c531 ("io_uring: grab ->fs as part
of async offload") as found in the stable 5.4 tree was to make
io_sq_wq_submit_work() to switch the workqueue task's ->fs over to the
submitting task's one during the IO operation.

However, due to a small logic error, this change turned out to not have any
actual effect. From a high level, the relevant code in
io_sq_wq_submit_work() looks like

  old_fs_struct = current->fs;
  do {
          ...
          if (req->fs != current->fs && current->fs != old_fs_struct) {
                  task_lock(current);
                  if (req->fs)
                          current->fs = req->fs;
                  else
                          current->fs = old_fs_struct;
                  task_unlock(current);
          }
          ...
  } while (req);

The if condition is supposed to cover the case that current->fs doesn't
match what's needed for processing the request, but observe how it fails
to ever evaluate to true due to the second clause:
current->fs != old_fs_struct will be false in the first iteration as per
the initialization of old_fs_struct and because this prevents current->fs
from getting replaced, the same follows inductively for all subsequent
iterations.

Fix said if condition such that
- if req->fs is set and doesn't match current->fs, the latter will be
  switched to the former
- or if req->fs is unset, the switch back to the initial old_fs_struct
  will be made, if necessary.

While at it, also correct the condition for the ->fs related cleanup right
before the return of io_sq_wq_submit_work(): currently, old_fs_struct is
restored only if it's non-NULL. It is always non-NULL though and thus, the
if-condition is rendundant. Supposedly, the motivation had been to optimize
and avoid switching current->fs back to the initial old_fs_struct in case
it is found to have the desired value already. Make it so.

Cc: stable@vger.kernel.org # v5.4
Fixes: cac68d12c531 ("io_uring: grab ->fs as part of async offload")
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Nicolai Stange <nstange@suse.de>
---
Tested on top of v5.4.90.

 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4127ea027a14..478df7e10767 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2226,7 +2226,8 @@ static void io_sq_wq_submit_work(struct work_struct *work)
 		/* Ensure we clear previously set non-block flag */
 		req->rw.ki_flags &= ~IOCB_NOWAIT;
 
-		if (req->fs != current->fs && current->fs != old_fs_struct) {
+		if ((req->fs && req->fs != current->fs) ||
+		    (!req->fs && current->fs != old_fs_struct)) {
 			task_lock(current);
 			if (req->fs)
 				current->fs = req->fs;
@@ -2351,7 +2352,7 @@ static void io_sq_wq_submit_work(struct work_struct *work)
 		mmput(cur_mm);
 	}
 	revert_creds(old_cred);
-	if (old_fs_struct) {
+	if (old_fs_struct != current->fs) {
 		task_lock(current);
 		current->fs = old_fs_struct;
 		task_unlock(current);
-- 
2.26.2

