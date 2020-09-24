Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F27E276BC6
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 10:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbgIXI0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 04:26:33 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:40542 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726979AbgIXI0b (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Sep 2020 04:26:31 -0400
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Sep 2020 04:26:31 EDT
Received: from mailhost.synopsys.com (sv2-mailhost1.synopsys.com [10.205.2.133])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7B0EB402DC;
        Thu, 24 Sep 2020 08:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1600935679; bh=xTLmBPtKTdMjcXU+24f4RxHnyGuBb7ByOH3+djITM4M=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=Fk0qmA2SI5H2OzeZtwg002JHWcNdwMadM0fT+6RKH2amYgVPvyFRHMZ9j2SEApSnh
         YZllRJBccU3KbHeinpcztCqjrBPY4WwpycGh8imhZ57sfq0mSSmjELIEOMrHlA/jmI
         d06NT0sC3C7sHN7DXei9XeMA2P90vVW741vfAwXte8h0Yw+2t6v+kbBrqsyLTFfgBf
         fZq92NPNsL60Sr5YDfB5j3ChZueOEUSuOcyq7EeF4hegDafqLf78uWZgbTm8cXdZNE
         2pkTO2eqbHRSDqdhYCQWSpHHuEIz/j2yI5CAaPDEKJb7QObCvOY9FrYWqAltVz0B8G
         3HCvZKhKGzKtg==
Received: from te-lab16 (nanobot.internal.synopsys.com [10.10.186.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 63D1EA0096;
        Thu, 24 Sep 2020 08:21:18 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Thu, 24 Sep 2020 01:21:18 -0700
Date:   Thu, 24 Sep 2020 01:21:18 -0700
Message-Id: <290cbf2ba0fee13ba37cf934bf413795d4bd9a04.1600935293.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1600935293.git.Thinh.Nguyen@synopsys.com>
References: <cover.1600935293.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 01/10] usb: dwc3: gadget: Check MPS of the request length
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When preparing for SG, not all the entries are prepared at once. When
resume, don't use the remaining request length to calculate for MPS
alignment. Use the entire request->length to do that.

Cc: stable@vger.kernel.org
Fixes: 5d187c0454ef ("usb: dwc3: gadget: Don't setup more than requested")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/dwc3/gadget.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index cb19d682bbac..44351078f833 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1098,6 +1098,8 @@ static void dwc3_prepare_one_trb_sg(struct dwc3_ep *dep,
 	struct scatterlist *s;
 	int		i;
 	unsigned int length = req->request.length;
+	unsigned int maxp = usb_endpoint_maxp(dep->endpoint.desc);
+	unsigned int rem = length % maxp;
 	unsigned int remaining = req->request.num_mapped_sgs
 		- req->num_queued_sgs;
 
@@ -1109,8 +1111,6 @@ static void dwc3_prepare_one_trb_sg(struct dwc3_ep *dep,
 		length -= sg_dma_len(s);
 
 	for_each_sg(sg, s, remaining, i) {
-		unsigned int maxp = usb_endpoint_maxp(dep->endpoint.desc);
-		unsigned int rem = length % maxp;
 		unsigned int trb_length;
 		unsigned int chain = true;
 
-- 
2.28.0

