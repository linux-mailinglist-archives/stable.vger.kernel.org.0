Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573F32F2F90
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 13:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbhALM4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 07:56:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:53468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727907AbhALM4T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:56:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC7182311B;
        Tue, 12 Jan 2021 12:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456138;
        bh=Vn16jtZNEFCsP1kplk5ejLVYwaw2lJfNlSUz/ajB2EY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V8SreH+KF9bNGP9z0PhjZ9W63p3wzBzvfs7kKC1J8zOFLc5w7OD6ZeKzoZytDSmQG
         VmJLPBkqBGUB+RJY310d0IxZ+GxXxLaa+uNa2AbUaIfRq/ystP6nucEB3IMpAUkjqw
         n9j+ctSWuP4f/jqLbxPi/quQIUw13dQ6Iq1u/GjaFTtRCCFTbaLuC0mJkkXNiaZmtR
         dVQ20DhlSonI2i3BV0Uyujt+0U4MIkzc4MzDIC1rLIuEawrVnHFjW1t9j+8EPu8Otw
         BJzr+a4pppcKX34lws6TpmICilQxLDoaWZJCZD/AQmUSv8VUbJa9mhRdt1I9YVs9ye
         nu3dRzeElIVxw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 03/51] ARC: build: add boot_targets to PHONY
Date:   Tue, 12 Jan 2021 07:54:45 -0500
Message-Id: <20210112125534.70280-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
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
index 61a41123ad4c4..cf9da9aea12ac 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -104,6 +104,7 @@ boot		:= arch/arc/boot
 
 boot_targets := uImage uImage.bin uImage.gz uImage.lzma
 
+PHONY += $(boot_targets)
 $(boot_targets): vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
 
-- 
2.27.0

