Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34072F307A
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbhALNFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:05:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:54596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405262AbhALM63 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EEA42313E;
        Tue, 12 Jan 2021 12:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456271;
        bh=pSem51RdnDaXFatIK8DqrHQsjQCa0nlot9Q/lpqOReE=;
        h=From:To:Cc:Subject:Date:From;
        b=CrQQzUcLylPLImRhQW53zdlIDwm9wOJGip5vqMeuw2sGixNnyT5ySmrRrWx+/fFpB
         HfKI5K+yC6Dh5SVgWqzGXIixjiKo2hO9NOhCabI586FA+f2Gp6Ip1ZNrbrt48QpBmV
         PG9L1u3JumfcFdinfZ2AowHCvvnhARZAdD47fo6SU/6gBlO6wgEvjPPXmQZxt/JzxC
         bh6GszSzT5PE6isxTPmIfElIG88GJ0hywINkQKF7WYXihElyzmCXq0+h8OpuWS5DNC
         4E/ODb0kdr5y8c4aYE2LGeQTiZyJuPIhmXvZiLtIp7Mrpm1FkfO/cIrKUynyTDsdeZ
         lmmvYFjadlL3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 01/13] ARC: build: remove non-existing bootpImage from KBUILD_IMAGE
Date:   Tue, 12 Jan 2021 07:57:37 -0500
Message-Id: <20210112125749.71193-1-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 9836720911cfec25d3fbdead1c438bf87e0f2841 ]

The deb-pkg builds for ARCH=arc fail.

  $ export CROSS_COMPILE=<your-arc-compiler-prefix>
  $ make -s ARCH=arc defconfig
  $ make ARCH=arc bindeb-pkg
  SORTTAB vmlinux
  SYSMAP  System.map
  MODPOST Module.symvers
  make KERNELRELEASE=5.10.0-rc4 ARCH=arc KBUILD_BUILD_VERSION=2 -f ./Makefile intdeb-pkg
  sh ./scripts/package/builddeb
  cp: cannot stat 'arch/arc/boot/bootpImage': No such file or directory
  make[4]: *** [scripts/Makefile.package:87: intdeb-pkg] Error 1
  make[3]: *** [Makefile:1527: intdeb-pkg] Error 2
  make[2]: *** [debian/rules:13: binary-arch] Error 2
  dpkg-buildpackage: error: debian/rules binary subprocess returned exit status 2
  make[1]: *** [scripts/Makefile.package:83: bindeb-pkg] Error 2
  make: *** [Makefile:1527: bindeb-pkg] Error 2

The reason is obvious; arch/arc/Makefile sets $(boot)/bootpImage as
the default image, but there is no rule to build it.

Remove the meaningless KBUILD_IMAGE assignment so it will fallback
to the default vmlinux. With this change, you can build the deb package.

I removed the 'bootpImage' target as well. At best, it provides
'make bootpImage' as an alias of 'make vmlinux', but I do not see
much sense in doing so.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/Makefile | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arc/Makefile b/arch/arc/Makefile
index 2917f56f0ea43..98d31b701a97c 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -99,12 +99,6 @@ libs-y		+= arch/arc/lib/ $(LIBGCC)
 
 boot		:= arch/arc/boot
 
-#default target for make without any arguments.
-KBUILD_IMAGE	:= $(boot)/bootpImage
-
-all:	bootpImage
-bootpImage: vmlinux
-
 boot_targets += uImage uImage.bin uImage.gz
 
 $(boot_targets): vmlinux
-- 
2.27.0

