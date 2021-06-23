Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C693B1F67
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 19:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhFWR3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 13:29:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhFWR3V (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Jun 2021 13:29:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54EA660FEA;
        Wed, 23 Jun 2021 17:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624469223;
        bh=BZcJl3/DEBWkkHzvKFyiHzu8QCUtvnoonaWDd7Hal88=;
        h=From:To:Cc:Subject:Date:From;
        b=AIqTW3DGylWHuLcRv23OXo9FVX7mmLYAjKR/F8tt9RFgzdkplb2CHtzARLQGibe6h
         Ix6gkzKcLaKQ/9e5Ue9peLojRZToTbfU2Cm5vqteQOINcoCKaFh8gAFBJE/nsU9uSD
         ucR8aR+LJLrLeAjPB/q+BT7E3EBxxnrY38H7oGif96Mu9H6ypk6+8yw67nrxHlxlre
         5iEvsuVFmSbPhc7ljkGlMR+8n6w8ZHmrTsjFZYQneGdm5OMox9fiz4X4OPZLA4/t7K
         1vvNobnTMYmBHLjqkjbfVAFNVZnV4fK6XwY+UhdL6JykDBR+UKVf0YsF9IMTSmM4I9
         MFWyVwlj2vSew==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 4.4 to 4.19] Makefile: Move -Wno-unused-but-set-variable out of GCC only block
Date:   Wed, 23 Jun 2021 10:26:12 -0700
Message-Id: <20210623172610.3281050-1-nathan@kernel.org>
X-Mailer: git-send-email 2.32.0.93.g670b81a890
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 885480b084696331bea61a4f7eba10652999a9c1 upstream.

Currently, -Wunused-but-set-variable is only supported by GCC so it is
disabled unconditionally in a GCC only block (it is enabled with W=1).
clang currently has its implementation for this warning in review so
preemptively move this statement out of the GCC only block and wrap it
with cc-disable-warning so that both compilers function the same.

Cc: stable@vger.kernel.org
Link: https://reviews.llvm.org/D100581
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
[nc: Backport, workaround lack of e2079e93f562 in older branches]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 9ff7a4b7b8cb..cda7a18b925a 100644
--- a/Makefile
+++ b/Makefile
@@ -716,12 +716,11 @@ KBUILD_CFLAGS += $(call cc-disable-warning, tautological-compare)
 # See modpost pattern 2
 KBUILD_CFLAGS += $(call cc-option, -mno-global-merge,)
 KBUILD_CFLAGS += $(call cc-option, -fcatch-undefined-behavior)
-else
+endif
 
 # These warnings generated too much noise in a regular build.
 # Use make W=1 to enable them (see scripts/Makefile.extrawarn)
 KBUILD_CFLAGS += $(call cc-disable-warning, unused-but-set-variable)
-endif
 
 KBUILD_CFLAGS += $(call cc-disable-warning, unused-const-variable)
 ifdef CONFIG_FRAME_POINTER

base-commit: eb575cd5d7f60241d016fdd13a9e86d962093c9b
-- 
2.32.0.93.g670b81a890

