Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1C629676D
	for <lists+stable@lfdr.de>; Fri, 23 Oct 2020 00:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373078AbgJVWpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Oct 2020 18:45:01 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:51178 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S373010AbgJVWpB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Oct 2020 18:45:01 -0400
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E0C9D427AC;
        Thu, 22 Oct 2020 22:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1603406700; bh=DDQVeRa/me0kMyPuy45QTehC7ujAYJEstZEMcrO4T0A=;
        h=Date:From:Subject:To:Cc:From;
        b=GS0Eb/DZuAXg4ze+9b13ode5i/ionskx5Z5wFmHuRdN/AVsmu8Vokau3K2xopBWBq
         viBwjudCbb7B6ylKYkrYmUj1euPMi/4u+ZQD6MohCzanj/14abWa2jV70a8QQ4aJGc
         rO0y8ngrGVIe1dJaWKu0pTHptUrF60YWSevQINkXhxc8d5ARUiDPQJ8abhgV9cWN1d
         wZrSiBq+1GpTf1FJ1+5BTPVvMxEQHroaz1C6q7Baap9MGTA2BaGTCSVWAKxRth2ubq
         cif7SgQhLJC/7q6Jyupw3CG3nwlAJBjFBmINQL4mE3wbD3fQmVzpdSfIhY1AowTqwR
         wqOkR+9d23pDg==
Received: from te-lab16 (nanobot.internal.synopsys.com [10.10.186.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id A01ABA005E;
        Thu, 22 Oct 2020 22:44:59 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Thu, 22 Oct 2020 15:44:59 -0700
Date:   Thu, 22 Oct 2020 15:44:59 -0700
Message-Id: <e67dedc5a0f5fe7a8ea21f49bc795ac62ebed880.1603406408.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH] usb: dwc3: ep0: Fix delay status handling
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If we want to send a control status on our own time (through
delayed_status), make sure to handle a case where we may queue the
delayed status before the host requesting for it (when XferNotReady
is generated). Otherwise, the driver won't send anything because it's
not EP0_STATUS_PHASE yet. To resolve this, regardless whether
dwc->ep0state is EP0_STATUS_PHASE, make sure to clear the
dwc->delayed_status flag if dwc3_ep0_send_delayed_status() is called.
The control status can be sent when the host requests it later.

Cc: <stable@vger.kernel.org>
Fixes: d97c78a1908e ("usb: dwc3: gadget: END_TRANSFER before CLEAR_STALL command")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/dwc3/ep0.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/ep0.c b/drivers/usb/dwc3/ep0.c
index 7be3903cb842..8b668ef46f7f 100644
--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -1058,10 +1058,11 @@ void dwc3_ep0_send_delayed_status(struct dwc3 *dwc)
 {
 	unsigned int direction = !dwc->ep0_expect_in;
 
+	dwc->delayed_status = false;
+
 	if (dwc->ep0state != EP0_STATUS_PHASE)
 		return;
 
-	dwc->delayed_status = false;
 	__dwc3_ep0_do_control_status(dwc, dwc->eps[direction]);
 }
 

base-commit: 270315b8235e3d10c2e360cff56c2f9e0915a252
-- 
2.28.0

