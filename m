Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F60291E65
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbgJRTUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:20:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729074AbgJRTUv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:20:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 943B822314;
        Sun, 18 Oct 2020 19:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048851;
        bh=4q+xtkTEw+8lhssERipfns72GCshcPgkPtDFSe2mnDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zzT04MufBKSokAUwXrZouXv0tKO8Dm1PTivf3kuDYLQyOl9tIgcSogrEuq0goQn4O
         qZqQsTZ+OuIvyPRrGOVDrux39+dB701OBedKmq7U15Dgs5I0iFo6MCvfEf321Iexh1
         7VxSc9OKsaKAWYOuYRFwwkIxUIroMkuUhV4eNqBc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 019/101] x86/mce: Annotate mce_rd/wrmsrl() with noinstr
Date:   Sun, 18 Oct 2020 15:19:04 -0400
Message-Id: <20201018192026.4053674-19-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 14e4b4d17ee5b..d8dca24feccbe 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -371,16 +371,25 @@ static int msr_to_offset(u32 msr)
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
@@ -396,13 +405,19 @@ static u64 mce_rdmsrl(u32 msr)
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

