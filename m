Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829982FA31C
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392880AbhAROcO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:32:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:38144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390807AbhARLm7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:42:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E32A422DA7;
        Mon, 18 Jan 2021 11:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970149;
        bh=Vn16jtZNEFCsP1kplk5ejLVYwaw2lJfNlSUz/ajB2EY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O8+6nmNYrnphjhnhs5U+VL418ORAUVF60J/5niS7aCl4vwsCCo5PlauZt9ZJS5Z+d
         plxqJnyUxuDtHgGWSNIvqbHHeI1S6xM1SIgg3kvyiohNozsmntsjMVwKDjNWiky4qx
         lhgbp4pDlyIgl/udnyTuQR299oNyZI5i76XRlBIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/152] ARC: build: add boot_targets to PHONY
Date:   Mon, 18 Jan 2021 12:33:52 +0100
Message-Id: <20210118113355.527030744@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
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
index 61a41123ad4c4..cf9da9aea12ac 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -104,6 +104,7 @@ boot		:= arch/arc/boot
 
 boot_targets := uImage uImage.bin uImage.gz uImage.lzma
 
+PHONY += $(boot_targets)
 $(boot_targets): vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
 
-- 
2.27.0



