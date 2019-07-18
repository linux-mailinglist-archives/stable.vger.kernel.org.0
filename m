Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9913E6C61A
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403979AbfGRDNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:13:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403824AbfGRDNV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:13:21 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60900205F4;
        Thu, 18 Jul 2019 03:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419600;
        bh=AGn91DRtvh32XfeBVb4etPzBDdqTZajQ4S3EW0nqT2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kkpy2Z37HnZi1vtEFuqFm6uP7bgtBh3gauCLCUFIyEoADfH4z+YHCrDUfxMlkTUFM
         mBVSAQ7w6+vNAMPD0+R3PNBwvKigG/EuHOiJ48ISETzIvfeFMVYC2iadTwQKLSdXzX
         eIXWmRJC7OxqI2nk4j6+JiEiwzyTPMqd+HFA+K1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dianzhang Chen <dianzhangchen0@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, bp@alien8.de,
        hpa@zytor.com
Subject: [PATCH 4.9 23/54] x86/ptrace: Fix possible spectre-v1 in ptrace_get_debugreg()
Date:   Thu, 18 Jul 2019 12:01:53 +0900
Message-Id: <20190718030051.167314534@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030048.392549994@linuxfoundation.org>
References: <20190718030048.392549994@linuxfoundation.org>
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
@@ -23,6 +23,7 @@
 #include <linux/rcupdate.h>
 #include <linux/export.h>
 #include <linux/context_tracking.h>
+#include <linux/nospec.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -650,9 +651,11 @@ static unsigned long ptrace_get_debugreg
 {
 	struct thread_struct *thread = &tsk->thread;
 	unsigned long val = 0;
+	int index = n;
 
 	if (n < HBP_NUM) {
-		struct perf_event *bp = thread->ptrace_bps[n];
+		struct perf_event *bp = thread->ptrace_bps[index];
+		index = array_index_nospec(index, HBP_NUM);
 
 		if (bp)
 			val = bp->hw.info.address;


