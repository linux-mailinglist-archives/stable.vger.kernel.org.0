Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1A56622EE
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389501AbfGHP3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:29:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389500AbfGHP3c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:29:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AD6321743;
        Mon,  8 Jul 2019 15:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599771;
        bh=IWAfHE3MJdLP/FqmZHno6i2OiWv+r4s+QbncoVw12eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XP06qAH2RDYGUkSv7oZhIlSEEe7XG80CLHf1iWkOB7ufmgLCZZAL+Co0T0NkMhlCW
         Da+wpiT/vmybvto9hHcHioY7ekJXsSYJkhuj1oQHPddVjW+JfTgju7Qe124YWGfbpz
         EpE6onTqGE8Ie1FEJ5v1ICITfxjuIzdaJx6N5fEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kyle D Pelton <kyle.d.pelton@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Borislav Petkov <bp@suse.de>, dave.hansen@linux.intel.com,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wei Huang <wei@redhat.com>, x86-ml <x86@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 72/90] x86/boot/compressed/64: Do not corrupt EDX on EFER.LME=1 setting
Date:   Mon,  8 Jul 2019 17:13:39 +0200
Message-Id: <20190708150525.966995669@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 45b13b424faafb81c8c44541f093a682fdabdefc ]

RDMSR in the trampoline code overwrites EDX but that register is used
to indicate whether 5-level paging has to be enabled and if clobbered,
leads to failure to boot on a 5-level paging machine.

Preserve EDX on the stack while we are dealing with EFER.

Fixes: b677dfae5aa1 ("x86/boot/compressed/64: Set EFER.LME=1 in 32-bit trampoline before returning to long mode")
Reported-by: Kyle D Pelton <kyle.d.pelton@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: dave.hansen@linux.intel.com
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Wei Huang <wei@redhat.com>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20190206115253.1907-1-kirill.shutemov@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/compressed/head_64.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index f105ae8651c9..f62e347862cc 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -602,10 +602,12 @@ ENTRY(trampoline_32bit_src)
 3:
 	/* Set EFER.LME=1 as a precaution in case hypervsior pulls the rug */
 	pushl	%ecx
+	pushl	%edx
 	movl	$MSR_EFER, %ecx
 	rdmsr
 	btsl	$_EFER_LME, %eax
 	wrmsr
+	popl	%edx
 	popl	%ecx
 
 	/* Enable PAE and LA57 (if required) paging modes */
-- 
2.20.1



