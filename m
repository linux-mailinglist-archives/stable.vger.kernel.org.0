Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B4E35306
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 01:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfFDXWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 19:22:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbfFDXWP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 19:22:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 190FF20851;
        Tue,  4 Jun 2019 23:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690535;
        bh=gy8a2WMB91m89Hl9bICWGdCu1b9GfLzb2vz386JCyrM=;
        h=From:To:Cc:Subject:Date:From;
        b=GALRFBsnBC5owwxBrO4/6DoY0iAtcCugjMe4aLF+CXi1PbpSFcNnrdSC/6waXqrSS
         /QrzVUq0Xx6QGRam3VGI2aPPeZVRCkAjFwY+jb0eqGo0/w1Tf76gGHCO4RsIaxJBlf
         H7xS5MJiaDyCAcOnkTE5OInmHmkIgTv52L4R/EQ4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 01/60] x86/uaccess, kcov: Disable stack protector
Date:   Tue,  4 Jun 2019 19:21:11 -0400
Message-Id: <20190604232212.6753-1-sashal@kernel.org>
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
index 6c57e78817da..62471e75a2b0 100644
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

