Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 772F5198EB7
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 10:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbgCaIki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 04:40:38 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:33328 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726488AbgCaIkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 04:40:37 -0400
Received: from mailhost.synopsys.com (sv2-mailhost1.synopsys.com [10.205.2.133])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 6C4B9C0F3C;
        Tue, 31 Mar 2020 08:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1585644037; bh=gqFs5GBRR0/mdABAZSL2Z2tRlGeg16ZQ4Vz+ShxUxBU=;
        h=Date:From:Subject:To:Cc:From;
        b=EEHetHTJ7DbxKhBsrhn8r8T7bT8QgJ7ZKZ7ZK4sF6ylHR0+ksk0gADmji86+Fd/eY
         /KVn5SRMs0ZN55uOsLA+ZbJsAVtuP3QcCOe752fL/umu8I5hCTiZ6JANi3+ctf3gG7
         bU7qpZE6ZyXuDrsnNCWygMwe7EYNp144X3vlwF/aFCj0/lxD9uUzysXWNDar3q0TZg
         QhArgDAon/l5BhgvE+V9meMhCrPjCQynYsW07XsU958FQp4y+D9Y9vWGwcitkU8SDr
         6VDBbkDHjTvPv5ZjsNMqtlbXeq55oyNZQ3+XdO+5MvXtvgZH7/96aBCAgD+jc6AFye
         3vHyOuunG5G0A==
Received: from te-lab16 (nanobot.internal.synopsys.com [10.10.186.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id C847EA007C;
        Tue, 31 Mar 2020 08:40:35 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Tue, 31 Mar 2020 01:40:35 -0700
Date:   Tue, 31 Mar 2020 01:40:35 -0700
Message-Id: <bed19f474892bb74be92b762c6727a6a7d0106e4.1585643834.git.thinhn@synopsys.com>
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH v2 1/2] usb: dwc3: gadget: Fix request completion check
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A request may not be completed because not all the TRBs are prepared for
it. This happens when we run out of available TRBs. When some TRBs are
completed, the driver needs to prepare the rest of the TRBs for the
request. The check dwc3_gadget_ep_request_completed() shouldn't be
checking the amount of data received but rather the number of pending
TRBs. Revise this request completion check.

Cc: stable@vger.kernel.org
Fixes: e0c42ce590fe ("usb: dwc3: gadget: simplify IOC handling")
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
---
Changes in v2:
 - Add Cc: stable tag

 drivers/usb/dwc3/gadget.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 1a4fc03742aa..c45853b14cff 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2550,14 +2550,7 @@ static int dwc3_gadget_ep_reclaim_trb_linear(struct dwc3_ep *dep,
 
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
@@ -2581,8 +2574,7 @@ static int dwc3_gadget_ep_cleanup_completed_request(struct dwc3_ep *dep,
 
 	req->request.actual = req->request.length - req->remaining;
 
-	if (!dwc3_gadget_ep_request_completed(req) ||
-			req->num_pending_sgs) {
+	if (!dwc3_gadget_ep_request_completed(req)) {
 		__dwc3_gadget_kick_transfer(dep);
 		goto out;
 	}
-- 
2.11.0

