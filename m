Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7723B60F8
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbhF1ObY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:31:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234747AbhF1OaZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:30:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A807061CB8;
        Mon, 28 Jun 2021 14:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890405;
        bh=tgPcxuGjzy0G6s+Y43FulBrZ/Q/BfammVdZeVAAL3o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LAyL2RyHk5lllgfGLL/wMQyba1a9r3f7agGMP6MjapOgb/EHeQfxAjoV/Mf/hw7pY
         rchJi0nsrcExWO+b+kRVnlYdPcAyCgG0f3r/IJ5MwdnDoi6xMhJ7blLxd3jhugg+Jp
         j0mjIIVdHzLhYtr7OyiQRUU/Q5ndkk4U9I3Y1ihB57q9cwyC20mj55R0cNq4DLL1Aq
         HDhEz3ulv/9d7vVNbl5Ee3UkZ+rz6AOiojJFc29EpvgDDG3NrcOElESnr8AkaAT6Hi
         W6jpqzrJkpSo690jGDvdS6dgeC5TjCegsacqZqGpTo42zLT8nOtMP/aVtkZz5PJMK3
         LemtjuY48Rczw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Khem Raj <raj.khem@gmail.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/101] riscv32: Use medany C model for modules
Date:   Mon, 28 Jun 2021 10:25:08 -0400
Message-Id: <20210628142607.32218-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Khem Raj <raj.khem@gmail.com>

[ Upstream commit 5d2388dbf84adebeb6d9742164be8d32728e4269 ]

When CONFIG_CMODEL_MEDLOW is used it ends up generating riscv_hi20_rela
relocations in modules which are not resolved during runtime and
following errors would be seen

[    4.802714] virtio_input: target 00000000c1539090 can not be addressed by the 32-bit offset from PC = 39148b7b
[    4.854800] virtio_input: target 00000000c1539090 can not be addressed by the 32-bit offset from PC = 9774456d

Signed-off-by: Khem Raj <raj.khem@gmail.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index e241e0e85ac8..226c366072da 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -14,7 +14,7 @@ ifeq ($(CONFIG_DYNAMIC_FTRACE),y)
 	LDFLAGS_vmlinux := --no-relax
 endif
 
-ifeq ($(CONFIG_64BIT)$(CONFIG_CMODEL_MEDLOW),yy)
+ifeq ($(CONFIG_CMODEL_MEDLOW),y)
 KBUILD_CFLAGS_MODULE += -mcmodel=medany
 endif
 
-- 
2.30.2

