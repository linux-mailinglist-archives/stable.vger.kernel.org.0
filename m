Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215B24003B6
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 18:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235768AbhICQzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 12:55:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230187AbhICQzt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Sep 2021 12:55:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41DFD60F92;
        Fri,  3 Sep 2021 16:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630688089;
        bh=z9TzjPQw/sY0KmuxqT1qHjd1OMAPsehr7NQJw/38fG8=;
        h=From:To:Cc:Subject:Date:From;
        b=ZvDdAs6i95o5iMvoBptI7yBD+FfBvMhKttvnQ8FT3TkXpJmjN07CjqcgOTfb33Rpn
         mfdSuAvUc4UCCEKfoSjVPSfzAhZWFP7O0JGX7i+QKF6IAKCCFB/RhxMP9dBXOt4xVf
         0/uDPHd2nJbrhP+EVjQue5rOiLmeGnFwUDrdgBOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wenyou Yang <wenyou.yang@atmel.com>,
        Josh Wu <rainyfeeling@outlook.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Richard Weinberger <richard@nod.at>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH] mtd: nand: atmel_nand: remove build warning in atmel_nand_remove()
Date:   Fri,  3 Sep 2021 18:54:39 +0200
Message-Id: <20210903165439.3254568-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In the 4.9.y tree, the following build warning keeps showing up:

	drivers/mtd/nand/atmel_nand.c:2337:19: warning: unused variable 'mtd' [-Wunused-variable]

This driver was deleted / restructured in newer kernels so this is a
4.9.y patch only.

Cc: Wenyou Yang <wenyou.yang@atmel.com>
Cc: Josh Wu <rainyfeeling@outlook.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Brian Norris <computersforpeace@gmail.com>
Cc: Marek Vasut <marek.vasut@gmail.com>
Cc: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/atmel_nand.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index 45495bc1a70e..bcae07e60574 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -2334,7 +2334,6 @@ static int atmel_nand_probe(struct platform_device *pdev)
 static int atmel_nand_remove(struct platform_device *pdev)
 {
 	struct atmel_nand_host *host = platform_get_drvdata(pdev);
-	struct mtd_info *mtd = nand_to_mtd(&host->nand_chip);
 
 	nand_release(&host->nand_chip);
 
-- 
2.33.0

