Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20E88121751
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730008AbfLPSIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:08:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730321AbfLPSIs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:08:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FB49206E0;
        Mon, 16 Dec 2019 18:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519728;
        bh=ZvaVZQjOKfJxTpZ07uWHAkVkOLa3DZUdeKfk4bxPTO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZVXm/7N2K7l67qlhJTfu+S4/Hf8h86z5sxf4FvGs24cJ1081snRWuoDy1plOJpnQW
         s0bN1RVqqxuePgK8YvTybFudr3gcbbakX8q30aRTRrm358ean2eXTFO503Z4QOyg3U
         BDCxzX5/BF2TYS8zw6E8SASwZZXEvnaC9d9BdIOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Piotr Sroka <piotrs@cadence.com>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.3 045/180] mtd: rawnand: Change calculating of position page containing BBM
Date:   Mon, 16 Dec 2019 18:48:05 +0100
Message-Id: <20191216174819.918551533@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Piotr Sroka <piotrs@cadence.com>

commit a3c4c2339f8948b0f578e938970303a7372e60c0 upstream.

Change calculating of position page containing BBM

If none of BBM flags are set then function nand_bbm_get_next_page
reports EINVAL. It causes that BBM is not read at all during scanning
factory bad blocks. The result is that the BBT table is build without
checking factory BBM at all. For Micron flash memories none of these
flags are set if page size is different than 2048 bytes.

Address this regression by:
- adding NAND_BBM_FIRSTPAGE chip flag without any condition. It solves
  issue only for Micron devices.
- changing the nand_bbm_get_next_page_function. It will return 0
  if no of BBM flag is set and page parameter is 0. After that modification
  way of discovering factory bad blocks will work similar as in kernel
  version 5.1.

Cc: stable@vger.kernel.org
Fixes: f90da7818b14 (mtd: rawnand: Support bad block markers in first, second or last page)
Signed-off-by: Piotr Sroka <piotrs@cadence.com>
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/nand_base.c   |    8 ++++++--
 drivers/mtd/nand/raw/nand_micron.c |    4 +++-
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -292,12 +292,16 @@ int nand_bbm_get_next_page(struct nand_c
 	struct mtd_info *mtd = nand_to_mtd(chip);
 	int last_page = ((mtd->erasesize - mtd->writesize) >>
 			 chip->page_shift) & chip->pagemask;
+	unsigned int bbm_flags = NAND_BBM_FIRSTPAGE | NAND_BBM_SECONDPAGE
+		| NAND_BBM_LASTPAGE;
 
+	if (page == 0 && !(chip->options & bbm_flags))
+		return 0;
 	if (page == 0 && chip->options & NAND_BBM_FIRSTPAGE)
 		return 0;
-	else if (page <= 1 && chip->options & NAND_BBM_SECONDPAGE)
+	if (page <= 1 && chip->options & NAND_BBM_SECONDPAGE)
 		return 1;
-	else if (page <= last_page && chip->options & NAND_BBM_LASTPAGE)
+	if (page <= last_page && chip->options & NAND_BBM_LASTPAGE)
 		return last_page;
 
 	return -EINVAL;
--- a/drivers/mtd/nand/raw/nand_micron.c
+++ b/drivers/mtd/nand/raw/nand_micron.c
@@ -446,8 +446,10 @@ static int micron_nand_init(struct nand_
 	if (ret)
 		goto err_free_manuf_data;
 
+	chip->options |= NAND_BBM_FIRSTPAGE;
+
 	if (mtd->writesize == 2048)
-		chip->options |= NAND_BBM_FIRSTPAGE | NAND_BBM_SECONDPAGE;
+		chip->options |= NAND_BBM_SECONDPAGE;
 
 	ondie = micron_supports_on_die_ecc(chip);
 


