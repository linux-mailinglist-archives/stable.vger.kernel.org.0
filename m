Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 053C130AAC0
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 16:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhBAPOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 10:14:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbhBAPOU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 10:14:20 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7ABC06178A
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 07:13:39 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id i9so13511400wmq.1
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 07:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iXZwRIns2is4X1nRY0skb3yDaf3QquMnywmX7WSfZSk=;
        b=x22wUzCMVwDMyDfsMBLNuyiHE8hITKH7qezvMs8a9lM9BHIC2xz3YpA+26fN3vTiLL
         dCmCKmayTkBpiTpg/43H7jg/hAdWzoONYBEKr73tIbbR6JY7+pf8Pa+EhvtnQGoZ132T
         eq+YJz+whCohqI01knRb89dXRFcN4Sf6sfH1819d3Plm3WkevCX+x22O2DrF7KdeikfY
         aFyI7VRWBun8oqC6Np4vjg/WcngLmP5ybjCBHWkOyT+s8LrA+04LAzn5Vusxe8weZrLG
         9+ptxjqmOlovuGomtWN1H+J34/pXQMDMLiG/yUXeE/VoaS2HQsXuCGplwrVkcW3i3nw2
         V7fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iXZwRIns2is4X1nRY0skb3yDaf3QquMnywmX7WSfZSk=;
        b=GQyYHjhRZ6zEQ8nwbUJapDSyVbpc2OAZfducYDPMjC27jtteKLU7Hm+3/pqOEYJaTN
         m0ZrkqgiRViq59hUZkKyUC0bt/mhO7KcdnxSSCdPfyXPJ6Yurzn1hur9fR6RuomMbWBR
         lcGI+ZTxCzBWtnIhLnKUw+oLJkzSUo4IO92TfkkeVMsKqK94A7mL+3fzB/msnFrE6aYo
         Y6SVBdPtNcWZCgM+mnm58ylv3ndff3RvkeCKNMQwADXRd2LF99y9H9JaH9ecySy0rx06
         a8MylhtXXAWcftvaLgGgtIEYoLhL5kL4A1pcDgtTN3nE2z+5v/B1m8ssQvpKlhecH5t4
         TUSA==
X-Gm-Message-State: AOAM532u0a+gmz0h5FYf6lZ+S81WRaQ7os/2i15cW6qCeVSMpYCjJWRe
        XT419+U7+nOJ0EjFI3p4gxWC1oxKmAXCA0gZ
X-Google-Smtp-Source: ABdhPJxNTfOBpAIbkkho4PoZGn+ZKTz0lvnt/W+2z5TRMw3klsLdfHizbl4feFIhnS3Qelusdq0XCw==
X-Received: by 2002:a05:600c:4ed3:: with SMTP id g19mr15071996wmq.95.1612192417907;
        Mon, 01 Feb 2021 07:13:37 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id 192sm23323381wme.27.2021.02.01.07.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 07:13:37 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 04/12] exit/exec: Seperate mm_release()
Date:   Mon,  1 Feb 2021 15:12:06 +0000
Message-Id: <20210201151214.2193508-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201151214.2193508-1-lee.jones@linaro.org>
References: <20210201151214.2193508-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 4610ba7ad877fafc0a25a30c6c82015304120426 upstream.

mm_release() contains the futex exit handling. mm_release() is called from
do_exit()->exit_mm() and from exec()->exec_mm().

In the exit_mm() case PF_EXITING and the futex state is updated. In the
exec_mm() case these states are not touched.

As the futex exit code needs further protections against exit races, this
needs to be split into two functions.

Preparatory only, no functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20191106224556.240518241@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 fs/exec.c             |  2 +-
 include/linux/sched.h |  6 ++++--
 kernel/exit.c         |  2 +-
 kernel/fork.c         | 12 +++++++++++-
 4 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 46cc0c072246d..ce111af5784be 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -875,7 +875,7 @@ static int exec_mmap(struct mm_struct *mm)
 	/* Notify parent that we're no longer interested in the old VM */
 	tsk = current;
 	old_mm = current->mm;
-	mm_release(tsk, old_mm);
+	exec_mm_release(tsk, old_mm);
 
 	if (old_mm) {
 		sync_mm_rss(old_mm);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index bdd41a0127d10..aba34bba5e9e3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2647,8 +2647,10 @@ extern struct mm_struct *get_task_mm(struct task_struct *task);
  * succeeds.
  */
 extern struct mm_struct *mm_access(struct task_struct *task, unsigned int mode);
-/* Remove the current tasks stale references to the old mm_struct */
-extern void mm_release(struct task_struct *, struct mm_struct *);
+/* Remove the current tasks stale references to the old mm_struct on exit() */
+extern void exit_mm_release(struct task_struct *, struct mm_struct *);
+/* Remove the current tasks stale references to the old mm_struct on exec() */
+extern void exec_mm_release(struct task_struct *, struct mm_struct *);
 
 #ifdef CONFIG_HAVE_COPY_THREAD_TLS
 extern int copy_thread_tls(unsigned long, unsigned long, unsigned long,
diff --git a/kernel/exit.c b/kernel/exit.c
index 274a3c3834a15..a098d76a9877e 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -389,7 +389,7 @@ static void exit_mm(struct task_struct *tsk)
 	struct mm_struct *mm = tsk->mm;
 	struct core_state *core_state;
 
-	mm_release(tsk, mm);
+	exit_mm_release(tsk, mm);
 	if (!mm)
 		return;
 	sync_mm_rss(mm);
diff --git a/kernel/fork.c b/kernel/fork.c
index d0ab6aff5efdc..43a50072dd5b4 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -887,7 +887,7 @@ static int wait_for_vfork_done(struct task_struct *child,
  * restoring the old one. . .
  * Eric Biederman 10 January 1998
  */
-void mm_release(struct task_struct *tsk, struct mm_struct *mm)
+static void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 {
 	/* Get rid of any futexes when releasing the mm */
 	futex_mm_release(tsk);
@@ -924,6 +924,16 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 		complete_vfork_done(tsk);
 }
 
+void exit_mm_release(struct task_struct *tsk, struct mm_struct *mm)
+{
+	mm_release(tsk, mm);
+}
+
+void exec_mm_release(struct task_struct *tsk, struct mm_struct *mm)
+{
+	mm_release(tsk, mm);
+}
+
 /*
  * Allocate a new mm structure and copy contents from the
  * mm structure of the passed in task structure.
-- 
2.25.1

