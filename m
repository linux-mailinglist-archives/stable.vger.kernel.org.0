Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27A87FF1D3
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729729AbfKPPrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:47:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:54334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729724AbfKPPrf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:47:35 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B37F3208C0;
        Sat, 16 Nov 2019 15:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919254;
        bh=gLtelvidJmu/jlsBQOJ2hGDX/2Qcy3X0HMoFKf8YEr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oOcmbnFJMNO9mMj0FDVHA+rnqWeu5NiZcznLAamH6iyWBd4uMNsqsugXaY/dXg2wA
         CFyzk1tAXO0OrHU7jydeJqbAdAcwLM1elS5NLxIeT0A65BhRyhEhROLvI2cpy86TOh
         T2Uy9dqD6x1QFFXKMXDlaktazY1/SeEy9OgONYUU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joel Stanley <joel@jms.id.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 007/150] powerpc/boot: Disable vector instructions
Date:   Sat, 16 Nov 2019 10:45:05 -0500
Message-Id: <20191116154729.9573-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit e8e132e6885962582784b6fa16a80d07ea739c0f ]

This will avoid auto-vectorisation when building with higher
optimisation levels.

We don't know if the machine can support VSX and even if it's present
it's probably not going to be enabled at this point in boot.

These flag were both added prior to GCC 4.6 which is the minimum
compiler version supported by upstream, thanks to Segher for the
details.

Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index e2a5a932c24a8..5807c9d8e56d5 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -24,8 +24,8 @@ compress-$(CONFIG_KERNEL_GZIP) := CONFIG_KERNEL_GZIP
 compress-$(CONFIG_KERNEL_XZ)   := CONFIG_KERNEL_XZ
 
 BOOTCFLAGS    := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
-		 -fno-strict-aliasing -Os -msoft-float -pipe \
-		 -fomit-frame-pointer -fno-builtin -fPIC -nostdinc \
+		 -fno-strict-aliasing -Os -msoft-float -mno-altivec -mno-vsx \
+		 -pipe -fomit-frame-pointer -fno-builtin -fPIC -nostdinc \
 		 -D$(compress-y)
 
 BOOTCC := $(CC)
-- 
2.20.1

