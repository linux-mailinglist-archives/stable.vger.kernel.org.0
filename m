Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90494590186
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237070AbiHKP5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237415AbiHKP42 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:56:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06919A2850;
        Thu, 11 Aug 2022 08:47:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BE2FB82162;
        Thu, 11 Aug 2022 15:47:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FABC433C1;
        Thu, 11 Aug 2022 15:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232829;
        bh=XigKxQKnX8HVGGyUm7u2+VJg1iggexTC6eLWlfLd0Og=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tVnvTXZarE0nV9Q8ZDoDgzN94LkA5UimxOQVjPcZeN0yxqsUhqpEeeJ9VPBWgBL3O
         Z1/JorieoMo6cvVvNiksfQT3Prp9mGKW5lE89FUeXk9WUaShuy+JeFmUG8RhY4Tcx7
         1v3IO9IblUwrho/wJzWV41L2CUKXm6T7ztVv7jL/eUAX6swZi4GpUt68wGjObpGOtW
         XnWgeRTCnpl1eKp0uYHQihK6beUlc0oEDtsruvF4huCzJN4jVOFZaqyjUlUCwXgosw
         oKjMt0lLJfYUZMysVHKziEcb5AVvCc0Bsb/8T+mtYT0AxtDc4rEZJ+6ARDaieK/ez0
         6BRXNpJ+zYwKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gautam <gautammenghani201@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 45/93] kselftests: Enable the echo command to print newlines in Makefile
Date:   Thu, 11 Aug 2022 11:41:39 -0400
Message-Id: <20220811154237.1531313-45-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
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
index bd2ac8b3bf1f..197126a6614e 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -251,7 +251,7 @@ ifdef INSTALL_PATH
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

