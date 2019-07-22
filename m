Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0CE46FDE5
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 12:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbfGVKeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 06:34:23 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46511 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729320AbfGVKeX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jul 2019 06:34:23 -0400
Received: by mail-wr1-f66.google.com with SMTP id z1so38816656wru.13
        for <stable@vger.kernel.org>; Mon, 22 Jul 2019 03:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VZW1cKPyWj5Ampz3rVCU6hlBuliW62S0PB3Tim7U+c8=;
        b=e5l/e85jj7H/RnfFyePLacpBWbPvKc3KcypI/aKy5+3/IqsWf47nkMowu9LPnU8+vP
         6BXZuamA2KbqtfuvEGgtT3XVrZsB/FMjE0qpCWvAsnuQXneEHwWl8TTXkbxuneUBSlj1
         eleABLShIcoYPxluBf4/jzlxHp6kDZprXjFlDCvcyvzA9tTezUrhQutzS5dhir0i0OiZ
         Wptj59d0tIsvv3WYamOnt5qZ0b8eRWlXPwNLaGSniqFapEM0+6ZCnlagcbXrcVuLcs1N
         3LGk83FVQqJ6eLbQ0Lr78DHI73DTukw96PI965Yh4ikNcV3wiqrjRtuEet/zPRThil1R
         VU/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VZW1cKPyWj5Ampz3rVCU6hlBuliW62S0PB3Tim7U+c8=;
        b=my7BpFRW9e+5DnQRnyoOu/3MkDa7a/6qiX7NB0+3Ax7tQjL2gtYVzMn76XcUyZSVW2
         dAYDYkBT0Rw3sWoid7xQKNOLP7WBwsJGHMgImdpSJF8Gdx81fGB0Dj0dQCOO3ViqqsUa
         3e6ZzZFpUyCAjek0ecPwyS0khRm8UpJD+bgkqTEox0dqV8Jy+KE8/IoTzFX3nOMUQyT8
         W6svPXQ8wgMKuGAyXjGfUGNJEtPuBr+hNatg9HmjcH3EsDzPGJRwJ2QXIOVg8UecWpOI
         vOzIobozEoQVUk+VtiHpJdLicLZ2rGou2pcfafrCfx3ml3pE+RQCny4Hwg9zYg3GbCk4
         9Z3Q==
X-Gm-Message-State: APjAAAXIEKPufGLJjUZ0V/dL+SJLvnwxHKwTQIGtfZjd+thmR/9q2yR4
        Qhsiudn72u3orICJjnInzGvC9+ZA
X-Google-Smtp-Source: APXvYqwsjyxEhAGoC5jhnLdP7SHG9piI1KfGNz5vzISBL/W48+mDDukr22j8iAitUcofsiv13m1GMQ==
X-Received: by 2002:adf:e947:: with SMTP id m7mr11978384wrn.123.1563791661070;
        Mon, 22 Jul 2019 03:34:21 -0700 (PDT)
Received: from balsini.lon.corp.google.com ([2a00:79e0:d:210:e751:37a0:1e95:e65d])
        by smtp.gmail.com with ESMTPSA id g25sm28217197wmk.39.2019.07.22.03.34.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 03:34:20 -0700 (PDT)
From:   Alessio Balsini <balsini@android.com>
To:     gregkh@linuxfoundation.org
Cc:     astrachan@google.com, maennich@google.com, kernel-team@android.com,
        stable@vger.kernel.org
Subject: [PATCH 4.9 1/2] um: Allow building and running on older hosts
Date:   Mon, 22 Jul 2019 11:33:37 +0100
Message-Id: <20190722103338.111753-1-balsini@android.com>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 0a987645672ebde7844a9c0732a5a25f3d4bb6c6 upstream.

