Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9CF19C9A7
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389290AbgDBTNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:36 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37350 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388989AbgDBTNg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:36 -0400
Received: by mail-wm1-f66.google.com with SMTP id j19so4941270wmi.2
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=686Vsso/oibsZGiqpPZXeguTG8OFUTkPMQsHeo3SBbo=;
        b=i7HBmfEbR8sLxGdoUoXBXlldxuqtJChupcvUfLr9M1v2N87QNypo8v34DRUucv6UmX
         sXiWA1IKcTb1GmQ16umao9pBbXQeCRsbnn9FONyJLZ3E7aBeyd5jjZ1G6GUpxLUZhRxI
         hr6R76gmYsCUW+MjC1kv26wuQC5eZwp5DIPTE42QS9uz0VQkD/8zHEv8akIlFBZJA4F1
         TjD6cHUE7GHG+6OYdjxWo3FYuu9bm4a/0FwTjgQonpNQdPwpTI+wOqe35qsTx0w9OHuv
         BnBb5CV2YkpSEGqJRKtEcZ9QtPIVlXhcZOlJi+ObMG6UIVHpCPXsme7jHj53tUG2Cu35
         +8yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=686Vsso/oibsZGiqpPZXeguTG8OFUTkPMQsHeo3SBbo=;
        b=bev0SaEcVmf3In5iPHGg2+5lVMBm8Wxlj+SxvhKVNOg6A5iW7nyYQik4u8I7ea7yy5
         MgcvjYYsI8jo//Yywn00GyENcK3oKGWF7MWcN6jvPISK7DzdG7AwQizGl17QSAuhZoTn
         ZCKifwgMlemxwGA0pqbo3MXdN4ygKwffwEQBS0AU4fhEQRReO0kKK3uGkUvDc/nSggsF
         38LLW+8nRLwDoSgbfcvDGeR8iPVIiha3fdUW6RzstvBPFIEHtpDniV/T+pxwqXxlV55l
         HECbVolVYgtyF0LdtK/18MR3aeP00NNTBrUiPSRD5gM7qf96MueEtDt3L4OcXou/HUxO
         Vfrw==
X-Gm-Message-State: AGi0PuZytjb1ZxPFzIRc7Xdzg42eA7ymaHEZhWlu/VYDMHrfwhDN5NaM
        00qnqMGNAfu+levsU38F+Oe/aAGAGXaJ9g==
X-Google-Smtp-Source: APiQypIcv5AR5ce9rN2xhqTX0OC96R0Ee80igBVt5LCrEtbSU9FNdPI9DXOe/1FCMzPQtzg8WjcavQ==
X-Received: by 2002:a1c:6505:: with SMTP id z5mr630433wmb.28.1585854814265;
        Thu, 02 Apr 2020 12:13:34 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:33 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 32/33] usb: dwc3: don't set gadget->is_otg flag
Date:   Thu,  2 Apr 2020 20:13:52 +0100
Message-Id: <20200402191353.787836-32-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
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
index e96b22d6fa52e..76a0020b0f2e8 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3257,7 +3257,6 @@ int dwc3_gadget_init(struct dwc3 *dwc)
 	dwc->gadget.speed		= USB_SPEED_UNKNOWN;
 	dwc->gadget.sg_supported	= true;
 	dwc->gadget.name		= "dwc3-gadget";
-	dwc->gadget.is_otg		= dwc->dr_mode == USB_DR_MODE_OTG;
 
 	/*
 	 * FIXME We might be setting max_speed to <SUPER, however versions
-- 
2.25.1

