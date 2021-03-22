Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 361C634422C
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhCVMjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:39:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231208AbhCVMhm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:37:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8405619AF;
        Mon, 22 Mar 2021 12:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416631;
        bh=yiXvwz2Os9RG+jra+SAuODCPOe8zgnvxJPTMRo3X3+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xe1eFNA7cnB+qu+chp6fQuZcARfYwtgueN+UJhc87VGK8jU5/hd609qoz6BBVBxhN
         0b1bU8MSiaLjOUVMGtXvtc+s/XNhl1F2uNBm6Tmx+le1nlG6tmmPT/8h4sSqcT5oVz
         qFO1dJkFzmgl9DZQ+ufCWL+kbUOYN6yWQGmTMFwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Anderson <seanga2@gmail.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atish.patra@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.10 059/157] RISC-V: correct enum sbi_ext_rfence_fid
Date:   Mon, 22 Mar 2021 13:26:56 +0100
Message-Id: <20210322121935.627248248@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heinrich Schuchardt <xypron.glpk@gmx.de>

commit 6dd4879f59b0a0679ed8c3ebaff3d79f37930778 upstream.

The constants in enum sbi_ext_rfence_fid should match the SBI
specification. See
https://github.com/riscv/riscv-sbi-doc/blob/master/riscv-sbi.adoc#78-function-listing

| Function Name               | FID | EID
| sbi_remote_fence_i          |   0 | 0x52464E43
| sbi_remote_sfence_vma       |   1 | 0x52464E43
| sbi_remote_sfence_vma_asid  |   2 | 0x52464E43
| sbi_remote_hfence_gvma_vmid |   3 | 0x52464E43
| sbi_remote_hfence_gvma      |   4 | 0x52464E43
| sbi_remote_hfence_vvma_asid |   5 | 0x52464E43
| sbi_remote_hfence_vvma      |   6 | 0x52464E43

Fixes: ecbacc2a3efd ("RISC-V: Add SBI v0.2 extension definitions")
Reported-by: Sean Anderson <seanga2@gmail.com>
Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/sbi.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -51,10 +51,10 @@ enum sbi_ext_rfence_fid {
 	SBI_EXT_RFENCE_REMOTE_FENCE_I = 0,
 	SBI_EXT_RFENCE_REMOTE_SFENCE_VMA,
 	SBI_EXT_RFENCE_REMOTE_SFENCE_VMA_ASID,
-	SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA,
 	SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA_VMID,
-	SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA,
+	SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA,
 	SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA_ASID,
+	SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA,
 };
 
 enum sbi_ext_hsm_fid {


