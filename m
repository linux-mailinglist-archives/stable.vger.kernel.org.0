Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2011F12B99B
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 19:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbfL0SCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 13:02:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:59694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727962AbfL0SCo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 13:02:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D52B21775;
        Fri, 27 Dec 2019 18:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577469764;
        bh=rn+RqjIAdDdOswpcLXNztAWhWJuyC+dPZFWOqYFTTr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zMr/KIdxhlqvAHkdoC+MHrdqas3aoUa9NXzMpuEBP9Tec+JLtbrVj2W6EzVvpF3/Q
         ZefDXSPLslsgRqmxBuZWgFawlQvsIxzaW/lYOENzoIS+TSELWfE6qIecGFBa4hc9zK
         mstcxhneYagnO0SFrFlyO53ggIJuxfosVF5Ho4p4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 16/57] spi: spi-cavium-thunderx: Add missing pci_release_regions()
Date:   Fri, 27 Dec 2019 13:01:41 -0500
Message-Id: <20191227180222.7076-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227180222.7076-1-sashal@kernel.org>
References: <20191227180222.7076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit a841e2853e1afecc2ee692b8cc5bff606bc84e4c ]

The driver forgets to call pci_release_regions() in probe failure
and remove.
Add the missed calls to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Link: https://lore.kernel.org/r/20191206075500.18525-1-hslester96@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cavium-thunderx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-cavium-thunderx.c b/drivers/spi/spi-cavium-thunderx.c
index 877937706240..828fbbebc3c4 100644
--- a/drivers/spi/spi-cavium-thunderx.c
+++ b/drivers/spi/spi-cavium-thunderx.c
@@ -81,6 +81,7 @@ static int thunderx_spi_probe(struct pci_dev *pdev,
 
 error:
 	clk_disable_unprepare(p->clk);
+	pci_release_regions(pdev);
 	spi_master_put(master);
 	return ret;
 }
@@ -95,6 +96,7 @@ static void thunderx_spi_remove(struct pci_dev *pdev)
 		return;
 
 	clk_disable_unprepare(p->clk);
+	pci_release_regions(pdev);
 	/* Put everything in a known state. */
 	writeq(0, p->register_base + OCTEON_SPI_CFG(p));
 }
-- 
2.20.1

