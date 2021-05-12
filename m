Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF2137CBE3
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237482AbhELQiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:38:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238412AbhELQaT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:30:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 757E7613C5;
        Wed, 12 May 2021 15:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835035;
        bh=O8AkEc7Xps/dZTeO7uBNoyzMIcXrglmC010TCSsG1kI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FidGqYZWwkYMv25QY9fmkO70KQHvAu7ri7HuSghGbf5i8SJsYMqqdtICElUKJICe4
         dBnDvkYoXItf1skJhxtDqWO47u8botHcLPYtqM2F7dT0u216xX9o8mhDP5EvPYNKiS
         20UyN1NLofcHY7LHKxPSkBpRY3uGWHPSnoWMJOYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, Brian Norris <computersforpeace@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 181/677] mtd: rawnand: brcmnand: fix OOB R/W with Hamming ECC
Date:   Wed, 12 May 2021 16:43:47 +0200
Message-Id: <20210512144843.253919346@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
index 659eaa6f0980..5ff4291380c5 100644
--- a/drivers/mtd/nand/raw/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
@@ -2688,6 +2688,12 @@ static int brcmnand_attach_chip(struct nand_chip *chip)
 
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



