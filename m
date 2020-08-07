Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C3823F2E2
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 20:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbgHGSpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 14:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgHGSpf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 14:45:35 -0400
Received: from mail-ej1-x64a.google.com (mail-ej1-x64a.google.com [IPv6:2a00:1450:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6F7C061756
        for <stable@vger.kernel.org>; Fri,  7 Aug 2020 11:45:35 -0700 (PDT)
Received: by mail-ej1-x64a.google.com with SMTP id m24so1163068eje.20
        for <stable@vger.kernel.org>; Fri, 07 Aug 2020 11:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=wezATDNNHijFNE8xRUw9gZpSNfPJzDDYffclJLmDegw=;
        b=Hmvu85Ig5+eMHoqbRy5HPVSnec2zEqocJw1NoD68Ca/eOvN6JSA0aSxIRPamb3tiG3
         SS+DRbPKXnpUX2lZhARRkPsCHGMwBrqWfih+8alBYQuasKfxE5bhC4bRc1AP9FceWJ1J
         o2t4Hsm+BVunSB3f0uNr98v7dxVRaIlZS4qvCTypWegpTwUhksQAd4ELZaL7x6ZkRiP9
         7of3EezJULI5Gg0/tiobEtoEWKmumB5cYd3dtJFZQlC+KO00jI4YGZvLff41Ea88lK82
         DN/wVn9Qc8xtJiIJhxt7v6or8hndo2XY8PJuFnfKHJ//YkxyIpffsdt3N4cwznY2w8Eu
         mw3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=wezATDNNHijFNE8xRUw9gZpSNfPJzDDYffclJLmDegw=;
        b=Eg6GQvR5LgwxS6/zEhn2kEVr8/OXNc3TZUNVHIcmdSWNL/ZZvZOgLQcXoxjzX3z2Au
         JFkc7yHTd6mAcCVWTtQA4Y7NZTmRwflEnXK08uNk+ZxKkjuK7/473vr+2V4eBjJJzg2r
         ZpTzQLOhPJ2vdX/ktbOBUsxtlVBLsQBH5wRH1NqH/Srd4Tq4sZ1PF8Anka2plJ80Kt5o
         BkNgQSbFt6r+Z3ynrNnc0+wFrlZP+1DBQIenOg19pX7ZxRJQ2Kz6DDyx1p/uIoqbQNNS
         4Nk0K+2A6JFDm5koNt0U6m1S/FNJpuVnJZXYSvNe8FsIRol0cuixhXdYKcDJpsXBd8Vw
         cncw==
X-Gm-Message-State: AOAM531AT2HzZe9VDWC/SjReGCrM5/WfdOHLEP2vw/061wUuNzoQ64rT
        XLKba4zOVCHagf812hC2FrDs7F1aoaKO+Gq9YB+i/bCzy6C/5EdKq934D9KWO66ZXSDGQQcYt2k
        bryS/2+7tqeaN01zWIsLCIdpPVRs6uMwrcEd0JJneYlGz69AIwhj+SOclLc8=
X-Google-Smtp-Source: ABdhPJxYhdNIsXK3tA0Au2KEzhLLlPefX9bnAqyJR6Zlqug2vqTdl60J/DGFHdopwCQujLtxJMRUNKUpOA==
X-Received: by 2002:a17:906:4aca:: with SMTP id u10mr10503073ejt.320.1596825933057;
 Fri, 07 Aug 2020 11:45:33 -0700 (PDT)
Date:   Fri,  7 Aug 2020 20:45:00 +0200
Message-Id: <20200807184500.3711845-1-jannh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [PATCH 4.4+4.9] binder: Prevent context manager from incrementing ref 0
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org
Cc:     maco@android.com, tkjos@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 4b836a1426cb0f1ef2a6e211d7e553221594f8fc upstream.

Binder is designed such that a binder_proc never has references to
itself. If this rule is violated, memory corruption can occur when a
process sends a transaction to itself; see e.g.
<https://syzkaller.appspot.com/bug?extid=09e05aba06723a94d43d>.

There is a remaining edgecase through which such a transaction-to-self
can still occur from the context of a task with BINDER_SET_CONTEXT_MGR
access:

 - task A opens /dev/binder twice, creating binder_proc instances P1
   and P2
 - P1 becomes context manager
 - P2 calls ACQUIRE on the magic handle 0, allocating index 0 in its
   handle table
 - P1 dies (by closing the /dev/binder fd and waiting a bit)
 - P2 becomes context manager
 - P2 calls ACQUIRE on the magic handle 0, allocating index 1 in its
   handle table
   [this triggers a warning: "binder: 1974:1974 tried to acquire
   reference to desc 0, got 1 instead"]
 - task B opens /dev/binder once, creating binder_proc instance P3
 - P3 calls P2 (via magic handle 0) with (void*)1 as argument (two-way
   transaction)
 - P2 receives the handle and uses it to call P3 (two-way transaction)
 - P3 calls P2 (via magic handle 0) (two-way transaction)
 - P2 calls P2 (via handle 1) (two-way transaction)

And then, if P2 does *NOT* accept the incoming transaction work, but
instead closes the binder fd, we get a crash.

Solve it by preventing the context manager from using ACQUIRE on ref 0.
There shouldn't be any legitimate reason for the context manager to do
that.

Additionally, print a warning if someone manages to find another way to
trigger a transaction-to-self bug in the future.

Cc: stable@vger.kernel.org
Fixes: 457b9a6f09f0 ("Staging: android: add binder driver")
Acked-by: Todd Kjos <tkjos@google.com>
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Martijn Coenen <maco@android.com>
Link: https://lore.kernel.org/r/20200727120424.1627555-1-jannh@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[manual backport: remove fine-grained locking and error reporting that
                  don't exist in <=4.9]
Signed-off-by: Jann Horn <jannh@google.com>
---
 drivers/android/binder.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index e12288c245b5..f4c0b6295945 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -1427,6 +1427,10 @@ static void binder_transaction(struct binder_proc *proc,
 			return_error = BR_DEAD_REPLY;
 			goto err_dead_binder;
 		}
+		if (WARN_ON(proc == target_proc)) {
+			return_error = BR_FAILED_REPLY;
+			goto err_invalid_target_handle;
+		}
 		if (security_binder_transaction(proc->tsk,
 						target_proc->tsk) < 0) {
 			return_error = BR_FAILED_REPLY;
@@ -1830,6 +1834,11 @@ static int binder_thread_write(struct binder_proc *proc,
 			ptr += sizeof(uint32_t);
 			if (target == 0 && binder_context_mgr_node &&
 			    (cmd == BC_INCREFS || cmd == BC_ACQUIRE)) {
+				if (binder_context_mgr_node->proc == proc) {
+					binder_user_error("%d:%d context manager tried to acquire desc 0\n",
+							  proc->pid, thread->pid);
+					return -EINVAL;
+				}
 				ref = binder_get_ref_for_node(proc,
 					       binder_context_mgr_node);
 				if (ref->desc != target) {

base-commit: 8d6b541290cb9293bd2a7bb00c1d58d01abe183b
-- 
2.28.0.236.gb10cc79966-goog

