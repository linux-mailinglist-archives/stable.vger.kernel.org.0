Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E266E4EF33D
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349295AbiDAOxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350569AbiDAOrm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:47:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE982856A4;
        Fri,  1 Apr 2022 07:38:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F131B82519;
        Fri,  1 Apr 2022 14:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F03C2BBE4;
        Fri,  1 Apr 2022 14:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823853;
        bh=q8YSV0KJMrMQvGXSF/R+p/9Qsw994QlDUKjq0tKclzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IyVg0rJ3dyB/sXk3hkbGqrqThQeGps5f/2BSnzk/ddcEWvOZXSCdbfHiK9jam6nyG
         mngCJ7XEIMpOa8aK/l3Q7XfkiirUsDLnIRleO7sj/qwQmqH9nWUse6tugLgLfiadV6
         D1C4T7XllxZqaUaiUT4Zw7ZyNoBAxWrX48A2Qpq7ZOehg+0fbZAwsszL6JTIJbL2b1
         X8dzINFAyFy2FynccSvzAmKI8cFoEVU/bR66QtRJOqZ9yAwRNzROxRoePa5lmitl02
         fUfG/pFRKuP/6OThvmaPRn7T8jT9vUM2VKCdq/NK7TvEhGcsQIoUVrRPYNCw5PJnT6
         JoJLLoJKjLDkw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Feng Tang <feng.tang@intel.com>, kernel test robot <lkp@intel.com>,
        Guo Ren <guoren@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, nathan@kernel.org,
        peterz@infradead.org, masahiroy@kernel.org,
        ndesaulniers@google.com, keescook@chromium.org,
        penguin-kernel@I-love.SAKURA.ne.jp, isabbasso@riseup.net,
        dan.j.williams@intel.com, linux-csky@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 107/109] lib/Kconfig.debug: add ARCH dependency for FUNCTION_ALIGN option
Date:   Fri,  1 Apr 2022 10:32:54 -0400
Message-Id: <20220401143256.1950537-107-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143256.1950537-1-sashal@kernel.org>
References: <20220401143256.1950537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Feng Tang <feng.tang@intel.com>

[ Upstream commit 1bf18da62106225dbc47aab41efee2aeb99caccd ]

0Day robots reported there is compiling issue for 'csky' ARCH when
CONFIG_DEBUG_FORCE_DATA_SECTION_ALIGNED is enabled [1]:

All errors (new ones prefixed by >>):

   {standard input}: Assembler messages:
>> {standard input}:2277: Error: pcrel offset for branch to .LS000B too far (0x3c)

Which was discussed in [2].  And as there is no solution for csky yet, add
some dependency for this config to limit it to several ARCHs which have no
compiling issue so far.

[1]. https://lore.kernel.org/lkml/202202271612.W32UJAj2-lkp@intel.com/
[2]. https://www.spinics.net/lists/linux-kbuild/msg30298.html

Link: https://lkml.kernel.org/r/20220304021100.GN4548@shbuild999.sh.intel.com
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Guo Ren <guoren@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.debug | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 5e14e32056ad..166e67b98506 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -416,7 +416,8 @@ config SECTION_MISMATCH_WARN_ONLY
 	  If unsure, say Y.
 
 config DEBUG_FORCE_FUNCTION_ALIGN_64B
-	bool "Force all function address 64B aligned" if EXPERT
+	bool "Force all function address 64B aligned"
+	depends on EXPERT && (X86_64 || ARM64 || PPC32 || PPC64 || ARC)
 	help
 	  There are cases that a commit from one domain changes the function
 	  address alignment of other domains, and cause magic performance
-- 
2.34.1

