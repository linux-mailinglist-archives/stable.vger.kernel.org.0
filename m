Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09B123E604
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 04:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgHGCqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 22:46:37 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:57052 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726058AbgHGCqh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 22:46:37 -0400
Received: from mailhost.synopsys.com (sv2-mailhost1.synopsys.com [10.205.2.133])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id F1D04408EF;
        Fri,  7 Aug 2020 02:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1596768397; bh=958otJzrCCYip3bSAyN/Iy/an6KYxnXX8t2UmC0ryRA=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=jcEEiQrG2uHt3JU8MFhcC6kP83PWzETj1OjvbuUNNDzGP+XlZcOf2j78ZGlbieBqP
         o+zf9i0I6jLKqbJ0nhKB0X9dUhUqRP5XT/0mNgf0Bd40OG2Di7K/iXM+TVZBTziivZ
         e1w/VTJORzfSEH/jPY5WDdTmfkTqrra+p3J+FzXAHdGrio4wDvJzlp8THG0V22yxV8
         rUQw7LxpC+X4QWoMzcETVBUVEYoxVx/g7cY8YhwcvTM1FPYqYaSz1ysRuJqrz/NbDe
         LgZOxXz7Pwz0Lrr7FCQPP8TIzfRVcqBazvJXOUlrtqjXy08Q2GcW8WIrQf5HTwX0f9
         6aV1XxkLY0yDQ==
Received: from te-lab16 (nanobot.internal.synopsys.com [10.10.186.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id DB670A0096;
        Fri,  7 Aug 2020 02:46:35 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Thu, 06 Aug 2020 19:46:35 -0700
Date:   Thu, 06 Aug 2020 19:46:35 -0700
Message-Id: <08ab69d55ff0c9537b843a1f1d6099374116a6f3.1596767991.git.thinhn@synopsys.com>
In-Reply-To: <cover.1596767991.git.thinhn@synopsys.com>
References: <cover.1596767991.git.thinhn@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH v2 3/7] usb: dwc3: gadget: Handle ZLP for sg requests
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently dwc3 doesn't handle usb_request->zero for SG requests. This
change checks and prepares extra TRBs for the ZLP for SG requests.

Cc: stable@vger.kernel.org
Fixes: 04c03d10e507 ("usb: dwc3: gadget: handle request->zero")
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
---
 Changes in v2:
 - None

 drivers/usb/dwc3/gadget.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index df603a817a98..c2a0f64f8d1e 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1143,6 +1143,37 @@ static void dwc3_prepare_one_trb_sg(struct dwc3_ep *dep,
 					req->request.short_not_ok,
 					req->request.no_interrupt,
 					req->request.is_last);
+		} else if (req->request.zero && req->request.length &&
+			   !usb_endpoint_xfer_isoc(dep->endpoint.desc) &&
+			   !rem && !chain) {
+			struct dwc3	*dwc = dep->dwc;
+			struct dwc3_trb	*trb;
+
+			req->needs_extra_trb = true;
+
+			/* Prepare normal TRB */
+			dwc3_prepare_one_trb(dep, req, trb_length, true, i);
+
+			/* Prepare one extra TRB to handle ZLP */
+			trb = &dep->trb_pool[dep->trb_enqueue];
+			req->num_trbs++;
+			__dwc3_prepare_one_trb(dep, trb, dwc->bounce_addr, 0,
+					       !req->direction, 1,
+					       req->request.stream_id,
+					       req->request.short_not_ok,
+					       req->request.no_interrupt,
+					       req->request.is_last);
+
+			/* Prepare one more TRB to handle MPS alignment */
+			if (!req->direction) {
+				trb = &dep->trb_pool[dep->trb_enqueue];
+				req->num_trbs++;
+				__dwc3_prepare_one_trb(dep, trb, dwc->bounce_addr, maxp,
+						       false, 1, req->request.stream_id,
+						       req->request.short_not_ok,
+						       req->request.no_interrupt,
+						       req->request.is_last);
+			}
 		} else {
 			dwc3_prepare_one_trb(dep, req, trb_length, chain, i);
 		}
-- 
2.28.0

