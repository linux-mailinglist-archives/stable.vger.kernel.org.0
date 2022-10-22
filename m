Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E19596087D4
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbiJVIGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbiJVIFR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:05:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D282D52DA;
        Sat, 22 Oct 2022 00:52:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BD11B82DFB;
        Sat, 22 Oct 2022 07:52:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F68C433D6;
        Sat, 22 Oct 2022 07:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425120;
        bh=ecUngznMqnW5e4lWOlIz3hklrRoghLVGRnlS/7XReBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nmUo0hMwlMMUDdV0mXSJg1Es7ouuZnOFFKOGJ7JSPSqdzs3A9lJs7p/0mM8sZDK8m
         Ip1c6zghlSpz2n42tYhPPq4avGmaJf2orxomMypWV2/gpJiG1Ig2pC4sM7ghKIOpo9
         sRnUtwKqczXc41rg00yIVU171npAeJmjHnHaM0Mk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 366/717] ARM: Drop CMDLINE_* dependency on ATAGS
Date:   Sat, 22 Oct 2022 09:24:05 +0200
Message-Id: <20221022072512.795041613@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 136f4b1ec7c962ee37a787e095fd37b058d72bd3 ]

On arm32, the configuration options to specify the kernel command line
type depend on ATAGS.  However, the actual CMDLINE cofiguration option
does not depend on ATAGS, and the code that handles this is not specific
to ATAGS (see drivers/of/fdt.c:early_init_dt_scan_chosen()).

Hence users who desire to override the kernel command line on arm32 must
enable support for ATAGS, even on a pure-DT system.  Other architectures
(arm64, loongarch, microblaze, nios2, powerpc, and riscv) do not impose
such a restriction.

Hence drop the dependency on ATAGS.

Fixes: bd51e2f595580fb6 ("ARM: 7506/1: allow for ATAGS to be configured out when DT support is selected")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 7630ba9cb6cc..ccc4706484d3 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1653,7 +1653,6 @@ config CMDLINE
 choice
 	prompt "Kernel command line type" if CMDLINE != ""
 	default CMDLINE_FROM_BOOTLOADER
-	depends on ATAGS
 
 config CMDLINE_FROM_BOOTLOADER
 	bool "Use bootloader kernel arguments if available"
-- 
2.35.1



