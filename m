Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5BA24BBBF
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729637AbgHTMdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:33:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729627AbgHTJtL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:49:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8958320724;
        Thu, 20 Aug 2020 09:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916950;
        bh=BP2uJ9ktq3oZUfwxtBO2odfhgCbCxzcgJfknfPirCqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1VSBgCjXwIJ8n7Ngs/Gq0w4Q8KEdemMUncNG4O/Pao0/MPZ+EGgOIQ3qbWbMJjZtv
         SczLvQt4JHELk0599u4RMz5zyqWTjxLF0/KcZiKpOdnJXDg9VQbvlpTxNItPbZbM9A
         KGDRV+A06uTGUr9j80L/SQKq2Msi0cgPkTZT5NLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 102/152] selftests/powerpc: ptrace-pkey: Rename variables to make it easier to follow code
Date:   Thu, 20 Aug 2020 11:21:09 +0200
Message-Id: <20200820091558.987992661@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

[ Upstream commit 9a11f12e0a6c374b3ef1ce81e32ce477d28eb1b8 ]

Rename variable to indicate that they are invalid values which we will
use to test ptrace update of pkeys.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200709032946.881753-21-aneesh.kumar@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/powerpc/ptrace/ptrace-pkey.c    | 26 +++++++++----------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/powerpc/ptrace/ptrace-pkey.c b/tools/testing/selftests/powerpc/ptrace/ptrace-pkey.c
index bdbbbe8431e03..f9216c7a1829e 100644
--- a/tools/testing/selftests/powerpc/ptrace/ptrace-pkey.c
+++ b/tools/testing/selftests/powerpc/ptrace/ptrace-pkey.c
@@ -44,7 +44,7 @@ struct shared_info {
 	unsigned long amr2;
 
 	/* AMR value that ptrace should refuse to write to the child. */
-	unsigned long amr3;
+	unsigned long invalid_amr;
 
 	/* IAMR value the parent expects to read from the child. */
 	unsigned long expected_iamr;
@@ -57,8 +57,8 @@ struct shared_info {
 	 * (even though they're valid ones) because userspace doesn't have
 	 * access to those registers.
 	 */
-	unsigned long new_iamr;
-	unsigned long new_uamor;
+	unsigned long invalid_iamr;
+	unsigned long invalid_uamor;
 };
 
 static int sys_pkey_alloc(unsigned long flags, unsigned long init_access_rights)
@@ -100,7 +100,7 @@ static int child(struct shared_info *info)
 
 	info->amr1 |= 3ul << pkeyshift(pkey1);
 	info->amr2 |= 3ul << pkeyshift(pkey2);
-	info->amr3 |= info->amr2 | 3ul << pkeyshift(pkey3);
+	info->invalid_amr |= info->amr2 | 3ul << pkeyshift(pkey3);
 
 	if (disable_execute)
 		info->expected_iamr |= 1ul << pkeyshift(pkey1);
@@ -111,8 +111,8 @@ static int child(struct shared_info *info)
 
 	info->expected_uamor |= 3ul << pkeyshift(pkey1) |
 				3ul << pkeyshift(pkey2);
-	info->new_iamr |= 1ul << pkeyshift(pkey1) | 1ul << pkeyshift(pkey2);
-	info->new_uamor |= 3ul << pkeyshift(pkey1);
+	info->invalid_iamr |= 1ul << pkeyshift(pkey1) | 1ul << pkeyshift(pkey2);
+	info->invalid_uamor |= 3ul << pkeyshift(pkey1);
 
 	/*
 	 * We won't use pkey3. We just want a plausible but invalid key to test
@@ -196,9 +196,9 @@ static int parent(struct shared_info *info, pid_t pid)
 	PARENT_SKIP_IF_UNSUPPORTED(ret, &info->child_sync);
 	PARENT_FAIL_IF(ret, &info->child_sync);
 
-	info->amr1 = info->amr2 = info->amr3 = regs[0];
-	info->expected_iamr = info->new_iamr = regs[1];
-	info->expected_uamor = info->new_uamor = regs[2];
+	info->amr1 = info->amr2 = info->invalid_amr = regs[0];
+	info->expected_iamr = info->invalid_iamr = regs[1];
+	info->expected_uamor = info->invalid_uamor = regs[2];
 
 	/* Wake up child so that it can set itself up. */
 	ret = prod_child(&info->child_sync);
@@ -234,10 +234,10 @@ static int parent(struct shared_info *info, pid_t pid)
 		return ret;
 
 	/* Write invalid AMR value in child. */
-	ret = ptrace_write_regs(pid, NT_PPC_PKEY, &info->amr3, 1);
+	ret = ptrace_write_regs(pid, NT_PPC_PKEY, &info->invalid_amr, 1);
 	PARENT_FAIL_IF(ret, &info->child_sync);
 
-	printf("%-30s AMR: %016lx\n", ptrace_write_running, info->amr3);
+	printf("%-30s AMR: %016lx\n", ptrace_write_running, info->invalid_amr);
 
 	/* Wake up child so that it can verify it didn't change. */
 	ret = prod_child(&info->child_sync);
@@ -249,7 +249,7 @@ static int parent(struct shared_info *info, pid_t pid)
 
 	/* Try to write to IAMR. */
 	regs[0] = info->amr1;
-	regs[1] = info->new_iamr;
+	regs[1] = info->invalid_iamr;
 	ret = ptrace_write_regs(pid, NT_PPC_PKEY, regs, 2);
 	PARENT_FAIL_IF(!ret, &info->child_sync);
 
@@ -257,7 +257,7 @@ static int parent(struct shared_info *info, pid_t pid)
 	       ptrace_write_running, regs[0], regs[1]);
 
 	/* Try to write to IAMR and UAMOR. */
-	regs[2] = info->new_uamor;
+	regs[2] = info->invalid_uamor;
 	ret = ptrace_write_regs(pid, NT_PPC_PKEY, regs, 3);
 	PARENT_FAIL_IF(!ret, &info->child_sync);
 
-- 
2.25.1



