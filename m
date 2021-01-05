Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B092EA42A
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 04:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbhAED7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 22:59:01 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:35830 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726329AbhAED7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 22:59:01 -0500
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 62788C008F;
        Tue,  5 Jan 2021 03:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1609819080; bh=y36rUfDcn2jJqBvU+A+QisrkAsBjXRxiZgDHMaVSBjs=;
        h=Date:From:Subject:To:Cc:From;
        b=VWFrz/F1Ub1c2rnhP27eB9btx38w4EjSbcCMK+lJuTC/MHt6F5Ih0AJ4PnR8llXDu
         tRXJAetoS4tdPhkmE/O2YP1IK2tN2DkjYPqFU1uH2GRV03FChXnE3xK44dF3g7Wp+P
         gf83GwZq+pRAHgjUTdnrz38cxtbntTKJtGZwV2znBbfICmhvY+V0VTe29R0KjaJBqW
         rYGcCxAUUkQsG+nZY4qyCZOOW7IAbz4NHFLhN3mkb6FRMW4DLRn/7SQaXGPc8M3CEJ
         Qv9WhJNPGQa6gg73tb13HylsS+AZk0PAibwO/+7+YxLjTenLk+CPOFtwBl9HK99uew
         efr9T+++F+Hfg==
Received: from te-lab16 (unknown [10.10.52.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id BB1B6A0068;
        Tue,  5 Jan 2021 03:57:58 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Mon, 04 Jan 2021 19:57:58 -0800
Date:   Mon, 04 Jan 2021 19:57:58 -0800
Message-Id: <862c03c986a365ba3ba7f1dfc9b812cef386a36d.1609818994.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH] usb: dwc3: gadget: Clear wait flag on dequeue
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If a transfer is dequeued, then the endpoint is freed to start a new
transfer. Make sure to clear the endpoint's transfer wait flag if
dequeued.

Cc: stable@vger.kernel.org
Fixes: e0d19563eb6c ("usb: dwc3: gadget: Wait for transfer completion")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/dwc3/gadget.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 78cb4db8a6e4..9eaeb3c5d06c 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1771,6 +1771,7 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
 		request, ep->name);
 	ret = -EINVAL;
 out:
+	dep->flags &= ~DWC3_EP_WAIT_TRANSFER_COMPLETE;
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	return ret;

base-commit: 5c8fe583cce542aa0b84adc939ce85293de36e5e
-- 
2.28.0

