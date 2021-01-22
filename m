Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A289300B11
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 19:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbhAVSUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:20:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:40014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728572AbhAVOXA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:23:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D26CF23B78;
        Fri, 22 Jan 2021 14:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325022;
        bh=9FPRWmOC66yeYH9qhFzP0MvL2Oe/5q7lfDCx9RhoNpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x6qVCEFF+vSKEgTOlHlMN0QJf0UlU69iFzAekua+M3oD3AjBXq6h2o6J5OCZBdn0D
         zGORFhrffsqOcVWd8CtoLg6nXyHIzhB0+C6WivXKXCCkz1+WbzyqqYezNIYbUJ0097
         Srk/KV96kQYbC7a0zToOyLnJj6P9adzvUrCJDPx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qinglang Miao <miaoqinglang@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.4 07/33] spi: npcm-fiu: simplify the return expression of npcm_fiu_probe()
Date:   Fri, 22 Jan 2021 15:12:23 +0100
Message-Id: <20210122135733.865499923@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135733.565501039@linuxfoundation.org>
References: <20210122135733.565501039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

commit 4c3a14fbc05a09fc369fb68a86cdbf6f441a29f2 upstream

Simplify the return expression.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Link: https://lore.kernel.org/r/20200921131106.93228-1-miaoqinglang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-npcm-fiu.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/spi/spi-npcm-fiu.c
+++ b/drivers/spi/spi-npcm-fiu.c
@@ -677,7 +677,6 @@ static int npcm_fiu_probe(struct platfor
 	struct npcm_fiu_spi *fiu;
 	void __iomem *regbase;
 	struct resource *res;
-	int ret;
 	int id;
 
 	ctrl = devm_spi_alloc_master(dev, sizeof(*fiu));
@@ -736,11 +735,7 @@ static int npcm_fiu_probe(struct platfor
 	ctrl->num_chipselect = fiu->info->max_cs;
 	ctrl->dev.of_node = dev->of_node;
 
-	ret = devm_spi_register_master(dev, ctrl);
-	if (ret)
-		return ret;
-
-	return 0;
+	return devm_spi_register_master(dev, ctrl);
 }
 
 static int npcm_fiu_remove(struct platform_device *pdev)


