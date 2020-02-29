Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6111747D6
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 17:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbgB2QE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 11:04:56 -0500
Received: from outils.crapouillou.net ([89.234.176.41]:60514 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727164AbgB2QEz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Feb 2020 11:04:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1582992293; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:references; bh=U+bTaqw3ChcPXdwAu0239Q0g38tlXUK/Pg8FxcX6kas=;
        b=pIeEPB4OqTEnN5H7AVgAqjPxxHNLHLAyDjL3waCtxnnfexnXd3HoWD+rtrT9K02lW2k/Ps
        kvTmt55RSCj2s/WrU8evemxBsmEm3rjaZDa67x/z8VNznIY9dS1zK3YxUMZ34OXfrrqCmY
        +JdRg/W5CZmTdUPjH1HBydyJ6eliCLQ=
From:   Paul Cercueil <paul@crapouillou.net>
To:     Harvey Hunt <harveyhuntnexus@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>
Cc:     Vignesh Raghavendra <vigneshr@ti.com>, od@zcrc.me,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>, stable@vger.kernel.org
Subject: [PATCH] mtd: rawnand: ingenic: Fix unmet dependency if COMPILE_TEST
Date:   Sat, 29 Feb 2020 13:04:43 -0300
Message-Id: <20200229160443.11208-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 7c779cf7c1f7 ("mtd: rawnand: ingenic: Allow to compile test the
new Ingenic driver") dropped the dependency on JZ4780_NEMC when
COMPILE_TEST was set, which is wrong, as the driver requires symbols
provided by the jz4780-nemc driver.

Change the dependency to (MIPS || COMPILE_TEST) && JZ4780_NEMC to
address the issue.

Fixes: 7c779cf7c1f7 ("mtd: rawnand: ingenic: Allow to compile test the new Ingenic driver")
Cc: stable@vger.kernel.org
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/mtd/nand/raw/ingenic/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/ingenic/Kconfig b/drivers/mtd/nand/raw/ingenic/Kconfig
index 485abfa3f80b..96c5ae8b1bbc 100644
--- a/drivers/mtd/nand/raw/ingenic/Kconfig
+++ b/drivers/mtd/nand/raw/ingenic/Kconfig
@@ -1,7 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config MTD_NAND_JZ4780
 	tristate "JZ4780 NAND controller"
-	depends on JZ4780_NEMC || COMPILE_TEST
+	depends on MIPS || COMPILE_TEST
+	depends on JZ4780_NEMC
 	help
 	  Enables support for NAND Flash connected to the NEMC on JZ4780 SoC
 	  based boards, using the BCH controller for hardware error correction.
-- 
2.25.1

