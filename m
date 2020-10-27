Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F0729BE73
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1812927AbgJ0Qqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:46:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S368840AbgJ0Ply (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:41:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E24182231B;
        Tue, 27 Oct 2020 15:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813312;
        bh=03rrnBAbcn5auYNwT4Bq4ajdH7dqk1DCk3ewCdYhuOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K7tsz2gipxVuiHZ4kB6fAa7+fHGAAn5dbDE2nNXSFv7bjMiCyrXa3yujLdIfc8xfF
         2B0gCgpMlox/mA1Si1hV5MlD4LAb7Ik/vWEISQS4tv8isT+zjvfYwZkVb/IbPjqzx9
         oDEsuZvB9AXKk898Jj9q5wZ2gxZzC/w1H3Lx//Wo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 479/757] mtd: parsers: bcm63xx: Do not make it modular
Date:   Tue, 27 Oct 2020 14:52:09 +0100
Message-Id: <20201027135512.949267779@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit b597cc75f7fe76708bc6ab3f0e09bbff6f09ae4a ]

With commit 91e81150d388 ("mtd: parsers: bcm63xx: simplify CFE
detection"), we generate a reference to fw_arg3 which is the fourth
firmware/command line argument on MIPS platforms. That symbol is not
exported and would cause a linking failure.

The parser is typically necessary to boot a BCM63xx-based system anyway
so having it be part of the kernel image makes sense, therefore make it
'bool' instead of 'tristate'.

Fixes: 91e81150d388 ("mtd: parsers: bcm63xx: simplify CFE detection")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20200929172726.30469-1-f.fainelli@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/parsers/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/parsers/Kconfig b/drivers/mtd/parsers/Kconfig
index f98363c9b3630..e72354322f628 100644
--- a/drivers/mtd/parsers/Kconfig
+++ b/drivers/mtd/parsers/Kconfig
@@ -12,7 +12,7 @@ config MTD_BCM47XX_PARTS
 	  boards.
 
 config MTD_BCM63XX_PARTS
-	tristate "BCM63XX CFE partitioning parser"
+	bool "BCM63XX CFE partitioning parser"
 	depends on BCM63XX || BMIPS_GENERIC || COMPILE_TEST
 	select CRC32
 	select MTD_PARSER_IMAGETAG
-- 
2.25.1



