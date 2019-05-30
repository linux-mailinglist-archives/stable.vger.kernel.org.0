Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBF4F2F394
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729649AbfE3DN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:13:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729640AbfE3DN6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:13:58 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BB6B24561;
        Thu, 30 May 2019 03:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186038;
        bh=L7GkdcYjvguZwb2WT+RpJUm4C6wmJIXN09qTxaKWRYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bFhqqij6HQqji2syoeAxchKpGcNPTJ6r7PhMS+SLFdTNsFflL7/myjMnkbpmLuKFW
         bqqNe50lYyCi01HquwVsPdk642LF223RrSgNNduazP4+KG+F7Tm5z+u7VZAttm2WQf
         CrUfdGi8NvDcO28PPkQxk1vZITB9E/rerlqVvcwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, luto@kernel.org,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 126/346] x86/uaccess: Dont leak the AC flag into __put_user() argument evaluation
Date:   Wed, 29 May 2019 20:03:19 -0700
Message-Id: <20190530030547.502247280@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6ae865615fc43d014da2fd1f1bba7e81ee622d1b ]

The __put_user() macro evaluates it's @ptr argument inside the
__uaccess_begin() / __uaccess_end() region. While this would normally
not be expected to be an issue, an UBSAN bug (it ignored -fwrapv,
fixed in GCC 8+) would transform the @ptr evaluation for:

  drivers/gpu/drm/i915/i915_gem_execbuffer.c: if (unlikely(__put_user(offset, &urelocs[r-stack].presumed_offset))) {

into a signed-overflow-UB check and trigger the objtool AC validation.

Finish this commit:

  2a418cf3f5f1 ("x86/uaccess: Don't leak the AC flag into __put_user() value evaluation")

and explicitly evaluate all 3 arguments early.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: luto@kernel.org
Fixes: 2a418cf3f5f1 ("x86/uaccess: Don't leak the AC flag into __put_user() value evaluation")
Link: http://lkml.kernel.org/r/20190424072208.695962771@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/uaccess.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index f3aed639dccda..2b0dd1b9c2087 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -431,10 +431,11 @@ do {									\
 ({								\
 	__label__ __pu_label;					\
 	int __pu_err = -EFAULT;					\
-	__typeof__(*(ptr)) __pu_val;				\
-	__pu_val = x;						\
+	__typeof__(*(ptr)) __pu_val = (x);			\
+	__typeof__(ptr) __pu_ptr = (ptr);			\
+	__typeof__(size) __pu_size = (size);			\
 	__uaccess_begin();					\
-	__put_user_size(__pu_val, (ptr), (size), __pu_label);	\
+	__put_user_size(__pu_val, __pu_ptr, __pu_size, __pu_label);	\
 	__pu_err = 0;						\
 __pu_label:							\
 	__uaccess_end();					\
-- 
2.20.1



