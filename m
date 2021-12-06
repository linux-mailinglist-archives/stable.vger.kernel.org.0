Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578EE469EAB
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385910AbhLFPna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:43:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49066 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388469AbhLFPdf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:33:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0987361322;
        Mon,  6 Dec 2021 15:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DD2C34900;
        Mon,  6 Dec 2021 15:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804604;
        bh=wL4tWySXBrPzJT5fG9ckppc3JBbRbiWt60uRzrLiJp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DDRfTYoQdPhO5x6/mhuh1r+ltWx9rV2OOpu/kSrVGLwepYv5fWxZ8v8rTsgoG9bpI
         GPWXguR47fM6J/6KhXH6vkLUYhFtHiINyk0W3H1XhD1dFGuJTACpoUHHYoN8SszLLy
         J7ukdK5XGGyKPi7U0GkC6cTHECS0nMzYmB6a2MHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Borislav Petkov <bp@suse.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 174/207] x86/entry: Use the correct fence macro after swapgs in kernel CR3
Date:   Mon,  6 Dec 2021 15:57:08 +0100
Message-Id: <20211206145616.287986461@linuxfoundation.org>
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

[ Upstream commit 1367afaa2ee90d1c956dfc224e199fcb3ff3f8cc ]

The commit

  c75890700455 ("x86/entry/64: Remove unneeded kernel CR3 switching")

removed a CR3 write in the faulting path of load_gs_index().

But the path's FENCE_SWAPGS_USER_ENTRY has no fence operation if PTI is
enabled, see spectre_v1_select_mitigation().

Rather, it depended on the serializing CR3 write of SWITCH_TO_KERNEL_CR3
and since it got removed, add a FENCE_SWAPGS_KERNEL_ENTRY call to make
sure speculation is blocked.

 [ bp: Massage commit message and comment. ]

Fixes: c75890700455 ("x86/entry/64: Remove unneeded kernel CR3 switching")
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20211126101209.8613-3-jiangshanlai@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/entry_64.S | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index f1a8b5b2af964..f9e1c06a1c329 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -987,11 +987,6 @@ SYM_CODE_START_LOCAL(error_entry)
 	pushq	%r12
 	ret
 
-.Lerror_entry_done_lfence:
-	FENCE_SWAPGS_KERNEL_ENTRY
-.Lerror_entry_done:
-	ret
-
 	/*
 	 * There are two places in the kernel that can potentially fault with
 	 * usergs. Handle them here.  B stepping K8s sometimes report a
@@ -1014,8 +1009,14 @@ SYM_CODE_START_LOCAL(error_entry)
 	 * .Lgs_change's error handler with kernel gsbase.
 	 */
 	SWAPGS
-	FENCE_SWAPGS_USER_ENTRY
-	jmp .Lerror_entry_done
+
+	/*
+	 * Issue an LFENCE to prevent GS speculation, regardless of whether it is a
+	 * kernel or user gsbase.
+	 */
+.Lerror_entry_done_lfence:
+	FENCE_SWAPGS_KERNEL_ENTRY
+	ret
 
 .Lbstep_iret:
 	/* Fix truncated RIP */
-- 
2.33.0



