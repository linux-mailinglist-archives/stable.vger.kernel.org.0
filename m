Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030313769BA
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 19:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhEGR4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 13:56:25 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:14633 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhEGR4Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 May 2021 13:56:25 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1620410125; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=QEiUnP3LOUi2nXe4DLoSZyC62ngztBL3XlxmT2ZBLW0=; b=ETszTd/+BAALEfoceOhFBle4KPQ1mary2sfS6DoGHLhTxnuj/KVRFAxVukZo4dbgKbf30c3E
 v+bCTgcULQpK2YgUQBHeVLu1KIvIW0+84DbYNa7uwxZwo6zWSj9gFAKGp9kCPM9E1MYSss4M
 AhB3F2wMIbOwXU6uYIcmIhg+Vks=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 60957f0c74f773a664850dfb (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 07 May 2021 17:55:24
 GMT
Sender: wcheng=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 88B24C43145; Fri,  7 May 2021 17:55:23 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from wcheng-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: wcheng)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 76AFDC4338A;
        Fri,  7 May 2021 17:55:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 76AFDC4338A
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=wcheng@codeaurora.org
From:   Wesley Cheng <wcheng@codeaurora.org>
To:     balbi@kernel.org, gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thinh.Nguyen@synopsys.com, jackp@codeaurora.org,
        Wesley Cheng <wcheng@codeaurora.org>, stable@vger.kernel.org
Subject: [PATCH v2] usb: dwc3: gadget: Return success always for kick transfer in ep queue
Date:   Fri,  7 May 2021 10:55:19 -0700
Message-Id: <1620410119-24971-1-git-send-email-wcheng@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If an error is received when issuing a start or update transfer
command, the error handler will stop all active requests (including
the current USB request), and call dwc3_gadget_giveback() to notify
function drivers of the requests which have been stopped.  Avoid
returning an error for kick transfer during EP queue, to remove
duplicate cleanup operations on the request being queued.

Fixes: 8d99087c2db8 ("usb: dwc3: gadget: Properly handle failed kick_transfer")
cc: stable@vger.kernel.org
Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
---
Changes in v2:
 - Added Fixes tag and Cc'ed stable

Changes in v1:
 - Renamed commit title due to new implementation
 - Return success always for kick transfer during ep queue

Previous patchset:
https://lore.kernel.org/linux-usb/875yzxibur.fsf@kernel.org/T/#t

 drivers/usb/dwc3/gadget.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index dd80e5c..a5b7fd9 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1684,7 +1684,9 @@ static int __dwc3_gadget_ep_queue(struct dwc3_ep *dep, struct dwc3_request *req)
 		}
 	}
 
-	return __dwc3_gadget_kick_transfer(dep);
+	__dwc3_gadget_kick_transfer(dep);
+
+	return 0;
 }
 
 static int dwc3_gadget_ep_queue(struct usb_ep *ep, struct usb_request *request,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

