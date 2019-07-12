Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A512066CC3
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfGLMXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:23:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727839AbfGLMXC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:23:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B616E21670;
        Fri, 12 Jul 2019 12:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934181;
        bh=jIGF3tGsUd16gUWn6GBhxSJaxsz9nGgZeR+K3j5UKXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jTqI2qMiYmi1LdotQD+nfmCq5vobwtwI+FKxWDJJIsAN7VhGUh/mcLisMBltB8gmn
         0ymuUuATPBCXvkqTzPO759RoegR0csv7ADvKrvWDG9r26Mdsfila7NK8zBF3qk2Px7
         Xux5wnRaLLeJLqBsNJ4dj+VslLVDvzwTGdKbHAGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dianzhang Chen <dianzhangchen0@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, bp@alien8.de,
        hpa@zytor.com
Subject: [PATCH 4.19 63/91] x86/ptrace: Fix possible spectre-v1 in ptrace_get_debugreg()
Date:   Fri, 12 Jul 2019 14:19:06 +0200
Message-Id: <20190712121625.214928205@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
References: <20190712121621.422224300@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dianzhang Chen <dianzhangchen0@gmail.com>

commit 31a2fbb390fee4231281b939e1979e810f945415 upstream.

The index to access the threads ptrace_bps is controlled by userspace via
syscall: sys_ptrace(), hence leading to a potential exploitation of the
Spectre variant 1 vulnerability.

The index can be controlled from:
    ptrace -> arch_ptrace -> ptrace_get_debugreg.

Fix this by sanitizing the user supplied index before using it access
thread->ptrace_bps.

Signed-off-by: Dianzhang Chen <dianzhangchen0@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: bp@alien8.de
Cc: hpa@zytor.com
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1561476617-3759-1-git-send-email-dianzhangchen0@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/ptrace.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -24,6 +24,7 @@
 #include <linux/rcupdate.h>
 #include <linux/export.h>
 #include <linux/context_tracking.h>
+#include <linux/nospec.h>
 
 #include <linux/uaccess.h>
 #include <asm/pgtable.h>
@@ -651,9 +652,11 @@ static unsigned long ptrace_get_debugreg
 {
 	struct thread_struct *thread = &tsk->thread;
 	unsigned long val = 0;
+	int index = n;
 
 	if (n < HBP_NUM) {
-		struct perf_event *bp = thread->ptrace_bps[n];
+		index = array_index_nospec(index, HBP_NUM);
+		struct perf_event *bp = thread->ptrace_bps[index];
 
 		if (bp)
 			val = bp->hw.info.address;


