Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE70860A539
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbiJXMWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbiJXMUD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:20:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7914183223;
        Mon, 24 Oct 2022 04:58:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3292C612BF;
        Mon, 24 Oct 2022 11:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8CEC433B5;
        Mon, 24 Oct 2022 11:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612210;
        bh=7mkua9TtQY1bbz8Pik2tYh3kVXMe/0nuNR7b/SAw73I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P+rblkMD6kNZ2pXCylZ3C/eCTYB0K5ew7KxALelTiqRkFKhkCTsXySPqahR4Aw0g2
         u03AEz5GzkGt+4ALtO8tec/eyJnBgsyyA9So2vsOO/oUu6wY1B0Ui7BcMh5Kd89AQs
         y0OtNqcuE8+qdwfi8R+4jdRsxT6y9wWTMW3FNP0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 112/210] ARM: Drop CMDLINE_* dependency on ATAGS
Date:   Mon, 24 Oct 2022 13:30:29 +0200
Message-Id: <20221024113000.635406550@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 3793642e0223..6fe7085cf7bd 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1951,7 +1951,6 @@ config CMDLINE
 choice
 	prompt "Kernel command line type" if CMDLINE != ""
 	default CMDLINE_FROM_BOOTLOADER
-	depends on ATAGS
 
 config CMDLINE_FROM_BOOTLOADER
 	bool "Use bootloader kernel arguments if available"
-- 
2.35.1



