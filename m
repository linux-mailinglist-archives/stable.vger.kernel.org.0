Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51161300D2F
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 21:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbhAVT73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 14:59:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728397AbhAVOQ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:16:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44C0923A5C;
        Fri, 22 Jan 2021 14:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324792;
        bh=pSem51RdnDaXFatIK8DqrHQsjQCa0nlot9Q/lpqOReE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vHz/+X3yZCkfI2swhjLBVgwAchs62KuxADpx94OmccoNqKm6VfIY5SUrqskzDzwmG
         KEKGMu33fNuvM8FrUeArHDjPBiCCg3h1b9Unr4TEIDHPKjXTX+swPphxVouNyAarfo
         8HhAmZcTWACz1XMCTfLXIBEFa0Do9luJN5ar11Ls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 10/50] ARC: build: remove non-existing bootpImage from KBUILD_IMAGE
Date:   Fri, 22 Jan 2021 15:11:51 +0100
Message-Id: <20210122135735.606479670@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.176469491@linuxfoundation.org>
References: <20210122135735.176469491@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



