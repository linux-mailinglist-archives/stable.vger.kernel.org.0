Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E63540B7F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350541AbiFGS3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350271AbiFGSYR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:24:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37C4D4A36;
        Tue,  7 Jun 2022 10:54:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4229617A6;
        Tue,  7 Jun 2022 17:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF27C34115;
        Tue,  7 Jun 2022 17:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624454;
        bh=90Pwb1gFolXdYAzqnbg5nWM90mOc6mUXMhJrZxKLkLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hU/NKmCpVzup5ITJtopT84WqbP9S/bD8qckb43aysUj6m/ImcEQKDxzJ9n5+JI1Pw
         rbFblLHY+mCWv7cwQyMXhCb9no1iLRCAT2p3UEBUUbcuqL9TSPvQA1PVjavs+aLjlQ
         Euorh+uploTu8eoJ2sn1v0nMXwOunJ/9/CfwoAdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 333/667] m68k: math-emu: Fix dependencies of math emulation support
Date:   Tue,  7 Jun 2022 18:59:58 +0200
Message-Id: <20220607164944.755056159@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit ed6bc6bf0a7d75e80eb1df883c09975ebb74e590 ]

If CONFIG_M54xx=y, CONFIG_MMU=y, and CONFIG_M68KFPU_EMU=y:

    {standard input}:272: Error: invalid instruction for this architecture; needs 68000 or higher (68000 [68ec000, 68hc000, 68hc001, 68008, 68302, 68306, 68307, 68322, 68356], 68010, 68020 [68k, 68ec020], 68030 [68ec030], 68040 [68ec040], 68060 [68ec060], cpu32 [68330, 68331, 68332, 68333, 68334, 68336, 68340, 68341, 68349, 68360], fidoa [fido]) -- statement `sub.b %d1,%d3' ignored
    {standard input}:609: Error: invalid instruction for this architecture; needs 68020 or higher (68020 [68k, 68ec020], 68030 [68ec030], 68040 [68ec040], 68060 [68ec060]) -- statement `bfextu 4(%a1){%d0,#8},%d0' ignored
    {standard input}:752: Error: operands mismatch -- statement `mulu.l 4(%a0),%d3:%d0' ignored
    {standard input}:1155: Error: operands mismatch -- statement `divu.l %d0,%d3:%d7' ignored

The math emulation support code is intended for 68020 and higher, and
uses several instructions or instruction modes not available on coldfire
or 68000.

Originally, the dependency of M68KFPU_EMU on MMU was fine, as MMU
support was only available on 68020 or higher.  But this assumption
was broken by the introduction of MMU support for M547x and M548x.

Drop the dependency on MMU, as the code should work fine on 68020 and up
without MMU (which are not yet supported by Linux, though).
Add dependencies on M68KCLASSIC (to rule out Coldfire) and FPU (kernel
has some type of floating-point support --- be it hardware or software
emulated, to rule out anything below 68020).

Fixes: 1f7034b9616e6f14 ("m68k: allow ColdFire 547x and 548x CPUs to be built with MMU enabled")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Greg Ungerer <gerg@linux-m68k.org>
Link: https://lore.kernel.org/r/18c34695b7c95107f60ccca82a4ff252f3edf477.1652446117.git.geert@linux-m68k.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/Kconfig.cpu | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m68k/Kconfig.cpu b/arch/m68k/Kconfig.cpu
index 277d61a09463..29558055c71b 100644
--- a/arch/m68k/Kconfig.cpu
+++ b/arch/m68k/Kconfig.cpu
@@ -338,7 +338,7 @@ comment "Processor Specific Options"
 
 config M68KFPU_EMU
 	bool "Math emulation support"
-	depends on MMU
+	depends on M68KCLASSIC && FPU
 	help
 	  At some point in the future, this will cause floating-point math
 	  instructions to be emulated by the kernel on machines that lack a
-- 
2.35.1



