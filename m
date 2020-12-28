Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D956B2E3DDE
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437848AbgL1OUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:20:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:56138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437823AbgL1OUt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93B77229C4;
        Mon, 28 Dec 2020 14:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165203;
        bh=6DMu6UVT5XY11l7laUZ2NODoQR8Y7FJqYKfynL9wG98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tgtXhe8gXTCMiDkhJgGFXUCCA3e9j1hPD0AUjPTge3Se7lWb+I5YSTBAAy8zbLnoG
         zbQ1n7ZUfHZZXpagj3td+tOCcvc+d6o1MKCXaJzl6+uNX2bVQMVGv7f2TJQSz5vy0z
         +llml9ctvJai+L4HEbxTkpyVZdt1CZPrIB5gEmyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Han Xu <han.xu@nxp.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 408/717] mtd: rawnand: gpmi: fix reference count leak in gpmi ops
Date:   Mon, 28 Dec 2020 13:46:46 +0100
Message-Id: <20201228125040.528779957@linuxfoundation.org>
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
index dc8104e675062..b5f46f214a582 100644
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
@@ -2263,8 +2265,10 @@ static int gpmi_nfc_exec_op(struct nand_chip *chip,
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



