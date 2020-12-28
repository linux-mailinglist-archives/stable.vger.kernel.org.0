Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74202E42C8
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392646AbgL1P2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:28:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:58638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406784AbgL1N5R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:57:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C01920715;
        Mon, 28 Dec 2020 13:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163821;
        bh=928TzreslQ5IpUfPn0ImDZSaWSiNvOAFCxBNWBX/BXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hT6AA113hTBxOsHan/vj3Q/TCzh+xtmnCVSQOu7hnR3CMCyeP+1Hm8JIFO2JYHczo
         KLKonBU9hkkaZQS+s8aBkkKEdkFmt06WVsgmKTfr+QCgCZc5f74USEni6g6FkSw2y9
         uoepAYv2biqDTX4jQKC7ntNaPIqTSb/plyQ4zV5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Praveenkumar I <ipkumar@codeaurora.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 420/453] mtd: rawnand: qcom: Fix DMA sync on FLASH_STATUS register read
Date:   Mon, 28 Dec 2020 13:50:56 +0100
Message-Id: <20201228124957.431039654@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Praveenkumar I <ipkumar@codeaurora.org>

commit bc3686021122de953858a5be4cbf6e3f1d821e79 upstream.

After each codeword NAND_FLASH_STATUS is read for possible operational
failures. But there is no DMA sync for CPU operation before reading it
and this leads to incorrect or older copy of DMA buffer in reg_read_buf.

This patch adds the DMA sync on reg_read_buf for CPU before reading it.

Fixes: 5bc36b2bf6e2 ("mtd: rawnand: qcom: check for operation errors in case of raw read")
Cc: stable@vger.kernel.org
Signed-off-by: Praveenkumar I <ipkumar@codeaurora.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/1602230872-25616-1-git-send-email-ipkumar@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/qcom_nandc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mtd/nand/raw/qcom_nandc.c
+++ b/drivers/mtd/nand/raw/qcom_nandc.c
@@ -1570,6 +1570,8 @@ static int check_flash_errors(struct qco
 	struct qcom_nand_controller *nandc = get_qcom_nand_controller(chip);
 	int i;
 
+	nandc_read_buffer_sync(nandc, true);
+
 	for (i = 0; i < cw_cnt; i++) {
 		u32 flash = le32_to_cpu(nandc->reg_read_buf[i]);
 