Commit a78ff1112263 ("um: add extended processor state save/restore
support") and b6024b21fec8 ("um: extend fpstate to _xstate to support
YMM registers") forced the use of the x86 FP _xstate and
PTRACE_GETREGSET/SETREGSET. On older hosts, we would neither be able to
build UML nor run it anymore with these two commits applied because we
don't have definitions for struct _xstate nor these two ptrace requests.

We can determine at build time which fp context structure to check
against, just like we can keep using the old i387 fp save/restore if
PTRACE_GETRESET/SETREGSET are not defined.

Fixes: a78ff1112263 ("um: add extended processor state save/restore support")
Fixes: b6024b21fec8 ("um: extend fpstate to _xstate to support YMM registers")
Change-Id: I2cda034c8a6637de392c2740a993982ad132bda5
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Alessio Balsini <balsini@android.com>
---
 arch/x86/um/os-Linux/registers.c | 12 ++++++++----
 arch/x86/um/user-offsets.c       |  4 ++++
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/x86/um/os-Linux/registers.c b/arch/x86/um/os-Linux/registers.c
index 00f54a91bb4b..28775f55bde2 100644
--- a/arch/x86/um/os-Linux/registers.c
+++ b/arch/x86/um/os-Linux/registers.c
@@ -26,6 +26,7 @@ int save_i387_registers(int pid, unsigned long *fp_regs)
 
 int save_fp_registers(int pid, unsigned long *fp_regs)
 {
+#ifdef PTRACE_GETREGSET
 	struct iovec iov;
 
 	if (have_xstate_support) {
@@ -34,9 +35,9 @@ int save_fp_registers(int pid, unsigned long *fp_regs)
 		if (ptrace(PTRACE_GETREGSET, pid, NT_X86_XSTATE, &iov) < 0)
 			return -errno;
 		return 0;
-	} else {
+	} else
+#endif
 		return save_i387_registers(pid, fp_regs);
-	}
 }
 
 int restore_i387_registers(int pid, unsigned long *fp_regs)
@@ -48,6 +49,7 @@ int restore_i387_registers(int pid, unsigned long *fp_regs)
 
 int restore_fp_registers(int pid, unsigned long *fp_regs)
 {
+#ifdef PTRACE_SETREGSET
 	struct iovec iov;
 
 	if (have_xstate_support) {
@@ -56,9 +58,9 @@ int restore_fp_registers(int pid, unsigned long *fp_regs)
 		if (ptrace(PTRACE_SETREGSET, pid, NT_X86_XSTATE, &iov) < 0)
 			return -errno;
 		return 0;
-	} else {
+	} else
+#endif
 		return restore_i387_registers(pid, fp_regs);
-	}
 }
 
 #ifdef __i386__
@@ -122,6 +124,7 @@ int put_fp_registers(int pid, unsigned long *regs)
 
 void arch_init_registers(int pid)
 {
+#ifdef PTRACE_GETREGSET
 	struct _xstate fp_regs;
 	struct iovec iov;
 
@@ -129,6 +132,7 @@ void arch_init_registers(int pid)
 	iov.iov_len = sizeof(struct _xstate);
 	if (ptrace(PTRACE_GETREGSET, pid, NT_X86_XSTATE, &iov) == 0)
 		have_xstate_support = 1;
+#endif
 }
 #endif
 
diff --git a/arch/x86/um/user-offsets.c b/arch/x86/um/user-offsets.c
index cb3c22370cf5..8af0fb5d2780 100644
--- a/arch/x86/um/user-offsets.c
+++ b/arch/x86/um/user-offsets.c
@@ -50,7 +50,11 @@ void foo(void)
 	DEFINE(HOST_GS, GS);
 	DEFINE(HOST_ORIG_AX, ORIG_EAX);
 #else
+#if defined(PTRACE_GETREGSET) && defined(PTRACE_SETREGSET)
 	DEFINE(HOST_FP_SIZE, sizeof(struct _xstate) / sizeof(unsigned long));
+#else
+	DEFINE(HOST_FP_SIZE, sizeof(struct _fpstate) / sizeof(unsigned long));
+#endif
 	DEFINE_LONGS(HOST_BX, RBX);
 	DEFINE_LONGS(HOST_CX, RCX);
 	DEFINE_LONGS(HOST_DI, RDI);
-- 
2.22.0.657.g960e92d24f-goog

