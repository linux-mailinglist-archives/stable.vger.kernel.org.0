Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEBCC4388A4
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 13:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbhJXLke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 07:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229867AbhJXLke (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Oct 2021 07:40:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25B2760D43;
        Sun, 24 Oct 2021 11:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635075493;
        bh=Jit6id0heG9xc03i4XLpEWOnAGy5eBfxioToCN6e92c=;
        h=Subject:To:Cc:From:Date:From;
        b=2RfIYIV06hyA1nU+eqUVQajCfzqo3IPpYSXlFZKBZrbwok3uYQmVaXzncglD0S0b3
         3VCrva0S1Lm7c5zYGi9ojlOe/iqMPiM4js8hYzRW/sWVqCCMuOHdn+6oSwEdLJKzLK
         pIabGC032WUv5sSBkTC3JHne+q72MWFKjBa+gmfY=
Subject: FAILED: patch "[PATCH] ucounts: Proper error handling in set_cred_ucounts" failed to apply to 5.10-stable tree
To:     ebiederm@xmission.com, legion@kernel.org, yuzhao@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Oct 2021 13:38:11 +0200
Message-ID: <16350754917219@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 34dc2fd6e6908499b669c7b45320cddf38b332e1 Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Sat, 16 Oct 2021 12:47:51 -0500
Subject: [PATCH] ucounts: Proper error handling in set_cred_ucounts

Instead of leaking the ucounts in new if alloc_ucounts fails, store
the result of alloc_ucounts into a temporary variable, which is later
assigned to new->ucounts.

Cc: stable@vger.kernel.org
Fixes: 905ae01c4ae2 ("Add a reference to ucounts for each cred")
Link: https://lkml.kernel.org/r/87pms2s0v8.fsf_-_@disp2133
Tested-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Alexey Gladkov <legion@kernel.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

diff --git a/kernel/cred.c b/kernel/cred.c
index 3d163bfd64a9..16c05dfbec4d 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -669,7 +669,7 @@ int set_cred_ucounts(struct cred *new)
 {
 	struct task_struct *task = current;
 	const struct cred *old = task->real_cred;
-	struct ucounts *old_ucounts = new->ucounts;
+	struct ucounts *new_ucounts, *old_ucounts = new->ucounts;
 
 	if (new->user == old->user && new->user_ns == old->user_ns)
 		return 0;
@@ -681,9 +681,10 @@ int set_cred_ucounts(struct cred *new)
 	if (old_ucounts && old_ucounts->ns == new->user_ns && uid_eq(old_ucounts->uid, new->euid))
 		return 0;
 
-	if (!(new->ucounts = alloc_ucounts(new->user_ns, new->euid)))
+	if (!(new_ucounts = alloc_ucounts(new->user_ns, new->euid)))
 		return -EAGAIN;
 
+	new->ucounts = new_ucounts;
 	if (old_ucounts)
 		put_ucounts(old_ucounts);
 

