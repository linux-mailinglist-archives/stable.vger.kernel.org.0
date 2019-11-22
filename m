Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06BD3106612
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbfKVG2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:28:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:54730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727561AbfKVFuO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D6012070A;
        Fri, 22 Nov 2019 05:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401814;
        bh=IJ+0jeSZb9ortcdzj9j4dxSaRyrGAGfxWZNhRfCNZIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2iAcNVDoT//OSIQQxeyspNErwT+D3Hc+EzV5Ktnjd5mpY0EVjBXsIkfPPS2qiZAwV
         BW1N0DWCjPD2lPxBACMA+F3AUsKk+Vo971UlwSG9jokla+QzCvoX4QN2IayxTu4kuP
         B0Ha1y6VtCvzEi6FLrv3wEqscKXrsbCFYxgKHPQY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 058/219] microblaze: fix multiple bugs in arch/microblaze/boot/Makefile
Date:   Fri, 22 Nov 2019 00:46:30 -0500
Message-Id: <20191122054911.1750-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

[ Upstream commit 4722a3e6b716d9d4594c3cf3856b03bbd24a59a8 ]

This commit fixes some build issues.

The first issue is the breakage of linux.bin.ub target since commit
ece97f3a5fb5 ("microblaze: Fix simpleImage format generation")
because the addition of UIMAGE_{IN,OUT} affected it.

make ARCH=microblaze CROSS_COMPILE=microblaze-linux- linux.bin.ub
  [ snip ]
  OBJCOPY arch/microblaze/boot/linux.bin
  UIMAGE  arch/microblaze/boot/linux.bin.ub.ub
/usr/bin/mkimage: Can't open arch/microblaze/boot/linux.bin.ub: No such file or directory
make[1]: *** [arch/microblaze/boot/Makefile;14: arch/microblaze/boot/linux.bin.ub] Error 1
make: *** [arch/microblaze/Makefile;83: linux.bin.ub] Error 2

The second issue is the use of the "if_changed" multiple times for
the same target.

As commit 92a4728608a8 ("x86/boot: Fix if_changed build flip/flop bug")
pointed out, this never works properly. Moreover, generating multiple
images as a side-effect is confusing.

Let's split the build recipe for each image.

simpleImage.<dt>*.unstrip is just a copy of vmlinux.

simpleImage.<dt> and simpleImage.<dt>.ub are created in the same way
as linux.bin and linux.bin.ub, respectively.

I kept simpleImage.* recipes independent of linux.bin.* ones to not
change the behavior.

Lastly, this commit fixes "make ARCH=microblaze clean". Previously,
it only cleaned up the unstrip image. Now, all the simpleImage files
are cleaned.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/Makefile      |  2 +-
 arch/microblaze/boot/Makefile | 19 +++++++++----------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/microblaze/Makefile b/arch/microblaze/Makefile
index b9808ddaf985f..548bac6c60f8c 100644
--- a/arch/microblaze/Makefile
+++ b/arch/microblaze/Makefile
@@ -86,7 +86,7 @@ linux.bin linux.bin.gz linux.bin.ub: vmlinux
 	@echo 'Kernel: $(boot)/$@ is ready' ' (#'`cat .version`')'
 
 simpleImage.%: vmlinux
-	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
+	$(Q)$(MAKE) $(build)=$(boot) $(addprefix $(boot)/$@., ub unstrip strip)
 	@echo 'Kernel: $(boot)/$@ is ready' ' (#'`cat .version`')'
 
 define archhelp
diff --git a/arch/microblaze/boot/Makefile b/arch/microblaze/boot/Makefile
index 96eefdca0d9b3..cff570a719461 100644
--- a/arch/microblaze/boot/Makefile
+++ b/arch/microblaze/boot/Makefile
@@ -3,7 +3,7 @@
 # arch/microblaze/boot/Makefile
 #
 
-targets := linux.bin linux.bin.gz linux.bin.ub simpleImage.%
+targets := linux.bin linux.bin.gz linux.bin.ub simpleImage.*
 
 OBJCOPYFLAGS := -R .note -R .comment -R .note.gnu.build-id -O binary
 
@@ -16,21 +16,20 @@ $(obj)/linux.bin.ub: $(obj)/linux.bin FORCE
 $(obj)/linux.bin.gz: $(obj)/linux.bin FORCE
 	$(call if_changed,gzip)
 
-quiet_cmd_cp = CP      $< $@$2
-	cmd_cp = cat $< >$@$2 || (rm -f $@ && echo false)
-
 quiet_cmd_strip = STRIP   $< $@$2
 	cmd_strip = $(STRIP) -K microblaze_start -K _end -K __log_buf \
 				-K _fdt_start $< -o $@$2
 
 UIMAGE_LOADADDR = $(CONFIG_KERNEL_BASE_ADDR)
-UIMAGE_IN = $@
-UIMAGE_OUT = $@.ub
 
-$(obj)/simpleImage.%: vmlinux FORCE
-	$(call if_changed,cp,.unstrip)
+$(obj)/simpleImage.$(DTB): vmlinux FORCE
 	$(call if_changed,objcopy)
+
+$(obj)/simpleImage.$(DTB).ub: $(obj)/simpleImage.$(DTB) FORCE
 	$(call if_changed,uimage)
-	$(call if_changed,strip,.strip)
 
-clean-files += simpleImage.*.unstrip linux.bin.ub
+$(obj)/simpleImage.$(DTB).unstrip: vmlinux FORCE
+	$(call if_changed,shipped)
+
+$(obj)/simpleImage.$(DTB).strip: vmlinux FORCE
+	$(call if_changed,strip)
-- 
2.20.1

