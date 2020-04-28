Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE3C1BC9EE
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731308AbgD1Sn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:43:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731318AbgD1Snz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:43:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9818C20575;
        Tue, 28 Apr 2020 18:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099435;
        bh=ngkRcDgh2gXjSDeeX+GNSVS802t52ZmthJhMAK80nao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+wZDYDcEccR3oH+MT2FxJFiU1HbpM6rOq1y7aIwAhgJqEc+pvnCeB9qQOLX1IaQP
         Pdd0glUlwsjgSKF+U69PcquXVQ+6+DzSP7i/H7aOYyhrIwLDe+WAV6QdAxRbLkmbAp
         +T/+QJIzZJQCWXZuSXy3Hvc0nmTUj1xESb84onuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.4 150/168] usb: dwc3: gadget: Fix request completion check
Date:   Tue, 28 Apr 2020 20:25:24 +0200
Message-Id: <20200428182250.459995351@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 49e0590e3a60e75b493e5df879e216e5073c7663 upstream.

A request may not be completed because not all the TRBs are prepared for
it. This happens when we run out of available TRBs. When some TRBs are
completed, the driver needs to prepare the rest of the TRBs for the
request. The check dwc3_gadget_ep_request_completed() shouldn't be
checking the amount of data received but rather the number of pending
TRBs. Revise this request completion check.

Cc: stable@vger.kernel.org
Fixes: e0c42ce590fe ("usb: dwc3: gadget: simplify IOC handling")
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/gadget.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2481,14 +2481,7 @@ static int dwc3_gadget_ep_reclaim_trb_li
 
 static bool dwc3_gadget_ep_request_completed(struct dwc3_request *req)
 {
-	/*
-	 * For OUT direction, host may send less than the setup
-	 * length. Return true for all OUT requests.
-	 */
-	if (!req->direction)
-		return true;
-
-	return req->request.actual == req->request.length;
+	return req->num_pending_sgs == 0;
 }
 
 static int dwc3_gadget_ep_cleanup_completed_request(struct dwc3_ep *dep,
@@ -2512,8 +2505,7 @@ static int dwc3_gadget_ep_cleanup_comple
 
 	req->request.actual = req->request.length - req->remaining;
 
-	if (!dwc3_gadget_ep_request_completed(req) ||
-			req->num_pending_sgs) {
+	if (!dwc3_gadget_ep_request_completed(req)) {
 		__dwc3_gadget_kick_transfer(dep);
 		goto out;
 	}


