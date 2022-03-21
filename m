Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 274414E3399
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 23:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbiCUW5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 18:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbiCUW5P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 18:57:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817B83B2073;
        Mon, 21 Mar 2022 15:37:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B520BB81A61;
        Mon, 21 Mar 2022 21:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7E5C340F2;
        Mon, 21 Mar 2022 21:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647899585;
        bh=qYe/uBk0ndVaKY+4X1OhfMJEXd3Z6e/VbB81NnZOuOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m7u+vGjuU+kjaU5T6xXNPRR2Kej2ocgXxK1oSfdVwVdJsbbu3/AMHRBC/8YPM13GB
         tqCxrGaRiXW2Vn2W62qxKUuP4Ufuo6b4bCxQ+6qDygiA/WyJe1f3QDISU5twDsfDYv
         vzUxy85giTapQamuIi3JFzqzCwIPn8eXzdIe0jmbh70lP41XdurgxMpvlYWYA0FfOP
         77EnX0SmVAdfeL93YBIvn5/kkMxbdpI+3Bh9tDu8qQ0r4tIlihElaLnEhaAAz4XFJr
         xMZ4X+qI0j7hYy5nk9Cl+minAbJkjl8cn4IO8/oEBxWVSgbQvVrH1o9bw0IbXc+k0C
         aM0dlaH+37BKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yosry Ahmed <yosryahmed@google.com>, Shuah Khan <shuah@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 5/5] selftests: vm: fix clang build error multiple output files
Date:   Mon, 21 Mar 2022 17:52:53 -0400
Message-Id: <20220321215256.490267-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220321215256.490267-1-sashal@kernel.org>
References: <20220321215256.490267-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yosry Ahmed <yosryahmed@google.com>

[ Upstream commit 1c4debc443ef7037dcb7c4f08c33b9caebd21d2e ]

When building the vm selftests using clang, some errors are seen due to
having headers in the compilation command:

  clang -Wall -I ../../../../usr/include  -no-pie    gup_test.c ../../../../mm/gup_test.h -lrt -lpthread -o .../tools/testing/selftests/vm/gup_test
  clang: error: cannot specify -o when generating multiple output files
  make[1]: *** [../lib.mk:146: .../tools/testing/selftests/vm/gup_test] Error 1

Rework to add the header files to LOCAL_HDRS before including ../lib.mk,
since the dependency is evaluated in '$(OUTPUT)/%:%.c $(LOCAL_HDRS)' in
file lib.mk.

Link: https://lkml.kernel.org/r/20220304000645.1888133-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/Makefile | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index d9605bd10f2d..acf5eaeef9ff 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for vm selftests
 
+LOCAL_HDRS += $(selfdir)/vm/local_config.h $(top_srcdir)/mm/gup_test.h
+
 include local_config.mk
 
 uname_M := $(shell uname -m 2>/dev/null || echo not)
@@ -139,10 +141,6 @@ endif
 
 $(OUTPUT)/mlock-random-test $(OUTPUT)/memfd_secret: LDLIBS += -lcap
 
-$(OUTPUT)/gup_test: ../../../../mm/gup_test.h
-
-$(OUTPUT)/hmm-tests: local_config.h
-
 # HMM_EXTRA_LIBS may get set in local_config.mk, or it may be left empty.
 $(OUTPUT)/hmm-tests: LDLIBS += $(HMM_EXTRA_LIBS)
 
-- 
2.34.1

