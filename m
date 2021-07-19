Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43BE3CE4E5
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345570AbhGSPqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:46:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349235AbhGSPoz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:44:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E65061621;
        Mon, 19 Jul 2021 16:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711844;
        bh=jD0rpjtQwH3Vxn5fbUrhnkXH3IXNZerGkwRaslusX/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=epZ9Jf61woTN2JNVN3Ga3Mcyz61gQw8Tdp7+tKt3aFz14eDtiZ5Fy63fa31D4HHBt
         CdDOKg+1g4OSNs7Aczy21NZq1jvjIkajQiPrivdNt8me/tXdfnNTFGEFxDluCOW9tJ
         02ENIy3ZdGaMf5YRMgLaXbgp3RjiiaHrf9iob9wc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 119/292] ASoC: fsl_xcvr: check return value after calling platform_get_resource_byname()
Date:   Mon, 19 Jul 2021 16:53:01 +0200
Message-Id: <20210719144946.400396955@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
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
index 070e3f32859f..244a35122fbc 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -1205,6 +1205,10 @@ static int fsl_xcvr_probe(struct platform_device *pdev)
 
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



