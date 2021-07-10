Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8DF3C2E38
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbhGJC0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:26:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233162AbhGJCZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:25:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51C67613AF;
        Sat, 10 Jul 2021 02:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883788;
        bh=iltiHxdz1e8vkb/ZLiYSQzFszXkKMHS4XNSyFkNI/TE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=so/SUlL0w5SKrvtQl6dNuYqzx4VBsekKMnmCkAjP6lAwxK+S/4cqoshhZp0zTVQYn
         8wNOZ3ZRZxa1lXeBTEbDzHCN82XnEB88rh39rMOWqZrWIOozvr7l9vT17ctj+6QlbV
         El4ILWQyny/UNruS33Ex0vqYYoSUDOrLAjwbYSPtMS0Qs75LUUY1JDPW3YdUtHObXZ
         9yH6lwFiNSktOjoZhFzv5Jk4u2Ah8JTg/1MXTxY0oZNFDnQu+2AHgDeSJEi1j119LQ
         3b1SpK+J3Qlo1mIWrigqOmCGZa69n+ygOX9McUJlxVT9TpkukUUbKG5amQ4E4tpXDm
         OOjRuHiu2A5sQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabrice Fontaine <fontaine.fabrice@gmail.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 054/104] s390: disable SSP when needed
Date:   Fri,  9 Jul 2021 22:21:06 -0400
Message-Id: <20210710022156.3168825-54-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrice Fontaine <fontaine.fabrice@gmail.com>

[ Upstream commit 42e8d652438f5ddf04e5dac299cb5e623d113dc0 ]

Though -nostdlib is passed in PURGATORY_LDFLAGS and -ffreestanding in
KBUILD_CFLAGS_DECOMPRESSOR, -fno-stack-protector must also be passed to
avoid linking errors related to undefined references to
'__stack_chk_guard' and '__stack_chk_fail' if toolchain enforces
-fstack-protector.

Fixes
 - https://gitlab.com/kubu93/buildroot/-/jobs/1247043361

Signed-off-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Reviewed-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Tested-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Link: https://lore.kernel.org/r/20210510053133.1220167-1-fontaine.fabrice@gmail.com
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/Makefile           | 1 +
 arch/s390/purgatory/Makefile | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index e443ed9947bd..098abe3a56f3 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -28,6 +28,7 @@ KBUILD_CFLAGS_DECOMPRESSOR += -DDISABLE_BRANCH_PROFILING -D__NO_FORTIFY
 KBUILD_CFLAGS_DECOMPRESSOR += -fno-delete-null-pointer-checks -msoft-float -mbackchain
 KBUILD_CFLAGS_DECOMPRESSOR += -fno-asynchronous-unwind-tables
 KBUILD_CFLAGS_DECOMPRESSOR += -ffreestanding
+KBUILD_CFLAGS_DECOMPRESSOR += -fno-stack-protector
 KBUILD_CFLAGS_DECOMPRESSOR += $(call cc-disable-warning, address-of-packed-member)
 KBUILD_CFLAGS_DECOMPRESSOR += $(if $(CONFIG_DEBUG_INFO),-g)
 KBUILD_CFLAGS_DECOMPRESSOR += $(if $(CONFIG_DEBUG_INFO_DWARF4), $(call cc-option, -gdwarf-4,))
diff --git a/arch/s390/purgatory/Makefile b/arch/s390/purgatory/Makefile
index c57f8c40e992..21c4ebe29b9a 100644
--- a/arch/s390/purgatory/Makefile
+++ b/arch/s390/purgatory/Makefile
@@ -24,6 +24,7 @@ KBUILD_CFLAGS := -fno-strict-aliasing -Wall -Wstrict-prototypes
 KBUILD_CFLAGS += -Wno-pointer-sign -Wno-sign-compare
 KBUILD_CFLAGS += -fno-zero-initialized-in-bss -fno-builtin -ffreestanding
 KBUILD_CFLAGS += -c -MD -Os -m64 -msoft-float -fno-common
+KBUILD_CFLAGS += -fno-stack-protector
 KBUILD_CFLAGS += $(CLANG_FLAGS)
 KBUILD_CFLAGS += $(call cc-option,-fno-PIE)
 KBUILD_AFLAGS := $(filter-out -DCC_USING_EXPOLINE,$(KBUILD_AFLAGS))
-- 
2.30.2

