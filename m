Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0670C40781B
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236931AbhIKNXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:23:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:52012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236538AbhIKNU4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:20:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC8D56135A;
        Sat, 11 Sep 2021 13:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631366071;
        bh=ltZZyCsnjnNoe+sQ9hulck8kwCSo5dN6HI0l2iLLg8g=;
        h=From:To:Cc:Subject:Date:From;
        b=bhNCFMyywJP/qeYXNfLMZqr07wAwAZ9dANCL4pj9E/WjpfaA3nHQJV+eTMNXuIFjC
         3pX3lHqNvG+PSAlFY65MoWfA8jfCzbG4sGRVK1UUM/DJKaSHowgH95R2wj1z+xQ84p
         6/9S75qrfBbhbgQmXqMtbCawkGLP7a0TbuRnvW9vmJkDf8LBGK+xoxUnhj8j9s8/hl
         w5sxK3I/vdcwFGFRuBoN/JBhEo6apn2F9B9I4FkBzzjo5CiVRIZ3iHFR5Q+9FJvu59
         vcDLQmme5EHm3hYJixEU3HVrNMb1z0kfRtrxc35flx+6GPd0QpF2ZJeWj1qUZpvqkq
         xNM2UYWFtEPXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        "Ryan J . Barnett" <ryan.barnett@collins.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 1/2] dt-bindings: mtd: gpmc: Fix the ECC bytes vs. OOB bytes equation
Date:   Sat, 11 Sep 2021 09:14:28 -0400
Message-Id: <20210911131429.286330-1-sashal@kernel.org>
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
index fb733c4e1c11..3a58fdf0c566 100644
--- a/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
+++ b/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
@@ -112,7 +112,7 @@ on various other factors also like;
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

