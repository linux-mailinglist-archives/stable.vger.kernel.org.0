Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63A9329196
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243357AbhCAU2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:28:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:47596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243254AbhCAUX2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:23:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B16A6653FC;
        Mon,  1 Mar 2021 18:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621915;
        bh=mzZYf+yCeXFGZoOkq+fMZDwJmXoGWHFQOdM63Hokw8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fiSlTCpYB7apCJWy2rfRyFLnav5or3ftEzIRCYYt727F4SesFpFk4adZahokq9lDa
         gKy4imi2WlBlS6aNxKx2BdCy7tWBbDzS9WR3pe7sxzRj3Vp905oAEF1UzqaKWSf12P
         DBkqnqmQ03mf07bsUrbqqdb/G19yXPkSMOd62++4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Klauser <tklauser@distanz.ch>,
        Dmitry Vyukov <dvyukov@google.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.11 689/775] riscv: Disable KSAN_SANITIZE for vDSO
Date:   Mon,  1 Mar 2021 17:14:17 +0100
Message-Id: <20210301161235.435239001@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tobias Klauser <tklauser@distanz.ch>

commit f3d60f2a25e4417e1676161fe42115de3e3f98a2 upstream.

We use the generic C VDSO implementations of a handful of clock-related
functions.  When kasan is enabled this results in asan stub calls that
are unlikely to be resolved by userspace, this just disables KASAN
when building the VDSO.

Verified the fix on a kernel with KASAN enabled using vDSO selftests.

Link: https://lore.kernel.org/lkml/CACT4Y+ZNJBnkKHXUf=tm_yuowvZvHwN=0rmJ=7J+xFd+9r_6pQ@mail.gmail.com/
Tested-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Tested-by: Dmitry Vyukov <dvyukov@google.com>
[Palmer: commit text]
Fixes: ad5d1122b82f ("riscv: use vDSO common flow to reduce the latency of the time-related functions")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/vdso/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -32,9 +32,10 @@ CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
 # Disable -pg to prevent insert call site
 CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os
 
-# Disable gcov profiling for VDSO code
+# Disable profiling and instrumentation for VDSO code
 GCOV_PROFILE := n
 KCOV_INSTRUMENT := n
+KASAN_SANITIZE := n
 
 # Force dependency
 $(obj)/vdso.o: $(obj)/vdso.so


