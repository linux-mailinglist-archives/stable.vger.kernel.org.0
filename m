Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEB45EA580
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239016AbiIZMGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239045AbiIZMDW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:03:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478A87CAB9;
        Mon, 26 Sep 2022 03:54:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AE7660AF0;
        Mon, 26 Sep 2022 10:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B956C433B5;
        Mon, 26 Sep 2022 10:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189045;
        bh=jN9KKvCki6cYrlMLOPZxNTrmQsWhVjW4jDwmuoUfl0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=08owrhqOvZbvTS4RLUknuDt+uTBikGb1CD/kksxfUXE4eBx6tIpKGWsblzdmQW9Wb
         wcfdnkWuSX6Sd/B64bKiCvH7+k7Yx+e5b5vfepxHEjfUXqLC6/bAbjAJe6bOSQU1Kq
         LgCLszLmuSZjVkAF048l9PXxuo8ieAjwaUStxNMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.19 055/207] riscv: fix RISCV_ISA_SVPBMT kconfig dependency warning
Date:   Mon, 26 Sep 2022 12:10:44 +0200
Message-Id: <20220926100809.082416166@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit 225e47ea20ea4f37031131f4fa7a6c281fac6657 upstream.

RISCV_ISA_SVPBMT selects RISCV_ALTERNATIVE which depends on !XIP_KERNEL.
Therefore RISCV_ISA_SVPBMT should also depend on !XIP_KERNEL so
quieten this kconfig warning:

WARNING: unmet direct dependencies detected for RISCV_ALTERNATIVE
  Depends on [n]: !XIP_KERNEL [=y]
  Selected by [y]:
  - RISCV_ISA_SVPBMT [=y] && 64BIT [=y] && MMU [=y]

Fixes: ff689fd21cb1 ("riscv: add RISC-V Svpbmt extension support")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: stable@vger.kernel.org
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20220709014929.14221-1-rdunlap@infradead.org/
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -361,6 +361,7 @@ config RISCV_ISA_C
 config RISCV_ISA_SVPBMT
 	bool "SVPBMT extension support"
 	depends on 64BIT && MMU
+	depends on !XIP_KERNEL
 	select RISCV_ALTERNATIVE
 	default y
 	help


