Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80FDB3FDB1B
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343496AbhIAMiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:38:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343527AbhIAMg1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:36:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53D8C61107;
        Wed,  1 Sep 2021 12:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499619;
        bh=I0+t/F8LWWNbmqb6GxAshlhLll8/wXYdYiVEbdqhqlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=njOO6SnHWgonhj8cty0ZaTcTWXvFRwb07M+v9sLBk5RCHxBZUNI6/1qIai2RH+xBC
         rHRXRxO/8oGIa9Et1G49ReijdospD9c4I+T000eml+2Ra9cNLxigJ8bp3VTo8+XUT0
         tyPXE1ljwoqaz1KFWPmY/J8o0eB7rKxdZLm4Qt3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.10 020/103] usb: dwc3: gadget: Fix dwc3_calc_trbs_left()
Date:   Wed,  1 Sep 2021 14:27:30 +0200
Message-Id: <20210901122301.207236436@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 51f1954ad853d01ba4dc2b35dee14d8490ee05a1 upstream.

We can't depend on the TRB's HWO bit to determine if the TRB ring is
"full". A TRB is only available when the driver had processed it, not
when the controller consumed and relinquished the TRB's ownership to the
driver. Otherwise, the driver may overwrite unprocessed TRBs. This can
happen when many transfer events accumulate and the system is slow to
process them and/or when there are too many small requests.

If a request is in the started_list, that means there is one or more
unprocessed TRBs remained. Check this instead of the TRB's HWO bit
whether the TRB ring is full.

Fixes: c4233573f6ee ("usb: dwc3: gadget: prepare TRBs on update transfers too")
Cc: <stable@vger.kernel.org>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/e91e975affb0d0d02770686afc3a5b9eb84409f6.1629335416.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -932,19 +932,19 @@ static struct dwc3_trb *dwc3_ep_prev_trb
 
 static u32 dwc3_calc_trbs_left(struct dwc3_ep *dep)
 {
-	struct dwc3_trb		*tmp;
 	u8			trbs_left;
 
 	/*
-	 * If enqueue & dequeue are equal than it is either full or empty.
-	 *
-	 * One way to know for sure is if the TRB right before us has HWO bit
-	 * set or not. If it has, then we're definitely full and can't fit any
-	 * more transfers in our ring.
+	 * If the enqueue & dequeue are equal then the TRB ring is either full
+	 * or empty. It's considered full when there are DWC3_TRB_NUM-1 of TRBs
+	 * pending to be processed by the driver.
 	 */
 	if (dep->trb_enqueue == dep->trb_dequeue) {
-		tmp = dwc3_ep_prev_trb(dep, dep->trb_enqueue);
-		if (tmp->ctrl & DWC3_TRB_CTRL_HWO)
+		/*
+		 * If there is any request remained in the started_list at
+		 * this point, that means there is no TRB available.
+		 */
+		if (!list_empty(&dep->started_list))
 			return 0;
 
 		return DWC3_TRB_NUM - 1;


