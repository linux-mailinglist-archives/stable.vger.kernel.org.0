Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6554F469F7D
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391115AbhLFPpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48900 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233869AbhLFPdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:33:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FF5361320;
        Mon,  6 Dec 2021 15:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1955FC34900;
        Mon,  6 Dec 2021 15:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804587;
        bh=Hsds4PJTBlHXcK+rjBQuTccAnfhlCVvsnIcJZHAGLNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JuIMkmfZJhYZRSeXm/F+dwsbHyIWhBrLzxfiwAPUKk2rHWfd/f4SLE/N5E99dR7e0
         Mx9GA7W3PgBMEDZEE/hvedF0DkeKa9ML2YEnc6Djq24MDNuRj2qp8st9S0hqRI20JM
         IdL7MItGjK0gKYJnsxsyAkaKOd/N1Wrrhbqp3Tr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 173/207] x86/entry: Add a fence for kernel entry SWAPGS in paranoid_entry()
Date:   Mon,  6 Dec 2021 15:57:07 +0100
Message-Id: <20211206145616.255750412@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

[ Upstream commit c07e45553da1808aa802e9f0ffa8108cfeaf7a17 ]

Commit

  18ec54fdd6d18 ("x86/speculation: Prepare entry code for Spectre v1 swapgs mitigations")

added FENCE_SWAPGS_{KERNEL|USER}_ENTRY for conditional SWAPGS. In
paranoid_entry(), it uses only FENCE_SWAPGS_KERNEL_ENTRY for both
branches. This is because the fence is required for both cases since the
CR3 write is conditional even when PTI is enabled.

But

  96b2371413e8f ("x86/entry/64: Switch CR3 before SWAPGS in paranoid entry")

changed the order of SWAPGS and the CR3 write. And it missed the needed
FENCE_SWAPGS_KERNEL_ENTRY for the user gsbase case.

Add it back by changing the branches so that FENCE_SWAPGS_KERNEL_ENTRY
can cover both branches.

  [ bp: Massage, fix typos, remove obsolete comment while at it. ]

Fixes: 96b2371413e8f ("x86/entry/64: Switch CR3 before SWAPGS in paranoid entry")
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20211126101209.8613-2-jiangshanlai@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/entry_64.S | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index e38a4cf795d96..f1a8b5b2af964 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -890,6 +890,7 @@ SYM_CODE_START_LOCAL(paranoid_entry)
 .Lparanoid_entry_checkgs:
 	/* EBX = 1 -> kernel GSBASE active, no restore required */
 	movl	$1, %ebx
+
 	/*
 	 * The kernel-enforced convention is a negative GSBASE indicates
 	 * a kernel value. No SWAPGS needed on entry and exit.
@@ -897,21 +898,14 @@ SYM_CODE_START_LOCAL(paranoid_entry)
 	movl	$MSR_GS_BASE, %ecx
 	rdmsr
 	testl	%edx, %edx
-	jns	.Lparanoid_entry_swapgs
-	ret
+	js	.Lparanoid_kernel_gsbase
 
-.Lparanoid_entry_swapgs:
+	/* EBX = 0 -> SWAPGS required on exit */
+	xorl	%ebx, %ebx
 	swapgs
+.Lparanoid_kernel_gsbase:
 
-	/*
-	 * The above SAVE_AND_SWITCH_TO_KERNEL_CR3 macro doesn't do an
-	 * unconditional CR3 write, even in the PTI case.  So do an lfence
-	 * to prevent GS speculation, regardless of whether PTI is enabled.
-	 */
 	FENCE_SWAPGS_KERNEL_ENTRY
-
-	/* EBX = 0 -> SWAPGS required on exit */
-	xorl	%ebx, %ebx
 	ret
 SYM_CODE_END(paranoid_entry)
 
-- 
2.33.0



