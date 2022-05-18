Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5431052B0AF
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 05:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiERDSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 23:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiERDSI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 23:18:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C7961286;
        Tue, 17 May 2022 20:18:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EC78B81E5A;
        Wed, 18 May 2022 03:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC47C385AA;
        Wed, 18 May 2022 03:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652843878;
        bh=gRuTuRdI7OLIZp+f42a0XTQ5exBH9nOXmC6bIp3yNV0=;
        h=From:To:Cc:Subject:Date:From;
        b=HlGpi0/Cg0JdE2lY0HpdF1AlVnf/p+ozQgTyorU165UOEJa0dYP9pHtf7Tf+jxHHP
         ChVI4bUn/exGNh73MDbfZjgFABoxSyEmI/vfkDNmMAxFYCLG8H7+H8MqiyYxHMV3rB
         YOi+z+t4rkiDi+cAy/ac2IhgiCx04gZX+yH5+2WLdW4oouKLlwwcmebpvWRKX1g3Cn
         z6qBZCYhEA9rEDFRPZy+OO5HTE2XPH7/fiMbkwcINk+s3/qqkzaTTHVdZ8gyvxOilr
         GF9M2ULTe6gj4lbgMQSX0MMuR1Vv1F3+XUt88iNPWKSdvKVYGHsYkS88sW1azY0FoL
         xOt3WqQ4Z9DEg==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        linux-sgx@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] selftests/sgx: add test_encl.elf to TEST_GEN_FILES
Date:   Wed, 18 May 2022 06:16:19 +0300
Message-Id: <20220518031619.1179862-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 tools/testing/selftests/sgx/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/sgx/Makefile b/tools/testing/selftests/sgx/Makefile
index 75af864e07b6..f3f312904bcc 100644
--- a/tools/testing/selftests/sgx/Makefile
+++ b/tools/testing/selftests/sgx/Makefile
@@ -17,6 +17,7 @@ ENCL_CFLAGS := -Wall -Werror -static -nostdlib -nostartfiles -fPIC \
 	       -fno-stack-protector -mrdrnd $(INCLUDES)
 
 TEST_CUSTOM_PROGS := $(OUTPUT)/test_sgx
+TEST_GEN_FILES := $(OUTPUT)/test_encl.elf
 
 ifeq ($(CAN_BUILD_X86_64), 1)
 all: $(TEST_CUSTOM_PROGS) $(OUTPUT)/test_encl.elf
-- 
2.36.1

