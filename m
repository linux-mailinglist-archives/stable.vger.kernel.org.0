Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3022E3EB1
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392097AbgL1Obq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:31:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:39282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504127AbgL1ObE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:31:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CDB720731;
        Mon, 28 Dec 2020 14:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165824;
        bh=928TzreslQ5IpUfPn0ImDZSaWSiNvOAFCxBNWBX/BXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lKpJqmpNhKp15UakrjjwmC1KgQszZPjdk5QVujHp1G6O+id+bLz8F4UVvDIlQI362
         eLiIfX4n7t4+RewQH+z3YkEFWdw3n+Dc9wLxUIa5d5IjZ65dRWRwGgBMcfXAY23F2i
         VX9eXrtFDl3xBZ6c2g7fB8IuZ0Ss35hD2hN+lG6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Praveenkumar I <ipkumar@codeaurora.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 667/717] mtd: rawnand: qcom: Fix DMA sync on FLASH_STATUS register read
Date:   Mon, 28 Dec 2020 13:51:05 +0100
Message-Id: <20201228125052.936376219@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
 


