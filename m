Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 773923B647B
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235933AbhF1PIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:08:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237301AbhF1PFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:05:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42BC161D7E;
        Mon, 28 Jun 2021 14:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891415;
        bh=QHhfXnjasotvtdSvitlpftD6Lesu/+3UHKj1GppfsDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T16zYBitjmEZZhQnNw6W2gMg/JFiXsaRGIKoFQ4gticDPzGT4vaqd8OA6zFijXcFF
         OgnPbRTvjlqm+Hzb6RueGuyNxgI+1MgZTMW8a2lPkc1zkbUa4VjakJ/UQ2VPCKmxJu
         F4GuzRPqm9Av6ioinTArNRyB1mAdWvPQIwtKFVP3lsQP1DugugZ9XoY5QUx5iP4XBg
         FH7K5PnO8h9S7drWpcUEsGA9/LccRgOSKsJ2Lg3M7JWpvYXmCt5Hw/oxAFMivIybX3
         8pxZv2OCwisbjYKMzu24fP4vaOj23fdXN6mJs3O9VU6pFqYyme6t3wCpSlvV0RA8vG
         wFWofPSmBrIFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 44/57] Makefile: Move -Wno-unused-but-set-variable out of GCC only block
Date:   Mon, 28 Jun 2021 10:42:43 -0400
Message-Id: <20210628144256.34524-45-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
References: <20210628144256.34524-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:42+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 78a317e69e7f..691072b50fb5 100644
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
-- 
2.30.2

