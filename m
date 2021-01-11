Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 778322F14DB
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbhAKNbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:31:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:34118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731767AbhAKNPf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:15:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF6A822A83;
        Mon, 11 Jan 2021 13:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370894;
        bh=kt3eJ6+Fv6BLr3DlqMcs6XcFnePR3mZE7IhULG1IJ4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gXCE2EaN56sCDkCPkqyicLtImP3bIxFGyt/pMTQC5076rGvUL7YwV+6MDMMjFJIxm
         rQFGo5L7hTv+LTgveQ3/uhMpvaK1th+Lh8hG+e+2Q0hlysnkfxUw3CHXGOw5i2/Vhg
         R/e/CgEG+jmLrBFzV9NAI0Hyj995YgnSFM/WAdmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harish <harish@linux.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>,
        Shuah Khan <shuah@kernel.org>,
        John Hubbard <jhubbard@nvidia.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/145] selftests/vm: fix building protection keys test
Date:   Mon, 11 Jan 2021 14:01:14 +0100
Message-Id: <20210111130050.929878378@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harish <harish@linux.ibm.com>

[ Upstream commit 7cf22a1c88c05ea3807f95b1edfebb729016ae52 ]

Commit d8cbe8bfa7d ("tools/testing/selftests/vm: fix build error") tried
to include a ARCH check for powerpc, however ARCH is not defined in the
Makefile before including lib.mk.  This makes test building to skip on
both x86 and powerpc.

Fix the arch check by replacing it using machine type as it is already
defined and used in the test.

Link: https://lkml.kernel.org/r/20201215100402.257376-1-harish@linux.ibm.com
Fixes: d8cbe8bfa7d ("tools/testing/selftests/vm: fix build error")
Signed-off-by: Harish <harish@linux.ibm.com>
Reviewed-by: Sandipan Das <sandipan@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/Makefile | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index 691893afc15d8..e63f316327080 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for vm selftests
 uname_M := $(shell uname -m 2>/dev/null || echo not)
-MACHINE ?= $(shell echo $(uname_M) | sed -e 's/aarch64.*/arm64/')
+MACHINE ?= $(shell echo $(uname_M) | sed -e 's/aarch64.*/arm64/' -e 's/ppc64.*/ppc64/')
 
 # Without this, failed build products remain, with up-to-date timestamps,
 # thus tricking Make (and you!) into believing that All Is Well, in subsequent
@@ -39,7 +39,7 @@ TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += userfaultfd
 TEST_GEN_FILES += khugepaged
 
-ifeq ($(ARCH),x86_64)
+ifeq ($(MACHINE),x86_64)
 CAN_BUILD_I386 := $(shell ./../x86/check_cc.sh $(CC) ../x86/trivial_32bit_program.c -m32)
 CAN_BUILD_X86_64 := $(shell ./../x86/check_cc.sh $(CC) ../x86/trivial_64bit_program.c)
 CAN_BUILD_WITH_NOPIE := $(shell ./../x86/check_cc.sh $(CC) ../x86/trivial_program.c -no-pie)
@@ -61,13 +61,13 @@ TEST_GEN_FILES += $(BINARIES_64)
 endif
 else
 
-ifneq (,$(findstring $(ARCH),powerpc))
+ifneq (,$(findstring $(MACHINE),ppc64))
 TEST_GEN_FILES += protection_keys
 endif
 
 endif
 
-ifneq (,$(filter $(MACHINE),arm64 ia64 mips64 parisc64 ppc64 ppc64le riscv64 s390x sh64 sparc64 x86_64))
+ifneq (,$(filter $(MACHINE),arm64 ia64 mips64 parisc64 ppc64 riscv64 s390x sh64 sparc64 x86_64))
 TEST_GEN_FILES += va_128TBswitch
 TEST_GEN_FILES += virtual_address_range
 TEST_GEN_FILES += write_to_hugetlbfs
@@ -82,7 +82,7 @@ include ../lib.mk
 
 $(OUTPUT)/hmm-tests: LDLIBS += -lhugetlbfs -lpthread
 
-ifeq ($(ARCH),x86_64)
+ifeq ($(MACHINE),x86_64)
 BINARIES_32 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_32))
 BINARIES_64 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_64))
 
-- 
2.27.0



