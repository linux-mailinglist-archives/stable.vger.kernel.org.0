Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892DA2F30EB
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbhALNNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:13:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:53892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404221AbhALM5v (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3D2723719;
        Tue, 12 Jan 2021 12:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456209;
        bh=51ph/iuEnVXkdLuhjF2irXR0+XEbWi5bLFa6knyBXV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tDm5Pr5x76IkHTkQq8QKjQvGYDEQezyR/Qm8/DrB9KcoKubWs3lBDpJx3IZgwatf9
         5qtqz1RhF4OMJ5YJan8gql/HJc1EqkMVcaUrNB+W/fB3B7mWrQV9pDMlRi4uO9/bnE
         jiRBMEoDINWjXzeCjexP6BJ/Rczu8m/TlBKwc7/bpuAA2Z2r6J7uec3y/XtzUHmhjd
         o7Lv5wTUoHW4I0WG/IddyWdX6+qKJOWlolNyxii0Gw0Tcy1NRwvS1k7nIyrDcDT7+U
         fJTI+EDokx5402NQBEeGOW3GIDu2xdVbEwpgODDZB1+HyAlhPq0TW6Rb0MB2Nl0uFc
         BiExC0QScKbLg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 03/28] ARC: build: add boot_targets to PHONY
Date:   Tue, 12 Jan 2021 07:56:19 -0500
Message-Id: <20210112125645.70739-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125645.70739-1-sashal@kernel.org>
References: <20210112125645.70739-1-sashal@kernel.org>
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
index b0b119ebd9e9f..c95b950389ba6 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -92,6 +92,7 @@ boot		:= arch/arc/boot
 
 boot_targets := uImage uImage.bin uImage.gz uImage.lzma
 
+PHONY += $(boot_targets)
 $(boot_targets): vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
 
-- 
2.27.0

