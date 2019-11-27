Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBD4510BB3B
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733089AbfK0VKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:10:51 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:32818 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733085AbfK0VKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 16:10:51 -0500
Received: from mailhost.synopsys.com (sv2-mailhost1.synopsys.com [10.205.2.133])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C0336C00A7;
        Wed, 27 Nov 2019 21:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1574889049; bh=0psXz4JKqYmr/UJM2TBc2EQhoyhnFwk0WYHPemkXBi0=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=CAR3WbKa52q1/aE8HKHPV/5e50Uunb4OjRAHfQc8iEf7O201DLtcu5Gw2dye5oLHB
         M6Y48pEIkSH3hp4c1fuhqDLVqwOzNX1mR+OX56i9JCmveLIdQvgUcQ8h/jlgS318RO
         6g4GD5VtpXyV1rtXAsGmbcJPnLTwbmm8BuAVrlt7MRdcR9Kx6KTzLiuwqV4exneFwT
         xHKlo06bJ/ZA+SyXhyfVLs0cFlTu7lKUnvtWAIrATa/e8yhbZjsYY5tk137bTN2Gqw
         YnQOLo4ZW4I6AMiWl4/d0yzXN7w+uGriPGUN44LVFNLn8YSW3IPmN+33sTLeiFtE8S
         VXgiuOqzmMH5A==
Received: from te-lab16 (nanobot.internal.synopsys.com [10.10.186.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 1C2E7A007C;
        Wed, 27 Nov 2019 21:10:48 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Wed, 27 Nov 2019 13:10:47 -0800
Date:   Wed, 27 Nov 2019 13:10:47 -0800
Message-Id: <a0f9399b9959d8e5ad9ae9be8572a03dd2314589.1574888929.git.thinhn@synopsys.com>
In-Reply-To: <cover.1574888929.git.thinhn@synopsys.com>
References: <cover.1574888929.git.thinhn@synopsys.com>
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 1/2] usb: dwc3: gadget: Clear started flag for non-IOC
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Normally the END_TRANSFER command completion handler will clear the
DWC3_EP_TRANSFER_STARTED flag. However, if the command was sent without
interrupt on completion, then the flag will not be cleared. Make sure to
clear the flag in this case.

Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
---
 drivers/usb/dwc3/gadget.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 7f97856e6b20..95a0b2e7ecea 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2716,6 +2716,9 @@ static void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force,
 	WARN_ON_ONCE(ret);
 	dep->resource_index = 0;
 
+	if (!interrupt)
+		dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
+
 	if (dwc3_is_usb31(dwc) || dwc->revision < DWC3_REVISION_310A)
 		udelay(100);
 }
-- 
2.11.0

