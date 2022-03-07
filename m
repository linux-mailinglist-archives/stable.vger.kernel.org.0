Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3C2C4CF76C
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbiCGJqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:46:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241151AbiCGJl4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206466392;
        Mon,  7 Mar 2022 01:40:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDCBDB810B9;
        Mon,  7 Mar 2022 09:40:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D985C340F3;
        Mon,  7 Mar 2022 09:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646052;
        bh=4yB1WueRXrnEYauJd4KT8rCFKjgpOh9M/xBmzREYX8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TW++v8YhMpJvMXgLJ640u3ffqA4/qb8ZY36aGlB4DRVCP5EkutgyLpkUrwYSj4IQU
         Uui0Tlg5UnCmwl/AZ/uM3VJIksA9/ZafraQsDg2jtFHBpvhGClrisdZrFaJ7WzGc5o
         q+Fk+H25+lZgYWwwG/nsh19c9AfLn4GfY9t3lWrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Myrtle Shah <gatecat@ds0.me>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/262] riscv/mm: Add XIP_FIXUP for phys_ram_base
Date:   Mon,  7 Mar 2022 10:17:41 +0100
Message-Id: <20220307091705.768399587@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Palmer Dabbelt <palmer@rivosinc.com>

[ Upstream commit 4b1c70aa8ed8249608bb991380cb8ff423edf49e ]

This manifests as a crash early in boot on VexRiscv.

Signed-off-by: Myrtle Shah <gatecat@ds0.me>
[Palmer: split commit]
Fixes: 6d7f91d914bc ("riscv: Get rid of CONFIG_PHYS_RAM_BASE in kernel physical address conversion")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 5e7decd875258..3de593b26850e 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -451,6 +451,7 @@ static uintptr_t __init best_map_size(phys_addr_t base, phys_addr_t size)
 }
 
 #ifdef CONFIG_XIP_KERNEL
+#define phys_ram_base  (*(phys_addr_t *)XIP_FIXUP(&phys_ram_base))
 /* called from head.S with MMU off */
 asmlinkage void __init __copy_data(void)
 {
-- 
2.34.1



