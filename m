Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B18512E94B
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 18:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgABRYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 12:24:22 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43456 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgABRYU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 12:24:20 -0500
Received: by mail-wr1-f67.google.com with SMTP id d16so39945812wre.10;
        Thu, 02 Jan 2020 09:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wNOM5YVf4Ad6YkKqspKwGYhIR/Pz9al6tY5IJ5pfrD0=;
        b=SwCZtPUy7OtzJgJcz1GAVpSUiK2Wku5rYGazNe18hkD4mO3uO37I3VyKCT3uxlHNGQ
         qdExGA/rdyWzZuoQP3xspFWs9ZU2TgiZWUHHojawnIyZPLN7pBWOc+UauRYSVJ7d080c
         ZB+lQ/cSGWPV9wTJDCCg31/w6f02/DWXGF6NlKCGyyLILak+d+AWig7jZvvxj6QFQwkI
         g5gJe/SlzOoKR7nVtsuLhpbeWfFd5+bL/16aiF2HkPcAhvVGyPkW5e8Z94ZbTuJgogIW
         /8770zeWkHXy9I9tENFedyoDEyP6G9mGJgGonax3W7gJ+I1nK8u4GygsoM0A55D8mHKk
         C1eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wNOM5YVf4Ad6YkKqspKwGYhIR/Pz9al6tY5IJ5pfrD0=;
        b=EMrVwIt2GxRn74ILAYDbuyX3EMZxOI4FbhlkWUeurpyWITrRN63FgJBJSQ++aqYiYp
         psvsarkabCTHqb+XdfyPukzViMZwy409drbarKBLgAjy/VaxVl5G0WzrmWSvSwGt1vd4
         ibmPbu6jgMu4xltf85PShufhVwQ3XWMAZXLYC8NqNtNapRdUmtNAlbXRe8+RQML7mnA7
         +KWLc7KVCgIMzV3aevQc8qhyUijCzyvGBGMTbFZ6GtGHvgQS0wQDabkZzO+Putnpmtut
         tmob7BaHrRBCqVUv50wPCA5YDMk+YdH4/Qk1dmlH0ODRbOV0Iw3nfKoY0kgW9yW7Ur/G
         q70A==
X-Gm-Message-State: APjAAAWYI6OSUBwOXK6V1izrlPm9PowxXTonO6zVJFx5wZTgWKBtvNOf
        8dz7lSDuj/bUrmShZ5d22AZ3IP5vCb8Zh64n
X-Google-Smtp-Source: APXvYqzgd13vw55RXc1eoKXj4u9D5u6lDd1qVd/FLD5j6iUamc1uycDFuWu9VEWu7ed++1noj0mNVQ==
X-Received: by 2002:adf:f091:: with SMTP id n17mr85594064wro.387.1577985858946;
        Thu, 02 Jan 2020 09:24:18 -0800 (PST)
Received: from amanieu-laptop.home ([2a01:cb19:8051:6200:3fe7:84:7f3:e713])
        by smtp.gmail.com with ESMTPSA id z21sm9480328wml.5.2020.01.02.09.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 09:24:18 -0800 (PST)
From:   Amanieu d'Antras <amanieu@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Christian Brauner <christian@brauner.io>, stable@vger.kernel.org,
        Amanieu d'Antras <amanieu@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/7] arm: Implement copy_thread_tls
Date:   Thu,  2 Jan 2020 18:24:09 +0100
Message-Id: <20200102172413.654385-4-amanieu@gmail.com>
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
Cc: linux-arm-kernel@lists.infradead.org
Cc: <stable@vger.kernel.org> # 5.3.x
---
 arch/arm/Kconfig          | 1 +
 arch/arm/kernel/process.c | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ba75e3661a41..96dab76da3b3 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -72,6 +72,7 @@ config ARM
 	select HAVE_ARM_SMCCC if CPU_V7
 	select HAVE_EBPF_JIT if !CPU_ENDIAN_BE32
 	select HAVE_CONTEXT_TRACKING
+	select HAVE_COPY_THREAD_TLS
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DMA_CONTIGUOUS if MMU
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index cea1c27c29cb..46e478fb5ea2 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -226,8 +226,8 @@ void release_thread(struct task_struct *dead_task)
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
 int
-copy_thread(unsigned long clone_flags, unsigned long stack_start,
-	    unsigned long stk_sz, struct task_struct *p)
+copy_thread_tls(unsigned long clone_flags, unsigned long stack_start,
+	    unsigned long stk_sz, struct task_struct *p, unsigned long tls)
 {
 	struct thread_info *thread = task_thread_info(p);
 	struct pt_regs *childregs = task_pt_regs(p);
@@ -261,7 +261,7 @@ copy_thread(unsigned long clone_flags, unsigned long stack_start,
 	clear_ptrace_hw_breakpoint(p);
 
 	if (clone_flags & CLONE_SETTLS)
-		thread->tp_value[0] = childregs->ARM_r3;
+		thread->tp_value[0] = tls;
 	thread->tp_value[1] = get_tpuser();
 
 	thread_notify(THREAD_NOTIFY_COPY, thread);
-- 
2.24.1

