Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B89ED242D
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389858AbfJJItt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:49:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389854AbfJJItr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:49:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 396D12064A;
        Thu, 10 Oct 2019 08:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697386;
        bh=qT7Kvrkt0fJUpI1q/8NY3DMs5K2bhyu6Uhpan3ixSC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vJO0ZS7d0bPdmboqFofU6ETySijlhb1NgVP84v0yEHquQXeKtcHau0V/AiJaCEjks
         BYTwURObVOM/p8T+bEG9KY7LtXOuUEk6j1qXkbvO6O8HZA3FeVEWE2ELAf62ynos/5
         rXgpAbkasjrh7xCewr1Z3LDZq0kXZYYIXrhvMidM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 4.14 01/61] s390/process: avoid potential reading of freed stack
Date:   Thu, 10 Oct 2019 10:36:26 +0200
Message-Id: <20191010083450.038549745@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083449.500442342@linuxfoundation.org>
References: <20191010083449.500442342@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

commit 8769f610fe6d473e5e8e221709c3ac402037da6c upstream.

With THREAD_INFO_IN_TASK (which is selected on s390) task's stack usage
is refcounted and should always be protected by get/put when touching
other task's stack to avoid race conditions with task's destruction code.

Fixes: d5c352cdd022 ("s390: move thread_info into task_struct")
Cc: stable@vger.kernel.org # v4.10+
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/process.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -185,20 +185,30 @@ unsigned long get_wchan(struct task_stru
 
 	if (!p || p == current || p->state == TASK_RUNNING || !task_stack_page(p))
 		return 0;
+
+	if (!try_get_task_stack(p))
+		return 0;
+
 	low = task_stack_page(p);
 	high = (struct stack_frame *) task_pt_regs(p);
 	sf = (struct stack_frame *) p->thread.ksp;
-	if (sf <= low || sf > high)
-		return 0;
+	if (sf <= low || sf > high) {
+		return_address = 0;
+		goto out;
+	}
 	for (count = 0; count < 16; count++) {
 		sf = (struct stack_frame *) sf->back_chain;
-		if (sf <= low || sf > high)
-			return 0;
+		if (sf <= low || sf > high) {
+			return_address = 0;
+			goto out;
+		}
 		return_address = sf->gprs[8];
 		if (!in_sched_functions(return_address))
-			return return_address;
+			goto out;
 	}
-	return 0;
+out:
+	put_task_stack(p);
+	return return_address;
 }
 
 unsigned long arch_align_stack(unsigned long sp)


