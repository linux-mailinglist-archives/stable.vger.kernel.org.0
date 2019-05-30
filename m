Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B45962F4FD
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732890AbfE3EnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:43:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728856AbfE3DML (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:11 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB23A244A0;
        Thu, 30 May 2019 03:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185930;
        bh=vEOByxn9z6ZCUFQN8HmDmoIcUw5cBKWjZLs5n98wcSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tRkUZZrg0LpRTtkVawNBcul8fKiFMSjpVLYadZwRMcvtD6XN6F0rawqxobkQGczz9
         aIrhhw3sMw7SMhmaYp8S0rrt2spl4S+yjOQTl6YXMQ7kTCyMpnSBVBjBtmBAUK4iwc
         Qdawqy1aGxlFpA3q1rm5GWJ26KP5r/Dp37rSKF30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        George Hilliard <thirtythreeforty@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 324/405] staging: mt7621-mmc: Check for nonzero number of scatterlist entries
Date:   Wed, 29 May 2019 20:05:22 -0700
Message-Id: <20190530030557.140337596@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d4223e06b6aed581625f574ad8faa71b6c0fc903 ]

The buffer descriptor setup loop is correct only if it is setting up at
least one bd struct.  Besides, there is an error if dma_map_sg() returns
0, which is possible and must be handled.

Additionally, remove the BUG_ON() checking sglen, which is unnecessary
because we configure DMA with that constraint during init.

Signed-off-by: George Hilliard <thirtythreeforty@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/mt7621-mmc/sd.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/mt7621-mmc/sd.c b/drivers/staging/mt7621-mmc/sd.c
index 74f0e57ad2f15..38f9ea02ee3a9 100644
--- a/drivers/staging/mt7621-mmc/sd.c
+++ b/drivers/staging/mt7621-mmc/sd.c
@@ -596,8 +596,6 @@ static void msdc_dma_setup(struct msdc_host *host, struct msdc_dma *dma,
 	struct bd *bd;
 	u32 j;
 
-	BUG_ON(sglen > MAX_BD_NUM); /* not support currently */
-
 	gpd = dma->gpd;
 	bd  = dma->bd;
 
@@ -692,6 +690,13 @@ static int msdc_do_request(struct mmc_host *mmc, struct mmc_request *mrq)
 		data->sg_count = dma_map_sg(mmc_dev(mmc), data->sg,
 					    data->sg_len,
 					    mmc_get_dma_dir(data));
+
+		if (data->sg_count == 0) {
+			dev_err(mmc_dev(host->mmc), "failed to map DMA for transfer\n");
+			data->error = -ENOMEM;
+			goto done;
+		}
+
 		msdc_dma_setup(host, &host->dma, data->sg,
 			       data->sg_count);
 
-- 
2.20.1



