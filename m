Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE5D13945A0
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 18:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236213AbhE1QGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 12:06:55 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:42878 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236718AbhE1QGv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 May 2021 12:06:51 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622217917; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=Cf/VjNCTchFVUo8Gy9ne+Oe9WRq9NkIZsHxvuJhoelg=; b=kYM+qDn7It5kmSBpnAx3ZRudjEFq+c25gK4nkH3zudt5js2jhxYLUzip2hdggGDdylP6TSBm
 D6rFh08CbbyUc/Lrb9FVOFLarNGFv5hqiyFEIzNTINhYmnuEup7HungFSvb9Rsk7XHpjyL3Y
 pJ99vu9ptUsvCnKrn4kdRuhfeik=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 60b114b3cad205471db7a935 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 28 May 2021 16:05:07
 GMT
Sender: jackp=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 63D12C4323A; Fri, 28 May 2021 16:05:06 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from jackp-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jackp)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E57EEC433F1;
        Fri, 28 May 2021 16:05:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E57EEC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=jackp@codeaurora.org
From:   Jack Pham <jackp@codeaurora.org>
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Wesley Cheng <wcheng@codeaurora.org>, linux-usb@vger.kernel.org,
        Jack Pham <jackp@codeaurora.org>, stable@vger.kernel.org,
        Peter Chen <peter.chen@kernel.org>
Subject: [PATCH v2] usb: dwc3: gadget: Bail from dwc3_gadget_exit() if dwc->gadget is NULL
Date:   Fri, 28 May 2021 09:04:05 -0700
Message-Id: <20210528160405.17550-1-jackp@codeaurora.org>
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
	FFS instance is not in FFS_ACTIVE state (userspace has not
	re-opened and written the descriptors yet, i.e. desc_ready!=0).
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
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Jack Pham <jackp@codeaurora.org>
---
v2: Fixed commit message to refer to FFS_ACTIVE state; added
    Peter's Reviewed-by tag.

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

