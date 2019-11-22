Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24A9F106308
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfKVGBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:01:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:40112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729249AbfKVGBt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 01:01:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 284EF2068E;
        Fri, 22 Nov 2019 06:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402508;
        bh=ZCOYm7uvTGNlci+Nc06dmUObDmY7JSDWXNomo+BzJS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nX0jg1z4PO7LhHBqN8WZl10NXjMvtB0SncPc0rfF+x4r+ELI+l1UyQKVUSQtvpyc1
         fVnVmEFWQ8XgFIqDqgl8eZ6f1ihIaWOCPLntIN2bwPzBYp6Hc9g3jgnQNI45FFA/Qf
         i57KzuZc0XH3+AG258kdw3VfqZ0T1klmn0myS3DY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 18/91] microblaze: adjust the help to the real behavior
Date:   Fri, 22 Nov 2019 01:00:16 -0500
Message-Id: <20191122060129.4239-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122060129.4239-1-sashal@kernel.org>
References: <20191122060129.4239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 740f2b82a182a..5e1e18540a571 100644
--- a/arch/microblaze/Makefile
+++ b/arch/microblaze/Makefile
@@ -83,11 +83,11 @@ define archhelp
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

