Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9CCA469EF7
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391130AbhLFPpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388170AbhLFPcX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:32:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872D2C08E856;
        Mon,  6 Dec 2021 07:19:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50471B81135;
        Mon,  6 Dec 2021 15:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7F3C341C1;
        Mon,  6 Dec 2021 15:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803965;
        bh=rhQ6gw2N4GendxGyO6hG8ndGQ19HAKkm+QVk7bFiWG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l5DPpk9RX95DJpmynOdqDLExYCGEMTL2B0eLGRI3g5HoeRVpjhRrAhp4UoJ23CObh
         V+VLdDwZpFwThehRgLdgfviE4xv5jZxprBoQGXNaOBP0xSuhHiWhi4vaCNOZoDfJvm
         2dQELSnRyiBHP9V1hI5rJd75N0otaVZ0wCBnhZpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/130] x86/entry: Add a fence for kernel entry SWAPGS in paranoid_entry()
Date:   Mon,  6 Dec 2021 15:57:07 +0100
Message-Id: <20211206145603.437518528@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
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
index 166554a109aeb..a24ce5905ab82 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -936,6 +936,7 @@ SYM_CODE_START_LOCAL(paranoid_entry)
 .Lparanoid_entry_checkgs:
 	/* EBX = 1 -> kernel GSBASE active, no restore required */
 	movl	$1, %ebx
+
 	/*
 	 * The kernel-enforced convention is a negative GSBASE indicates
 	 * a kernel value. No SWAPGS needed on entry and exit.
@@ -943,21 +944,14 @@ SYM_CODE_START_LOCAL(paranoid_entry)
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



