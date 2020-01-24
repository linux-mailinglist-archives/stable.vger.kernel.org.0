Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 626EE147F57
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387710AbgAXLBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:01:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:34432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387703AbgAXLBd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:01:33 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 395D62077C;
        Fri, 24 Jan 2020 11:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863693;
        bh=CaPSLJry4eH8fezUaYIRpq7wcgRRX9Af99I3++DJUfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e/952ieCP1N4Yd55HCtgwio0XoUhG5OGhzf7LUqFoYpOOKvWX8fBBCiskJhV4Thu1
         2S1oiUCQ/X2q9ueWsEwb7PMSnmU6pTRLVOVLcOUbhWwX6ajowsJtKMhnSGvknV99HF
         ut8OU0GHJUo2c0R+diZASgbxTKSoVaRuVg/pSEVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Jon Mason <jdmason@kudzu.us>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 062/639] NTB: ntb_hw_idt: replace IS_ERR_OR_NULL with regular NULL checks
Date:   Fri, 24 Jan 2020 10:23:52 +0100
Message-Id: <20200124093055.181255257@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavo@embeddedor.com>

[ Upstream commit 1b7619828d0c341612f58683e73f279c37e70bbc ]

Both devm_kcalloc() and devm_kzalloc() return NULL on error. They
never return error pointers.

The use of IS_ERR_OR_NULL is currently applied to the wrong
context.

Fix this by replacing IS_ERR_OR_NULL with regular NULL checks.

Fixes: bf2a952d31d2 ("NTB: Add IDT 89HPESxNTx PCIe-switches support")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/idt/ntb_hw_idt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ntb/hw/idt/ntb_hw_idt.c b/drivers/ntb/hw/idt/ntb_hw_idt.c
index dbe72f116017a..a67ef23e81bca 100644
--- a/drivers/ntb/hw/idt/ntb_hw_idt.c
+++ b/drivers/ntb/hw/idt/ntb_hw_idt.c
@@ -1105,9 +1105,9 @@ static struct idt_mw_cfg *idt_scan_mws(struct idt_ntb_dev *ndev, int port,
 	}
 
 	/* Allocate memory for memory window descriptors */
-	ret_mws = devm_kcalloc(&ndev->ntb.pdev->dev, *mw_cnt,
-				sizeof(*ret_mws), GFP_KERNEL);
-	if (IS_ERR_OR_NULL(ret_mws))
+	ret_mws = devm_kcalloc(&ndev->ntb.pdev->dev, *mw_cnt, sizeof(*ret_mws),
+			       GFP_KERNEL);
+	if (!ret_mws)
 		return ERR_PTR(-ENOMEM);
 
 	/* Copy the info of detected memory windows */
@@ -2390,7 +2390,7 @@ static struct idt_ntb_dev *idt_create_dev(struct pci_dev *pdev,
 
 	/* Allocate memory for the IDT PCIe-device descriptor */
 	ndev = devm_kzalloc(&pdev->dev, sizeof(*ndev), GFP_KERNEL);
-	if (IS_ERR_OR_NULL(ndev)) {
+	if (!ndev) {
 		dev_err(&pdev->dev, "Memory allocation failed for descriptor");
 		return ERR_PTR(-ENOMEM);
 	}
-- 
2.20.1



