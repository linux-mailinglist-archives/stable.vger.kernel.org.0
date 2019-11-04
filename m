Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7DA8EED8B
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389757AbfKDWHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:07:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:40554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390036AbfKDWHt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:07:49 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DE4921929;
        Mon,  4 Nov 2019 22:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905268;
        bh=BlP8IYozOevQrxXlH5TJfSbvPd0H39Pymk/5eaQJdRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HT1HHbKHjAeC2pj7qU71OhokKDPEZcrr3qnTZyxMuIZFbtfi35UqaZuwD79HS8H5v
         6KUwDPsIFIwBh6Y1iDkdfxFqG80vFmTxtG451AECGuErrYphzcrdz++jD72ZG7+JdQ
         rUzcjU8xySYCffLBC+pdy2GRwBlVOhvcT/cnUpRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 050/163] arm64: vdso32: Dont use KBUILD_CPPFLAGS unconditionally
Date:   Mon,  4 Nov 2019 22:44:00 +0100
Message-Id: <20191104212143.810507927@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

[ Upstream commit c71e88c437962c1ec43d4d23a0ebf4c9cf9bee0d ]

KBUILD_CPPFLAGS is defined differently depending on whether the main
compiler is clang or not. This means that it is not possible to build
the compat vDSO with GCC if the rest of the kernel is built with clang.

Define VDSO_CPPFLAGS directly to break this dependency and allow a clang
kernel to build a compat vDSO with GCC:

  $ make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- \
    CROSS_COMPILE_COMPAT=arm-linux-gnueabihf- CC=clang \
    COMPATCC=arm-linux-gnueabihf-gcc

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/vdso32/Makefile | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/vdso32/Makefile b/arch/arm64/kernel/vdso32/Makefile
index 77aa613403747..aa171b043287b 100644
--- a/arch/arm64/kernel/vdso32/Makefile
+++ b/arch/arm64/kernel/vdso32/Makefile
@@ -25,11 +25,9 @@ cc32-as-instr = $(call try-run,\
 # arm64 one.
 # As a result we set our own flags here.
 
-# From top-level Makefile
-# NOSTDINC_FLAGS
-VDSO_CPPFLAGS := -nostdinc -isystem $(shell $(COMPATCC) -print-file-name=include)
+# KBUILD_CPPFLAGS and NOSTDINC_FLAGS from top-level Makefile
+VDSO_CPPFLAGS := -D__KERNEL__ -nostdinc -isystem $(shell $(COMPATCC) -print-file-name=include)
 VDSO_CPPFLAGS += $(LINUXINCLUDE)
-VDSO_CPPFLAGS += $(KBUILD_CPPFLAGS)
 
 # Common C and assembly flags
 # From top-level Makefile
-- 
2.20.1



