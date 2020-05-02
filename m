Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADFFC1C2209
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 02:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgEBAor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 20:44:47 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:34772 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726352AbgEBAoq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 20:44:46 -0400
Received: from mailhost.synopsys.com (sv2-mailhost1.synopsys.com [10.205.2.133])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 50B1E4398D;
        Sat,  2 May 2020 00:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1588380286; bh=f2s7mSgHF8VO4XLOfnwmQTgt2ilzKuI2hZe+IzdJUJM=;
        h=Date:From:Subject:To:Cc:From;
        b=aPLoFZEWBpENlDqHDxmnRjK4Fwo1irAi4Z+hBEXc/a3/tQNRIzJ6/hPCH+4dFfmUC
         iplDwVPIHuB0JgKq5s+bUGHMdVbFcugF44doj0gU3LKm2q7tdq4WruJYH9HNdbPnPQ
         We0n3SWhfaGm4zphdVwAgrMWhgPWQUho85ruG8KRzZ1dBTIMym2PZpy8whL/gMXF4I
         znWfQna8kqDlf85dUtalBLLaMq16gdBg1oTh8Ue69pziprgksWqPI0fTQEwfVTyuL6
         LJVxzptoDvOXgbk1db4+0XFUKM+1gNArrO7M6bmmDgB5eRoH5yLzOADXccDtQaCni+
         Dk5jQTpMDmYoA==
Received: from te-lab16 (nanobot.internal.synopsys.com [10.10.186.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id D5542A0259;
        Sat,  2 May 2020 00:44:44 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Fri, 01 May 2020 17:44:44 -0700
Date:   Fri, 01 May 2020 17:44:44 -0700
Message-Id: <7685ba14eaa185a170d6c4c9668d2ad98eeb8b14.1588380090.git.thinhn@synopsys.com>
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH] usb: dwc3: gadget: Don't setup more than requested
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Anurag Kumar Vulisha <anuragku@xilinx.com>
Cc:     John Youn <John.Youn@synopsys.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The sgl may be allocated larger than the requested length. Check the
usb_request->length and make sure that we don't setup the TRB to
send/receive more than requested.

Cc: stable@vger.kernel.org
Fixes: a31e63b608ff ("usb: dwc3: gadget: Correct handling of scattergather lists")
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
---
 drivers/usb/dwc3/gadget.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 4ca3e197bee4..95ec39e42409 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1040,7 +1040,8 @@ static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
 	unsigned		no_interrupt = req->request.no_interrupt;
 
 	if (req->request.num_sgs > 0) {
-		length = sg_dma_len(req->start_sg);
+		length = min_t(unsigned int, req->request.length,
+			       sg_dma_len(req->start_sg));
 		dma = sg_dma_address(req->start_sg);
 	} else {
 		length = req->request.length;
-- 
2.11.0

