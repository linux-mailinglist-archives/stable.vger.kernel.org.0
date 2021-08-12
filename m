Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DAD3EA948
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 19:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235249AbhHLRR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 13:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235375AbhHLRRZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 13:17:25 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DE0C061756
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 10:17:00 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id n7so11682994ljq.0
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 10:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b0JgbTAX05rhKAcAoEa4I+TuhbaN7/BKvLWyPaT2ewA=;
        b=tXxWh2R7Q04fvFaOX4Mi1p4yAIlSeLynJyvVgFTdgLI0nGusTh7Ex4px8x/dAwFBYP
         z6UvrIPr7fZ+SBmZEJrUerxYOX2YRDiPJAKqCtvzTv2aPaq4YKgv3hsp+4EpjW3U0/PC
         arl+Vn8vKrzx3SomkcD/mvO3z0qVrdaZNvIJak2r8UR+V8/POU+hikhHY8zuIi40jlTJ
         MdP+w4a02g9VUf0Ga9QIZkdCdVC1R/+zZ417WCoHELYIEh0QPEcF+sjr7EJnJpbVTo0a
         UPyuO7QIKH4Wy77hnM0P1TRrsvRXQ7OW/K3qrKeymyu/wU936uylC4lSTTTVQpDicF7I
         c1fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b0JgbTAX05rhKAcAoEa4I+TuhbaN7/BKvLWyPaT2ewA=;
        b=X8+ShRP7lUkV4+fSGn9bfS+EewU+JV7n55DoxXziE17NWoPHNnQzjCdydDj//1L+t+
         5MWOI43TBinHpr6X9PfhnA05eoueKjgSGKRTT6wcBrOl0dwZrIp+ODoUrIh7dDdqtZsY
         eXLSfRhSxqyI4BhMBCf5OD3sxS99KmtT0TUFCR2QzvNGeuz29Ca+KofE8E+4iWj4VtQ7
         gL06Nz7k0h1KvQJ0f1yHloziXL4Q3V4LOtQddxjMgS09iItrn5UWl7ABjbx5PuNX3ZgN
         FfftCfKwWKzLM1npkw9+/YliCOTKk+YBN8lthneoz98PpqKvc/2S+9ip6O/zmxhTvrUB
         96aw==
X-Gm-Message-State: AOAM533GWgU/3oubN8pN610wjyIrmPMTzSBPTTdXru6oFPHNlp+EbOUz
        dBDhHq16DO2sATY+EyCiP/Oosg==
X-Google-Smtp-Source: ABdhPJy981rThXcNhnLlCfos6IqgvpAqidzLp3UggM4WNMQPWTc6xxMI9VbORa2y89Id6l1xgr7nrg==
X-Received: by 2002:a05:651c:981:: with SMTP id b1mr2885652ljq.281.1628788618611;
        Thu, 12 Aug 2021 10:16:58 -0700 (PDT)
Received: from localhost ([31.134.121.151])
        by smtp.gmail.com with ESMTPSA id k44sm277730lfv.288.2021.08.12.10.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 10:16:58 -0700 (PDT)
From:   Sam Protsenko <semen.protsenko@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 5.4 3/7] usb: dwc3: gadget: Restart DWC3 gadget when enabling pullup
Date:   Thu, 12 Aug 2021 20:16:48 +0300
Message-Id: <20210812171652.23803-4-semen.protsenko@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210812171652.23803-1-semen.protsenko@linaro.org>
References: <20210812171652.23803-1-semen.protsenko@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Cheng <wcheng@codeaurora.org>

[ Upstream commit a1383b3537a7bea1c213baa7878ccc4ecf4413b5 ]

usb_gadget_deactivate/usb_gadget_activate does not execute the UDC start
operation, which may leave EP0 disabled and event IRQs disabled when
re-activating the function. Move the enabling/disabling of USB EP0 and
device event IRQs to be performed in the pullup routine.

Fixes: ae7e86108b12 ("usb: dwc3: Stop active transfers before halting the controller")
Tested-by: Michael Tretter <m.tretter@pengutronix.de>
Cc: stable <stable@vger.kernel.org>
Reported-by: Michael Tretter <m.tretter@pengutronix.de>
Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Link: https://lore.kernel.org/r/1609282837-21666-1-git-send-email-wcheng@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index bc655d637b86..e242174321d1 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1993,6 +1993,7 @@ static int dwc3_gadget_run_stop(struct dwc3 *dwc, int is_on, int suspend)
 
 static void dwc3_gadget_disable_irq(struct dwc3 *dwc);
 static void __dwc3_gadget_stop(struct dwc3 *dwc);
+static int __dwc3_gadget_start(struct dwc3 *dwc);
 
 static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 {
@@ -2067,6 +2068,8 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 						dwc->ev_buf->length;
 		}
 		dwc->connected = false;
+	} else {
+		__dwc3_gadget_start(dwc);
 	}
 
 	ret = dwc3_gadget_run_stop(dwc, is_on, false);
@@ -2244,10 +2247,6 @@ static int dwc3_gadget_start(struct usb_gadget *g,
 	}
 
 	dwc->gadget_driver	= driver;
-
-	if (pm_runtime_active(dwc->dev))
-		__dwc3_gadget_start(dwc);
-
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	return 0;
@@ -2273,13 +2272,6 @@ static int dwc3_gadget_stop(struct usb_gadget *g)
 	unsigned long		flags;
 
 	spin_lock_irqsave(&dwc->lock, flags);
-
-	if (pm_runtime_suspended(dwc->dev))
-		goto out;
-
-	__dwc3_gadget_stop(dwc);
-
-out:
 	dwc->gadget_driver	= NULL;
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
-- 
2.30.2

