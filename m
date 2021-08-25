Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396CA3F6E75
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 06:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhHYEaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 00:30:06 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:33128 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhHYEaE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 00:30:04 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1629865740; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=0+985ZB1bZ2Xt57BgaCKAO5yH9ewmG5YTGZdFzukfIw=; b=o+yHfBMR3zBlvqVc1cGjvkcZ2bzrhH5ESp8uYq7dUPuDlFPVTxQUuYfivJqrEUlCxak90ZJc
 fnljkwWotgy484hJ3maaHY8ObLtW4yfvTnYjJsS0+Nzeq5SLJnbtihmuveUvPjt5InRBdCzg
 Oet7L2ilw5aGniW2ck1iYbCnRnk=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 6125c70c1567234b8cb458a7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 25 Aug 2021 04:29:00
 GMT
Sender: wcheng=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D0314C43616; Wed, 25 Aug 2021 04:28:59 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from wcheng-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: wcheng)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5A39EC4338F;
        Wed, 25 Aug 2021 04:28:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 5A39EC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Wesley Cheng <wcheng@codeaurora.org>
To:     balbi@kernel.org, gregkh@linuxfoundation.org,
        Thinh.Nguyen@synopsys.com
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        jackp@codeaurora.org, Wesley Cheng <wcheng@codeaurora.org>,
        stable@vger.kernel.org
Subject: [PATCH v5] usb: dwc3: gadget: Stop EP0 transfers during pullup disable
Date:   Tue, 24 Aug 2021 21:28:55 -0700
Message-Id: <20210825042855.7977-1-wcheng@codeaurora.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During a USB cable disconnect, or soft disconnect scenario, a pending
SETUP transaction may not be completed, leading to the following
error:

    dwc3 a600000.dwc3: timed out waiting for SETUP phase

If this occurs, then the entire pullup disable routine is skipped and
proper cleanup and halting of the controller does not complete.

Instead of returning an error (which is ignored from the UDC
perspective), allow the pullup disable routine to continue, which
will also handle disabling of EP0/1.  This will end any active
transfers as well.  Ensure to clear any delayed_status also, as the
timeout could happen within the STATUS stage.

Cc: <stable@vger.kernel.org>
Fixes: bb0147364850 ("usb: dwc3: gadget: don't clear RUN/STOP when it's invalid to do so")
Reviewed-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
---
Changes in v5:
 - Added Cc stable and fixes tag

Changes in v4:
 - Fixed formatting and typos in commit text
 - Removed braces due to the removal of the return statement

Changes in v3:
 - Added suggestion by Thinh to change dev_err to dev_warn

Changes in v2:
 - Removed calls to dwc3_ep0_end_control_data() and just allow the ep disables
   on EP0 handle the proper ending of transfers.
 - Ensure that delayed_status is cleared, as ran into enumeration issues if the
   SETUP transaction fails on a STATUS stage.  Saw delayed_status == TRUE on the
   next connect, which blocked further SETUP transactions to be handled.

 drivers/usb/dwc3/gadget.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 5d084542718d..63f6d9f2a692 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2428,10 +2428,8 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 
 		ret = wait_for_completion_timeout(&dwc->ep0_in_setup,
 				msecs_to_jiffies(DWC3_PULL_UP_TIMEOUT));
-		if (ret == 0) {
-			dev_err(dwc->dev, "timed out waiting for SETUP phase\n");
-			return -ETIMEDOUT;
-		}
+		if (ret == 0)
+			dev_warn(dwc->dev, "timed out waiting for SETUP phase\n");
 	}
 
 	/*
@@ -2643,6 +2641,7 @@ static int __dwc3_gadget_start(struct dwc3 *dwc)
 	/* begin to receive SETUP packets */
 	dwc->ep0state = EP0_SETUP_PHASE;
 	dwc->link_state = DWC3_LINK_STATE_SS_DIS;
+	dwc->delayed_status = false;
 	dwc3_ep0_out_start(dwc);
 
 	dwc3_gadget_enable_irq(dwc);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

