Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036E22EB0B6
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 17:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729653AbhAEQ5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 11:57:43 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:34530 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728897AbhAEQ5n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 11:57:43 -0500
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7434AC00BA;
        Tue,  5 Jan 2021 16:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1609865802; bh=qgRUeUKMp2WjATgWa6bLaTyhrCROhZAPwUZlyIRX0AM=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=XC2Undug1MLxqnPXMWanl1iJkC7Qk7CjUj5FMaq6/DU7eKfN7xG5aIrvNqscGMuVe
         2lBisIaj6MhJftfjpqGHK1NnkX6stW8lcE6KA7vHpAHc9hglLaKHYGsmbvmmMjMa57
         EYYhZuHloX1qKiUSsiIqv4J8nQyjx0MdJzl62Q2rauYS1W+astisBVwp5FRxQH3+tV
         qqCdOOiSYBNflz4GDG+Nk4Ha38ST4P9GN2Yq8lfiRXJAm9Zr90uR3Vai/BpbA5mo4/
         83BzqU/POgxwOA+AwDuc+oDE6Ip8OEfVZ0kVzjlT9ss4lTaTyTIMYmvIsQBpOME+3J
         mXJTSoQVwBJ3g==
Received: from te-lab16 (unknown [10.10.52.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 44B79A006F;
        Tue,  5 Jan 2021 16:56:41 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Tue, 05 Jan 2021 08:56:41 -0800
Date:   Tue, 05 Jan 2021 08:56:41 -0800
Message-Id: <9d057f37b82083af331fb6225d7c7ef3d1840a6e.1609865348.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1609865348.git.Thinh.Nguyen@synopsys.com>
References: <cover.1609865348.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 2/2] usb: dwc3: gadget: Check if the gadget had stopped
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh.Nguyen@synopsys.com, linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the gadget had already stopped, don't try to stop again. Otherwise
we'd get a warning for trying to free an already freed irq. This can
happen if a user tries to trigger a soft-disconnect from soft_connect
sysfs multiple times. The fix is to check if there's a bounded gadget
driver to determined if the gadget had stopped.

Cc: stable@vger.kernel.org
Fixes: 8698e2acf3a5 ("usb: dwc3: gadget: introduce and use enable/disable irq methods")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/dwc3/gadget.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 51d81a32ce78..9ec70282e610 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2338,6 +2338,10 @@ static int dwc3_gadget_stop(struct usb_gadget *g)
 	struct dwc3		*dwc = gadget_to_dwc(g);
 	unsigned long		flags;
 
+	/* The controller is already stopped if there's no gadget driver */
+	if (!dwc->gadget_driver)
+		return 0;
+
 	spin_lock_irqsave(&dwc->lock, flags);
 	dwc->gadget_driver	= NULL;
 	spin_unlock_irqrestore(&dwc->lock, flags);
-- 
2.28.0

