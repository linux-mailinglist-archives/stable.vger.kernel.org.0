Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85E893AF30F
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 19:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbhFUR6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 13:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232132AbhFUR4v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 13:56:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E53D613AD;
        Mon, 21 Jun 2021 17:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298012;
        bh=tgPcxuGjzy0G6s+Y43FulBrZ/Q/BfammVdZeVAAL3o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bzjJSckKvOTlS8ep0J+UsjT3pQmdistkxCofKH92WW8e1xyj7rBvdHe/Fj1yqIlKG
         A7M0FfWau+yrPCc1iftZ8h4GOWpKSP7PVv1kZDeP/c9eDRltmiHcP2NnylUWagSnNm
         lxrSjJ+BrLPzwDnnCs/vyxItmbrnMtsJ8fsPiDGA5EyXcLCcBKvTQDzNrG/r6H4t0G
         2IBrFiXaXr7PzoBxPGKELeA5QRfMhMbdoYWd8zSMphdcTdJUZ5PKD0vLyUqRmlHL3L
         zm/a1ecVjLxU5RUt/LmJlGlAZKafkUaoRvBRbcNOijuL3HF6mFU6sYEiofT+meXhst
         m7Xr/5JP0rDpw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Khem Raj <raj.khem@gmail.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 21/35] riscv32: Use medany C model for modules
Date:   Mon, 21 Jun 2021 13:52:46 -0400
Message-Id: <20210621175300.735437-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175300.735437-1-sashal@kernel.org>
References: <20210621175300.735437-1-sashal@kernel.org>
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

