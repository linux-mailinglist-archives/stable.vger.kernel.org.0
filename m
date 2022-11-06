Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA1961E453
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiKFRK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiKFRKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:10:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CAF13E82;
        Sun,  6 Nov 2022 09:06:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8544860CF6;
        Sun,  6 Nov 2022 17:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5944C4347C;
        Sun,  6 Nov 2022 17:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754410;
        bh=clI9eVa6PdM3h28MFZfFoDG3wDAikj5pFNBDoPZuliY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BBqMPZY3oz2i8r6FS/1/dOl01BZjdVbmzU4HUAapHEbqOF7IW20dbS/INRqmFL/3w
         yRPgxgZg0z/24FkKua8km2/2HvoILgtQPmW0nwaaLzGZTahbtQntb/TStmZ0R6+Nx3
         MFlopGcmlr/IsjCZFJgxxadxks0nWIYU9rFXCcn8xogOt8EX1oRCHa4oPo1KloOZ9c
         NlUVKv5ubE9zKXFhtaAFxiB9+RIYdVRDUflSJtkUId577vasmCW1W6AowHUKn6S7uC
         WJSRsnmNLnHpYK+3/Qer8ywqs6y6ZFjPBdX0ABKdXkOOE5GwUL1usf+TM7clL4it1n
         qq3BVoKzbM1Zg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Lima <mauro.lima@eclypsium.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, tudor.ambarus@microchip.com,
        pratyush@kernel.org, miquel.raynal@bootlin.com, richard@nod.at,
        vigneshr@ti.com, linux-mtd@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 05/12] spi: intel: Fix the offset to get the 64K erase opcode
Date:   Sun,  6 Nov 2022 12:06:29 -0500
Message-Id: <20221106170637.1580802-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221106170637.1580802-1-sashal@kernel.org>
References: <20221106170637.1580802-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Lima <mauro.lima@eclypsium.com>

[ Upstream commit 6a43cd02ddbc597dc9a1f82c1e433f871a2f6f06 ]

According to documentation, the 64K erase opcode is located in VSCC
range [16:23] instead of [8:15].
Use the proper value to shift the mask over the correct range.

Signed-off-by: Mauro Lima <mauro.lima@eclypsium.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://lore.kernel.org/r/20221012152135.28353-1-mauro.lima@eclypsium.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/intel-spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/intel-spi.c b/drivers/mtd/spi-nor/intel-spi.c
index 43e55a2e9b27..21b98c82e196 100644
--- a/drivers/mtd/spi-nor/intel-spi.c
+++ b/drivers/mtd/spi-nor/intel-spi.c
@@ -113,7 +113,7 @@
 #define ERASE_OPCODE_SHIFT		8
 #define ERASE_OPCODE_MASK		(0xff << ERASE_OPCODE_SHIFT)
 #define ERASE_64K_OPCODE_SHIFT		16
-#define ERASE_64K_OPCODE_MASK		(0xff << ERASE_OPCODE_SHIFT)
+#define ERASE_64K_OPCODE_MASK		(0xff << ERASE_64K_OPCODE_SHIFT)
 
 #define INTEL_SPI_TIMEOUT		5000 /* ms */
 #define INTEL_SPI_FIFO_SZ		64
-- 
2.35.1

