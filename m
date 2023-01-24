Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8076799E4
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234349AbjAXNm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234315AbjAXNmm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:42:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868D13F298;
        Tue, 24 Jan 2023 05:42:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E2B2B811E7;
        Tue, 24 Jan 2023 13:42:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2EEC4339C;
        Tue, 24 Jan 2023 13:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567721;
        bh=zL2k4u+Jj8vLXa5xAgk1+a1szX++mO4axPA7wz/3+pU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bIY6HWCwTjlQnOIEWiF5yFaQVuTUvQ9qDxUwkhiJLkQdMkK8PM/hTqkwbfjTM3uMi
         ndGHX7qXzsf8x8O4O/GopZf2nsnEPcd5ixeIq/BkG+bBqvvz0fCMVuc0Lf4MqLMjIk
         tmdHjE71pYRxTlFVfVFT+Ujl7hQ82Y08A7sKLbg9IBYS5D1v71a03/o5JfI9+sVuBr
         0vxTJbrWfBPCNrCn+Ju264BFEUlNZ6jBwujhd/RWlbIjY5x+i72eP9zn/l801nOjJF
         jvq+O64T1JSKWW1ZH9OSc6FvrOTBapDg3wamDFJx2+DDv0CnC4E52CRHrLCriaVHq/
         DbA3i14k/2+mw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com,
        linux-kselftest@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.1 12/35] kselftest: Fix error message for unconfigured LLVM builds
Date:   Tue, 24 Jan 2023 08:41:08 -0500
Message-Id: <20230124134131.637036-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134131.637036-1-sashal@kernel.org>
References: <20230124134131.637036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 9fdaca2c1e157dc0a3c0faecf3a6a68e7d8d0c7b ]

We are missing a ) when we attempt to complain about not having enough
configuration for clang, resulting in the rather inscrutable error:

../lib.mk:23: *** unterminated call to function 'error': missing ')'.  Stop.

Add the required ) so we print the message we were trying to print.

Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/lib.mk | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 291144c284fb..f7900e75d230 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -20,7 +20,7 @@ CLANG_TARGET_FLAGS              := $(CLANG_TARGET_FLAGS_$(ARCH))
 
 ifeq ($(CROSS_COMPILE),)
 ifeq ($(CLANG_TARGET_FLAGS),)
-$(error Specify CROSS_COMPILE or add '--target=' option to lib.mk
+$(error Specify CROSS_COMPILE or add '--target=' option to lib.mk)
 else
 CLANG_FLAGS     += --target=$(CLANG_TARGET_FLAGS)
 endif # CLANG_TARGET_FLAGS
-- 
2.39.0

