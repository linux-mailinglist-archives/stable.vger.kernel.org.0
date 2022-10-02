Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133895F2671
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 00:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiJBWx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 18:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiJBWxC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 18:53:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A7E3C8FE;
        Sun,  2 Oct 2022 15:51:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D96AB80D6C;
        Sun,  2 Oct 2022 22:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329BEC43140;
        Sun,  2 Oct 2022 22:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751059;
        bh=gZav1BV8mfJpV0flxuOS9osbWhcUEDRWDElsQ/iQu7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DB7h88QOHTKAhFySvvEZTQOWzLuFcDr9X8qhFE3wEHHkLkp/LElD5QjvbcPQ9U4Sw
         52BWHaRmArbu7rw0U6QZFMiAE6F9YuYZ3k1RhoCgzGSQNgSbewwlpncoKMJq4+vl0+
         MLa9zpW+zR/2HAO0LOLyxXjmLei+fDBYD1734Zxp1K5A1zSgWaTzbEW5EGYHRiRo74
         JnGyX4ivU7wnk1hP+X1C/OSzu8/xCn9CUTqsG3pN8O9T6zWKq49MwRsMRdXmdd7egv
         rZWq/WgklvzLW9dMbKx1yCTkHSWDGTbdutcfJPOrBQ+8ezv6Q1kDo7O97RzMDGrPGz
         uu5QM6dSLjiGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Andi Kleen <ak@linux.intel.com>,
        Dmitrii Bundin <dmitrii.bundin.a@gmail.com>,
        Fangrui Song <maskray@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Sasha Levin <sashal@kernel.org>, michal.lkml@markovi.net,
        linux-kbuild@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.19 29/29] Makefile.debug: set -g unconditional on CONFIG_DEBUG_INFO_SPLIT
Date:   Sun,  2 Oct 2022 18:49:22 -0400
Message-Id: <20221002224922.238837-29-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002224922.238837-1-sashal@kernel.org>
References: <20221002224922.238837-1-sashal@kernel.org>
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

From: Nick Desaulniers <ndesaulniers@google.com>

[ Upstream commit 61f2b7c7497ba96cdde5bbaeb9e07f4c48f41f97 ]

Dmitrii, Fangrui, and Mashahiro note:

  Before GCC 11 and Clang 12 -gsplit-dwarf implicitly uses -g2.

Fix CONFIG_DEBUG_INFO_SPLIT for gcc-11+ & clang-12+ which now need -g
specified in order for -gsplit-dwarf to work at all.

-gsplit-dwarf has been mutually exclusive with -g since support for
CONFIG_DEBUG_INFO_SPLIT was introduced in
commit 866ced950bcd ("kbuild: Support split debug info v4")
I don't think it ever needed to be.

Link: https://lore.kernel.org/lkml/20220815013317.26121-1-dmitrii.bundin.a@gmail.com/
Link: https://lore.kernel.org/lkml/CAK7LNARPAmsJD5XKAw7m_X2g7Fi-CAAsWDQiP7+ANBjkg7R7ng@mail.gmail.com/
Link: https://reviews.llvm.org/D80391
Cc: Andi Kleen <ak@linux.intel.com>
Reported-by: Dmitrii Bundin <dmitrii.bundin.a@gmail.com>
Reported-by: Fangrui Song <maskray@google.com>
Reported-by: Masahiro Yamada <masahiroy@kernel.org>
Suggested-by: Dmitrii Bundin <dmitrii.bundin.a@gmail.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.debug | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/scripts/Makefile.debug b/scripts/Makefile.debug
index 9f39b0130551..26d6a9d97a20 100644
--- a/scripts/Makefile.debug
+++ b/scripts/Makefile.debug
@@ -1,9 +1,7 @@
-DEBUG_CFLAGS	:=
+DEBUG_CFLAGS	:= -g
 
 ifdef CONFIG_DEBUG_INFO_SPLIT
 DEBUG_CFLAGS	+= -gsplit-dwarf
-else
-DEBUG_CFLAGS	+= -g
 endif
 
 ifndef CONFIG_AS_IS_LLVM
-- 
2.35.1

