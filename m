Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6395FEF1A
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 15:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiJNNx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 09:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiJNNxQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 09:53:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00301D0679;
        Fri, 14 Oct 2022 06:52:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F3F561B27;
        Fri, 14 Oct 2022 13:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4308DC433C1;
        Fri, 14 Oct 2022 13:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665755573;
        bh=qa/nkLRZZlwVbA9hanFq24bZyUalUJx/CypuGXgINzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y2iilNWTa1D9g95WsmaBHkdPoUn8UtPyv+dKr2uHXEW4GD5u/J5MYmOX+f01WT3HA
         vTpFzabO33pjULyRBTCBEJWw1jGxwS+8ONbwd8zVEDoerdUVx0CiWGHIX7rrK4D1a+
         ezeXr29H9HVTB3hRyqtoXoZGbh9t2HPEwYX4FzUgp2DuVrKVLb1U3TbXkajQ0G15JO
         GgI7cOdWA050lkCRTfWjKBpiGlmVb1rVggzwvJM5Sc64mXXYjnPIKjyo1y5SdwmU/M
         Bep4+BRt8zm1a0qKW4589clx79VyXKbtzsXBl3qPWBMyiXGw9zF+Ygt06sjm9b92MY
         kYXD+OGACluvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Lynch <nathanl@linux.ibm.com>,
        Paul Moore <paul@paul-moore.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, jmorris@namei.org,
        serge@hallyn.com, ldufour@linux.ibm.com, npiggin@gmail.com,
        christophe.leroy@csgroup.eu, sourabhjain@linux.ibm.com,
        ajd@linux.ibm.com, paulus@ozlabs.org, casey@schaufler-ca.com,
        lucien.xin@gmail.com, davem@davemloft.net, tkjos@google.com,
        omosnace@redhat.com, daniel.thompson@linaro.org,
        mortonm@chromium.org, brauner@kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 08/10] powerpc/rtas: block error injection when locked down
Date:   Fri, 14 Oct 2022 09:52:19 -0400
Message-Id: <20221014135222.2109334-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221014135222.2109334-1-sashal@kernel.org>
References: <20221014135222.2109334-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit b8f3e48834fe8c86b4f21739c6effd160e2c2c19 ]

The error injection facility on pseries VMs allows corruption of
arbitrary guest memory, potentially enabling a sufficiently privileged
user to disable lockdown or perform other modifications of the running
kernel via the rtas syscall.

Block the PAPR error injection facility from being opened or called
when locked down.

Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Acked-by: Paul Moore <paul@paul-moore.com> (LSM)
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220926131643.146502-3-nathanl@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/rtas.c | 25 ++++++++++++++++++++++++-
 include/linux/security.h   |  1 +
 security/security.c        |  1 +
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 693133972294..c2540d393f1c 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -23,6 +23,7 @@
 #include <linux/memblock.h>
 #include <linux/slab.h>
 #include <linux/reboot.h>
+#include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/of.h>
 #include <linux/of_fdt.h>
@@ -464,6 +465,9 @@ void rtas_call_unlocked(struct rtas_args *args, int token, int nargs, int nret,
 	va_end(list);
 }
 
+static int ibm_open_errinjct_token;
+static int ibm_errinjct_token;
+
 int rtas_call(int token, int nargs, int nret, int *outputs, ...)
 {
 	va_list list;
@@ -476,6 +480,16 @@ int rtas_call(int token, int nargs, int nret, int *outputs, ...)
 	if (!rtas.entry || token == RTAS_UNKNOWN_SERVICE)
 		return -1;
 
+	if (token == ibm_open_errinjct_token || token == ibm_errinjct_token) {
+		/*
+		 * It would be nicer to not discard the error value
+		 * from security_locked_down(), but callers expect an
+		 * RTAS status, not an errno.
+		 */
+		if (security_locked_down(LOCKDOWN_RTAS_ERROR_INJECTION))
+			return -1;
+	}
+
 	if ((mfmsr() & (MSR_IR|MSR_DR)) != (MSR_IR|MSR_DR)) {
 		WARN_ON_ONCE(1);
 		return -1;
@@ -1227,6 +1241,14 @@ SYSCALL_DEFINE1(rtas, struct rtas_args __user *, uargs)
 	if (block_rtas_call(token, nargs, &args))
 		return -EINVAL;
 
+	if (token == ibm_open_errinjct_token || token == ibm_errinjct_token) {
+		int err;
+
+		err = security_locked_down(LOCKDOWN_RTAS_ERROR_INJECTION);
+		if (err)
+			return err;
+	}
+
 	/* Need to handle ibm,suspend_me call specially */
 	if (token == rtas_token("ibm,suspend-me")) {
 
@@ -1325,7 +1347,8 @@ void __init rtas_initialize(void)
 #ifdef CONFIG_RTAS_ERROR_LOGGING
 	rtas_last_error_token = rtas_token("rtas-last-error");
 #endif
-
+	ibm_open_errinjct_token = rtas_token("ibm,open-errinjct");
+	ibm_errinjct_token = rtas_token("ibm,errinjct");
 	rtas_syscall_filter_init();
 }
 
diff --git a/include/linux/security.h b/include/linux/security.h
index 3cc127bb5bfd..9b0ec28e96bf 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -122,6 +122,7 @@ enum lockdown_reason {
 	LOCKDOWN_XMON_WR,
 	LOCKDOWN_BPF_WRITE_USER,
 	LOCKDOWN_DBG_WRITE_KERNEL,
+	LOCKDOWN_RTAS_ERROR_INJECTION,
 	LOCKDOWN_INTEGRITY_MAX,
 	LOCKDOWN_KCORE,
 	LOCKDOWN_KPROBES,
diff --git a/security/security.c b/security/security.c
index 8b62654ff3f9..48a5d07d0ffc 100644
--- a/security/security.c
+++ b/security/security.c
@@ -60,6 +60,7 @@ const char *const lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
 	[LOCKDOWN_XMON_WR] = "xmon write access",
 	[LOCKDOWN_BPF_WRITE_USER] = "use of bpf to write user RAM",
 	[LOCKDOWN_DBG_WRITE_KERNEL] = "use of kgdb/kdb to write kernel RAM",
+	[LOCKDOWN_RTAS_ERROR_INJECTION] = "RTAS error injection",
 	[LOCKDOWN_INTEGRITY_MAX] = "integrity",
 	[LOCKDOWN_KCORE] = "/proc/kcore access",
 	[LOCKDOWN_KPROBES] = "use of kprobes",
-- 
2.35.1

