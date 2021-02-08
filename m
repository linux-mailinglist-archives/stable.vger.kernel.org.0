Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE729314259
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 22:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236937AbhBHVy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 16:54:29 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:44882 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236901AbhBHVyU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 16:54:20 -0500
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 364DD4010A;
        Mon,  8 Feb 2021 21:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1612821192; bh=iq9axuEzt6S+cRNecRhTNJ6ydU7TA+plKM/ftwy11lc=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=K9jAkJ38OHafgqXU07sP1cRm20iNRye3ZLqHqouPDgk5YKJFk2CUdCZ4GVKMJjiTd
         I4NHayABc9Z9WYIl4MmkVFlQSvMmntZfnbQXYeD999J84/GTwb9BY086g0fts8R9ax
         AfOC8S2Do2vd0Hpi85eBA0j1JEepBoybuIYL1i0sumAuUvgPKenuDOHwZF4BdPfAOu
         NJmcCGVVdPg3pW/DCshQI/+V2GiKl/pGoAslA9Axv0HHiHUzMmNNaIAI27oz6kWU99
         k0NXWQZMYxzmkKdvlo8Ht2HFxkAcnA484qXaSxs2+E6a8/48ECfnfk5XDmLxfjxAMM
         k7TkxSvrVyA5A==
Received: from te-lab16 (unknown [10.10.52.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id C1C24A005E;
        Mon,  8 Feb 2021 21:53:10 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Mon, 08 Feb 2021 13:53:10 -0800
Date:   Mon, 08 Feb 2021 13:53:10 -0800
Message-Id: <3f57026f993c0ce71498dbb06e49b3a47c4d0265.1612820995.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1612820995.git.Thinh.Nguyen@synopsys.com>
References: <cover.1612820995.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 1/2] usb: dwc3: gadget: Fix setting of DEPCFG.bInterval_m1
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh.Nguyen@synopsys.com, linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, <stable@vger.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Valid range for DEPCFG.bInterval_m1 is from 0 to 13, and it must be set
to 0 when the controller operates in full-speed. See the programming
guide for DEPCFG command section 3.2.2.1 (v3.30a).

Cc: <stable@vger.kernel.org>
Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/dwc3/gadget.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 97d707b4f384..d0f8d3ec855f 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -605,7 +605,17 @@ static int dwc3_gadget_set_ep_config(struct dwc3_ep *dep, unsigned int action)
 		params.param0 |= DWC3_DEPCFG_FIFO_NUMBER(dep->number >> 1);
 
 	if (desc->bInterval) {
-		params.param1 |= DWC3_DEPCFG_BINTERVAL_M1(desc->bInterval - 1);
+		u8 bInterval_m1;
+
+		/*
+		 * Valid range for DEPCFG.bInterval_m1 is from 0 to 13, and it
+		 * must be set to 0 when the controller operates in full-speed.
+		 */
+		bInterval_m1 = min_t(u8, desc->bInterval - 1, 13);
+		if (dwc->gadget->speed == USB_SPEED_FULL)
+			bInterval_m1 = 0;
+
+		params.param1 |= DWC3_DEPCFG_BINTERVAL_M1(bInterval_m1);
 		dep->interval = 1 << (desc->bInterval - 1);
 	}
 
-- 
2.28.0

