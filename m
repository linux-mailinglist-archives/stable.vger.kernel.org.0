Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22ADF3B600C
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbhF1OV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:21:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233170AbhF1OVc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4941361C75;
        Mon, 28 Jun 2021 14:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889946;
        bh=Fn+MfaRfUiknVaKYJyn4fWh6H+UdE8WZcI2glV1+a94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rDAmV9tQcKfZkflEWVic6m0nd47cksrP1ACNmIpclSMXATZPfKpk0XABSsPTd1qvy
         Li8H1EfwCIbDmX5Nwf61XiuDd4vftBicoqRU9wNjzMowHJR0oRM61cKXdywvjdLY8d
         DNkPOU4OSk5kpAr7rye5LketKqw4YA6xyThkykSNZ3iCxcS/NvKo8fzQYqtJ7a0DJp
         YdsXXV9XkGZ+1aRvUEiQ0ockhIhNHuuOaO+m9/ertfH+rPPNqoxIudwI80ppIntIXB
         LyQxNGjdEcIWa1F1Oyoo7rpVYZG6Z8VGE4EtDj0ZDDlxAJF7u1VXE0N3sPXPOX0Bhg
         sGvFoDYH6bITg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Khem Raj <raj.khem@gmail.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 043/110] riscv32: Use medany C model for modules
Date:   Mon, 28 Jun 2021 10:17:21 -0400
Message-Id: <20210628141828.31757-44-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
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
index 5243bf2327c0..a5ee34117321 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -16,7 +16,7 @@ ifeq ($(CONFIG_DYNAMIC_FTRACE),y)
 	CC_FLAGS_FTRACE := -fpatchable-function-entry=8
 endif
 
-ifeq ($(CONFIG_64BIT)$(CONFIG_CMODEL_MEDLOW),yy)
+ifeq ($(CONFIG_CMODEL_MEDLOW),y)
 KBUILD_CFLAGS_MODULE += -mcmodel=medany
 endif
 
-- 
2.30.2

