Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B14B276BC8
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 10:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbgIXI0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 04:26:34 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:40546 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727172AbgIXI0b (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Sep 2020 04:26:31 -0400
Received: from mailhost.synopsys.com (sv2-mailhost1.synopsys.com [10.205.2.133])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8F8DC402EF;
        Thu, 24 Sep 2020 08:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1600935685; bh=bpZOcgnHxr2qnnoKk0alXeL6UkN9hAC8Nf65rvQ7bQU=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=bF1SZmB35vHaQjR6yUV7hgQ9o1glc3W4ld1XiU9tbJSGOFXkF4FL7u1ZWeVzHC+Cf
         ebHbnAUiziY4i7/TXBD6vVteq0utAh9kFhC/nAmkUCWa/6EiFljn+NcRGQdfSD3W3d
         l7V+DdsyATfBDReKKNasmBC7mOMUrAdWWaTyOCqenXDyboUPyZuCoIubYMH+8ji28n
         Bv9WPKFNczv9ItxBMdFbrayRHgDGeMbvFdf8fAKARuTzfXPY88wyHeRtjd9NuhHV+J
         4zRiWdmCgFBjzi7kCoIzFt8sPjhTznQ1zHIMb6kxk/AIh5l+pid55JySbc7rLX1/jl
         edFXpQyvDTPVQ==
Received: from te-lab16 (nanobot.internal.synopsys.com [10.10.186.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 782D7A0096;
        Thu, 24 Sep 2020 08:21:24 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Thu, 24 Sep 2020 01:21:24 -0700
Date:   Thu, 24 Sep 2020 01:21:24 -0700
Message-Id: <326a4b8aa53cd427eec36678c2410c5698b89a13.1600935293.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1600935293.git.Thinh.Nguyen@synopsys.com>
References: <cover.1600935293.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 02/10] usb: dwc3: gadget: Reclaim extra TRBs after request completion
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh.Nguyen@synopsys.com, linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

An SG request may be partially completed (due to no available TRBs).
Don't reclaim extra TRBs and clear the needs_extra_trb flag until the
request is fully completed. Otherwise, the driver will reclaim the wrong
TRB.

Cc: stable@vger.kernel.org
Fixes: 1f512119a08c ("usb: dwc3: gadget: add remaining sg entries to ring")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/dwc3/gadget.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 44351078f833..6017263929f3 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2738,6 +2738,11 @@ static int dwc3_gadget_ep_cleanup_completed_request(struct dwc3_ep *dep,
 		ret = dwc3_gadget_ep_reclaim_trb_linear(dep, req, event,
 				status);
 
+	req->request.actual = req->request.length - req->remaining;
+
+	if (!dwc3_gadget_ep_request_completed(req))
+		goto out;
+
 	if (req->needs_extra_trb) {
 		unsigned int maxp = usb_endpoint_maxp(dep->endpoint.desc);
 
@@ -2753,11 +2758,6 @@ static int dwc3_gadget_ep_cleanup_completed_request(struct dwc3_ep *dep,
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
2.28.0

