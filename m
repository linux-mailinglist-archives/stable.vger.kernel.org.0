Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E753D38A377
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbhETJwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:52:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234594AbhETJum (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:50:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0441661261;
        Thu, 20 May 2021 09:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503336;
        bh=lkWwZMFJ429GqPC8y3MPC1rl2U3TSrVxtBf5jaz9avk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rkUZc9iTCfmCBxK6yaBNwj7lGqPN9JbaCXVUVI7jdEykXixPb6oZdj41I13UW7lQH
         Wm8iQ6Jn443ae1ZF5tFFvgLw1nh9JYwAb6wjj5iB7X+sbMgiqSdrApMHSe0Bb41CFb
         q9/5cOq0aNXiDt/uBcQJpv7j7ZVSPHCPSuyAXRqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, Brian Norris <computersforpeace@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 174/425] mtd: rawnand: brcmnand: fix OOB R/W with Hamming ECC
Date:   Thu, 20 May 2021 11:19:03 +0200
Message-Id: <20210520092137.159601491@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit f5200c14242fb8fa4a9b93f7fd4064d237e58785 ]

Hamming ECC doesn't cover the OOB data, so reading or writing OOB shall
always be done without ECC enabled.
This is a problem when adding JFFS2 cleanmarkers to erased blocks. If JFFS2
clenmarkers are added to the OOB with ECC enabled, OOB bytes will be changed
from ff ff ff to 00 00 00, reporting incorrect ECC errors.

Fixes: 27c5b17cd1b1 ("mtd: nand: add NAND driver "library" for Broadcom STB NAND controller")
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Acked-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210224080210.23686-1-noltari@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/brcmnand/brcmnand.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mtd/nand/raw/brcmnand/brcmnand.c b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
index aad8d107b85d..774ffa9e23f3 100644
--- a/drivers/mtd/nand/raw/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
@@ -2239,6 +2239,12 @@ static int brcmnand_attach_chip(struct nand_chip *chip)
 
 	ret = brcmstb_choose_ecc_layout(host);
 
+	/* If OOB is written with ECC enabled it will cause ECC errors */
+	if (is_hamming_ecc(host->ctrl, &host->hwcfg)) {
+		chip->ecc.write_oob = brcmnand_write_oob_raw;
+		chip->ecc.read_oob = brcmnand_read_oob_raw;
+	}
+
 	return ret;
 }
 
-- 
2.30.2



