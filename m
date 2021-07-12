Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E743C5532
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355396AbhGLIJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:09:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353133AbhGLIBg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:01:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37C6E61C50;
        Mon, 12 Jul 2021 07:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076459;
        bh=Q2FOvnjICuD6VGslWPL85LRcJm03rb1WO9PQ2VacMHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BUq/zmCJJkTZCrwGiP+sQn+8mdaz2a6deBwjFAJaK+V/k9FMNZrSPBVQv+C0fRVWU
         j39h4rFrSE87waIFtbZ0RZ02Bcq4y9OUGhb9REyMkbWnBaFqRiTkkmRDbO/WHpTnrL
         z8VXaYsRDw8R0Jd55C5NlMfgZs85H8rxOC0ZTarg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 650/800] misc/pvpanic-pci: Fix error handling in pvpanic_pci_probe()
Date:   Mon, 12 Jul 2021 08:11:13 +0200
Message-Id: <20210712061036.174665211@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 372dae89972594393b57f29ec44e351fa7eedbbe ]

There is no error handling path in the probe function.
Switch to managed resource so that errors in the probe are handled easily
and simplify the remove function accordingly.

Fixes: db3a4f0abefd ("misc/pvpanic: add PCI driver")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/ab071b1f4ed6e1174f9199095fb16a58bb406090.1621665058.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/pvpanic/pvpanic-pci.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/pvpanic/pvpanic-pci.c b/drivers/misc/pvpanic/pvpanic-pci.c
index 9ecc4e8559d5..046ce4ecc195 100644
--- a/drivers/misc/pvpanic/pvpanic-pci.c
+++ b/drivers/misc/pvpanic/pvpanic-pci.c
@@ -78,15 +78,15 @@ static int pvpanic_pci_probe(struct pci_dev *pdev,
 	void __iomem *base;
 	int ret;
 
-	ret = pci_enable_device(pdev);
+	ret = pcim_enable_device(pdev);
 	if (ret < 0)
 		return ret;
 
-	base = pci_iomap(pdev, 0, 0);
+	base = pcim_iomap(pdev, 0, 0);
 	if (!base)
 		return -ENOMEM;
 
-	pi = kmalloc(sizeof(*pi), GFP_ATOMIC);
+	pi = devm_kmalloc(&pdev->dev, sizeof(*pi), GFP_ATOMIC);
 	if (!pi)
 		return -ENOMEM;
 
@@ -107,9 +107,6 @@ static void pvpanic_pci_remove(struct pci_dev *pdev)
 	struct pvpanic_instance *pi = dev_get_drvdata(&pdev->dev);
 
 	pvpanic_remove(pi);
-	iounmap(pi->base);
-	kfree(pi);
-	pci_disable_device(pdev);
 }
 
 static struct pci_driver pvpanic_pci_driver = {
-- 
2.30.2



