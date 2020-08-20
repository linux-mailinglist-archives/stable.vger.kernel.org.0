Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5888824BB24
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730122AbgHTMYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:24:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730114AbgHTJyY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:54:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4755C2067C;
        Thu, 20 Aug 2020 09:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917262;
        bh=FIf245zXysx06zrfB4Thg/nzHVS7fWcttgKSzi+mJQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b4wiIGS28V+gnol6ahyI3T2QNNySc//jFopV179XS+XrdyAvR2uN1EXAHzGfriB0i
         QOWbrpZmfSsKTlvKZtId1jpdzuFdybKRyAz/7RBVd61KfKc35TUO2BSobAORmQzilP
         qtkBpHwZbzRZ7dmk4sZPKtNHQoTaVLadGzbfilEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 61/92] selftests/powerpc: ptrace-pkey: Update the test to mark an invalid pkey correctly
Date:   Thu, 20 Aug 2020 11:21:46 +0200
Message-Id: <20200820091540.787545895@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
References: <20200820091537.490965042@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

[ Upstream commit 0eaa3b5ca7b5a76e3783639c828498343be66a01 ]

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200709032946.881753-22-aneesh.kumar@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/powerpc/ptrace/ptrace-pkey.c    | 30 ++++++++-----------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/powerpc/ptrace/ptrace-pkey.c b/tools/testing/selftests/powerpc/ptrace/ptrace-pkey.c
index f9216c7a1829e..bc33d748d95b4 100644
--- a/tools/testing/selftests/powerpc/ptrace/ptrace-pkey.c
+++ b/tools/testing/selftests/powerpc/ptrace/ptrace-pkey.c
@@ -66,11 +66,6 @@ static int sys_pkey_alloc(unsigned long flags, unsigned long init_access_rights)
 	return syscall(__NR_pkey_alloc, flags, init_access_rights);
 }
 
-static int sys_pkey_free(int pkey)
-{
-	return syscall(__NR_pkey_free, pkey);
-}
-
 static int child(struct shared_info *info)
 {
 	unsigned long reg;
@@ -100,7 +95,11 @@ static int child(struct shared_info *info)
 
 	info->amr1 |= 3ul << pkeyshift(pkey1);
 	info->amr2 |= 3ul << pkeyshift(pkey2);
-	info->invalid_amr |= info->amr2 | 3ul << pkeyshift(pkey3);
+	/*
+	 * invalid amr value where we try to force write
+	 * things which are deined by a uamor setting.
+	 */
+	info->invalid_amr = info->amr2 | (~0x0UL & ~info->expected_uamor);
 
 	if (disable_execute)
 		info->expected_iamr |= 1ul << pkeyshift(pkey1);
@@ -111,17 +110,12 @@ static int child(struct shared_info *info)
 
 	info->expected_uamor |= 3ul << pkeyshift(pkey1) |
 				3ul << pkeyshift(pkey2);
-	info->invalid_iamr |= 1ul << pkeyshift(pkey1) | 1ul << pkeyshift(pkey2);
-	info->invalid_uamor |= 3ul << pkeyshift(pkey1);
-
 	/*
-	 * We won't use pkey3. We just want a plausible but invalid key to test
-	 * whether ptrace will let us write to AMR bits we are not supposed to.
-	 *
-	 * This also tests whether the kernel restores the UAMOR permissions
-	 * after a key is freed.
+	 * Create an IAMR value different from expected value.
+	 * Kernel will reject an IAMR and UAMOR change.
 	 */
-	sys_pkey_free(pkey3);
+	info->invalid_iamr = info->expected_iamr | (1ul << pkeyshift(pkey1) | 1ul << pkeyshift(pkey2));
+	info->invalid_uamor = info->expected_uamor & ~(0x3ul << pkeyshift(pkey1));
 
 	printf("%-30s AMR: %016lx pkey1: %d pkey2: %d pkey3: %d\n",
 	       user_write, info->amr1, pkey1, pkey2, pkey3);
@@ -196,9 +190,9 @@ static int parent(struct shared_info *info, pid_t pid)
 	PARENT_SKIP_IF_UNSUPPORTED(ret, &info->child_sync);
 	PARENT_FAIL_IF(ret, &info->child_sync);
 
-	info->amr1 = info->amr2 = info->invalid_amr = regs[0];
-	info->expected_iamr = info->invalid_iamr = regs[1];
-	info->expected_uamor = info->invalid_uamor = regs[2];
+	info->amr1 = info->amr2 = regs[0];
+	info->expected_iamr = regs[1];
+	info->expected_uamor = regs[2];
 
 	/* Wake up child so that it can set itself up. */
 	ret = prod_child(&info->child_sync);
-- 
2.25.1



