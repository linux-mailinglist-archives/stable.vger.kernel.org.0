Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53D9D50891
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729525AbfFXKP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:15:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:53340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730401AbfFXKP4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:15:56 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1F5F205ED;
        Mon, 24 Jun 2019 10:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371355;
        bh=KDRwmMMXjnhIupyqcWSvt37oEaC6vmIw/bQxsrFBOvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=07hsR1K9WQcs83sQ+I37VIIzYhTuE5E4msJ4kudybZcQEdvodCysu/kXFRzfbzopn
         vT4/4HUosrMfSRWxbtFeI5V2qy28GI29i8SAUTwr65n4TFcmFIA/sg+q0Fjh7JOJ4c
         IizQ9pETGkLz0NqCO3Mx3/V4cZme4hUiQ9wHdak0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baolin Wang <baolin.wang@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 037/121] dmaengine: sprd: Add validation of current descriptor in irq handler
Date:   Mon, 24 Jun 2019 17:56:09 +0800
Message-Id: <20190624092322.707315593@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 58152b0e573e5581c4b9ef7cf06d2e9fafae27d4 ]

When user terminates one DMA channel to free all its descriptors, but
at the same time one transaction interrupt was triggered possibly, now
we should not handle this interrupt by validating if the 'schan->cur_desc'
was set as NULL to avoid crashing the kernel.

Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sprd-dma.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/sprd-dma.c b/drivers/dma/sprd-dma.c
index e29342ab85f6..431e289d59a5 100644
--- a/drivers/dma/sprd-dma.c
+++ b/drivers/dma/sprd-dma.c
@@ -552,12 +552,17 @@ static irqreturn_t dma_irq_handle(int irq, void *dev_id)
 		schan = &sdev->channels[i];
 
 		spin_lock(&schan->vc.lock);
+
+		sdesc = schan->cur_desc;
+		if (!sdesc) {
+			spin_unlock(&schan->vc.lock);
+			return IRQ_HANDLED;
+		}
+
 		int_type = sprd_dma_get_int_type(schan);
 		req_type = sprd_dma_get_req_type(schan);
 		sprd_dma_clear_int(schan);
 
-		sdesc = schan->cur_desc;
-
 		/* cyclic mode schedule callback */
 		cyclic = schan->linklist.phy_addr ? true : false;
 		if (cyclic == true) {
-- 
2.20.1



