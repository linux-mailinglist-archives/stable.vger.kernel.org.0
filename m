Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A235F19C982
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731892AbgDBTLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:11:44 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36202 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389300AbgDBTLo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:11:44 -0400
Received: by mail-wm1-f68.google.com with SMTP id d202so4962992wmd.1
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=0AIBR/Fbp1+bL9hbHwPNzEV1sMWpxsi1yYPh/RkQmpU=;
        b=ufXA8Oc/iUdNyM66V8ojp5G07h2ci4rxmG5al1cypMqIVATJZ6Vq5aEOFbk4MkP4S/
         abXbQTnCFBCa5jdYDasbHu7+ZR8fD3dcokDwE5/vaYBzgwjVAFL4X9vTW97A5rjENzNZ
         L78EGwvOEj23BhIRYj/dHBktCWA+N3gHOa3stDkQcjcZFeQfOEQZm5K0POObq5Yk5J+Q
         QUIBVNMTh1/FVU4qs1mrLgvhLzGYDaB/qt3AvZlk6BMvaKil6kQZK3sDWP4t/+4FZgnk
         MLwnvcleufC/gjeHZPWRGkAd49weqztrrBh1OXhwKZomImZJCHsVOwpPxAp0OkrjIDAN
         flhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0AIBR/Fbp1+bL9hbHwPNzEV1sMWpxsi1yYPh/RkQmpU=;
        b=Z4THoE3RwNYnmPGFJVuRXbU8qzhpS8HcBLwBKAPt69bPhfm/fW5EFxF9Z6Z+zLvf0Q
         lclRb6hH9qp/5L1/ktRN7w2GvS8Sv8nIgZmGg8ASVZtmN9/rbklUZ1m2J3tKwbI5JM2K
         OyF+NNasI6RAG2mO5LstmOiEM/NH67yr0NrUR+CtdB5fnY9VAO42QQrAW/h+I0OJBLZh
         0CTatFLJMSSnvbs183PsEdzuc+5b9SShOuDmWPYFUO2Kv1kkuIUT7aqaptmAiezASTqu
         r2LRS7RhMXguQDojDLRUVYbZBRB+kci042SXCO5MMVit4B2EKYyYqRW27CCs7R3Bt9Zk
         BCEw==
X-Gm-Message-State: AGi0PuYBIbXN8YjSHdspWlQUSN28LgqY0STtinb/u1yr1r0YHMb6pDjK
        veDnaxKYLrtmY5vw/qrMQhvxyjVvKqkiLA==
X-Google-Smtp-Source: APiQypI644GUVorFjUXsJh2EJFKPXskXczJvmNNn+pJS3eHxlN5NcgExeZL3Al+91k/+n++VDkKKGw==
X-Received: by 2002:a7b:c401:: with SMTP id k1mr4708719wmi.152.1585854701169;
        Thu, 02 Apr 2020 12:11:41 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id s15sm8442164wrt.16.2020.04.02.12.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:11:40 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 13/14] usb: dwc3: don't set gadget->is_otg flag
Date:   Thu,  2 Apr 2020 20:12:19 +0100
Message-Id: <20200402191220.787381-13-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191220.787381-1-lee.jones@linaro.org>
References: <20200402191220.787381-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

[ Upstream commit c09b73cfac2a9317f1104169045c519c6021aa1d ]

This reverts
commit 6a4290cc28be1 ("usb: dwc3: gadget: set the OTG flag in dwc3 gadget driver.")

We don't yet support any of the OTG mechanisms (HNP/SRP/ADP)
and are not setting gadget->otg_caps, so don't set gadget->is_otg
flag.

If we do then we end up publishing a OTG1.0 descriptor in
the gadget descriptor which causes device enumeration to fail
if we are connected to a host with CONFIG_USB_OTG enabled.

Host side log without this patch

[   96.720453] usb 1-1: new high-speed USB device number 2 using xhci-hcd
[   96.901391] usb 1-1: Dual-Role OTG device on non-HNP port
[   96.907552] usb 1-1: set a_alt_hnp_support failed: -32
[   97.060447] usb 1-1: new high-speed USB device number 3 using xhci-hcd
[   97.241378] usb 1-1: Dual-Role OTG device on non-HNP port
[   97.247536] usb 1-1: set a_alt_hnp_support failed: -32
[   97.253606] usb usb1-port1: attempt power cycle
[   97.960449] usb 1-1: new high-speed USB device number 4 using xhci-hcd
[   98.141383] usb 1-1: Dual-Role OTG device on non-HNP port
[   98.147540] usb 1-1: set a_alt_hnp_support failed: -32
[   98.300453] usb 1-1: new high-speed USB device number 5 using xhci-hcd
[   98.481391] usb 1-1: Dual-Role OTG device on non-HNP port
[   98.487545] usb 1-1: set a_alt_hnp_support failed: -32
[   98.493532] usb usb1-port1: unable to enumerate USB device

Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/usb/dwc3/gadget.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index d482f89ffae2d..773d5dcaefcfb 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3166,7 +3166,6 @@ int dwc3_gadget_init(struct dwc3 *dwc)
 	dwc->gadget.speed		= USB_SPEED_UNKNOWN;
 	dwc->gadget.sg_supported	= true;
 	dwc->gadget.name		= "dwc3-gadget";
-	dwc->gadget.is_otg		= dwc->dr_mode == USB_DR_MODE_OTG;
 
 	/*
 	 * FIXME We might be setting max_speed to <SUPER, however versions
-- 
2.25.1

