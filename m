Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603D7548D72
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344633AbiFMKrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244542AbiFMKpc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:45:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAAE423BEB;
        Mon, 13 Jun 2022 03:25:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D318EB80E95;
        Mon, 13 Jun 2022 10:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34ED1C34114;
        Mon, 13 Jun 2022 10:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115940;
        bh=gDSkScukX2LSRwr4jVmPp/iYJ8xZ1NW+aQPq8tGwEL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qTyHgK3Lfnh4Mby0QlvIlGQNPVjpRili4Pqz0gjk9w6k5OAnzrezMp+AyjV4IZBmc
         w9nIF4YCQTRWLZKnijHaXd4PyVOGhr9lkMdViye/tkaH3e1TrXBPAxiQUVwiEFWoFQ
         D0GOvyqg2Ncx92sg8xTi2NYCo5way6HAIHsBBrGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 076/218] m68k: math-emu: Fix dependencies of math emulation support
Date:   Mon, 13 Jun 2022 12:08:54 +0200
Message-Id: <20220613094922.723214296@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
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
index ff5f0896318b..6f13c53c8dc7 100644
--- a/arch/m68k/Kconfig.cpu
+++ b/arch/m68k/Kconfig.cpu
@@ -308,7 +308,7 @@ comment "Processor Specific Options"
 
 config M68KFPU_EMU
 	bool "Math emulation support"
-	depends on MMU
+	depends on M68KCLASSIC && FPU
 	help
 	  At some point in the future, this will cause floating-point math
 	  instructions to be emulated by the kernel on machines that lack a
-- 
2.35.1



