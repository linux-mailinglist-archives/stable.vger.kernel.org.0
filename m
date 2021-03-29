Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E472D34DAC4
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbhC2WXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:23:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232268AbhC2WW4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:22:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B080D619C2;
        Mon, 29 Mar 2021 22:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056575;
        bh=yD6peMmSWVz5U0F2U/JDgRARKAZNOKTTL7H25m6GzpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PDSkPsLy4gnPVOZqGfG1NtBzV4Stdm/NPFFLzhDdtHDx28M+cxRztRNfXMgqE7Aaz
         2E+wesARBaGqFXqkVKhHypLBVUz+YoP2LNGl4ofJ/ebvyMsKovoXGtjE++FzbVITWs
         v/MuLkgSbBTjp26VQ0CJLvmxp43F5713z99uibl48CUjYUrHfG3ZZSBG1qLROVCT+q
         EfV6ODFafKud0iqBdOssnn3KEBw5fZLV+wBWnwpJ5s91oAt3gcxfTiddWqZpEbGDSf
         wGAXzbvImb3ePXEwiURVDr/JJngzVvu4nTK5PfCVkT8Q8/zcAg/CmiaI3rww7EYyM9
         IGibCg+MvTCsA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rong Chen <rong.a.chen@intel.com>,
        kernel test robot <lkp@intel.com>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 27/33] selftests/vm: fix out-of-tree build
Date:   Mon, 29 Mar 2021 18:22:15 -0400
Message-Id: <20210329222222.2382987-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222222.2382987-1-sashal@kernel.org>
References: <20210329222222.2382987-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rong Chen <rong.a.chen@intel.com>

[ Upstream commit 19ec368cbc7ee1915e78c120b7a49c7f14734192 ]

When building out-of-tree, attempting to make target from $(OUTPUT) directory:

  make[1]: *** No rule to make target '$(OUTPUT)/protection_keys.c', needed by '$(OUTPUT)/protection_keys_32'.

Link: https://lkml.kernel.org/r/20210315094700.522753-1-rong.a.chen@intel.com
Signed-off-by: Rong Chen <rong.a.chen@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index e63f31632708..2cf32e6b376e 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -99,7 +99,7 @@ endef
 ifeq ($(CAN_BUILD_I386),1)
 $(BINARIES_32): CFLAGS += -m32
 $(BINARIES_32): LDLIBS += -lrt -ldl -lm
-$(BINARIES_32): %_32: %.c
+$(BINARIES_32): $(OUTPUT)/%_32: %.c
 	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
 $(foreach t,$(TARGETS),$(eval $(call gen-target-rule-32,$(t))))
 endif
@@ -107,7 +107,7 @@ endif
 ifeq ($(CAN_BUILD_X86_64),1)
 $(BINARIES_64): CFLAGS += -m64
 $(BINARIES_64): LDLIBS += -lrt -ldl
-$(BINARIES_64): %_64: %.c
+$(BINARIES_64): $(OUTPUT)/%_64: %.c
 	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
 $(foreach t,$(TARGETS),$(eval $(call gen-target-rule-64,$(t))))
 endif
-- 
2.30.1

