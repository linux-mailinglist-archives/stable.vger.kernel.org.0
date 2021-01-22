Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C57300FD1
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 23:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730410AbhAVT4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 14:56:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:34330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728266AbhAVOKZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:10:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 421C523A5C;
        Fri, 22 Jan 2021 14:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324544;
        bh=eTOgMSs1N1PxgfxMoj1wYstzx8Qpt5KjBgDBV0XfFRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TrKUDx8MJURFFm8bDhnUArJqLCuB6Qif8EDfi/OMhmvMrwTVvsTz4uIxpn3BiOFyh
         /p4C3Qglu6FaoYpppVB/MbMieoVihmwoMt1FM/9jjcNofj3TYya208MsUHZIAVcpqV
         KGdoVAaXMbO37adS+eBp5FSSjnHx4G3nUNA04X2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 05/31] ARC: build: add boot_targets to PHONY
Date:   Fri, 22 Jan 2021 15:08:19 +0100
Message-Id: <20210122135732.089321885@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135731.873346566@linuxfoundation.org>
References: <20210122135731.873346566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 0cfccb3c04934cdef42ae26042139f16e805b5f7 ]

The top-level boot_targets (uImage and uImage.*) should be phony
targets. They just let Kbuild descend into arch/arc/boot/ and create
files there.

If a file exists in the top directory with the same name, the boot
image will not be created.

You can confirm it by the following steps:

  $ export CROSS_COMPILE=<your-arc-compiler-prefix>
  $ make -s ARCH=arc defconfig all   # vmlinux will be built
  $ touch uImage.gz
  $ make ARCH=arc uImage.gz
  CALL    scripts/atomic/check-atomics.sh
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  # arch/arc/boot/uImage.gz is not created

Specify the targets as PHONY to fix this.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arc/Makefile b/arch/arc/Makefile
index 8f8d53f08141d..150656503c117 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -108,6 +108,7 @@ bootpImage: vmlinux
 
 boot_targets += uImage uImage.bin uImage.gz
 
+PHONY += $(boot_targets)
 $(boot_targets): vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
 
-- 
2.27.0



