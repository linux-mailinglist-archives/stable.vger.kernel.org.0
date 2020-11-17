Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E77B2B65F5
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 15:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730599AbgKQN7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:59:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730529AbgKQNRh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:17:37 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA716241A6;
        Tue, 17 Nov 2020 13:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619055;
        bh=vpDr7mDvKW61P+5qPdz8cH995125ReCzW3VrE1uhgjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O8n0D0qr8SQ/IC4MeDskOntTBC8EuOUn6IqaeS0km5R6gR+gm5wecSnpoF0C9izqM
         +t64pWywi+XaWgw8lohdxdx8qcFJfHbbuYeVBqGM58raxbtr6TwonGjUSmggPmixFD
         K6ZMqRJyCxVV8N1zYrw1RMo2jflrkvoST5feLQrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 005/101] usb: dwc3: gadget: Reclaim extra TRBs after request completion
Date:   Tue, 17 Nov 2020 14:04:32 +0100
Message-Id: <20201117122113.380944173@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit 690e5c2dc29f8891fcfd30da67e0d5837c2c9df5 ]

An SG request may be partially completed (due to no available TRBs).
Don't reclaim extra TRBs and clear the needs_extra_trb flag until the
request is fully completed. Otherwise, the driver will reclaim the wrong
TRB.

Cc: stable@vger.kernel.org
Fixes: 1f512119a08c ("usb: dwc3: gadget: add remaining sg entries to ring")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index f24cfb3a6907b..6ab5c48f5d873 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2386,6 +2386,11 @@ static int dwc3_gadget_ep_cleanup_completed_request(struct dwc3_ep *dep,
 		ret = dwc3_gadget_ep_reclaim_trb_linear(dep, req, event,
 				status);
 
+	req->request.actual = req->request.length - req->remaining;
+
+	if (!dwc3_gadget_ep_request_completed(req))
+		goto out;
+
 	if (req->needs_extra_trb) {
 		unsigned int maxp = usb_endpoint_maxp(dep->endpoint.desc);
 
@@ -2401,11 +2406,6 @@ static int dwc3_gadget_ep_cleanup_completed_request(struct dwc3_ep *dep,
 		req->needs_extra_trb = false;
 	}
 
-	req->request.actual = req->request.length - req->remaining;
-
-	if (!dwc3_gadget_ep_request_completed(req))
-		goto out;
-
 	dwc3_gadget_giveback(dep, req, status);
 
 out:
-- 
2.27.0



