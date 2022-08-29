Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFD85A440F
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 09:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiH2HnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 03:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiH2HnW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 03:43:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30BD4DB7F
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 00:43:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FA426113D
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 07:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C25C433D6;
        Mon, 29 Aug 2022 07:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661759000;
        bh=UjkZii2TbEk+HEbEVBz5prhXk+sE/rkQ1quFfFx3L30=;
        h=Subject:To:Cc:From:Date:From;
        b=naGWVKMK0dJYzPpl8wnLFNiu/YPgY5bwUQ5uVIyAk/iLkjYQTG1PuxrGmoE6FUnx+
         ciA8pJV3aLQKwZrANTggSkoDlliBwfjf1ZY36pXBCppNZbrYsCXqYHMSjAnzW8DIQu
         HyAzigvuhGPAYWge5kZnt+bIps+lTnK196qSoDic=
Subject: FAILED: patch "[PATCH] riscv: signal: fix missing prototype warning" failed to apply to 5.4-stable tree
To:     conor.dooley@microchip.com, palmer@rivosinc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Aug 2022 09:43:04 +0200
Message-ID: <1661758984246197@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b5c3aca86d2698c4850b6ee8b341938025d2780c Mon Sep 17 00:00:00 2001
From: Conor Dooley <conor.dooley@microchip.com>
Date: Sun, 14 Aug 2022 15:12:37 +0100
Subject: [PATCH] riscv: signal: fix missing prototype warning

Fix the warning:
arch/riscv/kernel/signal.c:316:27: warning: no previous prototype for function 'do_notify_resume' [-Wmissing-prototypes]
asmlinkage __visible void do_notify_resume(struct pt_regs *regs,

All other functions in the file are static & none of the existing
headers stood out as an obvious location. Create signal.h to hold the
declaration.

Fixes: e2c0cdfba7f6 ("RISC-V: User-facing API")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220814141237.493457-4-mail@conchuod.ie
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

diff --git a/arch/riscv/include/asm/signal.h b/arch/riscv/include/asm/signal.h
new file mode 100644
index 000000000000..532c29ef0376
--- /dev/null
+++ b/arch/riscv/include/asm/signal.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __ASM_SIGNAL_H
+#define __ASM_SIGNAL_H
+
+#include <uapi/asm/signal.h>
+#include <uapi/asm/ptrace.h>
+
+asmlinkage __visible
+void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags);
+
+#endif
diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index 38b05ca6fe66..5a2de6b6f882 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -15,6 +15,7 @@
 
 #include <asm/ucontext.h>
 #include <asm/vdso.h>
+#include <asm/signal.h>
 #include <asm/signal32.h>
 #include <asm/switch_to.h>
 #include <asm/csr.h>

