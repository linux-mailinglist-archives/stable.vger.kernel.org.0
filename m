Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC2A35354
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 01:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbfFDXYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 19:24:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726930AbfFDXYT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 19:24:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0942208E4;
        Tue,  4 Jun 2019 23:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690658;
        bh=SMRdr6xuwV72HutdCUTMBMFsTciMYgBeEfJBnyYVZto=;
        h=From:To:Cc:Subject:Date:From;
        b=07k3WF3ydnff1CTi20ESlpURFdKsEa51sgXhe/GRr0OuCTYLBxiN/8aLILXNSUjCM
         KdoiPBSyy2b9NVskSjgUuFJVXCvhGaD7qr4K/4SiCryHW2qRMXfALK/sGY0Aywn2xh
         msbuX2dpBGlQqQ2Z8bIuN8/FMh42d82rzoR1rI9k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 01/24] x86/uaccess, kcov: Disable stack protector
Date:   Tue,  4 Jun 2019 19:23:52 -0400
Message-Id: <20190604232416.7479-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 40ea97290b08be2e038b31cbb33097d1145e8169 ]

New tooling noticed this mishap:

  kernel/kcov.o: warning: objtool: write_comp_data()+0x138: call to __stack_chk_fail() with UACCESS enabled
  kernel/kcov.o: warning: objtool: __sanitizer_cov_trace_pc()+0xd9: call to __stack_chk_fail() with UACCESS enabled

All the other instrumentation (KASAN,UBSAN) also have stack protector
disabled.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/Makefile b/kernel/Makefile
index 172d151d429c..3085141c055c 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -30,6 +30,7 @@ KCOV_INSTRUMENT_extable.o := n
 # Don't self-instrument.
 KCOV_INSTRUMENT_kcov.o := n
 KASAN_SANITIZE_kcov.o := n
+CFLAGS_kcov.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector)
 
 # cond_syscall is currently not LTO compatible
 CFLAGS_sys_ni.o = $(DISABLE_LTO)
-- 
2.20.1

