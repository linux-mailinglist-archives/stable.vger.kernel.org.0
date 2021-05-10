Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E99F378730
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236788AbhEJLOb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:14:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236138AbhEJLHj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:07:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96CE06192E;
        Mon, 10 May 2021 10:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644306;
        bh=59LsXGdZyP/PDtSD8U1o/gxSemZL1om5QmAcjhwY9Fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jg3rIuZ4eM3kTr6MU45ttUSXCMOgFoe2o1SU2Xx44/FsxRQk9nRCo9jtzhGbE4SE/
         fihIoea72PKwDtxeafmLPCYgDdbc9D6aVNj9RJ2lLv1phTeLRosEJKrI3kFZDzGCq/
         NuozMhGJUcHwYM5d0uSDEW54oT6SpdykpViRgVXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Kai Stuhlemmer (ebee Engineering)" <kai.stuhlemmer@ebee.de>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.12 028/384] mtd: rawnand: atmel: Update ecc_stats.corrected counter
Date:   Mon, 10 May 2021 12:16:57 +0200
Message-Id: <20210510102015.795795698@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Stuhlemmer (ebee Engineering) <kai.stuhlemmer@ebee.de>

commit 33cebf701e98dd12b01d39d1c644387b27c1a627 upstream.

Update MTD ECC statistics with the number of corrected bits.

Fixes: f88fc122cc34 ("mtd: nand: Cleanup/rework the atmel_nand driver")
Cc: stable@vger.kernel.org
Signed-off-by: Kai Stuhlemmer (ebee Engineering) <kai.stuhlemmer@ebee.de>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210322150714.101585-1-tudor.ambarus@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/atmel/nand-controller.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/raw/atmel/nand-controller.c
+++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
@@ -883,10 +883,12 @@ static int atmel_nand_pmecc_correct_data
 							  NULL, 0,
 							  chip->ecc.strength);
 
-		if (ret >= 0)
+		if (ret >= 0) {
+			mtd->ecc_stats.corrected += ret;
 			max_bitflips = max(ret, max_bitflips);
-		else
+		} else {
 			mtd->ecc_stats.failed++;
+		}
 
 		databuf += chip->ecc.size;
 		eccbuf += chip->ecc.bytes;


