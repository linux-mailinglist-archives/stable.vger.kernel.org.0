Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97312B65F8
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 15:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730471AbgKQN7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:59:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:49804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727468AbgKQNRc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:17:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDF12241A5;
        Tue, 17 Nov 2020 13:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619052;
        bh=dUvVRT7auAIFZotC3SYyNClJ93YgJxBW+SjL399KPQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dlV5Dxm5XzfLkNCvRPYSP+gTIn20g0Ge1HLpOsoprIcnn2tWwE80bnCXJKC00BE7t
         miY55XFypBCvOF8XKW+NqaUcueQRLduNu1O1vT+PlJnCmhGRHQRGhL131aXShxCRWV
         UVT+wT1o6SX7pAx2M2dXCTYIZPUNxvhEEHAw9pPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 004/101] usb: dwc3: gadget: Continue to process pending requests
Date:   Tue, 17 Nov 2020 14:04:31 +0100
Message-Id: <20201117122113.333051472@linuxfoundation.org>
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

[ Upstream commit d9feef974e0d8cb6842533c92476a1b32a41ba31 ]

If there are still pending requests because no TRB was available,
prepare more when started requests are completed.

Introduce dwc3_gadget_ep_should_continue() to check for incomplete and
pending requests to resume updating new TRBs to the controller's TRB
cache.

Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index f0d2f0a4e9908..f24cfb3a6907b 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2403,10 +2403,8 @@ static int dwc3_gadget_ep_cleanup_completed_request(struct dwc3_ep *dep,
 
 	req->request.actual = req->request.length - req->remaining;
 
-	if (!dwc3_gadget_ep_request_completed(req)) {
-		__dwc3_gadget_kick_transfer(dep);
+	if (!dwc3_gadget_ep_request_completed(req))
 		goto out;
-	}
 
 	dwc3_gadget_giveback(dep, req, status);
 
@@ -2430,6 +2428,24 @@ static void dwc3_gadget_ep_cleanup_completed_requests(struct dwc3_ep *dep,
 	}
 }
 
+static bool dwc3_gadget_ep_should_continue(struct dwc3_ep *dep)
+{
+	struct dwc3_request	*req;
+
+	if (!list_empty(&dep->pending_list))
+		return true;
+
+	/*
+	 * We only need to check the first entry of the started list. We can
+	 * assume the completed requests are removed from the started list.
+	 */
+	req = next_request(&dep->started_list);
+	if (!req)
+		return false;
+
+	return !dwc3_gadget_ep_request_completed(req);
+}
+
 static void dwc3_gadget_endpoint_frame_from_event(struct dwc3_ep *dep,
 		const struct dwc3_event_depevt *event)
 {
@@ -2459,6 +2475,8 @@ static void dwc3_gadget_endpoint_transfer_in_progress(struct dwc3_ep *dep,
 
 	if (stop)
 		dwc3_stop_active_transfer(dep, true, true);
+	else if (dwc3_gadget_ep_should_continue(dep))
+		__dwc3_gadget_kick_transfer(dep);
 
 	/*
 	 * WORKAROUND: This is the 2nd half of U1/U2 -> U0 workaround.
-- 
2.27.0



