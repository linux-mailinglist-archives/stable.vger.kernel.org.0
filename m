Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC2C3F63A8
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235069AbhHXQ5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:57:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234514AbhHXQ5S (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E11BF6140A;
        Tue, 24 Aug 2021 16:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824194;
        bh=zWITycdEmnFZK2EjMLbdmEPHankEIC+qDAKgQrLWXQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qcXnM5DOSsUAu+xfW+k9YMgp/2Eerv05G2IHJgzmTORtibLmNiPrpIJtFx1o4otS0
         HbEkRP0hGmoslO/oHmxwkwiKx3fIAa/3dOd81rS3fa0N5ETctw0CP646mM8HFt6eHw
         V9V5zX8mD52Z2P9BAxBV8djDcU6EYEVl5Rgs0fd3pdcXgJ0Tx558hcnQ0dOrXbSlyU
         y/rWahaD+abo2oBhgYWLS49UYW3cKo+y17ZyEk4hcQr40+Hd9ns6TjH8J4r67n/chI
         uhNw6X5cRlIrUwLlXu30BtLy3S4QMq6Z9nyDmTzatlpb//yu8ZuwYHyEshu3hsK4aI
         T+JYMyEqgge/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 026/127] mtd: rawnand: Add a check in of_get_nand_secure_regions()
Date:   Tue, 24 Aug 2021 12:54:26 -0400
Message-Id: <20210824165607.709387-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 14f97f0b8e2b9950c028d0cb7311ffe26a3cc1c0 ]

Check for whether of_property_count_elems_of_size() returns a negative
error code.

Fixes: 13b89768275d ("mtd: rawnand: Add support for secure regions in NAND memory")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/YMtQFXE0F1w7mUh+@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/nand_base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/raw/nand_base.c b/drivers/mtd/nand/raw/nand_base.c
index fb072c444495..b18c089a7dca 100644
--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -5059,8 +5059,8 @@ static int of_get_nand_secure_regions(struct nand_chip *chip)
 	int nr_elem, i, j;
 
 	nr_elem = of_property_count_elems_of_size(dn, "secure-regions", sizeof(u64));
-	if (!nr_elem)
-		return 0;
+	if (nr_elem <= 0)
+		return nr_elem;
 
 	chip->nr_secure_regions = nr_elem / 2;
 	chip->secure_regions = kcalloc(chip->nr_secure_regions, sizeof(*chip->secure_regions),
-- 
2.30.2

