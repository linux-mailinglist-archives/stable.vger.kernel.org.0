Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C81AA4D837C
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241137AbiCNMPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241139AbiCNMOl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:14:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606A0381A4;
        Mon, 14 Mar 2022 05:11:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE58D613CA;
        Mon, 14 Mar 2022 12:11:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4041C340E9;
        Mon, 14 Mar 2022 12:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259888;
        bh=geHGzriX4PGV6WZTOfnWNbzTkroyn7NhS+GPkc5qQwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Vgk9eCYsGhH4+zs1SNDlkhSKze2jPw2jKFobOEap4ET1Tcd7bYbfcJOk51fpKI5b
         W8dr7uzEwm+VP3mEkrQzpWOZU1bZpvOM6AdtSZeJIgxH3Kwvl11QiPmNjxvk4kyDmp
         +WTjy+icOTuxZYkcwV7pEmPtlMdllaHiAoGJk8kI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 080/110] riscv: alternative only works on !XIP_KERNEL
Date:   Mon, 14 Mar 2022 12:54:22 +0100
Message-Id: <20220314112745.264474698@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jisheng Zhang <jszhang@kernel.org>

commit c80ee64a8020ef1a6a92109798080786829b8994 upstream.

The alternative mechanism needs runtime code patching, it can't work
on XIP_KERNEL. And the errata workarounds are implemented via the
alternative mechanism. So add !XIP_KERNEL dependency for alternative
and erratas.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Fixes: 44c922572952 ("RISC-V: enable XIP")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/Kconfig.erratas |    1 +
 arch/riscv/Kconfig.socs    |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/arch/riscv/Kconfig.erratas
+++ b/arch/riscv/Kconfig.erratas
@@ -2,6 +2,7 @@ menu "CPU errata selection"
 
 config RISCV_ERRATA_ALTERNATIVE
 	bool "RISC-V alternative scheme"
+	depends on !XIP_KERNEL
 	default y
 	help
 	  This Kconfig allows the kernel to automatically patch the
--- a/arch/riscv/Kconfig.socs
+++ b/arch/riscv/Kconfig.socs
@@ -14,8 +14,8 @@ config SOC_SIFIVE
 	select CLK_SIFIVE
 	select CLK_SIFIVE_PRCI
 	select SIFIVE_PLIC
-	select RISCV_ERRATA_ALTERNATIVE
-	select ERRATA_SIFIVE
+	select RISCV_ERRATA_ALTERNATIVE if !XIP_KERNEL
+	select ERRATA_SIFIVE if !XIP_KERNEL
 	help
 	  This enables support for SiFive SoC platform hardware.
 


