Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD2C4E3353
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 23:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbiCUW5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 18:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbiCUW5A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 18:57:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556113BED34;
        Mon, 21 Mar 2022 15:37:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4AEB612B2;
        Mon, 21 Mar 2022 21:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1386C340EE;
        Mon, 21 Mar 2022 21:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647899573;
        bh=dyOSNsBIOAtZ7vGm89+pK75rTiVRFKBYVcdnYc/Tqyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hKYd4xyiZBkMI4yuRA/8hErx9o+PvXRfji1Z0y9/HDegqUTt0h8M1w9TK2w2QcAqf
         W5pGZ/+zF1Nv2koHR77xl0r8J1csvPULFTmH48rBnW2vF91kC9jGMGQ/Zybvi+2hea
         gnIC7rPWHQUIeYFQ6hHy/PGvAVSKsz1TWtDWKzkY+733oSNR6zPzkZUjBKeLie5cpL
         SRWtfIEnhH/0BOgaa9QE60Gc+VkViKeLMOpXLLPKC72mEQAAQRE98RXlDjp1yXLQ7W
         e0hbTnI2wOKChBUwlpB/M74HNoIm2C3GWbFh7CQp2XQ01S1Z4LTOqOkR3toxVOv04/
         I3Af4jN1GFNfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yosry Ahmed <yosryahmed@google.com>, Shuah Khan <shuah@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.16 6/6] selftests: vm: fix clang build error multiple output files
Date:   Mon, 21 Mar 2022 17:52:37 -0400
Message-Id: <20220321215240.490132-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220321215240.490132-1-sashal@kernel.org>
References: <20220321215240.490132-1-sashal@kernel.org>
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
index 1607322a112c..a14b5b800897 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for vm selftests
 
+LOCAL_HDRS += $(selfdir)/vm/local_config.h $(top_srcdir)/mm/gup_test.h
+
 include local_config.mk
 
 uname_M := $(shell uname -m 2>/dev/null || echo not)
@@ -140,10 +142,6 @@ endif
 
 $(OUTPUT)/mlock-random-test $(OUTPUT)/memfd_secret: LDLIBS += -lcap
 
-$(OUTPUT)/gup_test: ../../../../mm/gup_test.h
-
-$(OUTPUT)/hmm-tests: local_config.h
-
 # HMM_EXTRA_LIBS may get set in local_config.mk, or it may be left empty.
 $(OUTPUT)/hmm-tests: LDLIBS += $(HMM_EXTRA_LIBS)
 
-- 
2.34.1

