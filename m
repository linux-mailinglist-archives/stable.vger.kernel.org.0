Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C182D590376
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238147AbiHKQ0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237933AbiHKQY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:24:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FE92AE1C;
        Thu, 11 Aug 2022 09:06:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F22B8612F4;
        Thu, 11 Aug 2022 16:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF4CC433D6;
        Thu, 11 Aug 2022 16:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233996;
        bh=1k0g9Lhh2lfOxoM8zP7AtYUnS9VWBbR9RZcMDRlaSPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=svyixU7en3i00Vs3MK6/eYRiduLI2pSYdH7eeTi170NddSwqQpuCSZySZBkCA6S5s
         IsFae/tb1o8TfGCPAo91urPluXmT6LEIuopCzIwWnOhYzjPgPL28E7Ra6K6hB+l5BR
         Sd+vWVtPWmb8JFI24BGBg8JFMMTjKdZ0n/Sy9kk9oPvXxIhoO6Xz7tv1h6RaLOODc0
         8iaCEnYJq0OB33y1VG4XOBDKx6cMb70ZYm2URrel2gN8/slL3gVKAS9pha1JQhNEEX
         cFRYMt2RYmRigNfuzuZj21apbNahZ3xJOueknylxemwi768YmeNxv9YVXSaE6eCc/1
         nYwWn6CKKEDUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gautam <gautammenghani201@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 27/46] kselftests: Enable the echo command to print newlines in Makefile
Date:   Thu, 11 Aug 2022 12:03:51 -0400
Message-Id: <20220811160421.1539956-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811160421.1539956-1-sashal@kernel.org>
References: <20220811160421.1539956-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gautam <gautammenghani201@gmail.com>

[ Upstream commit 3297a4df805d4263506b6dfec4d1bbeff8862dd8 ]

In the install section of the main Makefile of kselftests, the echo
command is used with -n flag, which disables the printing of new line
due to which the output contains "\n" chars as follows:

  Emit Tests for alsa\nSkipping non-existent dir: arm64
  Emit Tests for breakpoints\nEmit Tests for capabilities\n

This patch fixes the above bug by using the -e flag.

Signed-off-by: Gautam <gautammenghani201@gmail.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index d9c283503159..a90eacec83ee 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -233,7 +233,7 @@ ifdef INSTALL_PATH
 	for TARGET in $(TARGETS); do \
 		BUILD_TARGET=$$BUILD/$$TARGET;	\
 		[ ! -d $(INSTALL_PATH)/$$TARGET ] && echo "Skipping non-existent dir: $$TARGET" && continue; \
-		echo -n "Emit Tests for $$TARGET\n"; \
+		echo -ne "Emit Tests for $$TARGET\n"; \
 		$(MAKE) -s --no-print-directory OUTPUT=$$BUILD_TARGET COLLECTION=$$TARGET \
 			-C $$TARGET emit_tests >> $(TEST_LIST); \
 	done;
-- 
2.35.1

