Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7EB3CE4CD
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241367AbhGSPqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:46:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343985AbhGSPni (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:43:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74F5661175;
        Mon, 19 Jul 2021 16:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711745;
        bh=iltiHxdz1e8vkb/ZLiYSQzFszXkKMHS4XNSyFkNI/TE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aNTqjyCqoFZEiMAtXFLdzUvQfhSQxGblbTjIj4AUpvg4f7xc4LqzsbXVOm5WxubB3
         wTgPelFbMFMXmT/pkh/uv2YAjAstEOMqVXzgQFi9PkSu9eR0H36jajpLQHiwfUBrvf
         QcUAr4mo+cfBYgKG+ZyBQSEXKUEKOTwyqxUl4NRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fabrice Fontaine <fontaine.fabrice@gmail.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 083/292] s390: disable SSP when needed
Date:   Mon, 19 Jul 2021 16:52:25 +0200
Message-Id: <20210719144945.247784264@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



