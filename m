Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEA710B862
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbfK0Umu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:42:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:49612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727813AbfK0Umt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:42:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2F1421780;
        Wed, 27 Nov 2019 20:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887369;
        bh=XfDiQjvwi/dxFwd5jdxe7CZGUs6C2zCSTVXvUAaR0ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GD1Uf8wF6qLG39VCaK4QTjm/nkOCtu5azIpiUerOnUogAzfn4QEnRREF67XNjxYQ5
         fUln8m9CpSFFPQMqODUMCTZ9WdNc03fiZA0em/JNyvdu0x5dp+4F4R3nM3mIegWUal
         RM2F7cQGxHURHijQnm+B4H71wLlMDIusClRTCLmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Brodsky <kevin.brodsky@arm.com>,
        Victor Kamensky <kamensky@cisco.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 084/151] arm64: makefile fix build of .i file in external module case
Date:   Wed, 27 Nov 2019 21:31:07 +0100
Message-Id: <20191127203036.453789056@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



