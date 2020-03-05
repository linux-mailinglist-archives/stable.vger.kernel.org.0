Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B7B17B094
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 22:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgCEVYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 16:24:03 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:53412 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726143AbgCEVYD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Mar 2020 16:24:03 -0500
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 6041343BE1;
        Thu,  5 Mar 2020 21:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1583443443; bh=+wBPbe13994Dn1+F8xR0oAiYGqsds2IkNx+WDRUaBrA=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=WX6Ie/Nt8E6eI9txD/Wo7dG8LxXzuBM9viHuKJksoxgGVCLtY9b3TG9+dXzynXz9m
         nExvYuWJ0VQJdrYpWwOxS0pLLVOYo3ywMyb7Zxwz3C/GifGPhTTpGVgboQlzoC7igi
         /0eAT6Tq3tpGIXi7rIdoFucAsRfoGIMH4bBgcsA7y8c2SaTzHVZT/V/mzBRXA+SXMi
         bOp7AuP8ASKdMpikvqSTpNaFcfUKj45N08LYZop57sxQkRBrJHEFsENuaAjzhaWqP3
         uRaXs7MlpE9UIG5/2izf/ITLPdF9thfFJ9HGiQPcX15ktMmP0BvguMwGqe1QyMkgF/
         o2pqJ0Ha3ANDg==
Received: from te-lab16 (nanobot.internal.synopsys.com [10.10.186.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id D7326A00C0;
        Thu,  5 Mar 2020 21:24:01 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Thu, 05 Mar 2020 13:24:01 -0800
Date:   Thu, 05 Mar 2020 13:24:01 -0800
Message-Id: <64f999fcdcab268f325296043d451964da65ffa2.1583443184.git.thinhn@synopsys.com>
In-Reply-To: <cover.1583443184.git.thinhn@synopsys.com>
References: <cover.1583443184.git.thinhn@synopsys.com>
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 3/6] usb: dwc3: gadget: Wrap around when skip TRBs
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable <stable@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When skipping TRBs, we need to account for wrapping around the ring
buffer and not modifying some invalid TRBs. Without this fix, dwc3 won't
be able to check for available TRBs.

Cc: stable <stable@vger.kernel.org>
Fixes: 7746a8dfb3f9 ("usb: dwc3: gadget: extract dwc3_gadget_ep_skip_trbs()")
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
---
 drivers/usb/dwc3/gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 21b10364b888..8c27c6ede7c4 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1518,7 +1518,7 @@ static void dwc3_gadget_ep_skip_trbs(struct dwc3_ep *dep, struct dwc3_request *r
 	for (i = 0; i < req->num_trbs; i++) {
 		struct dwc3_trb *trb;
 
-		trb = req->trb + i;
+		trb = &dep->trb_pool[dep->trb_dequeue];
 		trb->ctrl &= ~DWC3_TRB_CTRL_HWO;
 		dwc3_ep_inc_deq(dep);
 	}
-- 
2.11.0

