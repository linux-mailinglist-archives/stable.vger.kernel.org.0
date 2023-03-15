Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B60A6BB1C5
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbjCOMaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232369AbjCOMaP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:30:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D98C968E5
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:29:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D49361CC2
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712D0C433D2;
        Wed, 15 Mar 2023 12:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883350;
        bh=fnWKLIfO0bGuYOsKFlRWkyrt4+UMiNZ/xDiTBmnb34A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dCFVruYnpMG7LtzpWVHQk9hvYi+TbMW1pdLz4fN8Nb04IBXx3FoV39qCmSSrdQJQO
         0AraonmZPJXzgcI9IjY6wvdpmGSxQSi2EZoP3fg84mseItMdTGSuGGeLPGEwo1mykr
         9t9eLb1DX5agh2FoC6zAhpivqba6hemE2cWx0FoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/145] s390/ftrace: remove dead code
Date:   Wed, 15 Mar 2023 13:12:26 +0100
Message-Id: <20230315115741.638617453@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit b860b9346e2d5667fbae2cefc571bdb6ce665b53 ]

ftrace_shared_hotpatch_trampoline() never returns NULL,
therefore quite a bit of code can be removed.

Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Stable-dep-of: 2a8db5ec4a28 ("RISC-V: Don't check text_mutex during stop_machine")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/ftrace.c | 86 +++------------------------------------
 1 file changed, 6 insertions(+), 80 deletions(-)

diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
index 1d94ffdf347bb..5d0c45c13b5fa 100644
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -80,17 +80,6 @@ asm(
 
 #ifdef CONFIG_MODULES
 static char *ftrace_plt;
-
-asm(
-	"	.data\n"
-	"ftrace_plt_template:\n"
-	"	basr	%r1,%r0\n"
-	"	lg	%r1,0f-.(%r1)\n"
-	"	br	%r1\n"
-	"0:	.quad	ftrace_caller\n"
-	"ftrace_plt_template_end:\n"
-	"	.previous\n"
-);
 #endif /* CONFIG_MODULES */
 
 static const char *ftrace_shared_hotpatch_trampoline(const char **end)
@@ -116,7 +105,7 @@ static const char *ftrace_shared_hotpatch_trampoline(const char **end)
 
 bool ftrace_need_init_nop(void)
 {
-	return ftrace_shared_hotpatch_trampoline(NULL);
+	return true;
 }
 
 int ftrace_init_nop(struct module *mod, struct dyn_ftrace *rec)
@@ -175,28 +164,6 @@ int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_addr,
 	return 0;
 }
 
-static void ftrace_generate_nop_insn(struct ftrace_insn *insn)
-{
-	/* brcl 0,0 */
-	insn->opc = 0xc004;
-	insn->disp = 0;
-}
-
-static void ftrace_generate_call_insn(struct ftrace_insn *insn,
-				      unsigned long ip)
-{
-	unsigned long target;
-
-	/* brasl r0,ftrace_caller */
-	target = FTRACE_ADDR;
-#ifdef CONFIG_MODULES
-	if (is_module_addr((void *)ip))
-		target = (unsigned long)ftrace_plt;
-#endif /* CONFIG_MODULES */
-	insn->opc = 0xc005;
-	insn->disp = (target - ip) / 2;
-}
-
 static void brcl_disable(void *brcl)
 {
 	u8 op = 0x04; /* set mask field to zero */
@@ -207,23 +174,7 @@ static void brcl_disable(void *brcl)
 int ftrace_make_nop(struct module *mod, struct dyn_ftrace *rec,
 		    unsigned long addr)
 {
-	struct ftrace_insn orig, new, old;
-
-	if (ftrace_shared_hotpatch_trampoline(NULL)) {
-		brcl_disable((void *)rec->ip);
-		return 0;
-	}
-
-	if (copy_from_kernel_nofault(&old, (void *) rec->ip, sizeof(old)))
-		return -EFAULT;
-	/* Replace ftrace call with a nop. */
-	ftrace_generate_call_insn(&orig, rec->ip);
-	ftrace_generate_nop_insn(&new);
-
-	/* Verify that the to be replaced code matches what we expect. */
-	if (memcmp(&orig, &old, sizeof(old)))
-		return -EINVAL;
-	s390_kernel_write((void *) rec->ip, &new, sizeof(new));
+	brcl_disable((void *)rec->ip);
 	return 0;
 }
 
@@ -236,23 +187,7 @@ static void brcl_enable(void *brcl)
 
 int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 {
-	struct ftrace_insn orig, new, old;
-
-	if (ftrace_shared_hotpatch_trampoline(NULL)) {
-		brcl_enable((void *)rec->ip);
-		return 0;
-	}
-
-	if (copy_from_kernel_nofault(&old, (void *) rec->ip, sizeof(old)))
-		return -EFAULT;
-	/* Replace nop with an ftrace call. */
-	ftrace_generate_nop_insn(&orig);
-	ftrace_generate_call_insn(&new, rec->ip);
-
-	/* Verify that the to be replaced code matches what we expect. */
-	if (memcmp(&orig, &old, sizeof(old)))
-		return -EINVAL;
-	s390_kernel_write((void *) rec->ip, &new, sizeof(new));
+	brcl_enable((void *)rec->ip);
 	return 0;
 }
 
@@ -269,10 +204,7 @@ int __init ftrace_dyn_arch_init(void)
 
 void arch_ftrace_update_code(int command)
 {
-	if (ftrace_shared_hotpatch_trampoline(NULL))
-		ftrace_modify_all_code(command);
-	else
-		ftrace_run_stop_machine(command);
+	ftrace_modify_all_code(command);
 }
 
 static void __ftrace_sync(void *dummy)
@@ -281,10 +213,8 @@ static void __ftrace_sync(void *dummy)
 
 int ftrace_arch_code_modify_post_process(void)
 {
-	if (ftrace_shared_hotpatch_trampoline(NULL)) {
-		/* Send SIGP to the other CPUs, so they see the new code. */
-		smp_call_function(__ftrace_sync, NULL, 1);
-	}
+	/* Send SIGP to the other CPUs, so they see the new code. */
+	smp_call_function(__ftrace_sync, NULL, 1);
 	return 0;
 }
 
@@ -299,10 +229,6 @@ static int __init ftrace_plt_init(void)
 		panic("cannot allocate ftrace plt\n");
 
 	start = ftrace_shared_hotpatch_trampoline(&end);
-	if (!start) {
-		start = ftrace_plt_template;
-		end = ftrace_plt_template_end;
-	}
 	memcpy(ftrace_plt, start, end - start);
 	set_memory_ro((unsigned long)ftrace_plt, 1);
 	return 0;
-- 
2.39.2



