Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1C9113432
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730283AbfLDSE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:04:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:50654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730273AbfLDSEv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:04:51 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99F4A206DF;
        Wed,  4 Dec 2019 18:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482691;
        bh=hoHaxQ1FpR1KmrO2bIdXBLQAaLGfFdc4kghUGkigRBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=doLi0CPF2FdLzJOv8xogeom3QX3IejPeAXqkuW6IFlBgczRjJMX1/Gs+ui5l02MdQ
         R8XOHUJKaUsDu6yMm0w9aaikMq1NtX1cHnqzf8G7Qh08e0Jp1TBoGag/kpwwsiepyx
         SBgFUtiHJ3MxJ3sgBzG6cbEK4rSlrFap8CA71/mo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 053/209] microblaze: move "... is ready" messages to arch/microblaze/Makefile
Date:   Wed,  4 Dec 2019 18:54:25 +0100
Message-Id: <20191204175325.021720455@linuxfoundation.org>
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
index 188f07bba0959..fe5e48184c3c2 100644
--- a/arch/microblaze/Makefile
+++ b/arch/microblaze/Makefile
@@ -83,9 +83,11 @@ archclean:
 
 linux.bin linux.bin.gz linux.bin.ub: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
+	@echo 'Kernel: $(boot)/$@ is ready' ' (#'`cat .version`')'
 
 simpleImage.%: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
+	@echo 'Kernel: $(boot)/$@ is ready' ' (#'`cat .version`')'
 
 define archhelp
   echo '* linux.bin    - Create raw binary'
diff --git a/arch/microblaze/boot/Makefile b/arch/microblaze/boot/Makefile
index 7c2f52d4a0e45..49dbd1063d717 100644
--- a/arch/microblaze/boot/Makefile
+++ b/arch/microblaze/boot/Makefile
@@ -9,15 +9,12 @@ OBJCOPYFLAGS := -R .note -R .comment -R .note.gnu.build-id -O binary
 
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
@@ -35,6 +32,5 @@ $(obj)/simpleImage.%: vmlinux FORCE
 	$(call if_changed,objcopy)
 	$(call if_changed,uimage)
 	$(call if_changed,strip,.strip)
-	@echo 'Kernel: $(UIMAGE_OUT) is ready' ' (#'`cat .version`')'
 
 clean-files += simpleImage.*.unstrip linux.bin.ub dts/*.dtb
-- 
2.20.1



