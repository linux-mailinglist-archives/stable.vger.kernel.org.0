Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE3D431D6B
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233427AbhJRNvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:51:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233437AbhJRNtW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:49:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 923E86187C;
        Mon, 18 Oct 2021 13:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564244;
        bh=X8T8nJdcfjDb9RMfDqAHqm8OX/AnvRnsLpuBQOCD6aY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fY7jZYvbgkiSVdLaFtCdonGZwCg1T/qGGDfcbI+BsnjGZZe60wLgTiudQfeLD/ycC
         hMqi1uSixO6L/8oxRHO1dj7OW/yGSyTvJXwmtO+EXgFPJywEg8+1JrE44WnbawQHu+
         Mqc0u3Nh6HYLM3SYN/OF1lgc+a+T7B0h/9SSjxfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Md Sadre Alam <mdalam@codeaurora.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.14 016/151] mtd: rawnand: qcom: Update code word value for raw read
Date:   Mon, 18 Oct 2021 15:23:15 +0200
Message-Id: <20211018132341.212664447@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Md Sadre Alam <mdalam@codeaurora.org>

commit f60f5741002b9fde748cff65fd09bd6222c5db0c upstream.

>From QPIC V2 onwards there is a separate register to read
last code word "QPIC_NAND_READ_LOCATION_LAST_CW_n".

qcom_nandc_read_cw_raw() is used to read only one code word
at a time. If we will configure number of code words to 1 in
in QPIC_NAND_DEV0_CFG0 register then QPIC controller thinks
its reading the last code word, since from QPIC V2 onwards
we are having separate register to read the last code word,
we have to configure "QPIC_NAND_READ_LOCATION_LAST_CW_n"
register to fetch data from controller buffer to system
memory.

Fixes: 503ee5aad430 ("mtd: rawnand: qcom: update last code word register")
Cc: stable@kernel.org
Signed-off-by: Md Sadre Alam <mdalam@codeaurora.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/1630998357-1359-1-git-send-email-mdalam@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/qcom_nandc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/raw/qcom_nandc.c
+++ b/drivers/mtd/nand/raw/qcom_nandc.c
@@ -1676,13 +1676,17 @@ qcom_nandc_read_cw_raw(struct mtd_info *
 	struct nand_ecc_ctrl *ecc = &chip->ecc;
 	int data_size1, data_size2, oob_size1, oob_size2;
 	int ret, reg_off = FLASH_BUF_ACC, read_loc = 0;
+	int raw_cw = cw;
 
 	nand_read_page_op(chip, page, 0, NULL, 0);
 	host->use_ecc = false;
 
+	if (nandc->props->qpic_v2)
+		raw_cw = ecc->steps - 1;
+
 	clear_bam_transaction(nandc);
 	set_address(host, host->cw_size * cw, page);
-	update_rw_regs(host, 1, true, cw);
+	update_rw_regs(host, 1, true, raw_cw);
 	config_nand_page_read(chip);
 
 	data_size1 = mtd->writesize - host->cw_size * (ecc->steps - 1);
@@ -1711,7 +1715,7 @@ qcom_nandc_read_cw_raw(struct mtd_info *
 		nandc_set_read_loc(chip, cw, 3, read_loc, oob_size2, 1);
 	}
 
-	config_nand_cw_read(chip, false, cw);
+	config_nand_cw_read(chip, false, raw_cw);
 
 	read_data_dma(nandc, reg_off, data_buf, data_size1, 0);
 	reg_off += data_size1;


