Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A465EA546
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238996AbiIZL7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239251AbiIZL6h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:58:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895E679A4F;
        Mon, 26 Sep 2022 03:52:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3823460A1E;
        Mon, 26 Sep 2022 10:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3968EC433D6;
        Mon, 26 Sep 2022 10:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189468;
        bh=AVRA1ujzvsdAyqlIxi/VLa//CtA1aWEcdrh9tMdOrcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xTcFDF9RCBSrzRsoY0Icsa5FostC3uLmDTq3qbk+Hmgp/czUDeqKT2jGaFuLq1fTB
         FWfyO3bgXJgoRKYI446ANMdEKdTzbsmkv6Ra9QUZDB3SBa3giO4PY74hZXB+KbyN6X
         59ausWuBf+Te/xcKaXJBwAWu9NzdPIGmrNxiUW08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Dmitrii Bundin <dmitrii.bundin.a@gmail.com>,
        Fangrui Song <maskray@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 197/207] Makefile.debug: set -g unconditional on CONFIG_DEBUG_INFO_SPLIT
Date:   Mon, 26 Sep 2022 12:13:06 +0200
Message-Id: <20220926100815.415112543@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Stable-dep-of: 32ef9e5054ec ("Makefile.debug: re-enable debug info for .S files")
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



