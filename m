Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94DB7688F48
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 07:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjBCGBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 01:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjBCGBm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 01:01:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FCD6FD08
        for <stable@vger.kernel.org>; Thu,  2 Feb 2023 22:01:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 881F1B828B3
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 06:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F74C433EF;
        Fri,  3 Feb 2023 06:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675404098;
        bh=mps9uBIAYeLKsSCABGlAhRdanjgE6rmjv/X9OmJwqHs=;
        h=Subject:To:From:Date:From;
        b=t1NQ3rKhX0mPW7ODiNSaJ0JH7Y0xNN2wqN5tPkzcH6tsy2qdlBIbi6mJ16OgjWuqQ
         7kK7P5LbLmG1fFqTF4lXzLo21nd/rGVOXVZHicop5jztL7tejZBWKD0T7o9AbRK6P5
         SmGajt+o59cmrF8qRc4prd9T2qNcmcc/LuwnxzQ8=
Subject: patch "bus: mhi: ep: Move chan->lock to the start of processing queued ch" added to char-misc-next
To:     manivannan.sadhasivam@linaro.org, quic_jhugo@quicinc.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 Feb 2023 07:01:20 +0100
Message-ID: <16754040804111@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    bus: mhi: ep: Move chan->lock to the start of processing queued ch

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 8d6a1fea53864cd9545741f48f4ae4df804db557 Mon Sep 17 00:00:00 2001
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Date: Wed, 28 Dec 2022 21:47:03 +0530
Subject: bus: mhi: ep: Move chan->lock to the start of processing queued ch
 ring

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
---
 drivers/bus/mhi/ep/main.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/mhi/ep/main.c b/drivers/bus/mhi/ep/main.c
index 0bce6610ebf1..2362fcc8b32c 100644
--- a/drivers/bus/mhi/ep/main.c
+++ b/drivers/bus/mhi/ep/main.c
@@ -730,24 +730,37 @@ static void mhi_ep_ch_ring_worker(struct work_struct *work)
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
-- 
2.39.1


