Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A729B38F994
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 06:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhEYEbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 00:31:19 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:36908 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbhEYEbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 00:31:18 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1621916989; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=oCutuukYs7uGs5rzLn8jFX89efaAqNYl7cu3djw/fGs=; b=v15o4e1AtLJFuD92UVev7mFjNty3zRQHqyQWzDJRHvKEJFMXeHLou/MtcQk8lpCad9Knn/r1
 5+u0qcS6lJO+bmuTN7g5g70Ll8IrtZC1Vz87u58IbXY86OfAaFi4T9+ylZcS32VI5BQmY4d0
 u5Ywq3LV/Ea9g88c0xmegyfnwlU=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 60ac7d3d8dd30e785fde5868 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 25 May 2021 04:29:49
 GMT
Sender: jackp=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 83BB4C4323A; Tue, 25 May 2021 04:29:48 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from jackp-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jackp)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8EE31C433D3;
        Tue, 25 May 2021 04:29:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8EE31C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=jackp@codeaurora.org
From:   Jack Pham <jackp@codeaurora.org>
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Chen <peter.chen@kernel.org>,
        Wesley Cheng <wcheng@codeaurora.org>,
        linux-usb@vger.kernel.org, Jack Pham <jackp@codeaurora.org>,
        stable@vger.kernel.org
Subject: [PATCH] usb: dwc3: gadget: Bail from dwc3_gadget_exit() if dwc->gadget is NULL
Date:   Mon, 24 May 2021 21:29:22 -0700
Message-Id: <20210525042922.15591-1-jackp@codeaurora.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There exists a possible scenario in which dwc3_gadget_init() can fail:
during during host -> peripheral mode switch in dwc3_set_mode(), and
a pending gadget driver fails to bind.  Then, if the DRD undergoes
another mode switch from peripheral->host the resulting
dwc3_gadget_exit() will attempt to reference an invalid and dangling
dwc->gadget pointer as well as call dma_free_coherent() on unmapped
DMA pointers.

The exact scenario can be reproduced as follows:
 - Start DWC3 in peripheral mode
 - Configure ConfigFS gadget with FunctionFS instance (or use g_ffs)
 - Run FunctionFS userspace application (open EPs, write descriptors, etc)
 - Bind gadget driver to DWC3's UDC
 - Switch DWC3 to host mode
   => dwc3_gadget_exit() is called. usb_del_gadget() will put the
	ConfigFS driver instance on the gadget_driver_pending_list
 - Stop FunctionFS application (closes the ep files)
 - Switch DWC3 to peripheral mode
   => dwc3_gadget_init() fails as usb_add_gadget() calls
	check_pending_gadget_drivers() and attempts to rebind the UDC
	to the ConfigFS gadget but fails with -19 (-ENODEV) because the
	FFS instance is not in FFS_READY state.
 - Switch DWC3 back to host mode
   => dwc3_gadget_exit() is called again, but this time dwc->gadget
	is invalid.

Although it can be argued that userspace should take responsibility
for ensuring that the FunctionFS application be ready prior to
allowing the composite driver bind to the UDC, failure to do so
should not result in a panic from the kernel driver.

Fix this by setting dwc->gadget to NULL in the failure path of
dwc3_gadget_init() and add a check to dwc3_gadget_exit() to bail out
unless the gadget pointer is valid.

Fixes: e81a7018d93a ("usb: dwc3: allocate gadget structure dynamically")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jack Pham <jackp@codeaurora.org>
---
Hi Felipe,

Although I marked the 'Fixes' tag above to e81a7018d93a, the problem
theoretically exists prior to Peter's change. But I'm not sure how
best to fix on versions prior to this change since dwc->gadget used
to be an embedded struct so we can't do a simple NULL check as below.
Suggestions on alternative approaches welcome if we want to proceed
with backporting to older (pre-5.9) stable releases.

Thanks,
Jack

 drivers/usb/dwc3/gadget.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 612825a39f82..65d9b7227752 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -4046,6 +4046,7 @@ int dwc3_gadget_init(struct dwc3 *dwc)
 	dwc3_gadget_free_endpoints(dwc);
 err4:
 	usb_put_gadget(dwc->gadget);
+	dwc->gadget = NULL;
 err3:
 	dma_free_coherent(dwc->sysdev, DWC3_BOUNCE_SIZE, dwc->bounce,
 			dwc->bounce_addr);
@@ -4065,6 +4066,9 @@ int dwc3_gadget_init(struct dwc3 *dwc)
 
 void dwc3_gadget_exit(struct dwc3 *dwc)
 {
+	if (!dwc->gadget)
+		return;
+
 	usb_del_gadget(dwc->gadget);
 	dwc3_gadget_free_endpoints(dwc);
 	usb_put_gadget(dwc->gadget);
-- 
2.24.0

