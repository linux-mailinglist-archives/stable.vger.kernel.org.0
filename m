Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F48151A802
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355453AbiEDRHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355741AbiEDREl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:04:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427404F9C0;
        Wed,  4 May 2022 09:53:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEEAFB8278E;
        Wed,  4 May 2022 16:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98893C385A5;
        Wed,  4 May 2022 16:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683197;
        bh=hmbtWVfyriMLSNG2cgnHPr6zR2rssfLG2hmu6gUSMOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pBTbZ71sdOk68ImgMCHiNWWhOLnMmX/Rkdp//H6//Z2Bp9PVLG/NmLu+Wlz0h8Ppr
         7a4efWp15F/HL4J9nMcDGRYmW3CBxsX0fIVFF+Xfi06Pq69viEk+pDjfe/oxBEjUKd
         /fr7+0w1xqz/KxRRnNIJe5EvhjKf3nD0W8cqkRGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@kernel.org>,
        Weitao Wang <WeitaoWang-oc@zhaoxin.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/177] USB: Fix xhci event ring dequeue pointer ERDP update issue
Date:   Wed,  4 May 2022 18:44:07 +0200
Message-Id: <20220504153057.854422954@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weitao Wang <WeitaoWang-oc@zhaoxin.com>

[ Upstream commit e91ac20889d1a26d077cc511365cd7ff4346a6f3 ]

In some situations software handles TRB events slower than adding TRBs.
If the number of TRB events to be processed in a given interrupt is exactly
the same as the event ring size 256, then the local variable
"event_ring_deq" that holds the initial dequeue position is equal to
software_dequeue after handling all 256 interrupts.

It will cause driver to not update ERDP to hardware,

Software dequeue pointer is out of sync with ERDP on interrupt exit.
On the next interrupt, the event ring may full but driver will not
update ERDP as software_dequeue is equal to ERDP.

[  536.377115] xhci_hcd 0000:00:12.0: ERROR unknown event type 37
[  566.933173] sd 8:0:0:0: [sdb] tag#27 uas_eh_abort_handler 0 uas-tag 7 inflight: CMD OUT
[  566.933181] sd 8:0:0:0: [sdb] tag#27 CDB: Write(10) 2a 00 17 71 e6 78 00 00 08 00
[  572.041186] xhci_hcd On some situataions,the0000:00:12.0: xHCI host not responding to stop endpoint command.
[  572.057193] xhci_hcd 0000:00:12.0: Host halt failed, -110
[  572.057196] xhci_hcd 0000:00:12.0: xHCI host controller not responding, assume dead
[  572.057236] sd 8:0:0:0: [sdb] tag#26 uas_eh_abort_handler 0 uas-tag 6 inflight: CMD
[  572.057240] sd 8:0:0:0: [sdb] tag#26 CDB: Write(10) 2a 00 38 eb cc d8 00 00 08 00
[  572.057244] sd 8:0:0:0: [sdb] tag#25 uas_eh_abort_handler 0 uas-tag 5 inflight: CMD

Hardware ERDP is updated mid event handling if there are more than 128
events in an interrupt (half of ring size).
Fix this by updating the software local variable at the same time as
hardware ERDP.

[commit message rewording -Mathias]

Fixes: dc0ffbea5729 ("usb: host: xhci: update event ring dequeue pointer on purpose")
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Weitao Wang <WeitaoWang-oc@zhaoxin.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20220408134823.2527272-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index d0b6806275e0..f9707997969d 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3141,6 +3141,7 @@ irqreturn_t xhci_irq(struct usb_hcd *hcd)
 		if (event_loop++ < TRBS_PER_SEGMENT / 2)
 			continue;
 		xhci_update_erst_dequeue(xhci, event_ring_deq);
+		event_ring_deq = xhci->event_ring->dequeue;
 
 		/* ring is half-full, force isoc trbs to interrupt more often */
 		if (xhci->isoc_bei_interval > AVOID_BEI_INTERVAL_MIN)
-- 
2.35.1



