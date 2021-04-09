Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3E6359ABE
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbhDIKC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:02:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233051AbhDIKAQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:00:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22212611C9;
        Fri,  9 Apr 2021 09:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962353;
        bh=tXKmzpCbT9s7J37IwQBYuV4y+Yq/h+U1KgJkOK62ihU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jshnfIY4CwSlUCmQwzTZL7hmXPZ3lfP2aQRsw0aUzh+wqzSHAtbhYvbLph4N9A2Gg
         /S4rbtB9RKClmdHnSLYdGGrZAbj9/kKNUaBmzmGB8LYMWip0iz016zJCFgkyuR5YGC
         QdYsMT3ck6I2Mfu1iMslsVqdhb4kWsMSy89NlgOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rong Chen <rong.a.chen@intel.com>,
        kernel test robot <lkp@intel.com>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 25/41] selftests/vm: fix out-of-tree build
Date:   Fri,  9 Apr 2021 11:53:47 +0200
Message-Id: <20210409095305.631075115@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095304.818847860@linuxfoundation.org>
References: <20210409095304.818847860@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.30.2



