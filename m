Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF304077ED
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237386AbhIKNVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:21:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237554AbhIKNTZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:19:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3396B61350;
        Sat, 11 Sep 2021 13:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631366057;
        bh=mdToDSP4iZ2cukpJ3ZT/GEREaE+0G5rXlJ0MG9HZdX0=;
        h=From:To:Cc:Subject:Date:From;
        b=GxCb8nUTLte0vV6uoc/laehKE8uVtBoWfQSF9ZlLbnol7pUjs5q5XNNVw9+3u9r/y
         +/03R2D6KCccKm8hCkOnnsIPodoWGptcRhSRa1brD2L8hgplzrbSUcq1BroReKjrOj
         g8B5u0EIKpxVXSLo4Cn+Zbctf2qgGfHVkMcMEaIb29+Al9LKBYJsd35LXloYLg6xcy
         RDI1HTAhkvfQ1TIV03fTvm+ATBW1vSZBV6huj+9TS0d7wLYNTyIG4/NkV3yozcxP8H
         ygm0n1m9/9Sr1nPgRoHIpTfKR4udICArCbTLIAlgrvkn5EXSbZLI08WcDzKbqjGnHn
         uxX1TWoF0losQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        "Ryan J . Barnett" <ryan.barnett@collins.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 1/5] dt-bindings: mtd: gpmc: Fix the ECC bytes vs. OOB bytes equation
Date:   Sat, 11 Sep 2021 09:14:10 -0400
Message-Id: <20210911131415.286125-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 778cb8e39f6ec252be50fc3850d66f3dcbd5dd5a ]

"PAGESIZE / 512" is the number of ECC chunks.
"ECC_BYTES" is the number of bytes needed to store a single ECC code.
"2" is the space reserved by the bad block marker.

"2 + (PAGESIZE / 512) * ECC_BYTES" should of course be lower or equal
than the total number of OOB bytes, otherwise it won't fit.

Fix the equation by substituting s/>=/<=/.

Suggested-by: Ryan J. Barnett <ryan.barnett@collins.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Acked-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/linux-mtd/20210610143945.3504781-1-miquel.raynal@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/mtd/gpmc-nand.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mtd/gpmc-nand.txt b/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
index dd559045593d..d2d1bae63a36 100644
--- a/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
+++ b/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
@@ -123,7 +123,7 @@ on various other factors also like;
 	so the device should have enough free bytes available its OOB/Spare
 	area to accommodate ECC for entire page. In general following expression
 	helps in determining if given device can accommodate ECC syndrome:
-	"2 + (PAGESIZE / 512) * ECC_BYTES" >= OOBSIZE"
+	"2 + (PAGESIZE / 512) * ECC_BYTES" <= OOBSIZE"
 	where
 		OOBSIZE		number of bytes in OOB/spare area
 		PAGESIZE	number of bytes in main-area of device page
-- 
2.30.2

