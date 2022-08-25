Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0DB5A078C
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 05:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbiHYDKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 23:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiHYDKN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 23:10:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367A13889
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 20:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661397011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+uLFfKq7qcEV0H4i/rnqMaNlkkBgppAXmycU7cKeUiw=;
        b=bEFJC/NC/AbOTMMYBXYNu+IzBc8LwchNxZD9ohWg/dKq17+RUtHGdYdbf960s5+kG+1Orx
        KqtFtEvcEU5LXmxJQfi5Fr7M1eHTxfaJMozqnVN38kxL6CSFYFAe3AEfraWl7Ihze82RjK
        TVJvurMnSBQFWBGjh12vQzwirNbLlrg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-tgXrejx_OCGQWfHhXHtT9Q-1; Wed, 24 Aug 2022 23:10:10 -0400
X-MC-Unique: tgXrejx_OCGQWfHhXHtT9Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 837D33804504;
        Thu, 25 Aug 2022 03:10:09 +0000 (UTC)
Received: from madcap2.tricolour.com (unknown [10.22.48.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC4092026D4C;
        Thu, 25 Aug 2022 03:10:07 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>, scorreia@redhat.com,
        omosnace@redhat.com, omoris@redhat.com,
        Eric Paris <eparis@redhat.com>, stable@vger.kernel.org
Subject: [PATCH ghak138] audit: move audit_return_fixup before the filters
Date:   Wed, 24 Aug 2022 23:09:33 -0400
Message-Id: <7cff118972930ccb650bd62fbf0d2e8e452d729a.1661395017.git.rgb@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The success and return_code are needed by the filters.  Move
audit_return_fixup() before the filters.

The pid member of struct audit_context is never used.  Remove it.

The audit_reset_context() comment about unconditionally resetting
"ctx->state" should read "ctx->context".

The proctitle is intentionally stored between syscalls.  Only free it in
audit_free_context().

Be explicit in checking the struct audit_context "context" member  enum
value rather than assuming the order of context enum values.

Cc: stable@vger.kernel.org
Fixes: 12c5e81d3fd0 ("audit: prepare audit_context for use in calling contexts beyond syscalls")
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.h   |  2 +-
 kernel/auditsc.c | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/audit.h b/kernel/audit.h
index 58b66543b4d5..d6eb7b59c791 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -133,7 +133,7 @@ struct audit_context {
 	struct sockaddr_storage *sockaddr;
 	size_t sockaddr_len;
 				/* Save things to print about task_struct */
-	pid_t		    pid, ppid;
+	pid_t		    ppid;
 	kuid_t		    uid, euid, suid, fsuid;
 	kgid_t		    gid, egid, sgid, fsgid;
 	unsigned long	    personality;
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 9226746dcf0a..9f8c05228d6d 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -965,7 +965,7 @@ static void audit_reset_context(struct audit_context *ctx)
 	if (!ctx)
 		return;
 
-	/* if ctx is non-null, reset the "ctx->state" regardless */
+	/* if ctx is non-null, reset the "ctx->context" regardless */
 	ctx->context = AUDIT_CTX_UNUSED;
 	if (ctx->dummy)
 		return;
@@ -1002,7 +1002,7 @@ static void audit_reset_context(struct audit_context *ctx)
 	kfree(ctx->sockaddr);
 	ctx->sockaddr = NULL;
 	ctx->sockaddr_len = 0;
-	ctx->pid = ctx->ppid = 0;
+	ctx->ppid = 0;
 	ctx->uid = ctx->euid = ctx->suid = ctx->fsuid = KUIDT_INIT(0);
 	ctx->gid = ctx->egid = ctx->sgid = ctx->fsgid = KGIDT_INIT(0);
 	ctx->personality = 0;
@@ -1016,7 +1016,6 @@ static void audit_reset_context(struct audit_context *ctx)
 	WARN_ON(!list_empty(&ctx->killed_trees));
 	audit_free_module(ctx);
 	ctx->fds[0] = -1;
-	audit_proctitle_free(ctx);
 	ctx->type = 0; /* reset last for audit_free_*() */
 }
 
@@ -1077,6 +1076,7 @@ static inline void audit_free_context(struct audit_context *context)
 {
 	/* resetting is extra work, but it is likely just noise */
 	audit_reset_context(context);
+	audit_proctitle_free(context);
 	free_tree_refs(context);
 	kfree(context->filterkey);
 	kfree(context);
@@ -1940,6 +1940,7 @@ void __audit_uring_exit(int success, long code)
 		goto out;
 	}
 
+	audit_return_fixup(ctx, success, code);
 	if (ctx->context == AUDIT_CTX_SYSCALL) {
 		/*
 		 * NOTE: See the note in __audit_uring_entry() about the case
@@ -1981,7 +1982,6 @@ void __audit_uring_exit(int success, long code)
 	audit_filter_inodes(current, ctx);
 	if (ctx->current_state != AUDIT_STATE_RECORD)
 		goto out;
-	audit_return_fixup(ctx, success, code);
 	audit_log_exit();
 
 out:
@@ -2065,13 +2065,13 @@ void __audit_syscall_exit(int success, long return_code)
 	if (!list_empty(&context->killed_trees))
 		audit_kill_trees(context);
 
+	audit_return_fixup(context, success, return_code);
 	/* run through both filters to ensure we set the filterkey properly */
 	audit_filter_syscall(current, context);
 	audit_filter_inodes(current, context);
-	if (context->current_state < AUDIT_STATE_RECORD)
+	if (context->current_state != AUDIT_STATE_RECORD)
 		goto out;
 
-	audit_return_fixup(context, success, return_code);
 	audit_log_exit();
 
 out:
-- 
2.27.0

