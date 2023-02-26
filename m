Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA11E6A3276
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 16:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjBZPmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 10:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjBZPmR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 10:42:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C705611B;
        Sun, 26 Feb 2023 07:42:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91C5060C5C;
        Sun, 26 Feb 2023 14:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF20C4339B;
        Sun, 26 Feb 2023 14:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422879;
        bh=X9kD3aKgNfLlx5BDHcTQjJAPnMiXAQhR9GFvlDICCWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/wVEy2L6gzET+fvlM+x6DmvLXzbAVkfZl7ESW9UhTksUxEd/iST27sDr95saVIFn
         F3CcaLj0FvxyDja8dCDBHzzHiMxkfBoFsxdhkLLZTtzD2Wq/DfbVQgYtBOJoVzJ8Jw
         mxWuTuTQUaZiSehWcNZlmXNEM5i01lyEOeqADMMQQe3lwhSdyLROZe3NQPPeZPT6/d
         DK5BOJ6fZ63LChHRflTVUK3LCcbSLZUdJSRzrN6TGYuyKXAiZIKcapd/dBV44y5gf+
         9QoRlzvuYJxuFkqUD+M+s90zYJRQ59OTlKKKQ7DRb0jsjQ9y14OBHGvRQrJk1v+UCB
         lV2uyNO+L67GQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sam James <sam@gentoo.org>, Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 30/49] gcc-plugins: drop -std=gnu++11 to fix GCC 13 build
Date:   Sun, 26 Feb 2023 09:46:30 -0500
Message-Id: <20230226144650.826470-30-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144650.826470-1-sashal@kernel.org>
References: <20230226144650.826470-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sam James <sam@gentoo.org>

[ Upstream commit 5a6b64adc18d9adfb497a529ff004d59b6df151f ]

The latest GCC 13 snapshot (13.0.1 20230129) gives the following:
```
cc1: error: cannot load plugin ./scripts/gcc-plugins/randomize_layout_plugin.so
 :./scripts/gcc-plugins/randomize_layout_plugin.so: undefined symbol: tree_code_type
```

This ends up being because of https://gcc.gnu.org/git/gitweb.cgi?p=gcc.git;h=b0241ce6e37031
upstream in GCC which changes the visibility of some types used by the kernel's
plugin infrastructure like tree_code_type.

After discussion with the GCC folks, we found that the kernel needs to be building
plugins with the same flags used to build GCC - and GCC defaults to gnu++17
right now. The minimum GCC version needed to build the kernel is GCC 5.1
and GCC 5.1 already defaults to gnu++14 anyway, so just drop the flag, as
all GCCs that could be used to build GCC already default to an acceptable
version which was >= the version we forced via flags until now.

Bug: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=108634
Signed-off-by: Sam James <sam@gentoo.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20230201230009.2252783-1-sam@gentoo.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gcc-plugins/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gcc-plugins/Makefile b/scripts/gcc-plugins/Makefile
index b34d11e226366..320afd3cf8e82 100644
--- a/scripts/gcc-plugins/Makefile
+++ b/scripts/gcc-plugins/Makefile
@@ -29,7 +29,7 @@ GCC_PLUGINS_DIR = $(shell $(CC) -print-file-name=plugin)
 plugin_cxxflags	= -Wp,-MMD,$(depfile) $(KBUILD_HOSTCXXFLAGS) -fPIC \
 		  -include $(srctree)/include/linux/compiler-version.h \
 		  -DPLUGIN_VERSION=$(call stringify,$(KERNELVERSION)) \
-		  -I $(GCC_PLUGINS_DIR)/include -I $(obj) -std=gnu++11 \
+		  -I $(GCC_PLUGINS_DIR)/include -I $(obj) \
 		  -fno-rtti -fno-exceptions -fasynchronous-unwind-tables \
 		  -ggdb -Wno-narrowing -Wno-unused-variable \
 		  -Wno-format-diag
-- 
2.39.0

