Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB804259940
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730865AbgIAQhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:37:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730530AbgIAP3Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:29:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28616207D3;
        Tue,  1 Sep 2020 15:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974164;
        bh=yqSDueq9STmAXT/pEDxa0GS6FpKoCSpu/A3VLu+EYgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=deOHwG54ML8B02R8ZV5NlrQu1FVYZeAvSRZJbjog/ipmMME456pyyIS5/MDRVGmuT
         b8C0kw2l/ZD/Zghn7rfvvoFHXNFRrEZX+rIRlkEj9if7UvfITuR8v6B3o2W0ZZc/mK
         98tarA1HdwB0EnPN7nImUlj/Nqqg59VZjmbxnNb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 070/214] usb: cdns3: gadget: always zeroed TRB buffer when enable endpoint
Date:   Tue,  1 Sep 2020 17:09:10 +0200
Message-Id: <20200901150956.328925074@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 95f5acfc4f58f01a22b66d8c9c0ffb72aa96271c ]

During the endpoint dequeue operation, it changes dequeued TRB as link
TRB, when the endpoint is disabled and re-enabled, the DMA fetches the
TRB before the link TRB, after it handles current TRB, the DMA pointer
will advance to the TRB after link TRB, but enqueue and dequene
variables don't know it due to no hardware interrupt at the time, when
the next TRB is added to link TRB position, the DMA will not handle
this TRB due to its pointer is already at the next TRB. See the trace
log like below:

file-storage-675   [001] d..1    86.585657: usb_ep_queue: ep0: req 00000000df9b3a4f length 0/0 sgs 0/0 stream 0 zsI status 0 --> 0
file-storage-675   [001] d..1    86.585663: cdns3_ep_queue: ep1out: req: 000000002ebce364, req buff 00000000f5bc96b4, length: 0/1024 zsi, status: -115, trb: [start:0, end:0: virt addr (null)], flags:0 SID: 0
file-storage-675   [001] d..1    86.585671: cdns3_prepare_trb: ep1out: trb 000000007f770303, dma buf: 0xbd195800, size: 1024, burst: 128 ctrl: 0x00000425 (C=1, T=0, ISP, IOC, Normal) SID:0 LAST_SID:0
file-storage-675   [001] d..1    86.585676: cdns3_ring:
            Ring contents for ep1out:
            Ring deq index: 0, trb: 000000007f770303 (virt), 0xc4003000 (dma)
            Ring enq index: 1, trb: 0000000049c1ba21 (virt), 0xc400300c (dma)
            free trbs: 38, CCS=1, PCS=1
            @0x00000000c4003000 bd195800 80020400 00000425
            @0x00000000c400300c c4003018 80020400 00001811
            @0x00000000c4003018 bcfcc000 0000001f 00000426
            @0x00000000c4003024 bcfce800 0000001f 00000426

	    ...

 irq/144-5b13000-698   [000] d...    87.619286: usb_gadget_giveback_request: ep1in: req 0000000031b832eb length 13/13 sgs 0/0 stream 0 zsI status 0 --> 0
    file-storage-675   [001] d..1    87.619287: cdns3_ep_queue: ep1out: req: 000000002ebce364, req buff 00000000f5bc96b4, length: 0/1024 zsi, status: -115, trb: [start:0, end:0: virt addr 0x80020400c400300c], flags:0 SID: 0
    file-storage-675   [001] d..1    87.619294: cdns3_prepare_trb: ep1out: trb 0000000049c1ba21, dma buf: 0xbd198000, size: 1024, burst: 128 ctrl: 0x00000425 (C=1, T=0, ISP, IOC, Normal) SID:0 LAST_SID:0
    file-storage-675   [001] d..1    87.619297: cdns3_ring:
                Ring contents for ep1out:
                Ring deq index: 1, trb: 0000000049c1ba21 (virt), 0xc400300c (dma)
                Ring enq index: 2, trb: 0000000059b34b67 (virt), 0xc4003018 (dma)
                free trbs: 38, CCS=1, PCS=1
                @0x00000000c4003000 bd195800 0000001f 00000427
                @0x00000000c400300c bd198000 80020400 00000425
                @0x00000000c4003018 bcfcc000 0000001f 00000426
                @0x00000000c4003024 bcfce800 0000001f 00000426
		...

    file-storage-675   [001] d..1    87.619305: cdns3_doorbell_epx: ep1out, ep_trbaddr c4003018
    file-storage-675   [001] ....    87.619308: usb_ep_queue: ep1out: req 000000002ebce364 length 0/1024 sgs 0/0 stream 0 zsI status -115 --> 0
 irq/144-5b13000-698   [000] d..1    87.619315: cdns3_epx_irq: IRQ for ep1out: 01000c80 TRBERR , ep_traddr: c4003018 ep_last_sid: 00000000 use_streams: 0
 irq/144-5b13000-698   [000] d..1    87.619395: cdns3_usb_irq: IRQ 00000008 = Hot Reset

Fixes: f616c3bda47e ("usb: cdns3: Fix dequeue implementation")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/gadget.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index 856c34010021b..9900888afbcd8 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -189,10 +189,10 @@ int cdns3_allocate_trb_pool(struct cdns3_endpoint *priv_ep)
 						       GFP_DMA32 | GFP_ATOMIC);
 		if (!priv_ep->trb_pool)
 			return -ENOMEM;
-	} else {
-		memset(priv_ep->trb_pool, 0, ring_size);
 	}
 
+	memset(priv_ep->trb_pool, 0, ring_size);
+
 	if (!priv_ep->num)
 		return 0;
 
-- 
2.25.1



