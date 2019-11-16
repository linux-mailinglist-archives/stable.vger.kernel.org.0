Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBA87FECFF
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbfKPPlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:41:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:44342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727702AbfKPPlW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:22 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B09A20718;
        Sat, 16 Nov 2019 15:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918882;
        bh=4Bq9zUx7ceP48+ET5OQc8d7++KgI10SHReEseY/1MN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zNB9pdymWpuqxlvMM9lJqPF/6bnqxMSuAy9ChSpKhfjvxWoxILX1LJr8RzFGm3o2a
         w8IDnc1E7QYSMPGXxrJDFJ46kO+DXB6DwXkrjGIW2Tcmysc2bQ8dNdnwPYlI7dpxav
         7SvgqZfDvVVKoxmAwZJjFvgRImzMVG/qFjG7bKnY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joel Stanley <joel@jms.id.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 011/237] powerpc/boot: Fix opal console in boot wrapper
Date:   Sat, 16 Nov 2019 10:37:26 -0500
Message-Id: <20191116154113.7417-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit 1a855eaccf353f7ed1d51a3d4b3af727ccbd81ca ]

As of commit 10c77dba40ff ("powerpc/boot: Fix build failure in 32-bit
boot wrapper") the opal code is hidden behind CONFIG_PPC64_BOOT_WRAPPER,
but the boot wrapper avoids include/linux, so it does not get the normal
Kconfig flags.

We can drop the guard entirely as in commit f8e8e69cea49 ("powerpc/boot:
Only build OPAL code when necessary") the makefile only includes opal.c
in the build if CONFIG_PPC64_BOOT_WRAPPER is set.

Fixes: 10c77dba40ff ("powerpc/boot: Fix build failure in 32-bit boot wrapper")
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/opal.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/powerpc/boot/opal.c b/arch/powerpc/boot/opal.c
index 0272570d02de1..dfb199ef5b949 100644
--- a/arch/powerpc/boot/opal.c
+++ b/arch/powerpc/boot/opal.c
@@ -13,8 +13,6 @@
 #include <libfdt.h>
 #include "../include/asm/opal-api.h"
 
-#ifdef CONFIG_PPC64_BOOT_WRAPPER
-
 /* Global OPAL struct used by opal-call.S */
 struct opal {
 	u64 base;
@@ -101,9 +99,3 @@ int opal_console_init(void *devp, struct serial_console_data *scdp)
 
 	return 0;
 }
-#else
-int opal_console_init(void *devp, struct serial_console_data *scdp)
-{
-	return -1;
-}
-#endif /* __powerpc64__ */
-- 
2.20.1

