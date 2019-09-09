Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0511AAE0B4
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 00:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392293AbfIIWRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 18:17:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392262AbfIIWRX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Sep 2019 18:17:23 -0400
Received: from sasha-vm.mshome.net (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19C0521D79;
        Mon,  9 Sep 2019 22:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568067443;
        bh=O9VeM1BOlt+ur9Dx7odq4IYF9Sb2o2TtG1rbzNzzC/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N/JZIoRwe+R0tlvyMu1ExaiN25pqJKI4vz4EKHdzq+WIAqNTamULIJLiGtT1oyN0/
         WA5uoL/z+B4nQTIPdMRBoicoCFLHkvxdrZpSRQLW6eBDrCYMFTS3bOugLYLMNZV9YY
         lRe4yY7FWlj+lEpaEnKKnoB/xTnrnStt/RMhr+Wk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, broonie@kernel.org,
        sfr@canb.auug.org.au, akpm@linux-foundation.org, mhocko@suse.cz,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 3/6] x86/uaccess: Don't leak the AC flags into __get_user() argument evaluation
Date:   Mon,  9 Sep 2019 11:42:02 -0400
Message-Id: <20190909154205.31376-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190909154205.31376-1-sashal@kernel.org>
References: <20190909154205.31376-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 9b8bd476e78e89c9ea26c3b435ad0201c3d7dbf5 ]

Identical to __put_user(); the __get_user() argument evalution will too
leak UBSAN crud into the __uaccess_begin() / __uaccess_end() region.
While uncommon this was observed to happen for:

  drivers/xen/gntdev.c: if (__get_user(old_status, batch->status[i]))

where UBSAN added array bound checking.

This complements commit:

  6ae865615fc4 ("x86/uaccess: Dont leak the AC flag into __put_user() argument evaluation")

Tested-by Sedat Dilek <sedat.dilek@gmail.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: broonie@kernel.org
Cc: sfr@canb.auug.org.au
Cc: akpm@linux-foundation.org
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: mhocko@suse.cz
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lkml.kernel.org/r/20190829082445.GM2369@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/uaccess.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 2177c7551ff77..9db8d8758ed3b 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -438,8 +438,10 @@ do {									\
 ({									\
 	int __gu_err;							\
 	__inttype(*(ptr)) __gu_val;					\
+	__typeof__(ptr) __gu_ptr = (ptr);				\
+	__typeof__(size) __gu_size = (size);				\
 	__uaccess_begin_nospec();					\
-	__get_user_size(__gu_val, (ptr), (size), __gu_err, -EFAULT);	\
+	__get_user_size(__gu_val, __gu_ptr, __gu_size, __gu_err, -EFAULT);	\
 	__uaccess_end();						\
 	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
 	__builtin_expect(__gu_err, 0);					\
-- 
2.20.1

