Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9034BDDFD
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346217AbiBUJEc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:04:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346895AbiBUJDi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:03:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5B72DA85;
        Mon, 21 Feb 2022 00:58:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6623461206;
        Mon, 21 Feb 2022 08:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAE6C340E9;
        Mon, 21 Feb 2022 08:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433898;
        bh=OOrcJLBMRnTKw4MRosAxas59uUfWSypDD+WFBvZegyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=diDoW3abBYu4M6Ds/jscgADtme5qcfrk+JHozIIefvJ70i8lNex9RRLYWTC7JhAPn
         NEr8csxVi02KGmAvEUPoicwTewHdm2mA3eqoUoAXkbPD3mvYJhWJYjoiSPBf6TlQ3Q
         InVIKpRhGWmK0DFxaWgTU0aE8iSpnF7nNV/tvxDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Miroslav Benes <mbenes@suse.cz>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Torsten Duwe <duwe@suse.de>,
        Sven Schnelle <svens@stackframe.org>,
        Ingo Molnar <mingo@redhat.com>,
        Stephen Boyd <swboyd@chromium.org>
Subject: [PATCH 5.4 23/80] ftrace: add ftrace_init_nop()
Date:   Mon, 21 Feb 2022 09:49:03 +0100
Message-Id: <20220221084916.342830178@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084915.554151737@linuxfoundation.org>
References: <20220221084915.554151737@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Mark Rutland <mark.rutland@arm.com>

commit fbf6c73c5b264c25484fa9f449b5546569fe11f0 upstream.

Architectures may need to perform special initialization of ftrace
callsites, and today they do so by special-casing ftrace_make_nop() when
the expected branch address is MCOUNT_ADDR. In some cases (e.g. for
patchable-function-entry), we don't have an mcount-like symbol and don't
want a synthetic MCOUNT_ADDR, but we may need to perform some
initialization of callsites.

To make it possible to separate initialization from runtime
modification, and to handle cases without an mcount-like symbol, this
patch adds an optional ftrace_init_nop() function that architectures can
implement, which does not pass a branch address.

Where an architecture does not provide ftrace_init_nop(), we will fall
back to the existing behaviour of calling ftrace_make_nop() with
MCOUNT_ADDR.

At the same time, ftrace_code_disable() is renamed to
ftrace_nop_initialize() to make it clearer that it is intended to
intialize a callsite into a disabled state, and is not for disabling a
callsite that has been runtime enabled. The kerneldoc description of rec
arguments is updated to cover non-mcount callsites.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Reviewed-by: Torsten Duwe <duwe@suse.de>
Tested-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Tested-by: Sven Schnelle <svens@stackframe.org>
Tested-by: Torsten Duwe <duwe@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ftrace.h |   35 ++++++++++++++++++++++++++++++++---
 kernel/trace/ftrace.c  |    6 +++---
 2 files changed, 35 insertions(+), 6 deletions(-)

--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -499,7 +499,7 @@ static inline int ftrace_disable_ftrace_
 /**
  * ftrace_make_nop - convert code into nop
  * @mod: module structure if called by module load initialization
- * @rec: the mcount call site record
+ * @rec: the call site record (e.g. mcount/fentry)
  * @addr: the address that the call site should be calling
  *
  * This is a very sensitive operation and great care needs
@@ -520,9 +520,38 @@ static inline int ftrace_disable_ftrace_
 extern int ftrace_make_nop(struct module *mod,
 			   struct dyn_ftrace *rec, unsigned long addr);
 
+
+/**
+ * ftrace_init_nop - initialize a nop call site
+ * @mod: module structure if called by module load initialization
+ * @rec: the call site record (e.g. mcount/fentry)
+ *
+ * This is a very sensitive operation and great care needs
+ * to be taken by the arch.  The operation should carefully
+ * read the location, check to see if what is read is indeed
+ * what we expect it to be, and then on success of the compare,
+ * it should write to the location.
+ *
+ * The code segment at @rec->ip should contain the contents created by
+ * the compiler
+ *
+ * Return must be:
+ *  0 on success
+ *  -EFAULT on error reading the location
+ *  -EINVAL on a failed compare of the contents
+ *  -EPERM  on error writing to the location
+ * Any other value will be considered a failure.
+ */
+#ifndef ftrace_init_nop
+static inline int ftrace_init_nop(struct module *mod, struct dyn_ftrace *rec)
+{
+	return ftrace_make_nop(mod, rec, MCOUNT_ADDR);
+}
+#endif
+
 /**
  * ftrace_make_call - convert a nop call site into a call to addr
- * @rec: the mcount call site record
+ * @rec: the call site record (e.g. mcount/fentry)
  * @addr: the address that the call site should call
  *
  * This is a very sensitive operation and great care needs
@@ -545,7 +574,7 @@ extern int ftrace_make_call(struct dyn_f
 #ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
 /**
  * ftrace_modify_call - convert from one addr to another (no nop)
- * @rec: the mcount call site record
+ * @rec: the call site record (e.g. mcount/fentry)
  * @old_addr: the address expected to be currently called to
  * @addr: the address to change to
  *
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2520,14 +2520,14 @@ struct dyn_ftrace *ftrace_rec_iter_recor
 }
 
 static int
-ftrace_code_disable(struct module *mod, struct dyn_ftrace *rec)
+ftrace_nop_initialize(struct module *mod, struct dyn_ftrace *rec)
 {
 	int ret;
 
 	if (unlikely(ftrace_disabled))
 		return 0;
 
-	ret = ftrace_make_nop(mod, rec, MCOUNT_ADDR);
+	ret = ftrace_init_nop(mod, rec);
 	if (ret) {
 		ftrace_bug_type = FTRACE_BUG_INIT;
 		ftrace_bug(ret, rec);
@@ -2969,7 +2969,7 @@ static int ftrace_update_code(struct mod
 			 * to the NOP instructions.
 			 */
 			if (!__is_defined(CC_USING_NOP_MCOUNT) &&
-			    !ftrace_code_disable(mod, p))
+			    !ftrace_nop_initialize(mod, p))
 				break;
 
 			update_cnt++;


