Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0776210BCB0
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731349AbfK0VFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:05:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:58666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731932AbfK0VFB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:05:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D49D42178F;
        Wed, 27 Nov 2019 21:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888701;
        bh=kJetW/Z6Ckzen/8njzEpaOOotsP1WWeBNpmitgi3smI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QoGFDiNJ18iWud2vLUZqSbIkMjyNDTAy2MoBUOHpZdZNyBFEFiMc+VXsSQFXU5qQJ
         7TwQXJ3GPPE37u0ppRFtXIAvoPs5BenUYtFO1jpg++ypwZAmbNqI7JHCtTpPpfo0gs
         jIX1wrgGba2Mm6fvv3YUe3mg7pAIuMy0FueOsGt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Brodsky <kevin.brodsky@arm.com>,
        Victor Kamensky <kamensky@cisco.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 193/306] arm64: makefile fix build of .i file in external module case
Date:   Wed, 27 Nov 2019 21:30:43 +0100
Message-Id: <20191127203129.314361619@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
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
index 5d8787f0ca5f9..9a5e281412116 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -148,6 +148,7 @@ archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
 	$(Q)$(MAKE) $(clean)=$(boot)/dts
 
+ifeq ($(KBUILD_EXTMOD),)
 # We need to generate vdso-offsets.h before compiling certain files in kernel/.
 # In order to do that, we should use the archprepare target, but we can't since
 # asm-offsets.h is included in some files used to generate vdso-offsets.h, and
@@ -157,6 +158,7 @@ archclean:
 prepare: vdso_prepare
 vdso_prepare: prepare0
 	$(Q)$(MAKE) $(build)=arch/arm64/kernel/vdso include/generated/vdso-offsets.h
+endif
 
 define archhelp
   echo  '* Image.gz      - Compressed kernel image (arch/$(ARCH)/boot/Image.gz)'
-- 
2.20.1



