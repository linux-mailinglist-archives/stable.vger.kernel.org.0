Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701F24F2BA4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356419AbiDEKXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236373AbiDEJbT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:31:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0DA0BF7;
        Tue,  5 Apr 2022 02:19:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97E08B81C69;
        Tue,  5 Apr 2022 09:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB9BC385A3;
        Tue,  5 Apr 2022 09:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150345;
        bh=qYe/uBk0ndVaKY+4X1OhfMJEXd3Z6e/VbB81NnZOuOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IMH8nnoewWUeKqhhIUM5cCCDEe+2cNpdSZ577z/cC1CW8VTLPCw5ayed1CRFFlQ9F
         GVkU7rGXB/3LgqeSfTlVDv2T5ZjKTaQhhwpIfw1NIoRlSq2LDnOw1GZH7LxlYulCnC
         GvXpFs+hQDtBiVW1YY66hgYnffyDSL1AtOKI5w8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>,
        Shuah Khan <shuah@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/913] selftests: vm: fix clang build error multiple output files
Date:   Tue,  5 Apr 2022 09:18:06 +0200
Message-Id: <20220405070340.539745810@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



