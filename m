Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35F5F53177F
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239388AbiEWSfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 14:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239620AbiEWSfQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 14:35:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3647237A08;
        Mon, 23 May 2022 11:13:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AA6E614B2;
        Mon, 23 May 2022 18:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BD5C385A9;
        Mon, 23 May 2022 18:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653329585;
        bh=5I0HfikDccwyhVscEZO/bun3P5f/cxGvdT/T0TkbS10=;
        h=From:To:Cc:Subject:Date:From;
        b=gl809vgi4yyyRaYOOm6YoPjPi0QTc7FJZ7tkdT2ftzR96j3ftaW2lG730jZyAfBlT
         CGffwUazv+tN80q2pN1PiJr6aZ1btcKPYvmwVB3KnAzNuoVSmR4d3UzEMpx/RHyn/Z
         wT1hWH8qWEKqyPSRqv/1o6GMCSzScTdev87DtMcH9Z2NVz1K4wMNXN5HCU6e8J/qoc
         om0XYSg9yMfmPnIIkaXFXUXwVf00RhcF0th0DX2qZtn1Rpt+T2PB3w5toLViMYRMcH
         So/F90JljZeoZzzCu+i0dkEmBPaz+maTuUqDIQ9kDqnoyGrUe89nbdmNdoEKa/Bmwx
         kiACbl5zoY0lw==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Shuah Khan <shuah@kernel.org>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, stable@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Borislav Petkov <bp@suse.de>, linux-sgx@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] selftests/sgx: add test_encl.elf to TEST_GEN_FILES
Date:   Mon, 23 May 2022 21:11:20 +0300
Message-Id: <20220523181120.54547-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

TEST_GEN_FILES contains files that are generated during compilation and are
required to be included together with the test binaries, e.g. when
performing:

make -C tools/testing/selftests install INSTALL_PATH=/some/other/path [*]

Add test_encl.elf to TEST_GEN_FILES because otherwise the installed test
binary will fail to run.

[*] https://docs.kernel.org/dev-tools/kselftest.html

Cc: stable@vger.kernel.org
Fixes: 2adcba79e69d ("selftests/x86: Add a selftest for SGX")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
v2:
Use TEST_GEN_FILES in the "all" target, instead of duplicating the path for
test_encl.elf.
---
 tools/testing/selftests/sgx/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/sgx/Makefile b/tools/testing/selftests/sgx/Makefile
index 75af864e07b6..7f60811b5b20 100644
--- a/tools/testing/selftests/sgx/Makefile
+++ b/tools/testing/selftests/sgx/Makefile
@@ -17,9 +17,10 @@ ENCL_CFLAGS := -Wall -Werror -static -nostdlib -nostartfiles -fPIC \
 	       -fno-stack-protector -mrdrnd $(INCLUDES)
 
 TEST_CUSTOM_PROGS := $(OUTPUT)/test_sgx
+TEST_GEN_FILES := $(OUTPUT)/test_encl.elf
 
 ifeq ($(CAN_BUILD_X86_64), 1)
-all: $(TEST_CUSTOM_PROGS) $(OUTPUT)/test_encl.elf
+all: $(TEST_CUSTOM_PROGS) $(TEST_GEN_FILES)
 endif
 
 $(OUTPUT)/test_sgx: $(OUTPUT)/main.o \
-- 
2.36.1

