Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3AA3783E3
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbhEJKr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:47:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233331AbhEJKpi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:45:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8606C619A1;
        Mon, 10 May 2021 10:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642966;
        bh=yFRxryqeJbgnPjATn1vS0LuRKrYh/hsd3oCMnWC80p4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jQIIZwfLgpjNHur6AV3gSoXCwiUVXFS5WnI99I8miF1IVLohplnrqX9gTewzprlfm
         sqztkEjAK4xrPuj53qSoxttGFswA2siK0bJ2+DEwlWfRqy7RNnxC49KaolTuNEM3Zj
         gWi5VLp6EasIiaTVg5qVFFXtcvCw2WyxxX6K57vI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Hemant Kumar <hemantk@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 088/299] bus: mhi: core: Clear context for stopped channels from remove()
Date:   Mon, 10 May 2021 12:18:05 +0200
Message-Id: <20210510102007.861213920@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bhaumik Bhatt <bbhatt@codeaurora.org>

[ Upstream commit 4e44ae3d6d9c2c2a6d9356dd279c925532d5cd8c ]

If a channel was explicitly stopped but not reset and a driver
remove is issued, clean up the channel context such that it is
reflected on the device. This move is useful if a client driver
module is unloaded or a device crash occurs with the host having
placed the channel in a stopped state.

Signed-off-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/1617311778-1254-3-git-send-email-bbhatt@codeaurora.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/core/init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/mhi/core/init.c b/drivers/bus/mhi/core/init.c
index 3422ea133deb..0d0386f67ffe 100644
--- a/drivers/bus/mhi/core/init.c
+++ b/drivers/bus/mhi/core/init.c
@@ -1280,7 +1280,8 @@ static int mhi_driver_remove(struct device *dev)
 
 		mutex_lock(&mhi_chan->mutex);
 
-		if (ch_state[dir] == MHI_CH_STATE_ENABLED &&
+		if ((ch_state[dir] == MHI_CH_STATE_ENABLED ||
+		     ch_state[dir] == MHI_CH_STATE_STOP) &&
 		    !mhi_chan->offload_ch)
 			mhi_deinit_chan_ctxt(mhi_cntrl, mhi_chan);
 
-- 
2.30.2



