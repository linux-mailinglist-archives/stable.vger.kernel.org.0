Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D7324BD65
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbgHTNEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:04:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728907AbgHTJjV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:39:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2200E2173E;
        Thu, 20 Aug 2020 09:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916360;
        bh=5avGjOD6eeskRsakvcZW1kvL4NEJJTiZf+LyC3LA7t0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EIJURgbze+OVRp17qIs9x6Afl0HY2JjDVc0OruX6mRyB4JuLMg+dHYcqvy3J8uzBE
         TSaS9REokY7vm02Lkj/hvS8ASPHgGToAKKGK4Gd9eeJvnzon2NxjOgeoOHBHJYJfNq
         OLF1/ihzbitcuNxMeQ9gX6zYnSWmkQH7zgd7e9BQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 102/204] mtd: rawnand: fsl_upm: Remove unused mtd var
Date:   Thu, 20 Aug 2020 11:19:59 +0200
Message-Id: <20200820091611.417906011@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
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
index f31fae3a4c689..6b8ec72686e29 100644
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



