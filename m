Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAD012EF99
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgABWrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:47:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:60872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729508AbgABW3l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:29:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10B9220863;
        Thu,  2 Jan 2020 22:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004181;
        bh=hmWCdqztjAp1Mjdb0Aca23x/E1Qclg6hUE9U9kkaU/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fhr+bDZ07qiRloQrsg+dtx8iOSb51dBZC/Zr56Gaf1JJXitMoD5nmHwjh6VdWAP6w
         lkeTNpJrcaK99Bs5j+meMF9rciNremfG9bgiAkLSgZgxNqu+waZ/fyotABX8opoOUX
         +I+V4Si6VA70fAfrlNj4IvNiSX4gR8YLPcRXzPRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 047/171] spi: img-spfi: fix potential double release
Date:   Thu,  2 Jan 2020 23:06:18 +0100
Message-Id: <20200102220553.485273060@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
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
index 7a37090dabbe..2e65b70c7879 100644
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



