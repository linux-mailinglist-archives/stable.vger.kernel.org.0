Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170AD3CE2C1
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235406AbhGSPbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:31:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238946AbhGSP2l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:28:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E91E861287;
        Mon, 19 Jul 2021 16:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710942;
        bh=0WNpUPYCiCvAiu+8gEFe1FqgDIa9C+QUv1qkqbpVoiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fnJtc0SDBHHUQZobgYQf9vdxfh+9zGUuNWcmPKMV2vQtFcsmSZ7AQ1Aeqx/H9ubBx
         ttwOnlnI8+xFOzsjQUZRJ9586Tm2F2cnmYNgMolbLUp9lvO8AvtssXyNK/rSgpkEp7
         5mbmrxduII7gWo70i7WYwnk0paoRA3dyFz+zMQos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 134/351] ASoC: fsl_xcvr: check return value after calling platform_get_resource_byname()
Date:   Mon, 19 Jul 2021 16:51:20 +0200
Message-Id: <20210719144948.917951317@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit a2f6ed4a44721d3a9fdf4da7e0743cb13866bf61 ]

It will cause null-ptr-deref if platform_get_resource_byname() returns NULL,
we need check the return value.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20210615013922.784296-10-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_xcvr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/fsl/fsl_xcvr.c b/sound/soc/fsl/fsl_xcvr.c
index 46f3f2c68756..535e17251a35 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -1202,6 +1202,10 @@ static int fsl_xcvr_probe(struct platform_device *pdev)
 
 	rx_res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "rxfifo");
 	tx_res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "txfifo");
+	if (!rx_res || !tx_res) {
+		dev_err(dev, "could not find rxfifo or txfifo resource\n");
+		return -EINVAL;
+	}
 	xcvr->dma_prms_rx.chan_name = "rx";
 	xcvr->dma_prms_tx.chan_name = "tx";
 	xcvr->dma_prms_rx.addr = rx_res->start;
-- 
2.30.2



