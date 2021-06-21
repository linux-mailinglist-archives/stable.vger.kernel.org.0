Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04883AEF08
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbhFUQfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:35:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232112AbhFUQdI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:33:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A9B16128E;
        Mon, 21 Jun 2021 16:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292773;
        bh=VUvpdwKNNvGE0HsWxu9oXu4dlx1Jhlt+vjypaAzSoWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+q4I0KFFnVn8eO0ZIAGBLWnz7X004CllBGse79IF3ace2atcngk3UMIdUyotQz1v
         MQWTX73aO8IPeNAGXziycDKVMXN6IvJcR3CZPQN4LZ4IBxQizp2UWTlufL+85nxbST
         SUm/w8FikcpU2olB5mNNB88OkDIFXS9j+3toHQCQ=
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
Subject: [PATCH 5.10 125/146] crash_core, vmcoreinfo: append SECTION_SIZE_BITS to vmcoreinfo
Date:   Mon, 21 Jun 2021 18:15:55 +0200
Message-Id: <20210621154919.359292901@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
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
@@ -463,6 +463,7 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_LENGTH(mem_section, NR_SECTION_ROOTS);
 	VMCOREINFO_STRUCT_SIZE(mem_section);
 	VMCOREINFO_OFFSET(mem_section, section_mem_map);
+	VMCOREINFO_NUMBER(SECTION_SIZE_BITS);
 	VMCOREINFO_NUMBER(MAX_PHYSMEM_BITS);
 #endif
 	VMCOREINFO_STRUCT_SIZE(page);


