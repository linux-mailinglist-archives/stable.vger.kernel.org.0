Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6943F1C8F01
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgEGO2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:28:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728285AbgEGO2s (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:28:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2159320870;
        Thu,  7 May 2020 14:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861727;
        bh=MKIyheyNGViV/MgpHcPvLYxIi6TdIFMAtGgTC0w2VSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kFDNm7YnplleywSfSTGqsgVKet4X+sU2AWOx+ET4p+C2rLL5QiiGyo1nISinTZzdd
         6NBSPx2yc8VSvE1MeBYa9QhhSKtNH5Q42ANmeX6ijt9iBUUdCydncp8k7umv4rrdkh
         HlAOozr83uswdc8lYY6bpg8Xrhhl1xlTRkupmYro=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lubomir Rintel <lkundrak@v3.sk>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>, dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 13/35] dmaengine: mmp_tdma: Reset channel error on release
Date:   Thu,  7 May 2020 10:28:07 -0400
Message-Id: <20200507142830.26239-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142830.26239-1-sashal@kernel.org>
References: <20200507142830.26239-1-sashal@kernel.org>
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
index 4d5b987e4841a..89d90c456c0ce 100644
--- a/drivers/dma/mmp_tdma.c
+++ b/drivers/dma/mmp_tdma.c
@@ -363,6 +363,8 @@ static void mmp_tdma_free_descriptor(struct mmp_tdma_chan *tdmac)
 		gen_pool_free(gpool, (unsigned long)tdmac->desc_arr,
 				size);
 	tdmac->desc_arr = NULL;
+	if (tdmac->status == DMA_ERROR)
+		tdmac->status = DMA_COMPLETE;
 
 	return;
 }
-- 
2.20.1

