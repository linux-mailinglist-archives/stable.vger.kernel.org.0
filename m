Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7821FE49F
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731714AbgFRCTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:19:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729371AbgFRBTJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:19:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EBE021D79;
        Thu, 18 Jun 2020 01:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443148;
        bh=7j13jfJAS5TmqGJhiUKQwtVBulobDufXNR5FSmvh8BY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4qqGlxhQC0b9nXAq7lNvz1VkNirp8mKrLDX4mXSlOidfcIM8DygmT3iX7lFtTOrl
         v4AgxDuW2QuX6CEP1FKz7+YElzRovKXuQisM6BqogB2qTI1OZJJu7TpyOZ2qSyYOON
         FZ7Q9jFMjuIixPAhii1CL30KyONubJ44KKTLM6fI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 117/266] usb: dwc3: gadget: Properly handle failed kick_transfer
Date:   Wed, 17 Jun 2020 21:14:02 -0400
Message-Id: <20200618011631.604574-117-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit 8d99087c2db863c5fa3a4a1f3cb82b3a493705ca ]

If dwc3 fails to issue START_TRANSFER/UPDATE_TRANSFER command, then we
should properly end an active transfer and give back all the started
requests. However if it's for an isoc endpoint, the failure maybe due to
bus-expiry status. In this case, don't give back the requests and wait
for the next retry.

Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 05180a09e70d..17340864a540 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1217,6 +1217,8 @@ static void dwc3_prepare_trbs(struct dwc3_ep *dep)
 	}
 }
 
+static void dwc3_gadget_ep_cleanup_cancelled_requests(struct dwc3_ep *dep);
+
 static int __dwc3_gadget_kick_transfer(struct dwc3_ep *dep)
 {
 	struct dwc3_gadget_ep_cmd_params params;
@@ -1256,14 +1258,20 @@ static int __dwc3_gadget_kick_transfer(struct dwc3_ep *dep)
 
 	ret = dwc3_send_gadget_ep_cmd(dep, cmd, &params);
 	if (ret < 0) {
-		/*
-		 * FIXME we need to iterate over the list of requests
-		 * here and stop, unmap, free and del each of the linked
-		 * requests instead of what we do now.
-		 */
-		if (req->trb)
-			memset(req->trb, 0, sizeof(struct dwc3_trb));
-		dwc3_gadget_del_and_unmap_request(dep, req, ret);
+		struct dwc3_request *tmp;
+
+		if (ret == -EAGAIN)
+			return ret;
+
+		dwc3_stop_active_transfer(dep, true, true);
+
+		list_for_each_entry_safe(req, tmp, &dep->started_list, list)
+			dwc3_gadget_move_cancelled_request(req);
+
+		/* If ep isn't started, then there's no end transfer pending */
+		if (!(dep->flags & DWC3_EP_END_TRANSFER_PENDING))
+			dwc3_gadget_ep_cleanup_cancelled_requests(dep);
+
 		return ret;
 	}
 
-- 
2.25.1

