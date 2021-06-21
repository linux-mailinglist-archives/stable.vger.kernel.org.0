Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77F03AF091
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbhFUQu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:50:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232746AbhFUQr7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:47:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80F8F6145C;
        Mon, 21 Jun 2021 16:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293238;
        bh=krHw4hiRnmPWyW69uCFr1bjPgmcwELw5Yevr8rfOP1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Al1Y6wN4viGl8nb4U0HPkC8K7nOTSnvqT/zVF2ym8kVw68ZdkjBgadb7HenMskXkV
         Rnf6rlWIRF9pY0wWxl5VkPWneFeSWg9LGcDCCUod9/axs+XjzkT4sC+UjDlL6BZGbH
         MncE4K1fI3upKhsIiEHedTyFO/02ay4KUAo2A2a0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pingfan Liu <kernelfans@gmail.com>,
        Baoquan He <bhe@redhat.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        Kazuhito Hagio <k-hagio@ab.jp.nec.com>,
        Dave Young <dyoung@redhat.com>, Boris Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Anderson <anderson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.12 149/178] crash_core, vmcoreinfo: append SECTION_SIZE_BITS to vmcoreinfo
Date:   Mon, 21 Jun 2021 18:16:03 +0200
Message-Id: <20210621154927.838117976@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pingfan Liu <kernelfans@gmail.com>

commit 4f5aecdff25f59fb5ea456d5152a913906ecf287 upstream.

As mentioned in kernel commit 1d50e5d0c505 ("crash_core, vmcoreinfo:
Append 'MAX_PHYSMEM_BITS' to vmcoreinfo"), SECTION_SIZE_BITS in the
formula:

    #define SECTIONS_SHIFT    (MAX_PHYSMEM_BITS - SECTION_SIZE_BITS)

Besides SECTIONS_SHIFT, SECTION_SIZE_BITS is also used to calculate
PAGES_PER_SECTION in makedumpfile just like kernel.

Unfortunately, this arch-dependent macro SECTION_SIZE_BITS changes, e.g.
recently in kernel commit f0b13ee23241 ("arm64/sparsemem: reduce
SECTION_SIZE_BITS").  But user space wants a stable interface to get
this info.  Such info is impossible to be deduced from a crashdump
vmcore.  Hence append SECTION_SIZE_BITS to vmcoreinfo.

Link: https://lkml.kernel.org/r/20210608103359.84907-1-kernelfans@gmail.com
Link: http://lists.infradead.org/pipermail/kexec/2021-June/022676.html
Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc: Kazuhito Hagio <k-hagio@ab.jp.nec.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Boris Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: James Morse <james.morse@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dave Anderson <anderson@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/crash_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -464,6 +464,7 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_LENGTH(mem_section, NR_SECTION_ROOTS);
 	VMCOREINFO_STRUCT_SIZE(mem_section);
 	VMCOREINFO_OFFSET(mem_section, section_mem_map);
+	VMCOREINFO_NUMBER(SECTION_SIZE_BITS);
 	VMCOREINFO_NUMBER(MAX_PHYSMEM_BITS);
 #endif
 	VMCOREINFO_STRUCT_SIZE(page);


