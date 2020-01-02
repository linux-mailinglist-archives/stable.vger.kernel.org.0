Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69F4E12E94F
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 18:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgABRYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 12:24:43 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33920 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727854AbgABRYV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 12:24:21 -0500
Received: by mail-wr1-f68.google.com with SMTP id t2so39963464wrr.1;
        Thu, 02 Jan 2020 09:24:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L1XTkfPnf+xygEwiEa8xupdElziS0T1yXcRh//IpEmk=;
        b=aTDKPpiCwVSTja4oES5GrKlvuc++gzMK0wRFPgM9RFp6FDFXnhIvqVR37S1wOloKgc
         8PHFWsZHUUHwNchW5ypD7FMh/aRveA56atk+VfNafRRwcVvHiOpTg5RMehfRqicVzeZi
         fgyWXfvccl7ZR6kNFLcInbO+IEPQiwOrEsFnyu2Lqc+kUv1Wyc7MEnLCoFmZ72dPRrHD
         QUW5sbxh60hYTgM3WAcJb7tk2gyqGqP1FUyc6uDPfLRlWZbCX+rjc5or/MW0e82ORdGp
         xkVnWXOyQaOQm60PpakJZI94qub7G9owf/iV0kfm0dW1A3NsIujTEEbx6iUYvr2vsruo
         A9qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L1XTkfPnf+xygEwiEa8xupdElziS0T1yXcRh//IpEmk=;
        b=PUdlRTn4gsudEDyYL3yss9lTpH68DQLIJpmgyaNNrt8hoDHl9Q/nKSto1tcB2tYioF
         oT88YexY9ckgfa6pEkUoH2Mu9vOQEw2Mh6nUkcaK6UbYds6rMTOHMF8RcSMqbjrGZ/2t
         kaEDr53GigcoUmO3SUH/JWdg55+0nge/W4mvAWV/BpDvMkZYtUYrSO1VpdrY53TQ0GA7
         6kUO+1nZTWEIF9ArRlkjr4I4r8pZAwYWa4wH5z09mrsHaRJAid5czTWHAE8WynFi0iV7
         5jeHUc/m71oXZh3pY7qMtLw3CN8PHA1kVlXTBQVNyDad4ZQ+QgU7NSYXXC84vtAKRZ4y
         SztA==
X-Gm-Message-State: APjAAAVJ4ZoREFter5Qnu5Y0APHDHCkYdw7OiL020BZBhUhwdsH4EkBH
        UJzqIEbXnMTZXhSjOYMcrF1Rc8VFhzaBepW8
X-Google-Smtp-Source: APXvYqzmOOKoMQKUxWUbitYsx3DhPyjVEL1vmWvRp3MkUNKIFndDIEsRrTuY+pZUkYhi78MTdV2b3A==
X-Received: by 2002:adf:ea88:: with SMTP id s8mr83518881wrm.293.1577985859767;
        Thu, 02 Jan 2020 09:24:19 -0800 (PST)
Received: from amanieu-laptop.home ([2a01:cb19:8051:6200:3fe7:84:7f3:e713])
        by smtp.gmail.com with ESMTPSA id z21sm9480328wml.5.2020.01.02.09.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 09:24:19 -0800 (PST)
From:   Amanieu d'Antras <amanieu@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Christian Brauner <christian@brauner.io>, stable@vger.kernel.org,
        Amanieu d'Antras <amanieu@gmail.com>,
        linux-parisc@vger.kernel.org
Subject: [PATCH 4/7] parisc: Implement copy_thread_tls
Date:   Thu,  2 Jan 2020 18:24:10 +0100
Message-Id: <20200102172413.654385-5-amanieu@gmail.com>
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
Cc: linux-parisc@vger.kernel.org
Cc: <stable@vger.kernel.org> # 5.3.x
---
 arch/parisc/Kconfig          | 1 +
 arch/parisc/kernel/process.c | 8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index b16237c95ea3..0c29d6cb2c8d 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -62,6 +62,7 @@ config PARISC
 	select HAVE_FTRACE_MCOUNT_RECORD if HAVE_DYNAMIC_FTRACE
 	select HAVE_KPROBES_ON_FTRACE
 	select HAVE_DYNAMIC_FTRACE_WITH_REGS
+	select HAVE_COPY_THREAD_TLS
 
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
index ecc5c2771208..230a6422b99f 100644
--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -208,8 +208,8 @@ arch_initcall(parisc_idle_init);
  * Copy architecture-specific thread state
  */
 int
-copy_thread(unsigned long clone_flags, unsigned long usp,
-	    unsigned long kthread_arg, struct task_struct *p)
+copy_thread_tls(unsigned long clone_flags, unsigned long usp,
+	    unsigned long kthread_arg, struct task_struct *p, unsigned long tls)
 {
 	struct pt_regs *cregs = &(p->thread.regs);
 	void *stack = task_stack_page(p);
@@ -254,9 +254,9 @@ copy_thread(unsigned long clone_flags, unsigned long usp,
 		cregs->ksp = (unsigned long)stack + THREAD_SZ_ALGN + FRAME_SIZE;
 		cregs->kpc = (unsigned long) &child_return;
 
-		/* Setup thread TLS area from the 4th parameter in clone */
+		/* Setup thread TLS area */
 		if (clone_flags & CLONE_SETTLS)
-			cregs->cr27 = cregs->gr[23];
+			cregs->cr27 = tls;
 	}
 
 	return 0;
-- 
2.24.1

