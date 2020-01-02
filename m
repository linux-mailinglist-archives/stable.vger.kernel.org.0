Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25FAC12E947
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 18:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgABRYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 12:24:34 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53364 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727859AbgABRYX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 12:24:23 -0500
Received: by mail-wm1-f65.google.com with SMTP id m24so6194626wmc.3;
        Thu, 02 Jan 2020 09:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nhEROhYvxQBpHG5tza2RMbb/t8HVyPfGN5knOZoumCE=;
        b=eknhSys+rc63QT2i9bwpakpxMChXuthSC86wntebhDjo69A4H0UfbC0yOzBpSL0mHx
         MzuY7eWJeovQ65PLjYUk+CDjXzlJ3ImpOBULYzHOhZsYriuhakcrf8SyuJBUFh6y/3Hq
         VWVwO/ATOi94iP5KoHKW2faAlxyArNiGP50VuGYBBtZTsmHx1sortGoCpsvBl6NZjYkf
         XX+z0vs0XF+9u/WL9yhTf6DG1T/MwTpu1jnkz2AQQofREbruYuzfaII/ZWrhJXPTWHgN
         2usCqVM/+wSjv6gB/LlC4HWHlX9zV9RjLTjeCzEoceTtOZRNmcBvIEKmrmXp1slsftIR
         3hZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nhEROhYvxQBpHG5tza2RMbb/t8HVyPfGN5knOZoumCE=;
        b=VxD4PKco2qQHwUhnfwZ83+lU0uKmsu0l4Xio3ZiDzoanvW2VM97hkp4b4tgUgJnmEz
         L5iUrlaJFRNX8faH5AAwDjafzIjuoREKfupLU/N+k1Xb2H4NSARVxnQ7HFlyLbzK76ls
         LJdw4X7Jki2Jv+daRtVy9J+fQMmNzW2qSprE98Pq8O5K+NiJHUWLSHLPP4bh88LGxD2o
         FJUk2hLnSe2UofOkTZSXq40R0J3K+9pmSLr6UgEk7+qjTZwHdNhR+wJlZPFuR9GALCZj
         iPDSB8quzn/UNJinkvKnC8vBAFAgT1/ikIR+XMR10NAdF6VLV7Uy1Yts91QwdJveNcuu
         MxAg==
X-Gm-Message-State: APjAAAWboMsWgBKK9Qh+6TfI/qDvmavqP6L23O0F0ip0om3hFl5L2+7m
        7zfl12Gr4BEoyw0C3caAFW/FbjPaZzjwuYPr
X-Google-Smtp-Source: APXvYqxLvMSwkkjy+lC/cVYbgrgkLkZ9PFS2hChYg9j0ye+fawiAzQzUVh+XFvNyZWFc136aIXGdLg==
X-Received: by 2002:a1c:ded6:: with SMTP id v205mr15076301wmg.86.1577985861294;
        Thu, 02 Jan 2020 09:24:21 -0800 (PST)
Received: from amanieu-laptop.home ([2a01:cb19:8051:6200:3fe7:84:7f3:e713])
        by smtp.gmail.com with ESMTPSA id z21sm9480328wml.5.2020.01.02.09.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 09:24:20 -0800 (PST)
From:   Amanieu d'Antras <amanieu@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Christian Brauner <christian@brauner.io>, stable@vger.kernel.org,
        Amanieu d'Antras <amanieu@gmail.com>,
        linux-xtensa@linux-xtensa.org
Subject: [PATCH 6/7] xtensa: Implement copy_thread_tls
Date:   Thu,  2 Jan 2020 18:24:12 +0100
Message-Id: <20200102172413.654385-7-amanieu@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102172413.654385-1-amanieu@gmail.com>
References: <20200102172413.654385-1-amanieu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is required for clone3 which passes the TLS value through a
struct rather than a register.

Signed-off-by: Amanieu d'Antras <amanieu@gmail.com>
Cc: linux-xtensa@linux-xtensa.org
Cc: <stable@vger.kernel.org> # 5.3.x
---
 arch/xtensa/Kconfig          | 1 +
 arch/xtensa/kernel/process.c | 8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 4a3fa295d8fe..296c5324dace 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -24,6 +24,7 @@ config XTENSA
 	select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL
 	select HAVE_ARCH_KASAN if MMU && !XIP_KERNEL
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_COPY_THREAD_TLS
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DMA_CONTIGUOUS
 	select HAVE_EXIT_THREAD
diff --git a/arch/xtensa/kernel/process.c b/arch/xtensa/kernel/process.c
index 9e1c49134c07..3edecc41ef8c 100644
--- a/arch/xtensa/kernel/process.c
+++ b/arch/xtensa/kernel/process.c
@@ -202,8 +202,9 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
  * involved.  Much simpler to just not copy those live frames across.
  */
 
-int copy_thread(unsigned long clone_flags, unsigned long usp_thread_fn,
-		unsigned long thread_fn_arg, struct task_struct *p)
+int copy_thread_tls(unsigned long clone_flags, unsigned long usp_thread_fn,
+		unsigned long thread_fn_arg, struct task_struct *p,
+		unsigned long tls)
 {
 	struct pt_regs *childregs = task_pt_regs(p);
 
@@ -266,9 +267,8 @@ int copy_thread(unsigned long clone_flags, unsigned long usp_thread_fn,
 
 		childregs->syscall = regs->syscall;
 
-		/* The thread pointer is passed in the '4th argument' (= a5) */
 		if (clone_flags & CLONE_SETTLS)
-			childregs->threadptr = childregs->areg[5];
+			childregs->threadptr = tls;
 	} else {
 		p->thread.ra = MAKE_RA_FOR_CALL(
 				(unsigned long)ret_from_kernel_thread, 1);
-- 
2.24.1

