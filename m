Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8255411C8C
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345875AbhITRLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:11:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345123AbhITRI6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:08:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07CD5617E1;
        Mon, 20 Sep 2021 16:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156963;
        bh=h4cabG8quT9jWEbXmVwOnnbV2rmN1SuRwXr0QGdj65A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/I6bV9rIK+PDLeFCnFCQMlQAiwklW1mOaiCBho5jkSO7yXte4Raeq20FN/M/1l8t
         EfbZOt8nE4jX8EI5KnGhzV0etppDJEzrh9sBSrqEXuf2f6YDC4MyzOhGsx6zvQyUXz
         d+0aqiO6R6G53Y9XfRaXV8JvbiBIdhx9pV7P5vAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Ryan J. Barnett" <ryan.barnett@collins.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 166/175] dt-bindings: mtd: gpmc: Fix the ECC bytes vs. OOB bytes equation
Date:   Mon, 20 Sep 2021 18:43:35 +0200
Message-Id: <20210920163923.494463918@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 174f68c26c1b..34981b98d807 100644
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



