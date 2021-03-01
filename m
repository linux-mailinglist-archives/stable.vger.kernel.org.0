Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBA632873E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237888AbhCARW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:22:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:50436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237862AbhCARNi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:13:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F4546502D;
        Mon,  1 Mar 2021 16:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617080;
        bh=t5JGzOM7XQbD+lP+H98M51tM4YYq6+btNlal7pCD0Fw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BBn0DEab6vpYmnCIR67u6/JCxq7Eo7b6BvKvvZQao2E+eVDoDk8Okz7FsWH07phyA
         1zpnidjuZ7JCFfreitIT+Y4TuxgpEDG/o/X+jJJn2wvwtJCM4tjURwYCgNS3N6nqGg
         CuqiRH38/AMbT8gFUrnGfdkDKUUj8NZH1k0Bk0U0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 4.19 188/247] usb: dwc3: gadget: Fix setting of DEPCFG.bInterval_m1
Date:   Mon,  1 Mar 2021 17:13:28 +0100
Message-Id: <20210301161040.858344989@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit a1679af85b2ae35a2b78ad04c18bb069c37330cc upstream.

Valid range for DEPCFG.bInterval_m1 is from 0 to 13, and it must be set
to 0 when the controller operates in full-speed. See the programming
guide for DEPCFG command section 3.2.2.1 (v3.30a).

Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/3f57026f993c0ce71498dbb06e49b3a47c4d0265.1612820995.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -593,7 +593,17 @@ static int dwc3_gadget_set_ep_config(str
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
+		if (dwc->gadget.speed == USB_SPEED_FULL)
+			bInterval_m1 = 0;
+
+		params.param1 |= DWC3_DEPCFG_BINTERVAL_M1(bInterval_m1);
 		dep->interval = 1 << (desc->bInterval - 1);
 	}
 


