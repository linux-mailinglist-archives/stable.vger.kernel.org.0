Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F16F601E7A
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbiJRAI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbiJRAIX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:08:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C5987691;
        Mon, 17 Oct 2022 17:08:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BACA612A3;
        Tue, 18 Oct 2022 00:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48BDBC433D7;
        Tue, 18 Oct 2022 00:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051683;
        bh=sPuojthYzSXbgbUnAK+0nBav8BXu2IisDBLQN7Eu100=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NyA+y+qaXSYstqcPJP9WlkjFKooy6xufAI7IcZHZHToR0iEbbkgeDLWv3/Th0qLlL
         2h8smrmj88ACBk7sJMIhlQH5933yNn75KFRQ5ojabNRnjTeJT7zbef20viyjo/3k33
         sDU02RGNPNsgoVemxIBwX2j/2DCqrSnMaLXyPHThIynEubcNIQnoD+OMywkwp8FgAy
         uONZjIjyT4i1PqF6Wx7d5YKcU2kbF0fPg7zKiEFV0q0b8+UCiC1Rb7tsySuG4Wh6i+
         FjKRP54EloFNwnuTSonBc2K8wOO0em9LGiIphhOLX4BaiINtanRiYLyQ0TPoHTNkPO
         LmOjfnWxrYuAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Ungerer <gerg@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-m68k@lists.linux-m68k.org
Subject: [PATCH AUTOSEL 6.0 16/32] m68knommu: fix non-mmu classic 68000 legacy timer tick selection
Date:   Mon, 17 Oct 2022 20:07:13 -0400
Message-Id: <20221018000729.2730519-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018000729.2730519-1-sashal@kernel.org>
References: <20221018000729.2730519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Ungerer <gerg@linux-m68k.org>

[ Upstream commit 18011e50c497f04a57a8e00122906f04922b30b4 ]

The family of classic 68000 parts supported when in non-mmu mode all
currently use the legacy timer support. Move the selection of that config
option, LEGACY_TIMER_TICK, into the core CPU configuration.

This fixes compilation if no specific CPU variant is selected, since
the LEGACY_TIMER_TICK option was only selected in the specific CPU
variant configurations.

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/Kconfig.cpu | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/m68k/Kconfig.cpu b/arch/m68k/Kconfig.cpu
index e0e9e31339c1..b0504b13b089 100644
--- a/arch/m68k/Kconfig.cpu
+++ b/arch/m68k/Kconfig.cpu
@@ -46,6 +46,7 @@ config M68000
 	select GENERIC_CSUM
 	select CPU_NO_EFFICIENT_FFS
 	select HAVE_ARCH_HASH
+	select LEGACY_TIMER_TICK
 	help
 	  The Freescale (was Motorola) 68000 CPU is the first generation of
 	  the well known M68K family of processors. The CPU core as well as
@@ -97,7 +98,6 @@ config M68060
 config M68328
 	bool
 	depends on !MMU
-	select LEGACY_TIMER_TICK
 	select M68000
 	help
 	  Motorola 68328 processor support.
@@ -105,7 +105,6 @@ config M68328
 config M68EZ328
 	bool
 	depends on !MMU
-	select LEGACY_TIMER_TICK
 	select M68000
 	help
 	  Motorola 68EX328 processor support.
@@ -113,7 +112,6 @@ config M68EZ328
 config M68VZ328
 	bool
 	depends on !MMU
-	select LEGACY_TIMER_TICK
 	select M68000
 	help
 	  Motorola 68VZ328 processor support.
-- 
2.35.1

