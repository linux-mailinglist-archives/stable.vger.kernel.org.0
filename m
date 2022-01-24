Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B51499E59
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356483AbiAXWco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:32:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1585424AbiAXWXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:23:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CE8C04189C;
        Mon, 24 Jan 2022 12:53:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45B51B811FB;
        Mon, 24 Jan 2022 20:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82EC5C340E5;
        Mon, 24 Jan 2022 20:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057629;
        bh=QjAv+mVi3dI62MzHUFz7B9G4FS95ehWT/yUknSVrAwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E8/yhqkSmwH+cz7jHIpLEntlFSlNqJgxVAJPzuKIWCjGYbNAugNSktBTv3oItVZOw
         MPD3J/xsvap3V5QWQ7OJRBBt1w+cfj7odnD3/SH8yK/0pQnxUv81ZqyJGBZnHsPrwE
         e2enNCaFKxjZGVCp6vrXLoSHbbe43M3hKqe0UjJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jisheng Zhang <jszhang@kernel.org>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.16 0028/1039] riscv: mm: fix wrong phys_ram_base value for RV64
Date:   Mon, 24 Jan 2022 19:30:17 +0100
Message-Id: <20220124184126.086370772@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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


