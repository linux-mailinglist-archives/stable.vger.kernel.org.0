Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5052C9B3C
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388329AbgLAJGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:06:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:43026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387687AbgLAJGH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:06:07 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E082221FF;
        Tue,  1 Dec 2020 09:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813526;
        bh=r1jrhRzId3J+mwff/ZgZqPPEVyjusmeRqjtfsfeGUfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vy63DEpyoenqUaOqK5K2mQ2uGJ7p7ibLtARrTWV+fs3tQ/vIlPLWtVJ0QRJ6QeH0p
         2XQkWvyhNu76B0hLi8TPEuxfug8C2XPh4OCiFFAkA4lzWd1YFAdGmwnmy+5a4cap2w
         sYqHLdN+wYGsOGr5M4CxGmlbf4AcaRPIkR4RNrng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 70/98] efi: EFI_EARLYCON should depend on EFI
Date:   Tue,  1 Dec 2020 09:53:47 +0100
Message-Id: <20201201084658.504147238@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 36a237526cd81ff4b6829e6ebd60921c6f976e3b ]

CONFIG_EFI_EARLYCON defaults to yes, and thus is enabled on systems that
do not support EFI, or do not have EFI support enabled, but do satisfy
the symbol's other dependencies.

While drivers/firmware/efi/ won't be entered during the build phase if
CONFIG_EFI=n, and drivers/firmware/efi/earlycon.c itself thus won't be
built, enabling EFI_EARLYCON does force-enable CONFIG_FONT_SUPPORT and
CONFIG_ARCH_USE_MEMREMAP_PROT, and CONFIG_FONT_8x16, which is
undesirable.

Fix this by making CONFIG_EFI_EARLYCON depend on CONFIG_EFI.

This reduces kernel size on headless systems by more than 4 KiB.

Fixes: 69c1f396f25b805a ("efi/x86: Convert x86 EFI earlyprintk into generic earlycon implementation")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/r/20201124191646.3559757-1-geert@linux-m68k.org
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 6a6b412206ec0..3222645c95b33 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -216,7 +216,7 @@ config EFI_DEV_PATH_PARSER
 
 config EFI_EARLYCON
 	def_bool y
-	depends on SERIAL_EARLYCON && !ARM && !IA64
+	depends on EFI && SERIAL_EARLYCON && !ARM && !IA64
 	select FONT_SUPPORT
 	select ARCH_USE_MEMREMAP_PROT
 
-- 
2.27.0



