Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6981548C01
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346739AbiFMKzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350093AbiFMKyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:54:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D2424970;
        Mon, 13 Jun 2022 03:29:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30475B80E59;
        Mon, 13 Jun 2022 10:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEDFC34114;
        Mon, 13 Jun 2022 10:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116149;
        bh=pOFYgfee5iVtMFAxZz46DsyhKPKQrBcJoxcFBBfq19w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c08SeGDs8US+g6GmBs5+Hg8uFHB7AGqyQzPYpSQl7YYj3h7QkpBr+i0wo1xnFRx0P
         bCT7yjG63LqSKq7+GV7momnFXIJ3ra73EOJOUpyvgnN6lxLaOVGvAGvo4awI8JlAM6
         eonfeBkYMzE85vKDINwDwFYI8krZLGWhuUgVGAt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kees Cook <keescook@chromium.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, Manuel Lauss <manuel.lauss@gmail.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 140/218] pcmcia: db1xxx_ss: restrict to MIPS_DB1XXX boards
Date:   Mon, 13 Jun 2022 12:09:58 +0200
Message-Id: <20220613094924.834796876@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 3928cf08334ed895a31458cbebd8d4ec6d84c080 ]

When the MIPS_ALCHEMY board selection is MIPS_XXS1500 instead of
MIPS_DB1XXX, the PCMCIA driver 'db1xxx_ss' has build errors due
to missing DB1XXX symbols. The PCMCIA driver should be restricted
to MIPS_DB1XXX instead of MIPS_ALCHEMY to fix this build error.

ERROR: modpost: "bcsr_read" [drivers/pcmcia/db1xxx_ss.ko] undefined!
ERROR: modpost: "bcsr_mod" [drivers/pcmcia/db1xxx_ss.ko] undefined!

Fixes: 42a4f17dc356 ("MIPS: Alchemy: remove SOC_AU1X00 in favor of MIPS_ALCHEMY")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@vger.kernel.org
Acked-by: Manuel Lauss <manuel.lauss@gmail.com>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pcmcia/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index d3c378b4db6c..20d85d564b80 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -146,7 +146,7 @@ config TCIC
 
 config PCMCIA_ALCHEMY_DEVBOARD
 	tristate "Alchemy Db/Pb1xxx PCMCIA socket services"
-	depends on MIPS_ALCHEMY && PCMCIA
+	depends on MIPS_DB1XXX && PCMCIA
 	help
 	  Enable this driver of you want PCMCIA support on your Alchemy
 	  Db1000, Db/Pb1100, Db/Pb1500, Db/Pb1550, Db/Pb1200, DB1300
-- 
2.35.1



