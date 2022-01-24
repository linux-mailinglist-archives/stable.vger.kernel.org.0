Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D058149A928
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322248AbiAYDV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:21:29 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37336 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379254AbiAXUK5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:10:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 560D261028;
        Mon, 24 Jan 2022 20:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BBADC340E5;
        Mon, 24 Jan 2022 20:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055055;
        bh=QjAv+mVi3dI62MzHUFz7B9G4FS95ehWT/yUknSVrAwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oovzwR4ZTDkLv/HqiGl0Q8ZtufrG2ZBMys4FEiSdCoOdhfGsk6dAT8wdlRPLSo2hh
         xd/fUQWSze1MUoRObt8G/ZaRwz1Ml2TSjad9kB6L6I3mbnpSU/mZ4OCbDL14MOt9g0
         F9rdv4TaN8tLCrh9XZB9DU6eBm1gKnA4SMUNr1v4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jisheng Zhang <jszhang@kernel.org>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 026/846] riscv: mm: fix wrong phys_ram_base value for RV64
Date:   Mon, 24 Jan 2022 19:32:23 +0100
Message-Id: <20220124184101.822048720@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jisheng Zhang <jszhang@kernel.org>

commit b0fd4b1bf995172b9efcee23600d4f69571c321c upstream.

Currently, if 64BIT and !XIP_KERNEL, the phys_ram_base is always 0,
no matter the real start of dram reported by memblock is.

Fixes: 6d7f91d914bc ("riscv: Get rid of CONFIG_PHYS_RAM_BASE in kernel physical address conversion")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Reviewed-by: Alexandre Ghiti <alex@ghiti.fr>
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -187,10 +187,10 @@ static void __init setup_bootmem(void)
 
 
 	phys_ram_end = memblock_end_of_DRAM();
-#ifndef CONFIG_64BIT
 #ifndef CONFIG_XIP_KERNEL
 	phys_ram_base = memblock_start_of_DRAM();
 #endif
+#ifndef CONFIG_64BIT
 	/*
 	 * memblock allocator is not aware of the fact that last 4K bytes of
 	 * the addressable memory can not be mapped because of IS_ERR_VALUE


