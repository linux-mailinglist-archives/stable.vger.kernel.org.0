Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52321C8FA5
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgEGOdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:33:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728566AbgEGO3a (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:29:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B2952073A;
        Thu,  7 May 2020 14:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861770;
        bh=WnNstYCDUFAAXrsF4FoTE8vpCGvT/AX729NNv95uTrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u63shO+HPDMBwt6pFZ3T16f5AICTAde98eUjffCjRt0kRUfgQwfjF5ozH6V2sJaSP
         J7ZI2gUYFNm97H+1nJA0do8JHKN2KFf0LQCEfTXU2lTouiaAr8IrfBAr937wjB6PVU
         DzTQT4ArG+QQyjnUH8Wk4sMukyQ/EiYANw2wp4r8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lubomir Rintel <lkundrak@v3.sk>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>, dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 10/20] dmaengine: mmp_tdma: Reset channel error on release
Date:   Thu,  7 May 2020 10:29:06 -0400
Message-Id: <20200507142917.26612-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142917.26612-1-sashal@kernel.org>
References: <20200507142917.26612-1-sashal@kernel.org>
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

