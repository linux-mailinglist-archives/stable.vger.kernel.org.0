Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3ACA49443
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbfFQVUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:20:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728339AbfFQVUa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:20:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40B6120B1F;
        Mon, 17 Jun 2019 21:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806429;
        bh=iMJZBU2UkJd2A7Q2CPPqhoaU8qote8ye4jNhz0Q8s3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fdyYkEWbVqJXDEqtsUKwgzbs4CQsaAkIDYwNODqDElsoa4zYUuviA6hHfLdIPEB82
         jlPGid9aD7L6SVK3RpGOg735fhTjlXBqLehPOy3mAr1hPDq61IbXUGUkSPq5lvmv2a
         aYNHrxis0fBh2fcmw1Auuku3hLm1CG+shTTX7v8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 042/115] x86/uaccess, kcov: Disable stack protector
Date:   Mon, 17 Jun 2019 23:09:02 +0200
Message-Id: <20190617210802.173135786@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



