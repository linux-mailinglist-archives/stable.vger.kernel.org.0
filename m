Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6CD5B7046
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbiIMOYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233683AbiIMOX5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:23:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DBD659FC;
        Tue, 13 Sep 2022 07:15:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64E22B80F98;
        Tue, 13 Sep 2022 14:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C998AC433B5;
        Tue, 13 Sep 2022 14:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078532;
        bh=N2FyX9dFkbWb3Hsc+KI8JegjR/gdsORGOpT+he8/EzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ne+hEoQvmcWi3rQKfD6yMIMIcIveR3Co/VkXDc3eXb/fAQxbgeh+P6Ss9cJ9Pmh4j
         WCZW4qOMG3PQX/jeo0f3YmJ5THsqCltYsBxaYPAI4ipYC+Zcx8yqZxKcNLHxUcC+er
         ybS0U0NDnKiihCTOdbrTDr7s9DOuQbir6UcYPz/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.19 159/192] lsm,io_uring: add LSM hooks for the new uring_cmd file op
Date:   Tue, 13 Sep 2022 16:04:25 +0200
Message-Id: <20220913140417.951467472@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>

commit 2a5840124009f133bd09fd855963551fb2cefe22 upstream.

io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
add infrastructure for uring-cmd"), this extended the struct
file_operations to allow a new command which each subsystem can use
to enable command passthrough. Add an LSM specific for the command
passthrough which enables LSMs to inspect the command details.

This was discussed long ago without no clear pointer for something
conclusive, so this enables LSMs to at least reject this new file
operation.

[0] https://lkml.kernel.org/r/8adf55db-7bab-f59d-d612-ed906b948d19@schaufler-ca.com

Cc: stable@vger.kernel.org
Fixes: ee692a21e9bf ("fs,io_uring: add infrastructure for uring-cmd")
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Acked-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/lsm_hook_defs.h |    1 +
 include/linux/lsm_hooks.h     |    3 +++
 include/linux/security.h      |    5 +++++
 io_uring/io_uring.c           |    4 ++++
 security/security.c           |    4 ++++
 5 files changed, 17 insertions(+)

--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -406,4 +406,5 @@ LSM_HOOK(int, 0, perf_event_write, struc
 #ifdef CONFIG_IO_URING
 LSM_HOOK(int, 0, uring_override_creds, const struct cred *new)
 LSM_HOOK(int, 0, uring_sqpoll, void)
+LSM_HOOK(int, 0, uring_cmd, struct io_uring_cmd *ioucmd)
 #endif /* CONFIG_IO_URING */
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1575,6 +1575,9 @@
  *      Check whether the current task is allowed to spawn a io_uring polling
  *      thread (IORING_SETUP_SQPOLL).
  *
+ * @uring_cmd:
+ *      Check whether the file_operations uring_cmd is allowed to run.
+ *
  */
 union security_list_options {
 	#define LSM_HOOK(RET, DEFAULT, NAME, ...) RET (*NAME)(__VA_ARGS__);
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -2051,6 +2051,7 @@ static inline int security_perf_event_wr
 #ifdef CONFIG_SECURITY
 extern int security_uring_override_creds(const struct cred *new);
 extern int security_uring_sqpoll(void);
+extern int security_uring_cmd(struct io_uring_cmd *ioucmd);
 #else
 static inline int security_uring_override_creds(const struct cred *new)
 {
@@ -2060,6 +2061,10 @@ static inline int security_uring_sqpoll(
 {
 	return 0;
 }
+static inline int security_uring_cmd(struct io_uring_cmd *ioucmd)
+{
+	return 0;
+}
 #endif /* CONFIG_SECURITY */
 #endif /* CONFIG_IO_URING */
 
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4878,6 +4878,10 @@ static int io_uring_cmd(struct io_kiocb
 	if (!req->file->f_op->uring_cmd)
 		return -EOPNOTSUPP;
 
+	ret = security_uring_cmd(ioucmd);
+	if (ret)
+		return ret;
+
 	if (ctx->flags & IORING_SETUP_SQE128)
 		issue_flags |= IO_URING_F_SQE128;
 	if (ctx->flags & IORING_SETUP_CQE32)
--- a/security/security.c
+++ b/security/security.c
@@ -2654,4 +2654,8 @@ int security_uring_sqpoll(void)
 {
 	return call_int_hook(uring_sqpoll, 0);
 }
+int security_uring_cmd(struct io_uring_cmd *ioucmd)
+{
+	return call_int_hook(uring_cmd, 0, ioucmd);
+}
 #endif /* CONFIG_IO_URING */


