Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEAD215F42E
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389585AbgBNSTP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:19:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:54774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730518AbgBNPue (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:50:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA69024688;
        Fri, 14 Feb 2020 15:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695433;
        bh=zbK5P6bE+5w9JpZDIVeW4d4YCT86HCfVE6Z0vyzn7KM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R+QX5IosFj6JEcMveVs/fm32I/rxTvJ7WF0MSIVcrQdzZnG6euQCiNAksdX8plWKZ
         ymaqzHkSlw8RFep0yrDWKvhy7idTstes6Ls2v1+YVD4Amhx26uBcIUuXh8ittqynBy
         dLNIk9FkEYgFJFpCvCL1i7NMHYbuVfmTXkfas8wY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Keeping <john@metanate.com>,
        Minas Harutyunyan <hminas@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 076/542] usb: dwc2: Fix IN FIFO allocation
Date:   Fri, 14 Feb 2020 10:41:08 -0500
Message-Id: <20200214154854.6746-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Keeping <john@metanate.com>

[ Upstream commit 644139f8b64d818f6345351455f14471510879a5 ]

On chips with fewer FIFOs than endpoints (for example RK3288 which has 9
endpoints, but only 6 which are cabable of input), the DPTXFSIZN
registers above the FIFO count may return invalid values.

With logging added on startup, I see:

	dwc2 ff580000.usb: dwc2_hsotg_init_fifo: ep=1 sz=256
	dwc2 ff580000.usb: dwc2_hsotg_init_fifo: ep=2 sz=128
	dwc2 ff580000.usb: dwc2_hsotg_init_fifo: ep=3 sz=128
	dwc2 ff580000.usb: dwc2_hsotg_init_fifo: ep=4 sz=64
	dwc2 ff580000.usb: dwc2_hsotg_init_fifo: ep=5 sz=64
	dwc2 ff580000.usb: dwc2_hsotg_init_fifo: ep=6 sz=32
	dwc2 ff580000.usb: dwc2_hsotg_init_fifo: ep=7 sz=0
	dwc2 ff580000.usb: dwc2_hsotg_init_fifo: ep=8 sz=0
	dwc2 ff580000.usb: dwc2_hsotg_init_fifo: ep=9 sz=0
	dwc2 ff580000.usb: dwc2_hsotg_init_fifo: ep=10 sz=0
	dwc2 ff580000.usb: dwc2_hsotg_init_fifo: ep=11 sz=0
	dwc2 ff580000.usb: dwc2_hsotg_init_fifo: ep=12 sz=0
	dwc2 ff580000.usb: dwc2_hsotg_init_fifo: ep=13 sz=0
	dwc2 ff580000.usb: dwc2_hsotg_init_fifo: ep=14 sz=0
	dwc2 ff580000.usb: dwc2_hsotg_init_fifo: ep=15 sz=0

but:

	# cat /sys/kernel/debug/ff580000.usb/fifo
	Non-periodic FIFOs:
	RXFIFO: Size 275
	NPTXFIFO: Size 16, Start 0x00000113

	Periodic TXFIFOs:
		DPTXFIFO 1: Size 256, Start 0x00000123
		DPTXFIFO 2: Size 128, Start 0x00000223
		DPTXFIFO 3: Size 128, Start 0x000002a3
		DPTXFIFO 4: Size 64, Start 0x00000323
		DPTXFIFO 5: Size 64, Start 0x00000363
		DPTXFIFO 6: Size 32, Start 0x000003a3
		DPTXFIFO 7: Size 0, Start 0x000003e3
		DPTXFIFO 8: Size 0, Start 0x000003a3
		DPTXFIFO 9: Size 256, Start 0x00000123

so it seems that FIFO 9 is mirroring FIFO 1.

Fix the allocation by using the FIFO count instead of the endpoint count
when selecting a FIFO for an endpoint.

Acked-by: Minas Harutyunyan <hminas@synopsys.com>
Signed-off-by: John Keeping <john@metanate.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/gadget.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 6be10e496e105..a9133773b89e4 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -4056,11 +4056,12 @@ static int dwc2_hsotg_ep_enable(struct usb_ep *ep,
 	 * a unique tx-fifo even if it is non-periodic.
 	 */
 	if (dir_in && hsotg->dedicated_fifos) {
+		unsigned fifo_count = dwc2_hsotg_tx_fifo_count(hsotg);
 		u32 fifo_index = 0;
 		u32 fifo_size = UINT_MAX;
 
 		size = hs_ep->ep.maxpacket * hs_ep->mc;
-		for (i = 1; i < hsotg->num_of_eps; ++i) {
+		for (i = 1; i <= fifo_count; ++i) {
 			if (hsotg->fifo_map & (1 << i))
 				continue;
 			val = dwc2_readl(hsotg, DPTXFSIZN(i));
-- 
2.20.1

