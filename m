Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA1A3C2F42
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbhGJCbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:31:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234168AbhGJC3O (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:29:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AB0A6142B;
        Sat, 10 Jul 2021 02:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883936;
        bh=IxaehiJGGRFs1bfaxinZIXvUNI2hkK+ktz7VylF8d7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WFuNhiUkR3dnB7U8y75Ue2OxcejBZtXOfs2ztY5P9vMPEiwSCpnmyew3+AD1sW5iD
         z8mv/u5unP0rcam6qzoCkhQGa2CsUIeNIgUdKlCMh78oK6oItoXHSOkNHfpP1RS7vk
         RM412gXrI2v90fDoy8QIuvJZV+uX17o8p/a7ijBTHuKF+mcdzLQNmyC+2irYh0iCED
         UUmrVdG8lJ/ePf4Uv17ogGCHvkAjLmEN9isPu1oZ0FoAPCfkmReR9IY/M/ZaW+sPem
         eTyi0bLTBo0OJtpe9cgdWhqpkImylra9WJa+7yFrnGDDZstLcNgQ6czT8qc3UXPFRv
         lcDTuCawn4xrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabrice Fontaine <fontaine.fabrice@gmail.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 51/93] s390: disable SSP when needed
Date:   Fri,  9 Jul 2021 22:23:45 -0400
Message-Id: <20210710022428.3169839-51-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
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
index ba94b03c8b2f..92506918da63 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -28,6 +28,7 @@ KBUILD_CFLAGS_DECOMPRESSOR += -DDISABLE_BRANCH_PROFILING -D__NO_FORTIFY
 KBUILD_CFLAGS_DECOMPRESSOR += -fno-delete-null-pointer-checks -msoft-float
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

