Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815392E40A4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441244AbgL1OQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:16:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:51268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441258AbgL1OQu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:16:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2224120731;
        Mon, 28 Dec 2020 14:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164994;
        bh=fGdpDe3GdEdKv7k2MsyEgHarQQpAdk+OfVeTJVA5oiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2rsSAd99zzffjxCgS7247cqmVZlWL0yQBKx/2DahtNL2IZYlw6zdwh+bzD8fcCx6Z
         WbeTHF5FOI+5nB8ygcweeFXJrcYoxufbPSW/8JgAg+yoEgg1OBnaSm/j2CdCt40w+5
         f+GktjbAPJCv8tQlJLyvatDDn1VNDbvyYPtD37MI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 345/717] adm8211: fix error return code in adm8211_probe()
Date:   Mon, 28 Dec 2020 13:45:43 +0100
Message-Id: <20201228125037.555923763@linuxfoundation.org>
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

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 05c2a61d69ea306e891884a86486e1ef37c4b78d ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: cc0b88cf5ecf ("[PATCH] Add adm8211 802.11b wireless driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1607071638-33619-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/admtek/adm8211.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/admtek/adm8211.c b/drivers/net/wireless/admtek/adm8211.c
index 5cf2045fadeff..c41e72508d3db 100644
--- a/drivers/net/wireless/admtek/adm8211.c
+++ b/drivers/net/wireless/admtek/adm8211.c
@@ -1796,6 +1796,7 @@ static int adm8211_probe(struct pci_dev *pdev,
 	if (io_len < 256 || mem_len < 1024) {
 		printk(KERN_ERR "%s (adm8211): Too short PCI resources\n",
 		       pci_name(pdev));
+		err = -ENOMEM;
 		goto err_disable_pdev;
 	}
 
@@ -1805,6 +1806,7 @@ static int adm8211_probe(struct pci_dev *pdev,
 	if (reg != ADM8211_SIG1 && reg != ADM8211_SIG2) {
 		printk(KERN_ERR "%s (adm8211): Invalid signature (0x%x)\n",
 		       pci_name(pdev), reg);
+		err = -EINVAL;
 		goto err_disable_pdev;
 	}
 
@@ -1815,8 +1817,8 @@ static int adm8211_probe(struct pci_dev *pdev,
 		return err; /* someone else grabbed it? don't disable it */
 	}
 
-	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(32)) ||
-	    dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32))) {
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+	if (err) {
 		printk(KERN_ERR "%s (adm8211): No suitable DMA available\n",
 		       pci_name(pdev));
 		goto err_free_reg;
-- 
2.27.0



