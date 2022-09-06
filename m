Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B045AF696
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 23:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiIFVDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 17:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiIFVDp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 17:03:45 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3BBA2A99
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 14:03:44 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id w28so9045029qtc.7
        for <stable@vger.kernel.org>; Tue, 06 Sep 2022 14:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:from:to:cc:subject
         :date;
        bh=6MX65zgqfAKJcqzX9VApOUmwZEqdlbEKFsyJ0TCOG60=;
        b=HsuhH5IoR0RN1paQiFiauDrlrsexQjSB1OEw5OVPUTYNhsIiNcJGnzinpIdSqqRCQz
         GMN5AOIiPVnA/9TwwDUMudBu6FSjlSiER9Ykg+z0FJyJUu3iYfetpx9rI9EThWw9qGxu
         AA/GXQllChELlUWK3JbrxwyFPDg8ilHu36oW/Lx94N1ICUI+JFVqK3DOkGc9NpaZO2ab
         O46h/YojIx+3JNp365u7Ga4wnPyqMwQYh2Mfki2XrNj1CENfgN8Rn2r4czdpd4GOEpkh
         ctzSogd8RaeM8aBdyMqBBMILOfflbQKG2YVlSMdaxzPROVUZ/QFDdbI3ZXFeQARLtNxQ
         KUcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:x-gm-message-state
         :from:to:cc:subject:date;
        bh=6MX65zgqfAKJcqzX9VApOUmwZEqdlbEKFsyJ0TCOG60=;
        b=3lkb/SY89GJJoWDsbEHfwLet5hgGlz2Zetv1j40pwOtj6ZrnXArOZQx8sRpsZR7Bnn
         kOdN5V5rTa/GimOhVTm0aRXHBE+iu2MVhuM1jNFGCa/ZsVE4hvehhm2ektcONRIK19B/
         NAoC5adV3b9+LC38369lM7DUzfZbCZX9ipukiaQCs6Z5wVPJ1QCE6o1cH3nmjdIYFYBi
         Wfsn6D3/O7Hd4ONrSm0BtTCg3HKYp8A52xrbSmzNXeZvM6NuWcFL6jtwdh4ek+1xADhA
         ePwvy+cNF9yYYLEHaQ1XKfHI98rS664lpPjdftkf+dEb0GgcoUDGAlZdf3TFb/KVdRkB
         PS3A==
X-Gm-Message-State: ACgBeo3QUbO+2BmaeD2hFeE9mAwKejub29b5ljtvWEbz62igSsz1G2pC
        oK+a5OjQ4Dt2h9koO04LowgjbLPd5oX4
X-Google-Smtp-Source: AA6agR7jFp3i7Ot9zXuFRrmJ6/orjtTiDUwxI8Nqw4e2ahjv0IoLatAnDx239V5TxnR2ZWrLMYDLMQ==
X-Received: by 2002:ac8:5d49:0:b0:344:7275:dd61 with SMTP id g9-20020ac85d49000000b003447275dd61mr489446qtx.48.1662498223359;
        Tue, 06 Sep 2022 14:03:43 -0700 (PDT)
Received: from localhost (pool-108-26-161-203.bstnma.fios.verizon.net. [108.26.161.203])
        by smtp.gmail.com with ESMTPSA id t32-20020a05622a182000b0033aac3da27dsm10595301qtc.19.2022.09.06.14.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 14:03:42 -0700 (PDT)
Subject: [v5.19.y PATCH 1/3] lsm,io_uring: add LSM hooks for the new uring_cmd
 file op
From:   Paul Moore <paul@paul-moore.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Luis Chamberlain <mcgrof@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        selinux@vger.kernel.org, linux-security-module@vger.kernel.org
Date:   Tue, 06 Sep 2022 17:03:42 -0400
Message-ID: <166249822248.409408.10261922549346984289.stgit@olly>
In-Reply-To: <166249766105.409408.12118839467847524983.stgit@olly>
References: <166249766105.409408.12118839467847524983.stgit@olly>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport the following upstream commit into Linux v5.19.y:

    commit 2a5840124009f133bd09fd855963551fb2cefe22
    Author: Luis Chamberlain <mcgrof@kernel.org>
    Date:   Fri Jul 15 12:16:22 2022 -0700

    lsm,io_uring: add LSM hooks for the new uring_cmd file op

    io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
    add infrastructure for uring-cmd"), this extended the struct
    file_operations to allow a new command which each subsystem can use
    to enable command passthrough. Add an LSM specific for the command
    passthrough which enables LSMs to inspect the command details.

    This was discussed long ago without no clear pointer for something
    conclusive, so this enables LSMs to at least reject this new file
    operation.

    [0] https://lkml.kernel.org/r/8adf55db-7bab-f59d-d612-ed906b948d19@schaufler-ca.com

Signed-off-by: Paul Moore <paul@paul-moore.com>
---
 include/linux/lsm_hook_defs.h |    1 +
 include/linux/lsm_hooks.h     |    3 +++
 include/linux/security.h      |    5 +++++
 io_uring/io_uring.c           |    4 ++++
 security/security.c           |    4 ++++
 5 files changed, 17 insertions(+)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index eafa1d2489fd..4e94755098f1 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -406,4 +406,5 @@ LSM_HOOK(int, 0, perf_event_write, struct perf_event *event)
 #ifdef CONFIG_IO_URING
 LSM_HOOK(int, 0, uring_override_creds, const struct cred *new)
 LSM_HOOK(int, 0, uring_sqpoll, void)
+LSM_HOOK(int, 0, uring_cmd, struct io_uring_cmd *ioucmd)
 #endif /* CONFIG_IO_URING */
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 91c8146649f5..b681cfce6190 100644
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
diff --git a/include/linux/security.h b/include/linux/security.h
index 7fc4e9f49f54..3cc127bb5bfd 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -2051,6 +2051,7 @@ static inline int security_perf_event_write(struct perf_event *event)
 #ifdef CONFIG_SECURITY
 extern int security_uring_override_creds(const struct cred *new);
 extern int security_uring_sqpoll(void);
+extern int security_uring_cmd(struct io_uring_cmd *ioucmd);
 #else
 static inline int security_uring_override_creds(const struct cred *new)
 {
@@ -2060,6 +2061,10 @@ static inline int security_uring_sqpoll(void)
 {
 	return 0;
 }
+static inline int security_uring_cmd(struct io_uring_cmd *ioucmd)
+{
+	return 0;
+}
 #endif /* CONFIG_SECURITY */
 #endif /* CONFIG_IO_URING */
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cd155b7e1346..c5208dca18fa 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4878,6 +4878,10 @@ static int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	if (!req->file->f_op->uring_cmd)
 		return -EOPNOTSUPP;
 
+	ret = security_uring_cmd(ioucmd);
+	if (ret)
+		return ret;
+
 	if (ctx->flags & IORING_SETUP_SQE128)
 		issue_flags |= IO_URING_F_SQE128;
 	if (ctx->flags & IORING_SETUP_CQE32)
diff --git a/security/security.c b/security/security.c
index 188b8f782220..8b62654ff3f9 100644
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

