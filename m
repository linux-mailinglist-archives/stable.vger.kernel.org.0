Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52BD2113203
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbfLDSEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:04:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:50550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730265AbfLDSEt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:04:49 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12F0D20659;
        Wed,  4 Dec 2019 18:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482688;
        bh=BN0DhflK9aTP7pbgnOI1FtlaLz5PDG30I11spKOXY7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OIFoYkeINDmg7MbCaOa6A6L5kT+596L5LLEhRrY4ml3Ql6gV6WYZub9opgnDxH0OO
         WBXmetjBzEueQu71WloNcEOC6zCGW6rs+++KP/80tXE63hZZr0HnCofiN5lWZ+f5vn
         Tz+HK10yYSEMlOSeVT5AqZB1MTsrjktkPFdN5jjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 052/209] microblaze: adjust the help to the real behavior
Date:   Wed,  4 Dec 2019 18:54:24 +0100
Message-Id: <20191204175324.959353887@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

[ Upstream commit bafcc61d998c1ca18f556d92a0e95335ac68c7da ]

"make ARCH=microblaze help" mentions simpleImage.<dt>.unstrip,
but it is not a real Make target. It does not work because Makefile
assumes "system.unstrip" is the name of DT.

$ make ARCH=microblaze CROSS_COMPILE=microblaze-linux- simpleImage.system.unstrip
  [ snip ]
make[1]: *** No rule to make target 'arch/microblaze/boot/dts/system.unstrip.dtb', needed by 'arch/microblaze/boot/dts/system.dtb'.  Stop.
make: *** [Makefile;1060: arch/microblaze/boot/dts] Error 2
make: *** Waiting for unfinished jobs....

simpleImage.<dt> works like a phony target that generates multiple
images. Reflect the real behavior. I removed the DT directory path
information because it is already explained a few lines below.

While I am here, I deleted the redundant *_defconfig explanation.

The top-level Makefile caters to list available defconfig files:

  mmu_defconfig            - Build for mmu
  nommu_defconfig          - Build for nommu

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/Makefile | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/microblaze/Makefile b/arch/microblaze/Makefile
index d269dd4b82795..188f07bba0959 100644
--- a/arch/microblaze/Makefile
+++ b/arch/microblaze/Makefile
@@ -91,11 +91,11 @@ define archhelp
   echo '* linux.bin    - Create raw binary'
   echo '  linux.bin.gz - Create compressed raw binary'
   echo '  linux.bin.ub - Create U-Boot wrapped raw binary'
-  echo '  simpleImage.<dt> - ELF image with $(arch)/boot/dts/<dt>.dts linked in'
-  echo '                   - stripped elf with fdt blob'
-  echo '  simpleImage.<dt>.unstrip - full ELF image with fdt blob'
-  echo '  *_defconfig      - Select default config from arch/microblaze/configs'
-  echo ''
+  echo '  simpleImage.<dt> - Create the following images with <dt>.dtb linked in'
+  echo '                    simpleImage.<dt>        : raw image'
+  echo '                    simpleImage.<dt>.ub     : raw image with U-Boot header'
+  echo '                    simpleImage.<dt>.unstrip: ELF (identical to vmlinux)'
+  echo '                    simpleImage.<dt>.strip  : stripped ELF'
   echo '  Targets with <dt> embed a device tree blob inside the image'
   echo '  These targets support board with firmware that does not'
   echo '  support passing a device tree directly. Replace <dt> with the'
-- 
2.20.1



