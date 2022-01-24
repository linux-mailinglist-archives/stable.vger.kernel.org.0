Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C125F499FE6
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842320AbiAXXBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1838729AbiAXWr6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:47:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4615C06B5BC;
        Mon, 24 Jan 2022 13:07:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4522C61320;
        Mon, 24 Jan 2022 21:07:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC69C340E5;
        Mon, 24 Jan 2022 21:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058432;
        bh=R+WX8tRh9BhkMM3bYGELy4TMhMrbAv10+Nlt5zhG0vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PzAMTE8Q3fYvRSivvG2A+F/PnnvpJ7/lui00eIGGG7qyDa33dfUBHreGFyPa/clFi
         Ld4/mhoORRSObDhA/5iovarN0CsP6wxcTsQ+4g9I8Hnem8Xrg6wXzL6gAGgd5/WyJL
         9DRk51ihkdfhlosDpVLmtiNajD1Ks32hVRKUM6YQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0287/1039] media: coda/imx-vdoa: Handle dma_set_coherent_mask error codes
Date:   Mon, 24 Jan 2022 19:34:36 +0100
Message-Id: <20220124184134.932125326@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 43f0633f89947df57fe0b5025bdd741768007708 ]

The return value of dma_set_coherent_mask() is not always 0.
To catch the exception in case that dma is not support the mask.

Link: https://lore.kernel.org/linux-media/20211206022201.1639460-1-jiasheng@iscas.ac.cn
Fixes: b0444f18e0b1 ("[media] coda: add i.MX6 VDOA driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/coda/imx-vdoa.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/imx-vdoa.c b/drivers/media/platform/coda/imx-vdoa.c
index 6996d4571e363..00643f37b3e6f 100644
--- a/drivers/media/platform/coda/imx-vdoa.c
+++ b/drivers/media/platform/coda/imx-vdoa.c
@@ -287,7 +287,11 @@ static int vdoa_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret;
 
-	dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	if (ret) {
+		dev_err(&pdev->dev, "DMA enable failed\n");
+		return ret;
+	}
 
 	vdoa = devm_kzalloc(&pdev->dev, sizeof(*vdoa), GFP_KERNEL);
 	if (!vdoa)
-- 
2.34.1



