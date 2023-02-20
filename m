Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D21AC69CC88
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbjBTNl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:41:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbjBTNlT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:41:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60541D912
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:41:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74276B80D49
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:41:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56FDC433D2;
        Mon, 20 Feb 2023 13:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900461;
        bh=KjnvU8TV+16xhI/CzbkkNmq7hVZIVDs1eAO4WcqRjK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IMHjHHwPE136leH6e2Cp39GyPEaFLGMzg+k7Im3AkZbw9o+n5J7oUyIR+LuzmGpjw
         7uyHlx7ekl8j24u3ByKsGGAZNeuIJECKDDwK+uRnkx0mE7Z719aHFYYfwXYafxfW27
         H74b7064qZlvpkk37fh57pPVcGu4iKwnG3iRWo0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Helge Deller <deller@gmx.de>
Subject: [PATCH 4.19 34/89] parisc: Wire up PTRACE_GETREGS/PTRACE_SETREGS for compat case
Date:   Mon, 20 Feb 2023 14:35:33 +0100
Message-Id: <20230220133554.349444544@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 316f1f42b5cc1d95124c1f0387c867c1ba7b6d0e upstream.

Wire up the missing ptrace requests PTRACE_GETREGS, PTRACE_SETREGS,
PTRACE_GETFPREGS and PTRACE_SETFPREGS when running 32-bit applications
on 64-bit kernels.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # 4.7+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/ptrace.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/arch/parisc/kernel/ptrace.c
+++ b/arch/parisc/kernel/ptrace.c
@@ -128,6 +128,12 @@ long arch_ptrace(struct task_struct *chi
 	unsigned long tmp;
 	long ret = -EIO;
 
+	unsigned long user_regs_struct_size = sizeof(struct user_regs_struct);
+#ifdef CONFIG_64BIT
+	if (is_compat_task())
+		user_regs_struct_size /= 2;
+#endif
+
 	switch (request) {
 
 	/* Read the word at location addr in the USER area.  For ptraced
@@ -183,14 +189,14 @@ long arch_ptrace(struct task_struct *chi
 		return copy_regset_to_user(child,
 					   task_user_regset_view(current),
 					   REGSET_GENERAL,
-					   0, sizeof(struct user_regs_struct),
+					   0, user_regs_struct_size,
 					   datap);
 
 	case PTRACE_SETREGS:	/* Set all gp regs in the child. */
 		return copy_regset_from_user(child,
 					     task_user_regset_view(current),
 					     REGSET_GENERAL,
-					     0, sizeof(struct user_regs_struct),
+					     0, user_regs_struct_size,
 					     datap);
 
 	case PTRACE_GETFPREGS:	/* Get the child FPU state. */
@@ -304,6 +310,11 @@ long compat_arch_ptrace(struct task_stru
 			}
 		}
 		break;
+	case PTRACE_GETREGS:
+	case PTRACE_SETREGS:
+	case PTRACE_GETFPREGS:
+	case PTRACE_SETFPREGS:
+		return arch_ptrace(child, request, addr, data);
 
 	default:
 		ret = compat_ptrace_request(child, request, addr, data);


