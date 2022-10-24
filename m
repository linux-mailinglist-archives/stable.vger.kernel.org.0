Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 829B260A61E
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbiJXMcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234393AbiJXMaM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:30:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837B53C8FA;
        Mon, 24 Oct 2022 05:04:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44E7CB811B2;
        Mon, 24 Oct 2022 11:51:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A643C433C1;
        Mon, 24 Oct 2022 11:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612303;
        bh=7BCEeXtMurlzH+XH4KqgBzBeshKByJRUGnyql6ZfYFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pux5b9MFpXDh8sdNarUl8RnThUQHfRzTMnPhchsATAhzV+cSJPJitmbxgyjwoB5vV
         Brp2gu1+ZZlUcrlPmdpT6iomLZB1GFxRofuJvn/jtps3CU3z95gPatNL7rHsebG23r
         YMZVWTcpzGaKtsmFjtf7Nn/OdSY2aAOXKRhXv8dQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 147/210] dmaengine: ioat: stop mod_timer from resurrecting deleted timer in __cleanup()
Date:   Mon, 24 Oct 2022 13:31:04 +0200
Message-Id: <20221024113001.743869123@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 898ec89dbb55b8294695ad71694a0684e62b2a73 ]

User reports observing timer event report channel halted but no error
observed in CHANERR register. The driver finished self-test and released
channel resources. Debug shows that __cleanup() can call
mod_timer() after the timer has been deleted and thus resurrect the
timer. While harmless, it causes suprious error message to be emitted.
Use mod_timer_pending() call to prevent deleted timer from being
resurrected.

Fixes: 3372de5813e4 ("dmaengine: ioatdma: removal of dma_v3.c and relevant ioat3 references")
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/166360672197.3851724.17040290563764838369.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ioat/dma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 4c2b41beaf63..6f167a082832 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -654,7 +654,7 @@ static void __cleanup(struct ioatdma_chan *ioat_chan, dma_addr_t phys_complete)
 	if (active - i == 0) {
 		dev_dbg(to_dev(ioat_chan), "%s: cancel completion timeout\n",
 			__func__);
-		mod_timer(&ioat_chan->timer, jiffies + IDLE_TIMEOUT);
+		mod_timer_pending(&ioat_chan->timer, jiffies + IDLE_TIMEOUT);
 	}
 
 	/* microsecond delay by sysfs variable  per pending descriptor */
@@ -680,7 +680,7 @@ static void ioat_cleanup(struct ioatdma_chan *ioat_chan)
 
 		if (chanerr &
 		    (IOAT_CHANERR_HANDLE_MASK | IOAT_CHANERR_RECOVER_MASK)) {
-			mod_timer(&ioat_chan->timer, jiffies + IDLE_TIMEOUT);
+			mod_timer_pending(&ioat_chan->timer, jiffies + IDLE_TIMEOUT);
 			ioat_eh(ioat_chan);
 		}
 	}
@@ -872,7 +872,7 @@ static void check_active(struct ioatdma_chan *ioat_chan)
 	}
 
 	if (test_and_clear_bit(IOAT_CHAN_ACTIVE, &ioat_chan->state))
-		mod_timer(&ioat_chan->timer, jiffies + IDLE_TIMEOUT);
+		mod_timer_pending(&ioat_chan->timer, jiffies + IDLE_TIMEOUT);
 }
 
 void ioat_timer_event(unsigned long data)
-- 
2.35.1



