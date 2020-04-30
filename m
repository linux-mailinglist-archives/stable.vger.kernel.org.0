Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDEE21BFA09
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 15:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgD3NvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 09:51:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727869AbgD3NvD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:51:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CACC2082E;
        Thu, 30 Apr 2020 13:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254663;
        bh=osGwwFtM7e5rMfw3M0DmRZxNr6qfcTUhOtTET+KOvqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RD4O0OxjAN1yQsHejbSQmBcM+VjP4qj1yN6DMeUpheeZvk6Zozf8fBvczPsYaUvMu
         qzooB0tzmKCqNIwn4J0BcDWnw2WMpgUlNMBoBrw4LySQdfFU8t6U+QAggfFqCTYaGa
         MUOMmHya6yP8ybnI9s7rvs6IvnVAmgqbZ+NXf5GU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sandipan Das <sandipan@linux.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-api@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 16/79] selftests: vm: Fix 64-bit test builds for powerpc64le
Date:   Thu, 30 Apr 2020 09:49:40 -0400
Message-Id: <20200430135043.19851-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sandipan Das <sandipan@linux.ibm.com>

[ Upstream commit 963e3e9c9a127013eb4d3c82eb997068b1adbb89 ]

Some tests are built only for 64-bit systems. This makes
sure that these tests are built for both big and little
endian variants of powerpc64.

Fixes: 7549b3364201 ("selftests: vm: Build/Run 64bit tests only on 64bit arch")
Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
Tested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/Makefile    | 2 +-
 tools/testing/selftests/vm/run_vmtests | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index 3f2e2f0ccbc9a..8074340c6b3ab 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -19,7 +19,7 @@ TEST_GEN_FILES += thuge-gen
 TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += userfaultfd
 
-ifneq (,$(filter $(MACHINE),arm64 ia64 mips64 parisc64 ppc64 riscv64 s390x sh64 sparc64 x86_64))
+ifneq (,$(filter $(MACHINE),arm64 ia64 mips64 parisc64 ppc64 ppc64le riscv64 s390x sh64 sparc64 x86_64))
 TEST_GEN_FILES += va_128TBswitch
 TEST_GEN_FILES += virtual_address_range
 endif
diff --git a/tools/testing/selftests/vm/run_vmtests b/tools/testing/selftests/vm/run_vmtests
index f337148431980..6e137c9baa1e0 100755
--- a/tools/testing/selftests/vm/run_vmtests
+++ b/tools/testing/selftests/vm/run_vmtests
@@ -59,7 +59,7 @@ else
 fi
 
 #filter 64bit architectures
-ARCH64STR="arm64 ia64 mips64 parisc64 ppc64 riscv64 s390x sh64 sparc64 x86_64"
+ARCH64STR="arm64 ia64 mips64 parisc64 ppc64 ppc64le riscv64 s390x sh64 sparc64 x86_64"
 if [ -z $ARCH ]; then
   ARCH=`uname -m 2>/dev/null | sed -e 's/aarch64.*/arm64/'`
 fi
-- 
2.20.1

