Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D34F451EF2
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347733AbhKPAiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344602AbhKOTZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2E1B63347;
        Mon, 15 Nov 2021 19:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002842;
        bh=47UUidKVJvjpqfqoGXab7vR8mElUYdvuxqyYcFCoWuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=znjwJr9UC55v5BmJ2lcF2+I2Nc0M0JrPF3xY57aU2yBBKFDRReDbcCg+LhgEy1LPB
         7kGuzAnc+RbBIf8959SZMBJbrl4isYRb4IJGmkcygz8WtlWZEnDa1ENIkWEZl1Lni1
         kmr0Njs+EQUbE5U1ZjcmjtB9r1KCaYeuok4ujcdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Nicolas Schier <n.schier@avm.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 717/917] sparc: Add missing "FORCE" target when using if_changed
Date:   Mon, 15 Nov 2021 18:03:32 +0100
Message-Id: <20211115165453.214509557@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit a3c7ca2b141b9735eb383246e966a4f4322e3e65 ]

Fix observed warning:

    /builds/linux/arch/sparc/boot/Makefile:35: FORCE prerequisite is missing

Fixes: e1f86d7b4b2a ("kbuild: warn if FORCE is missing for if_changed(_dep,_rule) and filechk")
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Nicolas Schier <n.schier@avm.de>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/boot/Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/boot/Makefile b/arch/sparc/boot/Makefile
index 849236d4eca48..45e5c76d449ea 100644
--- a/arch/sparc/boot/Makefile
+++ b/arch/sparc/boot/Makefile
@@ -22,7 +22,7 @@ ifeq ($(CONFIG_SPARC64),y)
 
 # Actual linking
 
-$(obj)/zImage: $(obj)/image
+$(obj)/zImage: $(obj)/image FORCE
 	$(call if_changed,gzip)
 	@echo '  kernel: $@ is ready'
 
@@ -31,7 +31,7 @@ $(obj)/vmlinux.aout: vmlinux FORCE
 	@echo '  kernel: $@ is ready'
 else
 
-$(obj)/zImage: $(obj)/image
+$(obj)/zImage: $(obj)/image FORCE
 	$(call if_changed,strip)
 	@echo '  kernel: $@ is ready'
 
@@ -44,7 +44,7 @@ OBJCOPYFLAGS_image.bin := -S -O binary -R .note -R .comment
 $(obj)/image.bin: $(obj)/image FORCE
 	$(call if_changed,objcopy)
 
-$(obj)/image.gz: $(obj)/image.bin
+$(obj)/image.gz: $(obj)/image.bin FORCE
 	$(call if_changed,gzip)
 
 UIMAGE_LOADADDR = $(CONFIG_UBOOT_LOAD_ADDR)
@@ -56,7 +56,7 @@ quiet_cmd_uimage.o = UIMAGE.O $@
                      -r -b binary $@ -o $@.o
 
 targets += uImage
-$(obj)/uImage: $(obj)/image.gz
+$(obj)/uImage: $(obj)/image.gz FORCE
 	$(call if_changed,uimage)
 	$(call if_changed,uimage.o)
 	@echo '  Image $@ is ready'
-- 
2.33.0



