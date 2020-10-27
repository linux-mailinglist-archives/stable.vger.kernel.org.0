Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F3329BC85
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1810073AbgJ0Qd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:33:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802479AbgJ0PtN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:49:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D63D22384;
        Tue, 27 Oct 2020 15:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813752;
        bh=vu7pTNAvw9+u1v2MqLtoBgxPJCu1Jl1H6ad4i3niq+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZlR71wPgcbQ4n/Y3aXDIDmD1ibjT+BCJFiBZGnjm/aisItqERxwOe/n76z7tO+SN
         z3301wNax/U8Uruw8BHPlgSkT/BeB7Bt18w6ex8Lry5C5daD8dvumAs8d7B+DPSt38
         lHHGapu3vurW9t7TNfIS2TrMgTIxgBye0UEcX9YI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 659/757] x86/mce: Annotate mce_rd/wrmsrl() with noinstr
Date:   Tue, 27 Oct 2020 14:55:09 +0100
Message-Id: <20201027135521.445794425@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit e100777016fdf6ec3a9d7c1773b15a2b5eca6c55 ]

They do get called from the #MC handler which is already marked
"noinstr".

Commit

  e2def7d49d08 ("x86/mce: Make mce_rdmsrl() panic on an inaccessible MSR")

already got rid of the instrumentation in the MSR accessors, fix the
annotation now too, in order to get rid of:

  vmlinux.o: warning: objtool: do_machine_check()+0x4a: call to mce_rdmsrl() leaves .noinstr.text section

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20200915194020.28807-1-bp@alien8.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mce/core.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index fc4f8c04bdb56..4288645425f15 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -374,16 +374,25 @@ static int msr_to_offset(u32 msr)
 }
 
 /* MSR access wrappers used for error injection */
-static u64 mce_rdmsrl(u32 msr)
+static noinstr u64 mce_rdmsrl(u32 msr)
 {
 	u64 v;
 
 	if (__this_cpu_read(injectm.finished)) {
-		int offset = msr_to_offset(msr);
+		int offset;
+		u64 ret;
 
+		instrumentation_begin();
+
+		offset = msr_to_offset(msr);
 		if (offset < 0)
-			return 0;
-		return *(u64 *)((char *)this_cpu_ptr(&injectm) + offset);
+			ret = 0;
+		else
+			ret = *(u64 *)((char *)this_cpu_ptr(&injectm) + offset);
+
+		instrumentation_end();
+
+		return ret;
 	}
 
 	if (rdmsrl_safe(msr, &v)) {
@@ -399,13 +408,19 @@ static u64 mce_rdmsrl(u32 msr)
 	return v;
 }
 
-static void mce_wrmsrl(u32 msr, u64 v)
+static noinstr void mce_wrmsrl(u32 msr, u64 v)
 {
 	if (__this_cpu_read(injectm.finished)) {
-		int offset = msr_to_offset(msr);
+		int offset;
 
+		instrumentation_begin();
+
+		offset = msr_to_offset(msr);
 		if (offset >= 0)
 			*(u64 *)((char *)this_cpu_ptr(&injectm) + offset) = v;
+
+		instrumentation_end();
+
 		return;
 	}
 	wrmsrl(msr, v);
-- 
2.25.1



