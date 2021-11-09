Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFB844A78A
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 08:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243618AbhKIH04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 02:26:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:41776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243606AbhKIH0z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 02:26:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF84E6115B;
        Tue,  9 Nov 2021 07:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636442649;
        bh=cCGQ6PVedWjHZMPiFZNE5v2yFH491iAD0qna5WLCBVU=;
        h=Subject:To:Cc:From:Date:From;
        b=LTw5ZzYda3JtuE1gUnTjvEjwGob2rSdWHgUf2mb5TbmlnFlBaVGLXohxQlhvndBgE
         n3UCK6OH1zKG2dtLDHltjd8RNOcZeXZwgevYRcgweGSlIn/uzKI7WEOVA8IlDSF6hl
         GJbH1MStBI2QMJtC/vgM6tAVa7/6clGyHa15KsC4=
Subject: FAILED: patch "[PATCH] binder: use cred instead of task for getsecid" failed to apply to 4.14-stable tree
To:     tkjos@google.com, casey@schaufler-ca.com, lkp@intel.com,
        paul@paul-moore.com, stephen.smalley.work@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 09 Nov 2021 08:23:59 +0100
Message-ID: <1636442639214247@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4d5b5539742d2554591751b4248b0204d20dcc9d Mon Sep 17 00:00:00 2001
From: Todd Kjos <tkjos@google.com>
Date: Tue, 12 Oct 2021 09:56:14 -0700
Subject: [PATCH] binder: use cred instead of task for getsecid

Use the 'struct cred' saved at binder_open() to lookup
the security ID via security_cred_getsecid(). This
ensures that the security context that opened binder
is the one used to generate the secctx.

Cc: stable@vger.kernel.org # 5.4+
Fixes: ec74136ded79 ("binder: create node flag to request sender's security context")
Signed-off-by: Todd Kjos <tkjos@google.com>
Suggested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 1571e01cfa52..49b08c04fa09 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2713,16 +2713,7 @@ static void binder_transaction(struct binder_proc *proc,
 		u32 secid;
 		size_t added_size;
 
-		/*
-		 * Arguably this should be the task's subjective LSM secid but
-		 * we can't reliably access the subjective creds of a task
-		 * other than our own so we must use the objective creds, which
-		 * are safe to access.  The downside is that if a task is
-		 * temporarily overriding it's creds it will not be reflected
-		 * here; however, it isn't clear that binder would handle that
-		 * case well anyway.
-		 */
-		security_task_getsecid_obj(proc->tsk, &secid);
+		security_cred_getsecid(proc->cred, &secid);
 		ret = security_secid_to_secctx(secid, &secctx, &secctx_sz);
 		if (ret) {
 			return_error = BR_FAILED_REPLY;
diff --git a/include/linux/security.h b/include/linux/security.h
index 9be72166e859..cc6d39358336 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1041,6 +1041,11 @@ static inline void security_transfer_creds(struct cred *new,
 {
 }
 
+static inline void security_cred_getsecid(const struct cred *c, u32 *secid)
+{
+	*secid = 0;
+}
+
 static inline int security_kernel_act_as(struct cred *cred, u32 secid)
 {
 	return 0;

