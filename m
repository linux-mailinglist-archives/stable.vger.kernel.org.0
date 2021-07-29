Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC923DA520
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 15:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237975AbhG2N6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 09:58:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238289AbhG2N54 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:57:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8780E61019;
        Thu, 29 Jul 2021 13:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627567073;
        bh=vnuB0YMTDTV4aN/s0lEZdXViNcICe+fh86uUv3TAXbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C3lBLIFosCmqkVg62b8qLBI4UiElN4BJmTzSqoOV3owMC5bsPzbGYbxyyNuZ99sYc
         Pj7cUWIsf3srNstrmPUIv6ybpnRrgLLx0nHxiNAqJDIw4m+poS7ogB0+maI42yso5x
         9NlCgsQ1Xm/SuyqhPN+FWg1W1wi0l1Nsg0reQLpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 5.10 01/24] tools: Allow proper CC/CXX/... override with LLVM=1 in Makefile.include
Date:   Thu, 29 Jul 2021 15:54:21 +0200
Message-Id: <20210729135137.312664710@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729135137.267680390@linuxfoundation.org>
References: <20210729135137.267680390@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

commit f62700ce63a315b4607cc9e97aa15ea409a677b9 upstream.

selftests/bpf/Makefile includes tools/scripts/Makefile.include.
With the following command
  make -j60 LLVM=1 LLVM_IAS=1  <=== compile kernel
  make -j60 -C tools/testing/selftests/bpf LLVM=1 LLVM_IAS=1 V=1
some files are still compiled with gcc. This patch
fixed the case if CC/AR/LD/CXX/STRIP is allowed to be
overridden, it will be written to clang/llvm-ar/..., instead of
gcc binaries. The definition of CC_NO_CLANG is also relocated
to the place after the above CC is defined.

Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210413153419.3028165-1-yhs@fb.com
Cc: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/scripts/Makefile.include |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -39,8 +39,6 @@ EXTRA_WARNINGS += -Wundef
 EXTRA_WARNINGS += -Wwrite-strings
 EXTRA_WARNINGS += -Wformat
 
-CC_NO_CLANG := $(shell $(CC) -dM -E -x c /dev/null | grep -Fq "__clang__"; echo $$?)
-
 # Makefiles suck: This macro sets a default value of $(2) for the
 # variable named by $(1), unless the variable has been set by
 # environment or command line. This is necessary for CC and AR
@@ -52,12 +50,22 @@ define allow-override
     $(eval $(1) = $(2)))
 endef
 
+ifneq ($(LLVM),)
+$(call allow-override,CC,clang)
+$(call allow-override,AR,llvm-ar)
+$(call allow-override,LD,ld.lld)
+$(call allow-override,CXX,clang++)
+$(call allow-override,STRIP,llvm-strip)
+else
 # Allow setting various cross-compile vars or setting CROSS_COMPILE as a prefix.
 $(call allow-override,CC,$(CROSS_COMPILE)gcc)
 $(call allow-override,AR,$(CROSS_COMPILE)ar)
 $(call allow-override,LD,$(CROSS_COMPILE)ld)
 $(call allow-override,CXX,$(CROSS_COMPILE)g++)
 $(call allow-override,STRIP,$(CROSS_COMPILE)strip)
+endif
+
+CC_NO_CLANG := $(shell $(CC) -dM -E -x c /dev/null | grep -Fq "__clang__"; echo $$?)
 
 ifneq ($(LLVM),)
 HOSTAR  ?= llvm-ar


