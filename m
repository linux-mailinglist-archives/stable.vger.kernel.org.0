Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF93303350
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbhAZEtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:49:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:33762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730102AbhAYSqS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:46:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C695120719;
        Mon, 25 Jan 2021 18:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600354;
        bh=qzM2hHj14eND2hCMF9AFPQw0B9SckEsTa+ivL8dBuIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X9Ww2bdYlQ1jR4unMValeL0Ejhip5lhyM36BQWnCgvRKcXl5pogN69m/+v+uSXqlL
         NHIRYMFWm7D+llQCtw4T7u/zNQ46TM0AVfjETHs/oBZx3ODWLs1aBCkWfM7MF0/MaG
         Tma2mX8/mXrIjXvcA9y4cLXdymhXpeIFPL2wUmKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Youling Tang <tangyouling@loongson.cn>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 42/86] powerpc: Use the common INIT_DATA_SECTION macro in vmlinux.lds.S
Date:   Mon, 25 Jan 2021 19:39:24 +0100
Message-Id: <20210125183202.840887063@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Youling Tang <tangyouling@loongson.cn>

[ Upstream commit fdcfeaba38e5b183045f5b079af94f97658eabe6 ]

Use the common INIT_DATA_SECTION rule for the linker script in an effort
to regularize the linker script.

Signed-off-by: Youling Tang <tangyouling@loongson.cn>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1604487550-20040-1-git-send-email-tangyouling@loongson.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/vmlinux.lds.S | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 4def51c12e1bf..f9081724d6910 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -223,21 +223,7 @@ SECTIONS
 		EXIT_TEXT
 	}
 
-	.init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {
-		INIT_DATA
-	}
-
-	.init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) {
-		INIT_SETUP(16)
-	}
-
-	.initcall.init : AT(ADDR(.initcall.init) - LOAD_OFFSET) {
-		INIT_CALLS
-	}
-
-	.con_initcall.init : AT(ADDR(.con_initcall.init) - LOAD_OFFSET) {
-		CON_INITCALL
-	}
+	INIT_DATA_SECTION(16)
 
 	. = ALIGN(8);
 	__ftr_fixup : AT(ADDR(__ftr_fixup) - LOAD_OFFSET) {
@@ -265,9 +251,6 @@ SECTIONS
 		__stop___fw_ftr_fixup = .;
 	}
 #endif
-	.init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
-		INIT_RAM_FS
-	}
 
 	PERCPU_SECTION(L1_CACHE_BYTES)
 
-- 
2.27.0



