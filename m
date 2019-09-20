Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28A9CB9324
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbfITOhz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:37:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35762 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388020AbfITOZA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:00 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqD-0004wz-P8; Fri, 20 Sep 2019 15:24:57 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqC-0007qe-Rj; Fri, 20 Sep 2019 15:24:56 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Vincenzo Frascino" <vincenzo.frascino@arm.com>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        "Will Deacon" <will.deacon@arm.com>, "Jann Horn" <jannh@google.com>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.890702323@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 026/132] arm64: compat: Reduce address limit
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Vincenzo Frascino <vincenzo.frascino@arm.com>

commit d263119387de9975d2acba1dfd3392f7c5979c18 upstream.

Currently, compat tasks running on arm64 can allocate memory up to
TASK_SIZE_32 (UL(0x100000000)).

This means that mmap() allocations, if we treat them as returning an
array, are not compliant with the sections 6.5.8 of the C standard
(C99) which states that: "If the expression P points to an element of
an array object and the expression Q points to the last element of the
same array object, the pointer expression Q+1 compares greater than P".

Redefine TASK_SIZE_32 to address the issue.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Jann Horn <jannh@google.com>
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
[will: fixed typo in comment]
Signed-off-by: Will Deacon <will.deacon@arm.com>
[bwh: Backported to 3.16: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm64/include/asm/memory.h | 8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -53,7 +53,15 @@
 #define TASK_SIZE_64		(UL(1) << VA_BITS)
 
 #ifdef CONFIG_COMPAT
+#ifdef CONFIG_ARM64_64K_PAGES
+/*
+ * With CONFIG_ARM64_64K_PAGES enabled, the last page is occupied
+ * by the compat vectors page.
+ */
 #define TASK_SIZE_32		UL(0x100000000)
+#else
+#define TASK_SIZE_32		(UL(0x100000000) - PAGE_SIZE)
+#endif /* CONFIG_ARM64_64K_PAGES */
 #define TASK_SIZE		(test_thread_flag(TIF_32BIT) ? \
 				TASK_SIZE_32 : TASK_SIZE_64)
 #define TASK_SIZE_OF(tsk)	(test_tsk_thread_flag(tsk, TIF_32BIT) ? \

