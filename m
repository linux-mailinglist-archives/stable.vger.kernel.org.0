Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58E445C59B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350559AbhKXN72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:59:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:45462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353111AbhKXN4r (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:56:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D38136124F;
        Wed, 24 Nov 2021 13:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759239;
        bh=oIPjv98Pj0MvpxF1IEhezwRQodIOeK4JnPNBxGngxHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M2odErYFu/jXWAaMVuSP3wbA237BKfmSIKrZwR+4nSNtr1ewRw2PxTKIsvTyxxXAS
         eGQvWU8MJ8APsci0/Fs1TzgBRVs/TPwLelXuCfUQuo7g9yxZjz59BKfgJ8yJck5C90
         P8R8SM9uQ8Yu/f4HoMgxMXszVXZtoO0tJFfZsK4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Schwab <schwab@suse.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 175/279] riscv: fix building external modules
Date:   Wed, 24 Nov 2021 12:57:42 +0100
Message-Id: <20211124115724.791647522@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Schwab <schwab@suse.de>

[ Upstream commit 5a19c7e06236a9c55dfc001bb4d1a8f1950d23e7 ]

When building external modules, vdso_prepare should not be run.  If the
kernel sources are read-only, it will fail.

Fixes: fde9c59aebaf ("riscv: explicitly use symbol offsets for VDSO")
Signed-off-by: Andreas Schwab <schwab@suse.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 0eb4568fbd290..41f3a75fe2ec8 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -108,11 +108,13 @@ PHONY += vdso_install
 vdso_install:
 	$(Q)$(MAKE) $(build)=arch/riscv/kernel/vdso $@
 
+ifeq ($(KBUILD_EXTMOD),)
 ifeq ($(CONFIG_MMU),y)
 prepare: vdso_prepare
 vdso_prepare: prepare0
 	$(Q)$(MAKE) $(build)=arch/riscv/kernel/vdso include/generated/vdso-offsets.h
 endif
+endif
 
 ifneq ($(CONFIG_XIP_KERNEL),y)
 ifeq ($(CONFIG_RISCV_M_MODE)$(CONFIG_SOC_CANAAN),yy)
-- 
2.33.0



