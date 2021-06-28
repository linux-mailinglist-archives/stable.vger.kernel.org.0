Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDE33B63EB
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236692AbhF1PCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:02:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236569AbhF1PAR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:00:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D353361D6B;
        Mon, 28 Jun 2021 14:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891251;
        bh=pXsmKr5Tq6LwRKMdROgnntzHJX1YHsvZX76wqaDXRhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oTToyHFROjfM/TY7Z4SMMH5guzFkRdMZ48yvhwF2YFZTvMYwDCfc9nRcc1Ap5sZmq
         9IztUt3hOipG+1nOGDlD/R4jeRRS+bKh7U4qJXU2ttJ1mNGb943+TQLXUmEOGH89Qp
         FbDL5vMqX06ap702Ru1hcj+msoO7WQz9+D7nx/s8WYbPlAHVzAhhUFkDErhUOH/r92
         bCptdeONyjm4IUQhza6WDqwwopHIDh65RSPDCyrhxLEGO8Z2bvkJ3Tkjix+jngupGW
         gqX8dZ2Rg2zJvEFo3jQ5b/vozwrS/9ddiRg1//WYtbI84seCZs+5PmITrBMrHzoL5/
         7/YfnOOCGQXxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 53/71] Makefile: Move -Wno-unused-but-set-variable out of GCC only block
Date:   Mon, 28 Jun 2021 10:39:45 -0400
Message-Id: <20210628144003.34260-54-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144003.34260-1-sashal@kernel.org>
References: <20210628144003.34260-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:39+00:00
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
index e43823c3337f..651d4fbf56aa 100644
--- a/Makefile
+++ b/Makefile
@@ -718,12 +718,11 @@ KBUILD_CFLAGS += $(call cc-disable-warning, tautological-compare)
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

