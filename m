Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A3A469EB1
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379869AbhLFPnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:43:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356797AbhLFPen (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:34:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8EA0C09B134;
        Mon,  6 Dec 2021 07:20:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1D1CB81125;
        Mon,  6 Dec 2021 15:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A85C341C5;
        Mon,  6 Dec 2021 15:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804038;
        bh=R/HvWG8ZXn1eCKRhCeNoVnI/H5D7PjFbjCxnqJsbzkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x1NcWNgcLFJii3Zm7t2qlfa6Se5YE5+Yt5RRa/Vz2AJq1gXZUM3jzD0F1J++WP+2s
         ljPVsXvKR3+o8sfYpFgu3F160F6oVEBwnbRLrCQNGLGrBA7vB8qS0jz3GfxjkzzQ/y
         Cw6r37v1vQ7XABMsuyMD7DFZg12rMuAzHILYbKXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Borislav Petkov <bp@suse.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/130] x86/entry: Use the correct fence macro after swapgs in kernel CR3
Date:   Mon,  6 Dec 2021 15:57:03 +0100
Message-Id: <20211206145603.300490448@linuxfoundation.org>
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
index f18f3932e971a..a806d68b96990 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1035,11 +1035,6 @@ SYM_CODE_START_LOCAL(error_entry)
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
@@ -1062,8 +1057,14 @@ SYM_CODE_START_LOCAL(error_entry)
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



