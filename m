Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8509590323
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237628AbiHKQTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237633AbiHKQSv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:18:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A424962DF;
        Thu, 11 Aug 2022 09:01:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64668B82166;
        Thu, 11 Aug 2022 16:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36660C433B5;
        Thu, 11 Aug 2022 16:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233658;
        bh=o19kBgzOZ6Nf2Slumy4yFLH0CGl+Wyk7gAV0NC4RciQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q2B9CyTXnXRsKPDlq5hV77Rq3fwSlo0iV/huazhGYeiOqIsnqnM8dsiNj7er3qmvO
         u7TYq6BvjIxX1r/SiDzjOVUaAjPyzT3UmTNlOm63tuKqPVebVeb8rYUTmPAxOK9HA8
         daEg57C9mLXT5QxTonUctHkfpUd/OT/TP7HMcXgKgsPqq5g2WGroTAckchzuhqZyUr
         7yMRQFxFNhh611PUcGbjwVbZnGC/K265zf0lE91ijsUZBCVB39J3ATPlTSVLNoP3u/
         tVVpqyPvXYVTipLIH0XDbvvNmOc2v3Wp4l82QQdeqmlyTpp23/nYSOfMq7qpm3EBX6
         uKdiVjrSXzv/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gautam <gautammenghani201@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 39/69] kselftests: Enable the echo command to print newlines in Makefile
Date:   Thu, 11 Aug 2022 11:55:48 -0400
Message-Id: <20220811155632.1536867-39-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811155632.1536867-1-sashal@kernel.org>
References: <20220811155632.1536867-1-sashal@kernel.org>
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
index 14206d1d1efe..5fe0bd7e05d8 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -235,7 +235,7 @@ ifdef INSTALL_PATH
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

