Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645BB3285F3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236033AbhCARBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:01:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:53998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236386AbhCAQyB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:54:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9EE464F38;
        Mon,  1 Mar 2021 16:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616476;
        bh=ESnmHocvwVNpUPk5zCzXufT1e/aRRdoemZB32wUkiao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fyJeXdhgl1i4PEf7/h2DqI/tpVEMLy9UDcWWaC67ET02TSU+btGuTVvIBkFu1cFEW
         msIHWfuIF8+4Vun48k8bHhROprSrtWBKKYA3ugb1p88FCxTyNvrFs6V3xs9B7od/h9
         4R9w3J3d3NE1HCQPv4skQe3KBLvyURr9t2N62jVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 4.14 134/176] usb: dwc3: gadget: Fix dep->interval for fullspeed interrupt
Date:   Mon,  1 Mar 2021 17:13:27 +0100
Message-Id: <20210301161027.646505904@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 4b049f55ed95cd889bcdb3034fd75e1f01852b38 upstream.

The dep->interval captures the number of frames/microframes per interval
from bInterval. Fullspeed interrupt endpoint bInterval is the number of
frames per interval and not 2^(bInterval - 1). So fix it here. This
change is only for debugging purpose and should not affect the interrupt
endpoint operation.

Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/1263b563dedc4ab8b0fb854fba06ce4bc56bd495.1612820995.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -616,8 +616,13 @@ static int dwc3_gadget_set_ep_config(str
 		if (dwc->gadget.speed == USB_SPEED_FULL)
 			bInterval_m1 = 0;
 
+		if (usb_endpoint_type(desc) == USB_ENDPOINT_XFER_INT &&
+		    dwc->gadget.speed == USB_SPEED_FULL)
+			dep->interval = desc->bInterval;
+		else
+			dep->interval = 1 << (desc->bInterval - 1);
+
 		params.param1 |= DWC3_DEPCFG_BINTERVAL_M1(bInterval_m1);
-		dep->interval = 1 << (desc->bInterval - 1);
 	}
 
 	return dwc3_send_gadget_ep_cmd(dep, DWC3_DEPCMD_SETEPCONFIG, &params);


