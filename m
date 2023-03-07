Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279316AF2DC
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbjCGS5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbjCGS4s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:56:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8900B4F46
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:44:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40B0361522
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:44:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3766AC433EF;
        Tue,  7 Mar 2023 18:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214653;
        bh=+UFbwSapYubz/zOvph1T4DXXzplLGsq9iFOXSpN8Uzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=va9v/tyRLzcQnZG62iJm+naFtuZMwxKO33uOC5zix2EEasVHMSZFvqsYig3n3fNy0
         Cine+eJ0oH16hwbMnEf4TfIOCNCYt79g2D4DuONFlhiwBSU0MlsDn6tfkOm1GyzAMC
         2b+Go/ChoB+bvDF29mUCnijAmCbFEDxsNyfYlXCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Jeffrey Hugo <quic_jhugo@quicinc.com>
Subject: [PATCH 6.1 870/885] bus: mhi: ep: Move chan->lock to the start of processing queued ch ring
Date:   Tue,  7 Mar 2023 18:03:24 +0100
Message-Id: <20230307170039.580725746@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit 8d6a1fea53864cd9545741f48f4ae4df804db557 upstream.

There is a good chance that while the channel ring gets processed, the STOP
or RESET command for the channel might be received from the MHI host. In
those cases, the entire channel ring processing needs to be protected by
chan->lock to prevent the race where the corresponding channel ring might
be reset.

While at it, let's also add a sanity check to make sure that the ring is
started before processing it. Because, if the STOP/RESET command gets
processed while mhi_ep_ch_ring_worker() waited for chan->lock, the ring
would've been reset.

Cc: <stable@vger.kernel.org> # 5.19
Fixes: 03c0bb8ec983 ("bus: mhi: ep: Add support for processing channel rings")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://lore.kernel.org/r/20221228161704.255268-6-manivannan.sadhasivam@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/ep/main.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/bus/mhi/ep/main.c
+++ b/drivers/bus/mhi/ep/main.c
@@ -723,24 +723,37 @@ static void mhi_ep_ch_ring_worker(struct
 		list_del(&itr->node);
 		ring = itr->ring;
 
+		chan = &mhi_cntrl->mhi_chan[ring->ch_id];
+		mutex_lock(&chan->lock);
+
+		/*
+		 * The ring could've stopped while we waited to grab the (chan->lock), so do
+		 * a sanity check before going further.
+		 */
+		if (!ring->started) {
+			mutex_unlock(&chan->lock);
+			kfree(itr);
+			continue;
+		}
+
 		/* Update the write offset for the ring */
 		ret = mhi_ep_update_wr_offset(ring);
 		if (ret) {
 			dev_err(dev, "Error updating write offset for ring\n");
+			mutex_unlock(&chan->lock);
 			kfree(itr);
 			continue;
 		}
 
 		/* Sanity check to make sure there are elements in the ring */
 		if (ring->rd_offset == ring->wr_offset) {
+			mutex_unlock(&chan->lock);
 			kfree(itr);
 			continue;
 		}
 
 		el = &ring->ring_cache[ring->rd_offset];
-		chan = &mhi_cntrl->mhi_chan[ring->ch_id];
 
-		mutex_lock(&chan->lock);
 		dev_dbg(dev, "Processing the ring for channel (%u)\n", ring->ch_id);
 		ret = mhi_ep_process_ch_ring(ring, el);
 		if (ret) {


