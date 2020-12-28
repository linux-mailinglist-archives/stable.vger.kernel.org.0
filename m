Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E7C2E62FC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406431AbgL1PiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:38:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:52248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406337AbgL1Nua (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:50:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4150122B3A;
        Mon, 28 Dec 2020 13:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163387;
        bh=xvfIl6YZ/nm2w5Nfrk/Ms5SuVIq1ExxubGwJyPXxozw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=szz+EpIN9UwM0J7RQamERbtdCehJFstNqad/fVnQ6RJm4P50OrAmWr58M4jRbt+0P
         BDycrn8tBEJIHefQjz2rJac6dvfKVEMpJFOmGk2hucTTggD3y9dJLsNutBaRr2CEpn
         1QhLeHg/K/3n9pOSp8eqKunvkEXWoF/DoWawpTKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Han Xu <han.xu@nxp.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 267/453] mtd: rawnand: gpmi: fix reference count leak in gpmi ops
Date:   Mon, 28 Dec 2020 13:48:23 +0100
Message-Id: <20201228124950.074976939@linuxfoundation.org>
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

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 1b391c7f2e863985668d705f525af3ceb55bc800 ]

pm_runtime_get_sync() will increment pm usage at first and it
will resume the device later. If runtime of the device has
error or device is in inaccessible state(or other error state),
resume operation will fail. If we do not call put operation to
decrease the reference, it will result in reference leak in
the two functions(gpmi_init and gpmi_nfc_exec_op). Moreover,
this device cannot enter the idle state and always stay busy or
other non-idle state later. So we fixed it through adding
pm_runtime_put_noidle.

Fixes: 5bc6bb603b4d0 ("mtd: rawnand: gpmi: Fix suspend/resume problem")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Acked-by: Han Xu <han.xu@nxp.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20201107110552.1568742-1-zhangqilong3@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
index ef89947ee3191..89239d9c4ea63 100644
--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -149,8 +149,10 @@ static int gpmi_init(struct gpmi_nand_data *this)
 	int ret;
 
 	ret = pm_runtime_get_sync(this->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(this->dev);
 		return ret;
+	}
 
 	ret = gpmi_reset_block(r->gpmi_regs, false);
 	if (ret)
@@ -2414,8 +2416,10 @@ static int gpmi_nfc_exec_op(struct nand_chip *chip,
 		this->transfers[i].direction = DMA_NONE;
 
 	ret = pm_runtime_get_sync(this->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(this->dev);
 		return ret;
+	}
 
 	/*
 	 * This driver currently supports only one NAND chip. Plus, dies share
-- 
2.27.0



