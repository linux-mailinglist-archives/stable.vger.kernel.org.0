Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D073C5211
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349759AbhGLHok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:44:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347569AbhGLHju (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:39:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1C486127C;
        Mon, 12 Jul 2021 07:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075303;
        bh=JPd5FDLaEWTxgxF4MNIHo12004q4BKHkaAGRwWU5Nng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D0vvC+iC8yjA9NRCJgWRj5BCiWmjcNo9j2UE7F7B3FsdgNCI7L5kZImYJcNM2ns4B
         YUa8mT3wFEqZgcF68uiGneaPSi2Bgy7S0DBgIPD1sFn1L2eC7+RIJeQtOQA5nb8Rfp
         pn301mgrtYuoix/CZZx27LV8gBD5LDQJ4Uoxh/bc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Collingbourne <pcc@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 174/800] Makefile: fix GDB warning with CONFIG_RELR
Date:   Mon, 12 Jul 2021 08:03:17 +0200
Message-Id: <20210712060937.430170588@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

[ Upstream commit 27f2a4db76e8d8a8b601fc1c6a7a17f88bd907ab ]

GDB produces the following warning when debugging kernels built with
CONFIG_RELR:

BFD: /android0/linux-next/vmlinux: unknown type [0x13] section `.relr.dyn'

when loading a kernel built with CONFIG_RELR into GDB. It can also
prevent debugging symbols using such relocations.

Peter sugguests:
  [That flag] means that lld will use dynamic tags and section type
  numbers in the OS-specific range rather than the generic range. The
  kernel itself doesn't care about these numbers; it determines the
  location of the RELR section using symbols defined by a linker script.

Link: https://github.com/ClangBuiltLinux/linux/issues/1057
Suggested-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/r/20210522012626.2811297-1-ndesaulniers@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile                      | 2 +-
 scripts/tools-support-relr.sh | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 069607cfe283..bc039bb78f30 100644
--- a/Makefile
+++ b/Makefile
@@ -1039,7 +1039,7 @@ LDFLAGS_vmlinux	+= $(call ld-option, -X,)
 endif
 
 ifeq ($(CONFIG_RELR),y)
-LDFLAGS_vmlinux	+= --pack-dyn-relocs=relr
+LDFLAGS_vmlinux	+= --pack-dyn-relocs=relr --use-android-relr-tags
 endif
 
 # We never want expected sections to be placed heuristically by the
diff --git a/scripts/tools-support-relr.sh b/scripts/tools-support-relr.sh
index 45e8aa360b45..cb55878bd5b8 100755
--- a/scripts/tools-support-relr.sh
+++ b/scripts/tools-support-relr.sh
@@ -7,7 +7,8 @@ trap "rm -f $tmp_file.o $tmp_file $tmp_file.bin" EXIT
 cat << "END" | $CC -c -x c - -o $tmp_file.o >/dev/null 2>&1
 void *p = &p;
 END
-$LD $tmp_file.o -shared -Bsymbolic --pack-dyn-relocs=relr -o $tmp_file
+$LD $tmp_file.o -shared -Bsymbolic --pack-dyn-relocs=relr \
+  --use-android-relr-tags -o $tmp_file
 
 # Despite printing an error message, GNU nm still exits with exit code 0 if it
 # sees a relr section. So we need to check that nothing is printed to stderr.
-- 
2.30.2



