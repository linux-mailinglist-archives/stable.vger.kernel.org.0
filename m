Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B8C3AF288
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 19:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbhFURzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 13:55:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232127AbhFURys (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 13:54:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CEC2611C1;
        Mon, 21 Jun 2021 17:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297954;
        bh=Fn+MfaRfUiknVaKYJyn4fWh6H+UdE8WZcI2glV1+a94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j02hr2VSL/JuomTkfvinWOrxip1Ax0vTtTyyZquNVMdNdUMrsrJy7m85ohl92o7YP
         TdPeowDXFGVdQpKgESCfsZhEUwKV9FTEcTia1OETLt8L6hVf3yxvP/kRUCdRpBz6md
         drV0GIzDNzel4gdFC9Av9Kga5H3nS8h94xjlOVZ6zaxawi6TkGfGwOBYccg6MqqX4F
         YpPfhrVQxjDWirG3LqHGZPPBzhrCqZ5ttMkPSN3UGs/9vXB3roWy6QO0/3DnoHiC/R
         LjyK01m/pPMHWkt30ZJ+W9klMm/ZIpmwSO7mmoWmAi4vIJWNFhbDfuPZHEy7I6g7ND
         kmRLnab812oxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Khem Raj <raj.khem@gmail.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 22/39] riscv32: Use medany C model for modules
Date:   Mon, 21 Jun 2021 13:51:38 -0400
Message-Id: <20210621175156.735062-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175156.735062-1-sashal@kernel.org>
References: <20210621175156.735062-1-sashal@kernel.org>
MIME-Version: 1.0
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

