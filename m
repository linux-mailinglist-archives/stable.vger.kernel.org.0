Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C8D247529
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392308AbgHQTTz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:19:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730525AbgHQPhF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:37:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAEAA23123;
        Mon, 17 Aug 2020 15:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678624;
        bh=6koyF1NfnaLb45FSujL5ROUMUf95tKOeWT7QZ7MH0kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wLZxGnbIgzNrCkvxzA13hW/TQza2FjOf5I8ouB+YoMuw6GqeHkD5danxzZ1NIPOj7
         bJiVs9ewO379KkYTCe43oFPnpnMzpbktS53fqh9e8XiAF3fQ7PToVAohaR1uRysc6o
         Aq8WAf+4p2rc1EM9QomApywIF2UwIE4LTltrGY9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.8 399/464] usb: cdns3: gadget: always zeroed TRB buffer when enable endpoint
Date:   Mon, 17 Aug 2020 17:15:52 +0200
Message-Id: <20200817143852.897871187@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

commit 95f5acfc4f58f01a22b66d8c9c0ffb72aa96271c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/cdns3/gadget.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -242,9 +242,10 @@ int cdns3_allocate_trb_pool(struct cdns3
 			return -ENOMEM;
 
 		priv_ep->alloc_ring_size = ring_size;
-		memset(priv_ep->trb_pool, 0, ring_size);
 	}
 
+	memset(priv_ep->trb_pool, 0, ring_size);
+
 	priv_ep->num_trbs = num_trbs;
 
 	if (!priv_ep->num)


