Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471692F2F70
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 13:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387616AbhALM4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 07:56:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:53442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727907AbhALM4R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:56:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 549AC2310F;
        Tue, 12 Jan 2021 12:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456136;
        bh=e1mZ12wrJyqgpsotztybEXA0mWJLgZqTKXAijW+v55c=;
        h=From:To:Cc:Subject:Date:From;
        b=L6g/gT5MkhwdFCv9DxmqUCgjC7gAl80lRfWkKhF2yT/3fTmR1yuaAN2x55TXY0UWI
         9qqWKaneSjVLknve5tphAUTm/28fy/WXpbEvyRmXp2R0BWrJ0792Eqs2GPvAL+aHMl
         K52bFV4TImlHHztl5/ZNplvjExcbmr01xYjMbA05ZnCyiUJG0j75p0rfK1WItFYNmb
         TXcK9WaecBHd6KSWJzUBQVGs83lb6jmXLnqHZusaWRHeGDxSc4QBkeM/YFgAyiI+ek
         lPZjlxmamy5SQ1Ss7l+s/BDfhC1IdkOottcMFfnhlpQedkvuQkjDXUKqDghTsdqS/a
         KWwElxnZs87Og==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 01/51] ARC: build: remove non-existing bootpImage from KBUILD_IMAGE
Date:   Tue, 12 Jan 2021 07:54:43 -0500
Message-Id: <20210112125534.70280-1-sashal@kernel.org>
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
index 0c6bf0d1df7ad..acf99420e161d 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -102,12 +102,6 @@ libs-y		+= arch/arc/lib/ $(LIBGCC)
 
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

