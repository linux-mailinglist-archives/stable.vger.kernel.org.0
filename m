Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8530541D1D
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383816AbiFGWIU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379210AbiFGWG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:06:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DDB252C3C;
        Tue,  7 Jun 2022 12:15:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0406261922;
        Tue,  7 Jun 2022 19:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F010C385A2;
        Tue,  7 Jun 2022 19:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629356;
        bh=lnzJyWD5Iju1jLJes8+CZ8ONeHKG3GLp2Af/HR1ee1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NdJam4wenxNSfW50uPhfkvytr0feOhE28bZi7UhquzbHwauV0tPVaXQVe96EQUJxi
         br/76WX7zfh5M5q03PBHgS8eknUI3/N82Z2zLBtHvR4Zyi/4cqYbwplKr9AgjrEARO
         37u6G08A7lX5eaMdBxJaGE5kqJBPoyUq3N4lWlE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>,
        Guo Ren <guoren@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 661/879] riscv: Fixup difference with defconfig
Date:   Tue,  7 Jun 2022 19:02:59 +0200
Message-Id: <20220607165022.034185835@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Guo Ren <guoren@linux.alibaba.com>

[ Upstream commit 72f045d19f25f19be6d7682d5b1d948e20580817 ]

Let's follow the origin patch's spirit:

The only difference between rv32_defconfig and defconfig is that
rv32_defconfig has  CONFIG_ARCH_RV32I=y.

This is helpful to compare rv64-compat-rv32 v.s. rv32-linux.

Fixes: 1b937e8faa87ccfb ("RISC-V: Add separate defconfig for 32bit systems")
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20220405071314.3225832-9-guoren@kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 7d81102cffd4..c6ca1b9cbf71 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -154,3 +154,7 @@ PHONY += rv64_randconfig
 rv64_randconfig:
 	$(Q)$(MAKE) KCONFIG_ALLCONFIG=$(srctree)/arch/riscv/configs/64-bit.config \
 		-f $(srctree)/Makefile randconfig
+
+PHONY += rv32_defconfig
+rv32_defconfig:
+	$(Q)$(MAKE) -f $(srctree)/Makefile defconfig 32-bit.config
-- 
2.35.1



