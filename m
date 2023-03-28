Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBAF06CC456
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbjC1PDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233781AbjC1PDt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:03:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60C3EB5A
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:02:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90934B81D7B
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0BD4C433D2;
        Tue, 28 Mar 2023 15:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015738;
        bh=Rws4IoTyzMXKlSKdC9oln+/HmUZ+0VC8t40sNPeVbIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WU8AD96WlBWN4z0/vY/lHbCmXRTPCcXiAGwGiGGT8seONmO7OG70w0FAhKatbtfuu
         5OrzMgmqoyri/I798km5QlXzz/4DhV1Jz8QPwg6wVEp0pa0vt1Hnc2NWHA25UA+Be+
         GDOcjDIMYHedTCvJPDdnR3f0SZupx1Z4hbxZnYRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.1 158/224] selftests/x86/amx: Add a ptrace test
Date:   Tue, 28 Mar 2023 16:42:34 +0200
Message-Id: <20230328142623.963221842@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chang S. Bae <chang.seok.bae@intel.com>

commit 62faca1ca10cc84e99ae7f38aa28df2bc945369b upstream.

Include a test case to validate the XTILEDATA injection to the target.

Also, it ensures the kernel's ability to copy states between different
XSAVE formats.

Refactor the memcmp() code to be usable for the state validation.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20230227210504.18520-3-chang.seok.bae%40intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/x86/amx.c |  108 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 105 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/x86/amx.c
+++ b/tools/testing/selftests/x86/amx.c
@@ -14,8 +14,10 @@
 #include <sys/auxv.h>
 #include <sys/mman.h>
 #include <sys/shm.h>
+#include <sys/ptrace.h>
 #include <sys/syscall.h>
 #include <sys/wait.h>
+#include <sys/uio.h>
 
 #include "../kselftest.h" /* For __cpuid_count() */
 
@@ -583,6 +585,13 @@ static void test_dynamic_state(void)
 	_exit(0);
 }
 
+static inline int __compare_tiledata_state(struct xsave_buffer *xbuf1, struct xsave_buffer *xbuf2)
+{
+	return memcmp(&xbuf1->bytes[xtiledata.xbuf_offset],
+		      &xbuf2->bytes[xtiledata.xbuf_offset],
+		      xtiledata.size);
+}
+
 /*
  * Save current register state and compare it to @xbuf1.'
  *
@@ -599,9 +608,7 @@ static inline bool __validate_tiledata_r
 		fatal_error("failed to allocate XSAVE buffer\n");
 
 	xsave(xbuf2, XFEATURE_MASK_XTILEDATA);
-	ret = memcmp(&xbuf1->bytes[xtiledata.xbuf_offset],
-		     &xbuf2->bytes[xtiledata.xbuf_offset],
-		     xtiledata.size);
+	ret = __compare_tiledata_state(xbuf1, xbuf2);
 
 	free(xbuf2);
 
@@ -826,6 +833,99 @@ static void test_context_switch(void)
 	free(finfo);
 }
 
+/* Ptrace test */
+
+/*
+ * Make sure the ptracee has the expanded kernel buffer on the first
+ * use. Then, initialize the state before performing the state
+ * injection from the ptracer.
+ */
+static inline void ptracee_firstuse_tiledata(void)
+{
+	load_rand_tiledata(stashed_xsave);
+	init_xtiledata();
+}
+
+/*
+ * Ptracer injects the randomized tile data state. It also reads
+ * before and after that, which will execute the kernel's state copy
+ * functions. So, the tester is advised to double-check any emitted
+ * kernel messages.
+ */
+static void ptracer_inject_tiledata(pid_t target)
+{
+	struct xsave_buffer *xbuf;
+	struct iovec iov;
+
+	xbuf = alloc_xbuf();
+	if (!xbuf)
+		fatal_error("unable to allocate XSAVE buffer");
+
+	printf("\tRead the init'ed tiledata via ptrace().\n");
+
+	iov.iov_base = xbuf;
+	iov.iov_len = xbuf_size;
+
+	memset(stashed_xsave, 0, xbuf_size);
+
+	if (ptrace(PTRACE_GETREGSET, target, (uint32_t)NT_X86_XSTATE, &iov))
+		fatal_error("PTRACE_GETREGSET");
+
+	if (!__compare_tiledata_state(stashed_xsave, xbuf))
+		printf("[OK]\tThe init'ed tiledata was read from ptracee.\n");
+	else
+		printf("[FAIL]\tThe init'ed tiledata was not read from ptracee.\n");
+
+	printf("\tInject tiledata via ptrace().\n");
+
+	load_rand_tiledata(xbuf);
+
+	memcpy(&stashed_xsave->bytes[xtiledata.xbuf_offset],
+	       &xbuf->bytes[xtiledata.xbuf_offset],
+	       xtiledata.size);
+
+	if (ptrace(PTRACE_SETREGSET, target, (uint32_t)NT_X86_XSTATE, &iov))
+		fatal_error("PTRACE_SETREGSET");
+
+	if (ptrace(PTRACE_GETREGSET, target, (uint32_t)NT_X86_XSTATE, &iov))
+		fatal_error("PTRACE_GETREGSET");
+
+	if (!__compare_tiledata_state(stashed_xsave, xbuf))
+		printf("[OK]\tTiledata was correctly written to ptracee.\n");
+	else
+		printf("[FAIL]\tTiledata was not correctly written to ptracee.\n");
+}
+
+static void test_ptrace(void)
+{
+	pid_t child;
+	int status;
+
+	child = fork();
+	if (child < 0) {
+		err(1, "fork");
+	} else if (!child) {
+		if (ptrace(PTRACE_TRACEME, 0, NULL, NULL))
+			err(1, "PTRACE_TRACEME");
+
+		ptracee_firstuse_tiledata();
+
+		raise(SIGTRAP);
+		_exit(0);
+	}
+
+	do {
+		wait(&status);
+	} while (WSTOPSIG(status) != SIGTRAP);
+
+	ptracer_inject_tiledata(child);
+
+	ptrace(PTRACE_DETACH, child, NULL, NULL);
+	wait(&status);
+	if (!WIFEXITED(status) || WEXITSTATUS(status))
+		err(1, "ptrace test");
+}
+
 int main(void)
 {
 	/* Check hardware availability at first */
@@ -846,6 +946,8 @@ int main(void)
 	ctxtswtest_config.num_threads = 5;
 	test_context_switch();
 
+	test_ptrace();
+
 	clearhandler(SIGILL);
 	free_stashed_xsave();
 


