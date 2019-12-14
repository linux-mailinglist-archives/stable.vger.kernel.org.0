Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8FB411F005
	for <lists+stable@lfdr.de>; Sat, 14 Dec 2019 03:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbfLNClF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 21:41:05 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:36692 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726422AbfLNClE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Dec 2019 21:41:04 -0500
Received: from mailhost.synopsys.com (sv2-mailhost1.synopsys.com [10.205.2.133])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 9FE00C0113;
        Sat, 14 Dec 2019 02:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576291263; bh=88Qy5g8mmejIuLc8nHzm6nl3V2zo5Tx0a3OJdwUXLN8=;
        h=Date:From:Subject:To:Cc:From;
        b=OMG9vw/goTmkHjbczZFR2F09sInteaQT4aKIJkDqVdrp+n6x3i40g8D4Js5qBRKZh
         zXgVEKBgSvJYxWk/ASWxUnj93L92D1ncnDTLZBd+I/9xhWJ2f8K8bVtZpWc1HxTtyr
         wH3LFzWzBX5Bvg81dEepRtLz+OPyAp/gzKpxjt6J9d08yZ4xUNNYkhrA+Tqi4B0xNz
         BuDju/bF6mnJO/Zj/6rHcLa7ErTbBfhVTwE8TtFKY/MRltcI84FZfI/C+aJ9REs9R6
         be3dhUhxiNBDxEd8Nb0o/5A4q99f7i2tA5gBXn1LRtJNv4JPNJEFY11iLXYSHDKw5j
         uI1vkU2dlto1A==
Received: from te-lab16 (nanobot.internal.synopsys.com [10.10.186.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 1159BA007C;
        Sat, 14 Dec 2019 02:40:45 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Fri, 13 Dec 2019 18:40:45 -0800
Date:   Fri, 13 Dec 2019 18:40:45 -0800
Message-Id: <ac5a3593a94fdaa3d92e6352356b5f7a01ccdc7c.1576291140.git.thinhn@synopsys.com>
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH] usb: dwc3: gadget: Fix request complete check
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

We can only check for IN direction if the request had completed. For OUT
direction, it's perfectly fine that the host can send less than the
setup length. Let's return true fall all cases of OUT direction.

Fixes: e0c42ce590fe ("usb: dwc3: gadget: simplify IOC handling")

Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
---
 drivers/usb/dwc3/gadget.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index b3f8514d1f27..edc478c20846 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2470,6 +2470,13 @@ static int dwc3_gadget_ep_reclaim_trb_linear(struct dwc3_ep *dep,
 
 static bool dwc3_gadget_ep_request_completed(struct dwc3_request *req)
 {
+	/*
+	 * For OUT direction, host may send less than the setup
+	 * length. Return true for all OUT requests.
+	 */
+	if (!req->direction)
+		return true;
+
 	return req->request.actual == req->request.length;
 }
 
-- 
2.11.0

