Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBDD2F3020
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbhALND3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:03:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:53842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405411AbhALM6i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C05052311A;
        Tue, 12 Jan 2021 12:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456292;
        bh=bkzbPcHxcN/DM4HPuvrVe94k+onOrF2TMurpnbCymt4=;
        h=From:To:Cc:Subject:Date:From;
        b=ABBuPHqXnA2uwfJ8lMozhNbSalHK1XBXvQX69/hM3aYJ/EGnY30wIuLRyDYzl9cJG
         vuKnxysZPl7SkSp8xHd7FyDzjQ/8tAj8hGfhlemmCk3KYXPvXQHmo7tIKdhFc3IjM/
         Xj3dRmpByJqGcMnaRXGCKiLysU6jomD63XCaaekNTWdu0E04h1PYftUw6pcWhDjdcP
         b9hfWIAhZI/N6EuROnID1jtwy2GgsEGm2uUS1eRSGhechYWzrWvCpvmtK2uwgPW0LV
         H7AGLKvEfDX29UPPGewTIWKM/+aDk3DUijZASERLMrCFyERxk0T+mLXzWbckVWuK6P
         FRAnqF68n0YNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 1/8] ARC: build: add boot_targets to PHONY
Date:   Tue, 12 Jan 2021 07:58:02 -0500
Message-Id: <20210112125810.71348-1-sashal@kernel.org>
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
index fd79faab78926..5dc2d73c64994 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -108,6 +108,7 @@ bootpImage: vmlinux
 
 boot_targets += uImage uImage.bin uImage.gz
 
+PHONY += $(boot_targets)
 $(boot_targets): vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
 
-- 
2.27.0

