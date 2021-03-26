Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A169B34A576
	for <lists+stable@lfdr.de>; Fri, 26 Mar 2021 11:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbhCZKZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Mar 2021 06:25:21 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:37612 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229904AbhCZKZP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Mar 2021 06:25:15 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 9D4D3C0269;
        Fri, 26 Mar 2021 10:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1616754315; bh=NmjoFpDwk9C6KhUVpjbaLtkpA+otz+Gqy0pYXDXxPZw=;
        h=Date:From:Subject:To:Cc:From;
        b=keLXx+IGR4/FPwlEBRD3YBySdiVEKnIOde6b+ObDPGHwsdLztcyPmGH62Ysn7YIm2
         hI7rUBf2okr3BjJb70d/CWhcfZHJqs7b+6t2SmT+XzzADG3p7KjNX69P11bdv+tneF
         gbNmGBBbzg0T98/4YE/+Ns6+bgGgx8Q+nVT9NgVj4CVkiBwAii8U9vHcUKPNGSMJg1
         0VY+TovCjWE52RzHRLrrBeJeq6ajuZ11tKbo8e2sl+2mQsoUruYUUnY2z5Pr/9X/P6
         bHA87m2q25+xOe6QLRGtB2E/QOyT8ccgGxm9DCwG6yUqlzca8G4Jh3/NCqlB2r+ffC
         tzb5JZa33hayw==
Received: from razpc-HP (razpc-hp.internal.synopsys.com [10.116.126.207])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id BDEDEA005D;
        Fri, 26 Mar 2021 10:25:10 +0000 (UTC)
Received: by razpc-HP (sSMTP sendmail emulation); Fri, 26 Mar 2021 14:25:09 +0400
Date:   Fri, 26 Mar 2021 14:25:09 +0400
X-SNPS-Relay: synopsys.com
From:   Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Subject: [PATCH 3/3] usb: dwc2: Prevent core suspend when port connection flag is 0
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        linux-usb@vger.kernel.org, Douglas Anderson <dianders@chromium.org>
Cc:     John Youn <John.Youn@synopsys.com>,
        Artur Petrosyan <Arthur.Petrosyan@synopsys.com>,
        Paul Zimmerman <paulz@synopsys.com>, <stable@vger.kernel.org>,
        #@synopsys.com, 5.2@synopsys.com, Felipe Balbi <balbi@ti.com>,
        Kever Yang <kever.yang@rock-chips.com>
Message-Id: <20210326102510.BDEDEA005D@mailhost.synopsys.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In host mode port connection status flag is "0" when loading
the driver. After loading the driver system asserts suspend
which is handled by "_dwc2_hcd_suspend()" function. Before
the system suspend the port connection status is "0". As
result need to check the "port_connect_status" if it is "0",
then skipping entering to suspend.

Cc: <stable@vger.kernel.org> # 5.2
Fixes: 6f6d70597c15 ("usb: dwc2: bus suspend/resume for hosts with
DWC2_POWER_DOWN_PARAM_NONE")
Signed-off-by: Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
---
 drivers/usb/dwc2/hcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index 40e5655921bf..1a9789ec5847 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -4322,7 +4322,8 @@ static int _dwc2_hcd_suspend(struct usb_hcd *hcd)
 	if (hsotg->op_state == OTG_STATE_B_PERIPHERAL)
 		goto unlock;
 
-	if (hsotg->params.power_down > DWC2_POWER_DOWN_PARAM_PARTIAL)
+	if (hsotg->params.power_down != DWC2_POWER_DOWN_PARAM_PARTIAL ||
+	    hsotg->flags.b.port_connect_status == 0)
 		goto skip_power_saving;
 
 	/*
-- 
2.25.1

