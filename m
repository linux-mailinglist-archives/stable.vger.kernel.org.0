Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBE72F3009
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbhALNBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:01:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:53862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390376AbhALM6t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D078123117;
        Tue, 12 Jan 2021 12:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456305;
        bh=eTOgMSs1N1PxgfxMoj1wYstzx8Qpt5KjBgDBV0XfFRs=;
        h=From:To:Cc:Subject:Date:From;
        b=s3WjL2OXVmKm3tBabmYY+rJVYlltoMdXt1WNCffLR5eHwSJw4raa4e2cVPN4oT3ZR
         rrGGhUmEll1kHZBKqATTjZP0hUwsCs8G20mvLg9CcLuirVCaA9w5uVIkJS9puJvnDF
         2QxDB+AmQ4/alsidr/VA7H91VhRQzb8stVJVeazyGBJ/H1isoxE3bB9dlSrkA9mhSn
         mYl8grMCt7Fj4vkFAWluErHAjo8+gPnXaV/J+NqAM/puqmN2a8wZ5VXWzBmZV/qJFC
         xDYfjjpn8kW/uVje7d39kv5L7dW4TzCHehrSZKSBujQXL7Waux1uAt8jYHgnX7itId
         2+BPWE+F3GOKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 4.4 1/8] ARC: build: add boot_targets to PHONY
Date:   Tue, 12 Jan 2021 07:58:16 -0500
Message-Id: <20210112125823.71463-1-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
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
index 8f8d53f08141d..150656503c117 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -108,6 +108,7 @@ bootpImage: vmlinux
 
 boot_targets += uImage uImage.bin uImage.gz
 
+PHONY += $(boot_targets)
 $(boot_targets): vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
 
-- 
2.27.0

