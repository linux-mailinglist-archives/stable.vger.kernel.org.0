Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 170E5FEFEF
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731110AbfKPPxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:53:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:33910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731102AbfKPPxB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:53:01 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8A3521826;
        Sat, 16 Nov 2019 15:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919580;
        bh=XfDiQjvwi/dxFwd5jdxe7CZGUs6C2zCSTVXvUAaR0ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PoOcClXjnMWEtsPBLiqlzl5Qv8W930ea5NOuetNCTk9jeUxrDOUfwW7BvPLMwrLl6
         m3354RIOJDR0J9bynW4edyhBbHxCIjLnWT8ycva7D2yrL3lJk8X2/m1La7hEhFLDee
         LxXvDrUglU3fiTFdfnJobmV9BiaDUvj8yHe4cFpY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Victor Kamensky <kamensky@cisco.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 72/99] arm64: makefile fix build of .i file in external module case
Date:   Sat, 16 Nov 2019 10:50:35 -0500
Message-Id: <20191116155103.10971-72-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155103.10971-1-sashal@kernel.org>
References: <20191116155103.10971-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Victor Kamensky <kamensky@cisco.com>

[ Upstream commit 98356eb0ae499c63e78073ccedd9a5fc5c563288 ]

After 'a66649dab350 arm64: fix vdso-offsets.h dependency' if
one will try to build .i file in case of external kernel module,
build fails complaining that prepare0 target is missing. This
issue came up with SystemTap when it tries to build variety
of .i files for its own generated kernel modules trying to
figure given kernel features/capabilities.

The issue is that prepare0 is defined in top level Makefile
only if KBUILD_EXTMOD is not defined. .i file rule depends
on prepare and in case KBUILD_EXTMOD defined top level Makefile
contains empty rule for prepare. But after mentioned commit
arch/arm64/Makefile would introduce dependency on prepare0
through its own prepare target.

Fix it to put proper ifdef KBUILD_EXTMOD around code introduced
by mentioned commit. It matches what top level Makefile does.

Acked-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Victor Kamensky <kamensky@cisco.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index ee94597773fab..8d469aa5fc987 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -134,6 +134,7 @@ archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
 	$(Q)$(MAKE) $(clean)=$(boot)/dts
 
+ifeq ($(KBUILD_EXTMOD),)
 # We need to generate vdso-offsets.h before compiling certain files in kernel/.
 # In order to do that, we should use the archprepare target, but we can't since
 # asm-offsets.h is included in some files used to generate vdso-offsets.h, and
@@ -143,6 +144,7 @@ archclean:
 prepare: vdso_prepare
 vdso_prepare: prepare0
 	$(Q)$(MAKE) $(build)=arch/arm64/kernel/vdso include/generated/vdso-offsets.h
+endif
 
 define archhelp
   echo  '* Image.gz      - Compressed kernel image (arch/$(ARCH)/boot/Image.gz)'
-- 
2.20.1

