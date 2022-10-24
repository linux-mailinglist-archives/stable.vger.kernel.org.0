Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8EF660B28D
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbiJXQsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234936AbiJXQrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:47:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9E2202727;
        Mon, 24 Oct 2022 08:31:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 600EEB815A1;
        Mon, 24 Oct 2022 12:09:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A927EC433C1;
        Mon, 24 Oct 2022 12:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613385;
        bh=Ja7lCy50tCJE6mYG1SdXngoINi65jyCg6+IPCRVXcOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NPV8zVtNYSN7Ed+nN3rW3pJoRvC6QVPHAYJy4mCj7SOuM1jYfGBe/3hxia9FPjA+p
         mgZiVU+8MBuxQx8f/+u3kBs6fayP3/20goORHKT6aSfnvD/4QA4/D/J9dCaZQ5ccfg
         jJbFOrxDZWDeh8BcudzY2SXnZICdovzAald5T2ug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 116/255] ARM: Drop CMDLINE_* dependency on ATAGS
Date:   Mon, 24 Oct 2022 13:30:26 +0200
Message-Id: <20221024113006.370145986@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
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
index a4364cce85f8..a70696a95b79 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1837,7 +1837,6 @@ config CMDLINE
 choice
 	prompt "Kernel command line type" if CMDLINE != ""
 	default CMDLINE_FROM_BOOTLOADER
-	depends on ATAGS
 
 config CMDLINE_FROM_BOOTLOADER
 	bool "Use bootloader kernel arguments if available"
-- 
2.35.1



