Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3DC3284C3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235033AbhCAQm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:42:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:41538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234227AbhCAQeg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:34:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF4B964F5C;
        Mon,  1 Mar 2021 16:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615918;
        bh=BgSq5fyoRIAGys31IXz3ITvJz0LLxGwNFfxyzYg0Jns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uO2DNsbps/xypIhb5yuYB1k63vrDnzmtpRG+gpu0suqnj9Vi+5NzBNbl9F7nxmHJa
         Xtl4GSfj6OhR0CapYk1mSC17u6uaXFNgFb4M5tsdJiOPdQ99eyvNQ9BEln0jyiaZ6u
         Cq3seoC7aPk0nV6ONjq3dcoMnpHSRCQy1YkS1Xq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 4.9 099/134] usb: dwc3: gadget: Fix setting of DEPCFG.bInterval_m1
Date:   Mon,  1 Mar 2021 17:13:20 +0100
Message-Id: <20210301161018.434888811@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
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
@@ -528,7 +528,17 @@ static int dwc3_gadget_set_ep_config(str
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
 


