Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335AF2F2FC4
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390436AbhALM6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 07:58:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:54632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405011AbhALM6R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3340F2310F;
        Tue, 12 Jan 2021 12:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456250;
        bh=o8UI3yBkRQdprQxc+IiJ5N44niPZfN1ywHkbHW68BFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gbX0W6bZ13RfAhRXibLWgPIbrgs3Viv+4iPxM7PvQAarRnhsl50UIX9QGVrEzk09f
         nJeIteZDpy3b/sYcwyaAFz4moxszuXLyKc951xJr4sQbpYBps7dLVOIVm9g9x8H0a5
         L9T4IOZBCun5k03fk3PboAE/9h+BoOSKAcQ+/ehpvBTVAtzO5yDiCvBsgfCoBwDrbg
         rcwRIAmjX/ehZ0fNbNTfjUIL095/pg1iMiSfDsH3EbJbZZHRWSrvIRbOd6XSfwkdIX
         Zn+XVoc4IukmT/20MmuuOj5gvJoTXDhjIwiczGBy+F9GBJCZPU3erYmaIs2yiwaJ7p
         059mlgMJz5pNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 03/16] ARC: build: add boot_targets to PHONY
Date:   Tue, 12 Jan 2021 07:57:12 -0500
Message-Id: <20210112125725.71014-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125725.71014-1-sashal@kernel.org>
References: <20210112125725.71014-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 0cfccb3c04934cdef42ae26042139f16e805b5f7 ]

The top-level boot_targets (uImage and uImage.*) should be phony
targets. They just let Kbuild descend into arch/arc/boot/ and create
files there.

If a file exists in the top directory with the same name, the boot
image will not be created.

You can confirm it by the following steps:

  $ export CROSS_COMPILE=<your-arc-compiler-prefix>
  $ make -s ARCH=arc defconfig all   # vmlinux will be built
  $ touch uImage.gz
  $ make ARCH=arc uImage.gz
  CALL    scripts/atomic/check-atomics.sh
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  # arch/arc/boot/uImage.gz is not created

Specify the targets as PHONY to fix this.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arc/Makefile b/arch/arc/Makefile
index cbb110309ae1c..99c55f015ce86 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -93,6 +93,7 @@ boot		:= arch/arc/boot
 
 boot_targets := uImage uImage.bin uImage.gz uImage.lzma
 
+PHONY += $(boot_targets)
 $(boot_targets): vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
 
-- 
2.27.0

