Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3E8106309
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbfKVGIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:08:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:40122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729189AbfKVGBu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 01:01:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 218D42070A;
        Fri, 22 Nov 2019 06:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402509;
        bh=H1WBjtuVHU+q1pByMDCrOf3M0NmQW+pm/fk8+btGKfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IeyFldKgq8KszDQ/JQmljUcIdN0bL7zqnI7pjy2HquHP+0rEpZ9WQJJQMG5JEcdBr
         jVe+2TFA+cOQY8lkflRpchIcQAN0TB7oQH0C0qEEaWBsbUz/8HvP70iWu+9CbgWM9f
         fELWh9Qw+oH8C18pbUwCgb2WVjCeQkBoDNE2Fu18=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 19/91] microblaze: move "... is ready" messages to arch/microblaze/Makefile
Date:   Fri, 22 Nov 2019 01:00:17 -0500
Message-Id: <20191122060129.4239-18-sashal@kernel.org>
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

[ Upstream commit 2e14f94cf4bc2f15ca5362e81ca3a987c79e3062 ]

To prepare for more fixes, move this to arch/microblaze/Makefile.
Otherwise, the same "... is ready" would be printed multiple times.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/Makefile      | 2 ++
 arch/microblaze/boot/Makefile | 4 ----
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/microblaze/Makefile b/arch/microblaze/Makefile
index 5e1e18540a571..491676a6cde57 100644
--- a/arch/microblaze/Makefile
+++ b/arch/microblaze/Makefile
@@ -75,9 +75,11 @@ archclean:
 
 linux.bin linux.bin.gz linux.bin.ub: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
+	@echo 'Kernel: $(boot)/$@ is ready' ' (#'`cat .version`')'
 
 simpleImage.%: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
+	@echo 'Kernel: $(boot)/$@ is ready' ' (#'`cat .version`')'
 
 define archhelp
   echo '* linux.bin    - Create raw binary'
diff --git a/arch/microblaze/boot/Makefile b/arch/microblaze/boot/Makefile
index 0f3fe6a151dce..22bed08ec7f28 100644
--- a/arch/microblaze/boot/Makefile
+++ b/arch/microblaze/boot/Makefile
@@ -8,15 +8,12 @@ OBJCOPYFLAGS := -R .note -R .comment -R .note.gnu.build-id -O binary
 
 $(obj)/linux.bin: vmlinux FORCE
 	$(call if_changed,objcopy)
-	@echo 'Kernel: $@ is ready' ' (#'`cat .version`')'
 
 $(obj)/linux.bin.ub: $(obj)/linux.bin FORCE
 	$(call if_changed,uimage)
-	@echo 'Kernel: $@ is ready' ' (#'`cat .version`')'
 
 $(obj)/linux.bin.gz: $(obj)/linux.bin FORCE
 	$(call if_changed,gzip)
-	@echo 'Kernel: $@ is ready' ' (#'`cat .version`')'
 
 quiet_cmd_cp = CP      $< $@$2
 	cmd_cp = cat $< >$@$2 || (rm -f $@ && echo false)
@@ -34,6 +31,5 @@ $(obj)/simpleImage.%: vmlinux FORCE
 	$(call if_changed,objcopy)
 	$(call if_changed,uimage)
 	$(call if_changed,strip,.strip)
-	@echo 'Kernel: $(UIMAGE_OUT) is ready' ' (#'`cat .version`')'
 
 clean-files += simpleImage.*.unstrip linux.bin.ub dts/*.dtb
-- 
2.20.1

