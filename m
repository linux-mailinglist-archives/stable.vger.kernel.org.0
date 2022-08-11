Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3040258FFFB
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235813AbiHKPgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236095AbiHKPfe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:35:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A99A85ABA;
        Thu, 11 Aug 2022 08:32:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DAA2615FD;
        Thu, 11 Aug 2022 15:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DF5C433C1;
        Thu, 11 Aug 2022 15:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660231977;
        bh=OTZX4o/1I9QcOQRs41z3/jKJNq7WMWe0cV4dLn6X6Dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJkPl0RB1KM4TlgKuXfOB6nu4n1bzAxokZW58NuZg82pD/MeAgsR9iBBhKVS8J5mE
         0iVZ/7ropgh0ktViki5nY1IB83RtvRIaRGfY/EXGJyoerTTYbqPKeJSEpvpiQbiKEL
         Xy2qt22dxTb49GkIBliBNZip7HwJcyyI1yGfO8gvggPhHQYWuu6z6VnZ1uxtEhEqiA
         TbqhgNUpBXWxuKLhReBBuPstf39I+NJtEXuHc9KSUJMzyK4i166b1rOdIInegd8lU4
         o5P+pnErrDE7Oy2CNA7EBLs10Cs+ezBDSVVi7fEByZMc7EAca8WZ5Y3xlJFr5jK9w/
         kHJE01VdelFsQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Willy Tarreau <w@1wt.eu>, "Paul E . McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.19 037/105] tools/nolibc: fix the makefile to also work as "make -C tools ..."
Date:   Thu, 11 Aug 2022 11:27:21 -0400
Message-Id: <20220811152851.1520029-37-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
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

From: Willy Tarreau <w@1wt.eu>

[ Upstream commit 6a3ad243b29be01d0c30f8c3b35a1149e1a0139a ]

As reported by Linus, the nolibc's makefile is currently broken when
invoked as per the documented method (make -C tools nolibc_<target>),
because it now relies on the ARCH and OUTPUT variables that are not
set in this case.

This patch addresses this by sourcing subarch.include, and by
presetting OUTPUT to the current directory if not set. This is
sufficient to make the commands work both as a standalone target
and as a tools/ sub-target.

Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/Makefile | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/include/nolibc/Makefile b/tools/include/nolibc/Makefile
index 7a16d917c185..e8bac6ef3653 100644
--- a/tools/include/nolibc/Makefile
+++ b/tools/include/nolibc/Makefile
@@ -7,6 +7,22 @@ ifeq ($(srctree),)
 srctree := $(patsubst %/tools/include/,%,$(dir $(CURDIR)))
 endif
 
+# when run as make -C tools/ nolibc_<foo> the arch is not set
+ifeq ($(ARCH),)
+include $(srctree)/scripts/subarch.include
+ARCH = $(SUBARCH)
+endif
+
+# OUTPUT is only set when run from the main makefile, otherwise
+# it defaults to this nolibc directory.
+OUTPUT ?= $(CURDIR)/
+
+ifeq ($(V),1)
+Q=
+else
+Q=@
+endif
+
 nolibc_arch := $(patsubst arm64,aarch64,$(ARCH))
 arch_file := arch-$(nolibc_arch).h
 all_files := ctype.h errno.h nolibc.h signal.h std.h stdio.h stdlib.h string.h \
@@ -36,7 +52,7 @@ headers:
 
 headers_standalone: headers
 	$(Q)$(MAKE) -C $(srctree) headers
-	$(Q)$(MAKE) -C $(srctree) headers_install INSTALL_HDR_PATH=$(OUTPUT)/sysroot
+	$(Q)$(MAKE) -C $(srctree) headers_install INSTALL_HDR_PATH=$(OUTPUT)sysroot
 
 clean:
 	$(call QUIET_CLEAN, nolibc) rm -rf "$(OUTPUT)sysroot"
-- 
2.35.1

