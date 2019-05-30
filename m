Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C93AC2F652
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbfE3EzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:55:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728029AbfE3DKS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:18 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B54A2447C;
        Thu, 30 May 2019 03:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185818;
        bh=5vbN2sGhXvL584Ap53AdED5tHV36JbXlhLfe11zdrjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qHbAsayC+iA9TS7rgREItVBHdVIGMHP9/kENFYp+NUysFbKKlojMWtXgibPQrHBuF
         w7w4eF5/PjIBYp1cDy/+fQBONlMUU7MwM/Kg6bPZY3W0IaWdr7dfBUqz+DDkWaT4IC
         cY8GszVs2XrPZliYiNdUYRpzWSdQHw773edChhKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 112/405] arm64: futex: Fix FUTEX_WAKE_OP atomic ops with non-zero result value
Date:   Wed, 29 May 2019 20:01:50 -0700
Message-Id: <20190530030546.667811321@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 84ff7a09c371bc7417eabfda19bf7f113ec917b6 ]

Rather embarrassingly, our futex() FUTEX_WAKE_OP implementation doesn't
explicitly set the return value on the non-faulting path and instead
leaves it holding the result of the underlying atomic operation. This
means that any FUTEX_WAKE_OP atomic operation which computes a non-zero
value will be reported as having failed. Regrettably, I wrote the buggy
code back in 2011 and it was upstreamed as part of the initial arm64
support in 2012.

The reasons we appear to get away with this are:

  1. FUTEX_WAKE_OP is rarely used and therefore doesn't appear to get
     exercised by futex() test applications

  2. If the result of the atomic operation is zero, the system call
     behaves correctly

  3. Prior to version 2.25, the only operation used by GLIBC set the
     futex to zero, and therefore worked as expected. From 2.25 onwards,
     FUTEX_WAKE_OP is not used by GLIBC at all.

Fix the implementation by ensuring that the return value is either 0
to indicate that the atomic operation completed successfully, or -EFAULT
if we encountered a fault when accessing the user mapping.

Cc: <stable@kernel.org>
Fixes: 6170a97460db ("arm64: Atomic operations")
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/futex.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
index 6fb2214333a24..2d78ea6932b7b 100644
--- a/arch/arm64/include/asm/futex.h
+++ b/arch/arm64/include/asm/futex.h
@@ -58,7 +58,7 @@ do {									\
 static inline int
 arch_futex_atomic_op_inuser(int op, int oparg, int *oval, u32 __user *_uaddr)
 {
-	int oldval = 0, ret, tmp;
+	int oldval, ret, tmp;
 	u32 __user *uaddr = __uaccess_mask_ptr(_uaddr);
 
 	pagefault_disable();
-- 
2.20.1



