Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2E173C48C1
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236335AbhGLGku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:40:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238329AbhGLGkH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:40:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3392C610FB;
        Mon, 12 Jul 2021 06:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071816;
        bh=eBswLedJYx/ZLEIT8tcmKoRHn3htzjnt1RXCAbktCrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TIHq1u9Kxk8udv3McrRcP/j18VRv8WKwpuFIIQiQK9aP1AdMsp/ZL819dkjR2vl3+
         DZ7RClSiSofg+n66DtnDgiH5t8Co1A/23q+qRE+mRx2+pehbROw4H9ieZqzDvAbeEy
         XpzoOCahUATl75xxAEIRwoSPC5kSouJp3ISoLA+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Waiman Long <longman@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 231/593] locking/lockdep: Reduce LOCKDEP dependency list
Date:   Mon, 12 Jul 2021 08:06:31 +0200
Message-Id: <20210712060908.330626233@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit b8e00abe7d9fe21dd13609e2e3a707e38902b105 ]

Some arches (um, sparc64, riscv, xtensa) cause a Kconfig warning for
LOCKDEP.
These arch-es select LOCKDEP_SUPPORT but they are not listed as one
of the arch-es that LOCKDEP depends on.

Since (16) arch-es define the Kconfig symbol LOCKDEP_SUPPORT if they
intend to have LOCKDEP support, replace the awkward list of
arch-es that LOCKDEP depends on with the LOCKDEP_SUPPORT symbol.

But wait. LOCKDEP_SUPPORT is included in LOCK_DEBUGGING_SUPPORT,
which is already a dependency here, so LOCKDEP_SUPPORT is redundant
and not needed.
That leaves the FRAME_POINTER dependency, but it is part of an
expression like this:
	depends on (A && B) && (FRAME_POINTER || B')
where B' is a dependency of B so if B is true then B' is true
and the value of FRAME_POINTER does not matter.
Thus we can also delete the FRAME_POINTER dependency.

Fixes this kconfig warning: (for um, sparc64, riscv, xtensa)

WARNING: unmet direct dependencies detected for LOCKDEP
  Depends on [n]: DEBUG_KERNEL [=y] && LOCK_DEBUGGING_SUPPORT [=y] && (FRAME_POINTER [=n] || MIPS || PPC || S390 || MICROBLAZE || ARM || ARC || X86)
  Selected by [y]:
  - PROVE_LOCKING [=y] && DEBUG_KERNEL [=y] && LOCK_DEBUGGING_SUPPORT [=y]
  - LOCK_STAT [=y] && DEBUG_KERNEL [=y] && LOCK_DEBUGGING_SUPPORT [=y]
  - DEBUG_LOCK_ALLOC [=y] && DEBUG_KERNEL [=y] && LOCK_DEBUGGING_SUPPORT [=y]

Fixes: 7d37cb2c912d ("lib: fix kconfig dependency on ARCH_WANT_FRAME_POINTERS")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Waiman Long <longman@redhat.com>
Link: https://lkml.kernel.org/r/20210524224150.8009-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.debug | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index dcf4a9028e16..5b7f88a2876d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1302,7 +1302,6 @@ config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && LOCK_DEBUGGING_SUPPORT
 	select STACKTRACE
-	depends on FRAME_POINTER || MIPS || PPC || S390 || MICROBLAZE || ARM || ARC || X86
 	select KALLSYMS
 	select KALLSYMS_ALL
 
-- 
2.30.2



