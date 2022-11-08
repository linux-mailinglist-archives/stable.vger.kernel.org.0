Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFE06215AC
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235284AbiKHOOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:14:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235289AbiKHOOD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:14:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5DA6152
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:14:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DCE3615DD
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3FDC433D7;
        Tue,  8 Nov 2022 14:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916841;
        bh=3rAyITHvXRN28NP+X1DFtmCLekyzDUVTjiT456fTKjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rdRVP7rQV0vWR5wEGhnERZ7DHLL0WteE7d3he1tncJsyGmuDH88mgBH70S/AS3L4z
         N2kyZ4jNjhmVOKBV5nm0JqIfqhL7uAU1MMCrEkiaqzTgpuuODC7fTvjApBC756cwrH
         v4Qq/QnLx9lP8a7cwPNFXxZWDApI2mD8ykIJJ9AA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anders Roxell <anders.roxell@linaro.org>,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        Mark Brown <broonie@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.0 149/197] selftests/landlock: Build without static libraries
Date:   Tue,  8 Nov 2022 14:39:47 +0100
Message-Id: <20221108133401.741126738@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mickaël Salaün <mic@digikod.net>

commit 091873e47ef700e935aa80079b63929af599a0b2 upstream.

The only (forced) static test binary doesn't depend on libcap.  Because
using -lcap on systems that don't have such static library would fail
(e.g. on Arch Linux), let's be more specific and require only dynamic
libcap linking.

Fixes: a52540522c95 ("selftests/landlock: Fix out-of-tree builds")
Cc: Anders Roxell <anders.roxell@linaro.org>
Cc: Guillaume Tucker <guillaume.tucker@collabora.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20221019200536.2771316-1-mic@digikod.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/landlock/Makefile | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/landlock/Makefile b/tools/testing/selftests/landlock/Makefile
index 6632bfff486b..348e2dbdb4e0 100644
--- a/tools/testing/selftests/landlock/Makefile
+++ b/tools/testing/selftests/landlock/Makefile
@@ -3,7 +3,6 @@
 # First run: make -C ../../../.. headers_install
 
 CFLAGS += -Wall -O2 $(KHDR_INCLUDES)
-LDLIBS += -lcap
 
 LOCAL_HDRS += common.h
 
@@ -13,10 +12,12 @@ TEST_GEN_PROGS := $(src_test:.c=)
 
 TEST_GEN_PROGS_EXTENDED := true
 
-# Static linking for short targets:
+# Short targets:
+$(TEST_GEN_PROGS): LDLIBS += -lcap
 $(TEST_GEN_PROGS_EXTENDED): LDFLAGS += -static
 
 include ../lib.mk
 
-# Static linking for targets with $(OUTPUT)/ prefix:
+# Targets with $(OUTPUT)/ prefix:
+$(TEST_GEN_PROGS): LDLIBS += -lcap
 $(TEST_GEN_PROGS_EXTENDED): LDFLAGS += -static
-- 
2.38.1



