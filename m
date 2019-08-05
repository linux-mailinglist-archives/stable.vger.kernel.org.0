Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08FB181D1B
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbfHEN3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:29:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730565AbfHENVi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:21:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2DC420657;
        Mon,  5 Aug 2019 13:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011298;
        bh=0cNwFlZ1b10kVaaejrryEAcU+pkQ8MaKIVH9ntFQ0Ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hNxHbq2NSx/jwJyZhYWiG3UyN+6N3pDEO2dA4ZdW4lUx16sUl1A/gBprIFqKhZe69
         fBGKtSpI0KgH9yDn6+yH2INN1/e4Jf/lcpy1zRCMrnnxVPS2zpcuWlkus2vHYdouGf
         stccMiiW8gaUi7ZOwTFiLW5bHdHB31I1JwjQw+QU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 038/131] selftests/bpf: do not ignore clang failures
Date:   Mon,  5 Aug 2019 15:02:05 +0200
Message-Id: <20190805124953.988355516@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9cae4ace80ef39005da106fbb89c952b27d7b89e ]

When compiling an eBPF prog fails, make still returns 0, because
failing clang command's output is piped to llc and therefore its
exit status is ignored.

When clang fails, pipe the string "clang failed" to llc. This will make
llc fail with an informative error message. This solution was chosen
over using pipefail, having separate targets or getting rid of llc
invocation due to its simplicity.

In addition, pull Kbuild.include in order to get .DELETE_ON_ERROR target,
which would cause partial .o files to be removed.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 1c95112629477..f1573a11d3e41 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
+include ../../../../scripts/Kbuild.include
 
 LIBDIR := ../../../lib
 BPFDIR := $(LIBDIR)/bpf
@@ -185,8 +186,8 @@ $(ALU32_BUILD_DIR)/test_progs_32: prog_tests/*.c
 
 $(ALU32_BUILD_DIR)/%.o: progs/%.c $(ALU32_BUILD_DIR) \
 					$(ALU32_BUILD_DIR)/test_progs_32
-	$(CLANG) $(CLANG_FLAGS) \
-		 -O2 -target bpf -emit-llvm -c $< -o - |      \
+	($(CLANG) $(CLANG_FLAGS) -O2 -target bpf -emit-llvm -c $< -o - || \
+		echo "clang failed") | \
 	$(LLC) -march=bpf -mattr=+alu32 -mcpu=$(CPU) $(LLC_FLAGS) \
 		-filetype=obj -o $@
 ifeq ($(DWARF2BTF),y)
@@ -197,16 +198,16 @@ endif
 # Have one program compiled without "-target bpf" to test whether libbpf loads
 # it successfully
 $(OUTPUT)/test_xdp.o: progs/test_xdp.c
-	$(CLANG) $(CLANG_FLAGS) \
-		-O2 -emit-llvm -c $< -o - | \
+	($(CLANG) $(CLANG_FLAGS) -O2 -emit-llvm -c $< -o - || \
+		echo "clang failed") | \
 	$(LLC) -march=bpf -mcpu=$(CPU) $(LLC_FLAGS) -filetype=obj -o $@
 ifeq ($(DWARF2BTF),y)
 	$(BTF_PAHOLE) -J $@
 endif
 
 $(OUTPUT)/%.o: progs/%.c
-	$(CLANG) $(CLANG_FLAGS) \
-		 -O2 -target bpf -emit-llvm -c $< -o - |      \
+	($(CLANG) $(CLANG_FLAGS) -O2 -target bpf -emit-llvm -c $< -o - || \
+		echo "clang failed") | \
 	$(LLC) -march=bpf -mcpu=$(CPU) $(LLC_FLAGS) -filetype=obj -o $@
 ifeq ($(DWARF2BTF),y)
 	$(BTF_PAHOLE) -J $@
-- 
2.20.1



