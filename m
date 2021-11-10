Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4150B44C7E2
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbhKJS4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:56:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:54264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233707AbhKJSyf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:54:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7409B619F5;
        Wed, 10 Nov 2021 18:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636570145;
        bh=An4mUW80MSsxbz+rCJVpLo3RQdg5IAnU60AaarSe0aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQtXf+YuSjkFlW/mF8rzQUD81AxvHAb0yl7ZZHViuBAkypkPloBc4ON+Q9vxfbn30
         LCRJ/TUcqkAG4pkzFshjnAO3t7ZREdRKpOJqdIzr3/m+4sszXleSSSDHEabstkRdM0
         EQILnBPbUBXIA1k0j6QTqIcp2F2ppYIvqX5ieh9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Todd Kjos <tkjos@google.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.14 12/24] binder: use cred instead of task for getsecid
Date:   Wed, 10 Nov 2021 19:44:04 +0100
Message-Id: <20211110182003.724807094@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182003.342919058@linuxfoundation.org>
References: <20211110182003.342919058@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Todd Kjos <tkjos@google.com>

commit 4d5b5539742d2554591751b4248b0204d20dcc9d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |   11 +----------
 include/linux/security.h |    5 +++++
 2 files changed, 6 insertions(+), 10 deletions(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2722,16 +2722,7 @@ static void binder_transaction(struct bi
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
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1041,6 +1041,11 @@ static inline void security_transfer_cre
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


