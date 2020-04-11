Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 645FD1A5060
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgDKMRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:17:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728370AbgDKMRL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:17:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D493520644;
        Sat, 11 Apr 2020 12:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607431;
        bh=E03Dhfc2oBH5Q3tpRD5N2QLqFY+7GVOS9HYPb0ME0ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dpYfEFkmz590dJT5cZlDJA9QiEo0ZcYUZr2Mruk6klVWCtmnZmBKRSGAl6ifxRcRh
         Q9zdHVUhdOnppZvMgXrgFprswEplQVJiS0tM3yncdx1S5RPHzuSTsjitTdoGYScN80
         zRaBEROgk4+Vjm9kD3nslPJNhLMD5PAObV08eVoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.4 17/41] usb: dwc3: gadget: Wrap around when skip TRBs
Date:   Sat, 11 Apr 2020 14:09:26 +0200
Message-Id: <20200411115505.281877775@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115504.124035693@linuxfoundation.org>
References: <20200411115504.124035693@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 2dedea035ae82c5af0595637a6eda4655532b21e upstream.

When skipping TRBs, we need to account for wrapping around the ring
buffer and not modifying some invalid TRBs. Without this fix, dwc3 won't
be able to check for available TRBs.

Cc: stable <stable@vger.kernel.org>
Fixes: 7746a8dfb3f9 ("usb: dwc3: gadget: extract dwc3_gadget_ep_skip_trbs()")
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/gadget.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1518,7 +1518,7 @@ static void dwc3_gadget_ep_skip_trbs(str
 	for (i = 0; i < req->num_trbs; i++) {
 		struct dwc3_trb *trb;
 
-		trb = req->trb + i;
+		trb = &dep->trb_pool[dep->trb_dequeue];
 		trb->ctrl &= ~DWC3_TRB_CTRL_HWO;
 		dwc3_ep_inc_deq(dep);
 	}


