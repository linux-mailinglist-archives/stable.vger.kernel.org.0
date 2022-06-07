Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6AA541589
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376513AbiFGUgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378094AbiFGUeu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:34:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C533F1EA043;
        Tue,  7 Jun 2022 11:37:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6367DB823A0;
        Tue,  7 Jun 2022 18:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0517C385A5;
        Tue,  7 Jun 2022 18:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627044;
        bh=Oz+plO2iRurQYDPDw9ZV4i0l5/QPC6FIt06Lw0gRW90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YVxl42hYaR8glijHHA8TyxtzrdCn/3rfATM0huE1v6NuUYm7Q2CKRGun2t2+Qy8nw
         T4b8CMuX4tuP6dMQ4yRiQP9OCkbepRmPL6gmkCKKHh03BtfS9JsTXlsXaNyBGO/1U4
         MeX9o8eoYG232Ps7F3QMHKlgiXrMipKh/QtoqOP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Ren <guoren@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 596/772] RISC-V: Fix the XIP build
Date:   Tue,  7 Jun 2022 19:03:08 +0200
Message-Id: <20220607165006.505285204@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Palmer Dabbelt <palmer@rivosinc.com>

[ Upstream commit d9e418d0ca1c464fe361468b772d4aa870d54e63 ]

A handful of functions unused functions were enabled during XIP builds,
which themselves didn't build correctly.  This just disables the
functions entirely.

Fixes: e8a62cc26ddf ("riscv: Implement sv48 support")
Reviewed-by: Guo Ren <guoren@kernel.org>
Link: https://lore.kernel.org/r/20220420184056.7886-5-palmer@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 697a9aed4f77..e42c51196995 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -591,7 +591,7 @@ static __init pgprot_t pgprot_from_va(uintptr_t va)
 }
 #endif /* CONFIG_STRICT_KERNEL_RWX */
 
-#ifdef CONFIG_64BIT
+#if defined(CONFIG_64BIT) && !defined(CONFIG_XIP_KERNEL)
 static void __init disable_pgtable_l4(void)
 {
 	pgtable_l4_enabled = false;
-- 
2.35.1



