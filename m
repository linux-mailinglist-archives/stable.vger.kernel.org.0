Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 296AD1F349
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbfEOLFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:05:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727691AbfEOLFc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:05:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A28D821883;
        Wed, 15 May 2019 11:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918332;
        bh=02cBGOZiwwF5AKSu6sXomuTQyICypRgMIgPtnXx5JQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VONVFYA0bdUspibAQETIYfz91MAaiy/VOWH0Llp/ikke2dB4fMatJIVxCjcdqE6KA
         GmzhP3gsI7dzgOewvSlMg5yTrpDE7yYqMiMFVy4oARpXplu/p8JrbBXtSlnReAEDRI
         5hKZXlLsifIu3x2kB0daG5xrfG3WZOTFKyygt9/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Guido Kiener <guido.kiener@rohde-schwarz.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.4 093/266] usb: gadget: net2280: Fix net2280_dequeue()
Date:   Wed, 15 May 2019 12:53:20 +0200
Message-Id: <20190515090725.594594715@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f1d3fba17cd4eeea20397f1324b7b9c69a6a935c ]

When a request must be dequeued with net2280_dequeue() e.g. due
to a device clear action and the same request is finished by the
function scan_dma_completions() then the function net2280_dequeue()
does not find the request in the following search loop and
returns the error -EINVAL without restoring the status ep->stopped.
Thus the endpoint keeps blocked and does not receive any data
anymore.
This fix restores the status and does not issue an error message.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Guido Kiener <guido.kiener@rohde-schwarz.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/usb/gadget/udc/net2280.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/net2280.c
index fc94a09e2a5a..3a8d056a5d16 100644
--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -1270,9 +1270,9 @@ static int net2280_dequeue(struct usb_ep *_ep, struct usb_request *_req)
 			break;
 	}
 	if (&req->req != _req) {
+		ep->stopped = stopped;
 		spin_unlock_irqrestore(&ep->dev->lock, flags);
-		dev_err(&ep->dev->pdev->dev, "%s: Request mismatch\n",
-								__func__);
+		ep_dbg(ep->dev, "%s: Request mismatch\n", __func__);
 		return -EINVAL;
 	}
 
-- 
2.19.1



