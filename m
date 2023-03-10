Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496456B466D
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbjCJOnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:43:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232824AbjCJOmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:42:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E344D11F633
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:42:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81E30B822E7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11D7C433D2;
        Fri, 10 Mar 2023 14:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459360;
        bh=cbWO7an7DylfP+mWKJycr3q9q9kP6l5spTuHFzL5k9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yv1h6nLNUoiE/ign6UOgbEOx5afY6xgd5l4Q3WPS1wd/8xvt/OpOqq4wrPdl1fjY3
         TtWGeCMHOemLE1j4HdBu/IGDrujUPTYMhQ3o+QhRsByeJjwWED8MWUJzO+ZUUuBe5W
         Wo4kyylBMbskFsdcFKmUYLZyzLU0H1Bl6EpG5WTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Simon Horman <horms@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 336/357] staging: emxx_udc: Add checks for dma_alloc_coherent()
Date:   Fri, 10 Mar 2023 14:40:25 +0100
Message-Id: <20230310133749.490106148@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit f6510a93cfd8c6c79b4dda0f2967cdc6df42eff4 ]

As the dma_alloc_coherent may return NULL, the return value needs to be
checked to avoid NULL poineter dereference.

Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Simon Horman <horms@verge.net.au>
Link: https://lore.kernel.org/r/20230119083119.16956-1-yuancan@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/emxx_udc/emxx_udc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/emxx_udc/emxx_udc.c b/drivers/staging/emxx_udc/emxx_udc.c
index cc4c18c3fb36d..7d18ad68be264 100644
--- a/drivers/staging/emxx_udc/emxx_udc.c
+++ b/drivers/staging/emxx_udc/emxx_udc.c
@@ -2593,10 +2593,15 @@ static int nbu2ss_ep_queue(struct usb_ep *_ep,
 		req->unaligned = false;
 
 	if (req->unaligned) {
-		if (!ep->virt_buf)
+		if (!ep->virt_buf) {
 			ep->virt_buf = dma_alloc_coherent(udc->dev, PAGE_SIZE,
 							  &ep->phys_buf,
 							  GFP_ATOMIC | GFP_DMA);
+			if (!ep->virt_buf) {
+				spin_unlock_irqrestore(&udc->lock, flags);
+				return -ENOMEM;
+			}
+		}
 		if (ep->epnum > 0)  {
 			if (ep->direct == USB_DIR_IN)
 				memcpy(ep->virt_buf, req->req.buf,
-- 
2.39.2



