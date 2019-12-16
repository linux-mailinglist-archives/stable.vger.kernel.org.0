Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5873912142F
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbfLPSJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:09:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:50962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728056AbfLPSJA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:09:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBE5120700;
        Mon, 16 Dec 2019 18:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519740;
        bh=K0O0fJrGWr8JYMaBAwhKQId7RgwS9oiMPA2ryRrCwd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fSmW5SK/DVJsGs3h5Swg05aLOLdIcMqdP+dLpi46HmYDXW4n4aI9p5SRPrTQgAQHL
         YTghaJGwAGVrY9DZq/y9gpmgf5OivYP8rkpEcIjfQSnkPU51VRly0yx7uCq+dED2Hy
         /jZBmBlry/B2AF2BLoUXrpwIf7ZewQY+Bgl368ZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejas Joglekar <joglekar@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.3 049/180] usb: dwc3: gadget: Fix logical condition
Date:   Mon, 16 Dec 2019 18:48:09 +0100
Message-Id: <20191216174822.512153908@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejas Joglekar <Tejas.Joglekar@synopsys.com>

commit 8c7d4b7b3d43c54c0b8c1e4adb917a151c754196 upstream.

This patch corrects the condition to kick the transfer without
giving back the requests when either request has remaining data
or when there are pending SGs. The && check was introduced during
spliting up the dwc3_gadget_ep_cleanup_completed_requests() function.

Fixes: f38e35dd84e2 ("usb: dwc3: gadget: split dwc3_gadget_ep_cleanup_completed_requests()")

Cc: stable@vger.kernel.org
Signed-off-by: Tejas Joglekar <joglekar@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/gadget.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2471,7 +2471,7 @@ static int dwc3_gadget_ep_cleanup_comple
 
 	req->request.actual = req->request.length - req->remaining;
 
-	if (!dwc3_gadget_ep_request_completed(req) &&
+	if (!dwc3_gadget_ep_request_completed(req) ||
 			req->num_pending_sgs) {
 		__dwc3_gadget_kick_transfer(dep);
 		goto out;


