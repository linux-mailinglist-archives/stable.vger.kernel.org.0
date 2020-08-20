Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5A924BBB4
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729667AbgHTJte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:49:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729661AbgHTJtd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:49:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B77A620724;
        Thu, 20 Aug 2020 09:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916973;
        bh=ywxkViXDSf4Hxd7HA+Y658fe5xz6Ys2MM0vs3KLzo+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZCulpbHLVOqZ8CAlmgNZvejbyaXyKvstohuLOK8VS8gPjHIrikdoRDpGA97llVdj/
         NnBWdD0aQg68FOM0iwFQXlZM0yjBlI63lSXhaTH8BOgPKqiBoWwMtPCpmQ6hi67Rtj
         3cab0qlB0Dy7labFsO10KrVKdE/YVufdXzKr8PFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/152] mtd: rawnand: fsl_upm: Remove unused mtd var
Date:   Thu, 20 Aug 2020 11:20:47 +0200
Message-Id: <20200820091557.831204711@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit ccc49eff77bee2885447a032948959a134029fe3 ]

The mtd var in fun_wait_rnb() is now unused, let's get rid of it and
fix the warning resulting from this unused var.

Fixes: 50a487e7719c ("mtd: rawnand: Pass a nand_chip object to chip->dev_ready()")
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20200603134922.1352340-2-boris.brezillon@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/fsl_upm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/fsl_upm.c b/drivers/mtd/nand/raw/fsl_upm.c
index 1054cc070747e..20b0ee174dc61 100644
--- a/drivers/mtd/nand/raw/fsl_upm.c
+++ b/drivers/mtd/nand/raw/fsl_upm.c
@@ -62,7 +62,6 @@ static int fun_chip_ready(struct nand_chip *chip)
 static void fun_wait_rnb(struct fsl_upm_nand *fun)
 {
 	if (fun->rnb_gpio[fun->mchip_number] >= 0) {
-		struct mtd_info *mtd = nand_to_mtd(&fun->chip);
 		int cnt = 1000000;
 
 		while (--cnt && !fun_chip_ready(&fun->chip))
-- 
2.25.1



