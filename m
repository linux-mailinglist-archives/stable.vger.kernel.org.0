Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B484E51A664
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345353AbiEDQzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353889AbiEDQwp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:52:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1A04757C;
        Wed,  4 May 2022 09:48:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 401F4B827A6;
        Wed,  4 May 2022 16:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B83C385B0;
        Wed,  4 May 2022 16:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682927;
        bh=dpdC6tHpuWhfBpAtkD90g7ap4SOW4WqlZ/hC5cmZH+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SMS/xmWbCcapFrey6djSMHUmgHw9pUZEC966dTA4cgrkQOkKQ9XxEjAZ6AvYK0QwC
         8E50u++2JOZsZ1730dBkwzRXJJbjICPrmVMt/tAV9qZKQqci2gtxsT+9k7URObDWpn
         wIgKFWYRiFbM4kg76SrkD6ogbkCDyu6teYuemjTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@kernel.org>,
        Weitao Wang <WeitaoWang-oc@zhaoxin.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 33/84] USB: Fix xhci event ring dequeue pointer ERDP update issue
Date:   Wed,  4 May 2022 18:44:14 +0200
Message-Id: <20220504152930.110168469@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
References: <20220504152927.744120418@linuxfoundation.org>
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
 drivers/usb/host/xhci-ring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 7fa27b403756..6cedae902adf 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2932,6 +2932,8 @@ irqreturn_t xhci_irq(struct usb_hcd *hcd)
 		if (event_loop++ < TRBS_PER_SEGMENT / 2)
 			continue;
 		xhci_update_erst_dequeue(xhci, event_ring_deq);
+		event_ring_deq = xhci->event_ring->dequeue;
+
 		event_loop = 0;
 	}
 
-- 
2.35.1



