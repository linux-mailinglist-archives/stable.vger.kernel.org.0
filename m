Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D644B6C786
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389870AbfGRDFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:05:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389853AbfGRDFG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:05:06 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B17352173B;
        Thu, 18 Jul 2019 03:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419105;
        bh=SZLtCnvDrzAG+3SlFn47Lfe9Tc9P9rbtJ9EMIqcWHuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UCuQ/bb5ovyAfRxTDz3V5AZVN1UIlNhbH8uK18l0/hlFSGVop3+85xr1ZwWvxGKDX
         iIjJPl1VaQSaTd6HChMa0eJetbVDEVT9SSlO9aqbyIud1R0LN9faZomam+945pdXn1
         HQcBXGOSj94XzMpb6u7bZlzmNYXegUZi2ZQG4Vfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Potapenko <glider@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 31/54] x86/boot/64: Add missing fixup_pointer() for next_early_pgt access
Date:   Thu, 18 Jul 2019 12:01:26 +0900
Message-Id: <20190718030055.748720665@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030053.287374640@linuxfoundation.org>
References: <20190718030053.287374640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c1887159eb48ba40e775584cfb2a443962cf1a05 ]

__startup_64() uses fixup_pointer() to access global variables in a
position-independent fashion. Access to next_early_pgt was wrapped into the
helper, but one instance in the 5-level paging branch was missed.

GCC generates a R_X86_64_PC32 PC-relative relocation for the access which
doesn't trigger the issue, but Clang emmits a R_X86_64_32S which leads to
an invalid memory access and system reboot.

Fixes: 187e91fe5e91 ("x86/boot/64/clang: Use fixup_pointer() to access 'next_early_pgt'")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Potapenko <glider@google.com>
Link: https://lkml.kernel.org/r/20190620112422.29264-1-kirill.shutemov@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/head64.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 7df5bce4e1be..29ffa495bd1c 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -184,7 +184,8 @@ unsigned long __head __startup_64(unsigned long physaddr,
 	pgtable_flags = _KERNPG_TABLE_NOENC + sme_get_me_mask();
 
 	if (la57) {
-		p4d = fixup_pointer(early_dynamic_pgts[next_early_pgt++], physaddr);
+		p4d = fixup_pointer(early_dynamic_pgts[(*next_pgt_ptr)++],
+				    physaddr);
 
 		i = (physaddr >> PGDIR_SHIFT) % PTRS_PER_PGD;
 		pgd[i + 0] = (pgdval_t)p4d + pgtable_flags;
-- 
2.20.1



