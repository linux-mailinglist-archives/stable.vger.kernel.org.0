Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C5E3BB385
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhGDXSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:18:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233610AbhGDXOd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC17B61946;
        Sun,  4 Jul 2021 23:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440213;
        bh=DAeD0r+v//2Ew0XhFrwy6954/xVEA06eegqtkuK1sDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=on7ArL+GZq3ydgrhVb1ohVbktRnod6OWtmYT+2Bgdoju8716yJrUNlCFX+pPgPf4X
         BlT9MMlH2fn9V62iBcaoGyGXIENr6xtdR96TLnORG9WtyP17iKA1dUDi/lVBDjCfWP
         hanaOPx9e1gpEtFOsQwU3x475tEqHVTA4Y5PPScbMDa9zEAXTo8wW99VZ1TxirBPyU
         HsE3pXJcQGJjuVZtTTUKw4JuhYfmvN1jLb+7VTiHs+gTJBtVUj1osXAiwnjY1Q+LRn
         gjrwbzKnP9xJ1VhpBYknjn6V+1hzSry5Fi3Nkw2z5FxiAJxE2IItLTQmtCTT3KucCU
         2ZVOguLNpxjaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Peter Collingbourne <pcc@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 27/50] Makefile: fix GDB warning with CONFIG_RELR
Date:   Sun,  4 Jul 2021 19:09:15 -0400
Message-Id: <20210704230938.1490742-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230938.1490742-1-sashal@kernel.org>
References: <20210704230938.1490742-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 5db87d8031f1..df9365a3432f 100644
--- a/Makefile
+++ b/Makefile
@@ -937,7 +937,7 @@ LDFLAGS_vmlinux	+= $(call ld-option, -X,)
 endif
 
 ifeq ($(CONFIG_RELR),y)
-LDFLAGS_vmlinux	+= --pack-dyn-relocs=relr
+LDFLAGS_vmlinux	+= --pack-dyn-relocs=relr --use-android-relr-tags
 endif
 
 # make the checker run with the right architecture
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

