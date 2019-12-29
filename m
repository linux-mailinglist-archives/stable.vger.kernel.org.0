Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23E6112C94A
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732285AbfL2SEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:04:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:38812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732297AbfL2Rwc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:52:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5EC5206A4;
        Sun, 29 Dec 2019 17:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641952;
        bh=YHT4jib6C/ve98RMB9mERFb3A8aWaHVi6zg3GXFzM50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XqMkRWh1v8XV4aN9xLDKUvWfCEtO6IK6EeGq7wdp7/XBrn7R9AHEd6M08hv4DIw1T
         hADbzRTYG81Ista3Nh2iBFYvfs5rQ2SnDsDml/oPKjY3rFmHaleEpmVU+qJNhPLULo
         qt5EcAR2KOutDVYE8Zz7137epWv8BHTW2JYr7gl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 238/434] spi: img-spfi: fix potential double release
Date:   Sun, 29 Dec 2019 18:24:51 +0100
Message-Id: <20191229172717.690949251@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit e9a8ba9769a0e354341bc6cc01b98aadcea1dfe9 ]

The channels spfi->tx_ch and spfi->rx_ch are not set to NULL after they
are released. As a result, they will be released again, either on the
error handling branch in the same function or in the corresponding
remove function, i.e. img_spfi_remove(). This patch fixes the bug by
setting the two members to NULL.

Signed-off-by: Pan Bian <bianpan2016@163.com>
Link: https://lore.kernel.org/r/1573007769-20131-1-git-send-email-bianpan2016@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-img-spfi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-img-spfi.c b/drivers/spi/spi-img-spfi.c
index 439b01e4a2c8..f4a8f470aecc 100644
--- a/drivers/spi/spi-img-spfi.c
+++ b/drivers/spi/spi-img-spfi.c
@@ -673,6 +673,8 @@ static int img_spfi_probe(struct platform_device *pdev)
 			dma_release_channel(spfi->tx_ch);
 		if (spfi->rx_ch)
 			dma_release_channel(spfi->rx_ch);
+		spfi->tx_ch = NULL;
+		spfi->rx_ch = NULL;
 		dev_warn(spfi->dev, "Failed to get DMA channels, falling back to PIO mode\n");
 	} else {
 		master->dma_tx = spfi->tx_ch;
-- 
2.20.1



