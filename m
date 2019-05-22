Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35D2526B5A
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731897AbfEVT0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:26:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731908AbfEVT0O (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:26:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AB7F2184E;
        Wed, 22 May 2019 19:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553174;
        bh=2rNaSUWz/8CmAwfM5ftVRMsv7mIhU0dU63TQclH0hgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OO0surR686S0sA9F2NbUDM0DuwS+UXog4TW2okkr+JxUF9rXKiMWHYLOXzNzIaFQR
         OaiF/m2lUcyDJC6WD+nawlYMYx8yj3820bTVIW4jQf3BVzD48d/UQsplTQz5lluuzZ
         y70NJMW5aajonBADh9qUQoGLkuBsdywhmHTy6/i8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, luto@kernel.org,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 093/317] x86/uaccess: Dont leak the AC flag into __put_user() argument evaluation
Date:   Wed, 22 May 2019 15:19:54 -0400
Message-Id: <20190522192338.23715-93-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

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

