Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF8138EF0A
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234902AbhEXPzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:55:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234652AbhEXPyI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:54:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CA8D613F5;
        Mon, 24 May 2021 15:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870777;
        bh=B2YmaOLZ8sUvAHqkfhLKExSdVVQsHbEQlSclP+9YIOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ldYX8n9SOk97UPEIOBjeUTST3H2Oe/Iqr1pJt4DwPDiHzxGqFeLWKF+BFjBErblPF
         0kg5fBhZgfFSIZpkrDOLllgbRfrwd9r+fM068QJlynosbor1703A+Z0EX//biPM3/u
         Ak+ga+T9Hpz12o06yhRB/lE6NKTXWf9jqxEE9SB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/104] powerpc: Fix early setup to make early_ioremap() work
Date:   Mon, 24 May 2021 17:25:25 +0200
Message-Id: <20210524152333.811212934@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit e2f5efd0f0e229bd110eab513e7c0331d61a4649 ]

The immediate problem is that after commit
0bd3f9e953bd ("powerpc/legacy_serial: Use early_ioremap()") the kernel
silently reboots on some systems.

The reason is that early_ioremap() returns broken addresses as it uses
slot_virt[] array which initialized with offsets from FIXADDR_TOP ==
IOREMAP_END+FIXADDR_SIZE == KERN_IO_END - FIXADDR_SIZ + FIXADDR_SIZE ==
__kernel_io_end which is 0 when early_ioremap_setup() is called.
__kernel_io_end is initialized little bit later in early_init_mmu().

This fixes the initialization by swapping early_ioremap_setup() and
early_init_mmu().

Fixes: 265c3491c4bc ("powerpc: Add support for GENERIC_EARLY_IOREMAP")
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
[mpe: Drop unrelated cleanup & cleanup change log]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210520032919.358935-1-aik@ozlabs.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/setup_64.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 3b871ecb3a92..3f8426bccd16 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -368,11 +368,11 @@ void __init early_setup(unsigned long dt_ptr)
 	apply_feature_fixups();
 	setup_feature_keys();
 
-	early_ioremap_setup();
-
 	/* Initialize the hash table or TLB handling */
 	early_init_mmu();
 
+	early_ioremap_setup();
+
 	/*
 	 * After firmware and early platform setup code has set things up,
 	 * we note the SPR values for configurable control/performance
-- 
2.30.2



