Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B794EF48BB
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390747AbfKHL6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:58:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:59590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390814AbfKHLog (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:44:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C9CC222CF;
        Fri,  8 Nov 2019 11:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213475;
        bh=lgzmDY7hvgwZlBz91lc4Dp9NshUnGaue5baV8VcMsmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ENbOnxlhEsWcqp6V7esK7k+E2191bPbncxXPsMrxz1ib/twrz8FTdm12O+wBpKJaz
         +GcIi7w88172tR1oV5/5toJsYqsKW9b2RpPxupfRb8P0cSGoNclrAHR++2sFlT6sOt
         D6tNEiCszFampVCRmucvb76yu2qjyRxK++e85NRU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Silsby <dansilsby@gmail.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Mathieu Malaterre <malat@debian.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 058/103] dmaengine: dma-jz4780: Further residue status fix
Date:   Fri,  8 Nov 2019 06:42:23 -0500
Message-Id: <20191108114310.14363-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114310.14363-1-sashal@kernel.org>
References: <20191108114310.14363-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Silsby <dansilsby@gmail.com>

[ Upstream commit 83ef4fb7556b6a673f755da670cbacab7e2c7f1b ]

Func jz4780_dma_desc_residue() expects the index to the next hw
descriptor as its last parameter. Caller func jz4780_dma_tx_status(),
however, applied modulus before passing it. When the current hw
descriptor was last in the list, the index passed became zero.

The resulting excess of reported residue especially caused problems
with cyclic DMA transfer clients, i.e. ALSA AIC audio output, which
rely on this for determining current DMA location within buffer.

Combined with the recent and related residue-reporting fixes, spurious
ALSA audio underruns on jz4770 hardware are now fixed.

Signed-off-by: Daniel Silsby <dansilsby@gmail.com>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Tested-by: Mathieu Malaterre <malat@debian.org>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dma-jz4780.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dma-jz4780.c b/drivers/dma/dma-jz4780.c
index 803cfb4523b08..aca2d6fd92d56 100644
--- a/drivers/dma/dma-jz4780.c
+++ b/drivers/dma/dma-jz4780.c
@@ -580,7 +580,7 @@ static enum dma_status jz4780_dma_tx_status(struct dma_chan *chan,
 					to_jz4780_dma_desc(vdesc), 0);
 	} else if (cookie == jzchan->desc->vdesc.tx.cookie) {
 		txstate->residue = jz4780_dma_desc_residue(jzchan, jzchan->desc,
-			  (jzchan->curr_hwdesc + 1) % jzchan->desc->count);
+					jzchan->curr_hwdesc + 1);
 	} else
 		txstate->residue = 0;
 
-- 
2.20.1

