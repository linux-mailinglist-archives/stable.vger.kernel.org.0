Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFA13290AC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242805AbhCAUM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:12:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:37632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242556AbhCAUCz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:02:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5B7265202;
        Mon,  1 Mar 2021 17:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621439;
        bh=Lo9NVBj9GRscMtLKDPl2drY3eoab/S0YPLPy2iCWFsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pTTRPlIWhlezv2qxaTJHo45kZrDRiF1/wPGHTTs1PWt9DnnApXPkdVuh4EmC1uATE
         VT9AlHpTFwjUZehJmX3Xy/7+cNQG1LCGu+0nOK/lXICxgmcRpb8aiZi5k5TncjOJp6
         0z6Tw9vuPGE3fqMuNKYKc/JeWpAZl9hx/o0vW1+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 516/775] mhi: Fix double dma free
Date:   Mon,  1 Mar 2021 17:11:24 +0100
Message-Id: <20210301161227.024924069@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

[ Upstream commit db4e8de1935b0202960e9ebb88ab93e8bd1e66b1 ]

mhi_deinit_chan_ctxt functionthat takes care of unitializing channel
resources, including unmapping coherent MHI areas, can be called
from different path in case of controller unregistering/removal:
 - From a client driver remove callback, via mhi_unprepare_channel
 - From mhi_driver_remove that unitialize all channels

mhi_driver_remove()
|-> driver->remove()
|    |-> mhi_unprepare_channel()
|        |-> mhi_deinit_chan_ctxt()
|...
|-> mhi_deinit_chan_ctxt()

This leads to double dma freeing...

Fix that by preventing deinit for already uninitialized channel.

Link: https://lore.kernel.org/r/1612894264-15956-1-git-send-email-loic.poulain@linaro.org
Fixes: a7f422f2f89e ("bus: mhi: Fix channel close issue on driver remove")
Reported-by: Kalle Valo <kvalo@codeaurora.org>
Tested-by: Kalle Valo <kvalo@codeaurora.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20210210082538.2494-2-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/core/init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bus/mhi/core/init.c b/drivers/bus/mhi/core/init.c
index f0697f433c2f1..08c45457c90fe 100644
--- a/drivers/bus/mhi/core/init.c
+++ b/drivers/bus/mhi/core/init.c
@@ -552,6 +552,9 @@ void mhi_deinit_chan_ctxt(struct mhi_controller *mhi_cntrl,
 	tre_ring = &mhi_chan->tre_ring;
 	chan_ctxt = &mhi_cntrl->mhi_ctxt->chan_ctxt[mhi_chan->chan];
 
+	if (!chan_ctxt->rbase) /* Already uninitialized */
+		return;
+
 	mhi_free_coherent(mhi_cntrl, tre_ring->alloc_size,
 			  tre_ring->pre_aligned, tre_ring->dma_handle);
 	vfree(buf_ring->base);
-- 
2.27.0



