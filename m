Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD35E2A5221
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730500AbgKCUrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:47:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:36940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730729AbgKCUrA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:47:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20B9B20719;
        Tue,  3 Nov 2020 20:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436419;
        bh=adrOmpVNtXk0w1K1x91AoAl2Qjk42x/Id2yz/Dg7u+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=arSu2TakxiuewHGV8/IwDbOejLY6+DBKxJ/QwPe984/OkzTxpGLrIWlYGzjXQeonp
         awSaJuIUERmBJMkqU3plxOFA2C8MphgITFi5wZxkBDptgMW2O8e3Uy5mVZL19naMHF
         TJJXYgj3z763xSMX4kxyQzW+P2UGDh+aThnzEmW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.9 242/391] usb: dwc3: gadget: Reclaim extra TRBs after request completion
Date:   Tue,  3 Nov 2020 21:34:53 +0100
Message-Id: <20201103203403.337060578@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 690e5c2dc29f8891fcfd30da67e0d5837c2c9df5 upstream.

An SG request may be partially completed (due to no available TRBs).
Don't reclaim extra TRBs and clear the needs_extra_trb flag until the
request is fully completed. Otherwise, the driver will reclaim the wrong
TRB.

Cc: stable@vger.kernel.org
Fixes: 1f512119a08c ("usb: dwc3: gadget: add remaining sg entries to ring")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/gadget.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2732,6 +2732,11 @@ static int dwc3_gadget_ep_cleanup_comple
 		ret = dwc3_gadget_ep_reclaim_trb_linear(dep, req, event,
 				status);
 
+	req->request.actual = req->request.length - req->remaining;
+
+	if (!dwc3_gadget_ep_request_completed(req))
+		goto out;
+
 	if (req->needs_extra_trb) {
 		unsigned int maxp = usb_endpoint_maxp(dep->endpoint.desc);
 
@@ -2747,11 +2752,6 @@ static int dwc3_gadget_ep_cleanup_comple
 		req->needs_extra_trb = false;
 	}
 
-	req->request.actual = req->request.length - req->remaining;
-
-	if (!dwc3_gadget_ep_request_completed(req))
-		goto out;
-
 	dwc3_gadget_giveback(dep, req, status);
 
 out:


