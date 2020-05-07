Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF61A1C8F6F
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbgEGOb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:31:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728769AbgEGOaJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:30:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6069E215A4;
        Thu,  7 May 2020 14:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861809;
        bh=WnNstYCDUFAAXrsF4FoTE8vpCGvT/AX729NNv95uTrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=btVOa/Tgo+7Lg7oIsHesvEM6Ely452dUpEzWa69zSpw7VLqP2yFrYne3kdRDpUc/+
         iKE+DAQ9BZhDbruNSVhnpmGxC+5n3wcwKf7YXIxkpUZ3Gvhxf3coQxYDXFnC8lrAuH
         2hKAP6iVZ0dxU2Xfh/Or7owenlLbwNn8Jqk3Ty/4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lubomir Rintel <lkundrak@v3.sk>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>, dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 04/11] dmaengine: mmp_tdma: Reset channel error on release
Date:   Thu,  7 May 2020 10:29:56 -0400
Message-Id: <20200507143003.27047-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507143003.27047-1-sashal@kernel.org>
References: <20200507143003.27047-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lubomir Rintel <lkundrak@v3.sk>

[ Upstream commit 0c89446379218698189a47871336cb30286a7197 ]

When a channel configuration fails, the status of the channel is set to
DEV_ERROR so that an attempt to submit it fails. However, this status
sticks until the heat end of the universe, making it impossible to
recover from the error.

Let's reset it when the channel is released so that further use of the
channel with correct configuration is not impacted.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Link: https://lore.kernel.org/r/20200419164912.670973-5-lkundrak@v3.sk
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mmp_tdma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
index 13c68b6434ce2..15b4a44e60069 100644
--- a/drivers/dma/mmp_tdma.c
+++ b/drivers/dma/mmp_tdma.c
@@ -362,6 +362,8 @@ static void mmp_tdma_free_descriptor(struct mmp_tdma_chan *tdmac)
 		gen_pool_free(gpool, (unsigned long)tdmac->desc_arr,
 				size);
 	tdmac->desc_arr = NULL;
+	if (tdmac->status == DMA_ERROR)
+		tdmac->status = DMA_COMPLETE;
 
 	return;
 }
-- 
2.20.1

