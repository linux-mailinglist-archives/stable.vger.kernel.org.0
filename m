Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46EC531778
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbiEWRdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241423AbiEWRap (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:30:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46AC6007A;
        Mon, 23 May 2022 10:26:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44B86611CB;
        Mon, 23 May 2022 17:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4891EC385A9;
        Mon, 23 May 2022 17:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326764;
        bh=RTDzHiDei7ULDBzcavq5W0If3VTGoCPC3qmIElAhzlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AkNhqteeaR1KBnXBWYPOey8DfU4LK7bPWJxSecSnhPjrROZzpxfi2ArCxqFPXGDFt
         5kVPfimcfwvVY6fGQWavEbLUYqYc1pK3asXYkquxXAtg7ay5bGf3ljq9cgUCEHbfCU
         /tIQSC2OI7GkKdSNqriYhIVebIKEcWrCN0QUf4oQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Orth <ju.orth@gmail.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.17 051/158] audit,io_uring,io-wq: call __audit_uring_exit for dummy contexts
Date:   Mon, 23 May 2022 19:03:28 +0200
Message-Id: <20220523165839.183895296@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Orth <ju.orth@gmail.com>

commit 69e9cd66ae1392437234a63a3a1d60b6655f92ef upstream.

Not calling the function for dummy contexts will cause the context to
not be reset. During the next syscall, this will cause an error in
__audit_syscall_entry:

	WARN_ON(context->context != AUDIT_CTX_UNUSED);
	WARN_ON(context->name_count);
	if (context->context != AUDIT_CTX_UNUSED || context->name_count) {
		audit_panic("unrecoverable error in audit_syscall_entry()");
		return;
	}

These problematic dummy contexts are created via the following call
chain:

       exit_to_user_mode_prepare
    -> arch_do_signal_or_restart
    -> get_signal
    -> task_work_run
    -> tctx_task_work
    -> io_req_task_submit
    -> io_issue_sqe
    -> audit_uring_entry

Cc: stable@vger.kernel.org
Fixes: 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to io_uring")
Signed-off-by: Julian Orth <ju.orth@gmail.com>
[PM: subject line tweaks]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/audit.h |    2 +-
 kernel/auditsc.c      |    6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -339,7 +339,7 @@ static inline void audit_uring_entry(u8
 }
 static inline void audit_uring_exit(int success, long code)
 {
-	if (unlikely(!audit_dummy_context()))
+	if (unlikely(audit_context()))
 		__audit_uring_exit(success, code);
 }
 static inline void audit_syscall_entry(int major, unsigned long a0,
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1959,6 +1959,12 @@ void __audit_uring_exit(int success, lon
 {
 	struct audit_context *ctx = audit_context();
 
+	if (ctx->dummy) {
+		if (ctx->context != AUDIT_CTX_URING)
+			return;
+		goto out;
+	}
+
 	if (ctx->context == AUDIT_CTX_SYSCALL) {
 		/*
 		 * NOTE: See the note in __audit_uring_entry() about the case


