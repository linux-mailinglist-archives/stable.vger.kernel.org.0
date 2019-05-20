Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3953233DD
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387426AbfETMUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:20:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387414AbfETMUm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:20:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8909B21707;
        Mon, 20 May 2019 12:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354842;
        bh=4s/pIXABEDSZVoKp7kapNJZleYdXNZPVMKYkWaXO+R4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g+DtfhtP5YHgTo94b/OfyHgsxyAI5lxfYo/FvVfzE81xoiGYAQGSMv3V8SSRd5TK1
         6oto9gVJN/NF3HOblmTRJ6K7ib8SJbRHN/zCutXhvOFPuN5sNmYVJpBe0Ex0URR7na
         JTeKBskv8Q1pDKqCQK1Zuoj4DZOll2cQuDgpVVwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Jann Horn <jannh@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: [PATCH 4.14 13/63] arm64: compat: Reduce address limit
Date:   Mon, 20 May 2019 14:13:52 +0200
Message-Id: <20190520115232.626804299@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115231.137981521@linuxfoundation.org>
References: <20190520115231.137981521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: <stable@vger.kernel.org>
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
[will: fixed typo in comment]
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/processor.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -49,7 +49,15 @@
  * TASK_UNMAPPED_BASE - the lower boundary of the mmap VM area.
  */
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


