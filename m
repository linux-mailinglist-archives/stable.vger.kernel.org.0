Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F057475E8E
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245384AbhLORXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:23:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40536 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245338AbhLORWz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:22:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98027B82024;
        Wed, 15 Dec 2021 17:22:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD41CC36AE0;
        Wed, 15 Dec 2021 17:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639588973;
        bh=EUDZ0LOZ5JAKP6WLWQRs+LR4neCUY9aDJhwwEMprwkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bXOH0/jAE1P3u/6E7HjqJe2aIlz/VByaCOqUcFwP7pm7otjb2LXQH2aM0Ia4RYukh
         Sj+FCQq49+bnkZY8lOsm4Ibh92WacsLjmTdLxIIkPuqI9y6sYFegIdZkr1aZaaj0r3
         MlorEdsc/CKpX9tPezupuuH+bcx+W6agjfs9UV0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herve Codina <herve.codina@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 05/42] mtd: rawnand: Fix nand_erase_op delay
Date:   Wed, 15 Dec 2021 18:20:46 +0100
Message-Id: <20211215172026.828777502@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
References: <20211215172026.641863587@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit 16d8b628a4152e8e8b01b6a1d82e30208ee2dd30 ]

NAND_OP_CMD() expects a delay parameter in nanoseconds.
The delay value is wrongly given in milliseconds.

Fix the conversion macro used in order to set this
delay in nanoseconds.

Fixes: d7a773e8812b ("mtd: rawnand: Access SDR and NV-DDR timings through a common macro")
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20211119150316.43080-2-herve.codina@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/nand_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/nand_base.c b/drivers/mtd/nand/raw/nand_base.c
index 3d6c6e8805207..5c6b065837eff 100644
--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -1837,7 +1837,7 @@ int nand_erase_op(struct nand_chip *chip, unsigned int eraseblock)
 			NAND_OP_CMD(NAND_CMD_ERASE1, 0),
 			NAND_OP_ADDR(2, addrs, 0),
 			NAND_OP_CMD(NAND_CMD_ERASE2,
-				    NAND_COMMON_TIMING_MS(conf, tWB_max)),
+				    NAND_COMMON_TIMING_NS(conf, tWB_max)),
 			NAND_OP_WAIT_RDY(NAND_COMMON_TIMING_MS(conf, tBERS_max),
 					 0),
 		};
-- 
2.33.0



