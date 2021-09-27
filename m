Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2288B419B7D
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236292AbhI0RTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:19:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236657AbhI0RRc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:17:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE06C61262;
        Mon, 27 Sep 2021 17:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762712;
        bh=yCOytb4p6EJdWyPLzgmAVZur+tgZdKI/qDaNrYIzcqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=reZoMTaLmMYNpZhQVTVOPwbTy3L9u0zaXjcTJCvdaJT/hdRrEuO6r7yKhtQCHDuNg
         ydJllLG1y1K4zYzdap8nv0ka2vd7tuUpQViD9Gti+c8NF6imxv+sGoU0GQ5LHeRepN
         JEu7FsXH4EW6RIp3+EWsJcQim5fLM1HvUi5TXRuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH 5.14 008/162] usb: dwc2: gadget: Fix ISOC transfer complete handling for DDMA
Date:   Mon, 27 Sep 2021 19:00:54 +0200
Message-Id: <20210927170233.741414401@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>

commit dbe2518b2d8eabffa74dbf7d9fdd7dacddab7fc0 upstream.

When last descriptor in a descriptor list completed with XferComplete
interrupt, core switching to handle next descriptor and assert BNA
interrupt. Both these interrupts are set while dwc2_hsotg_epint()
handler called. Each interrupt should be handled separately: first
XferComplete interrupt then BNA interrupt, otherwise last completed
transfer will not be giveback to function driver as completed
request.

Fixes: 729cac693eec ("usb: dwc2: Change ISOC DDMA flow")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Link: https://lore.kernel.org/r/a36981accc26cd674c5d8f8da6164344b94ec1fe.1631386531.git.Minas.Harutyunyan@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/gadget.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -3066,9 +3066,7 @@ static void dwc2_hsotg_epint(struct dwc2
 
 		/* In DDMA handle isochronous requests separately */
 		if (using_desc_dma(hsotg) && hs_ep->isochronous) {
-			/* XferCompl set along with BNA */
-			if (!(ints & DXEPINT_BNAINTR))
-				dwc2_gadget_complete_isoc_request_ddma(hs_ep);
+			dwc2_gadget_complete_isoc_request_ddma(hs_ep);
 		} else if (dir_in) {
 			/*
 			 * We get OutDone from the FIFO, so we only


