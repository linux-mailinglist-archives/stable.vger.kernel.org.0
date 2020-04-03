Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE1819D697
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 14:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403929AbgDCMSk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 08:18:40 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55430 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403925AbgDCMSj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 08:18:39 -0400
Received: by mail-wm1-f68.google.com with SMTP id r16so6926683wmg.5
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 05:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0AIBR/Fbp1+bL9hbHwPNzEV1sMWpxsi1yYPh/RkQmpU=;
        b=eq6a9O1f0AGpU3Ni8cr30IVsPzWOnyKRrPuz5xUhx12UATiza/Lk7qMHoS8tyY7zfg
         ahYcx/yFFdAU4RWltG201UG/FcLaFn30oYhsBH0BmngwNeQuYRbEoOMcsrGsUtNfYVz4
         D1Ti8MqXroavUlpVQmv4dDi45XSNUt5tUTtC81vHc6KIdfGwOOW05YiVZcKgW/KpqPJq
         r4E+LSPBKxvdcw0KxM3viR71qb1tSAp+VCy2oXVkL1anFVDEgABAspyE0ZPniyB6q1Yg
         LePO7chJsUrPU0h0rVRfOMyugqK7Hma6kVgj1DSKvVEivwg4SKcirKy6e3Jy0ierj+GV
         o7QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0AIBR/Fbp1+bL9hbHwPNzEV1sMWpxsi1yYPh/RkQmpU=;
        b=ADA8sCtYGlpymeVQ6lnkmBRrnAkFRraJTRMRtVdRq1nzFwqFtTue97FwWb+NDqWgp8
         HK/Zr6+LBKB6vulof3EzzkGKsJbASyUU3zZbjH+y7OgXfqKMeNZxV+j/mPM2E7YAkusc
         2Tiquf3nva4LIjSL9ak0WS2cnNRhNnjPHkif+m1fwXSTjHJRkpS1UTqo+Nw3oHDGH9Wq
         MjiF+JMRBGSouLQgLR8XNiR1pBP6B4Q4x7cfCG1RMnFkdJCX+GXgJKn+JzYoOPtRYFvQ
         gR4Sj5bdJGNHKXVpQbQIuzoZQ3AR0tOiaTTU1VQBAAReL8kANOtfX824ufWATt2znwTN
         vXQA==
X-Gm-Message-State: AGi0PuabJWX4VHJS2NJqsTpkIOYgbLEv+5SRhrePOINzaQ6GwxwZOLSS
        FI5adgnKzhGwb9Z/yIpynmGOjJjiq0w=
X-Google-Smtp-Source: APiQypLbp7e3Mr+JPo3b0j1LAtIoGzRMcgCzwI4cYhipPSfzTSSfhqtwubIlZDZZCEiE8OSlE8u2uw==
X-Received: by 2002:a05:600c:34c:: with SMTP id u12mr8351015wmd.186.1585916318063;
        Fri, 03 Apr 2020 05:18:38 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.179])
        by smtp.gmail.com with ESMTPSA id l185sm11377712wml.44.2020.04.03.05.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 05:18:37 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Roger Quadros <rogerq@ti.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.19 13/13] usb: dwc3: don't set gadget->is_otg flag
Date:   Fri,  3 Apr 2020 13:18:59 +0100
Message-Id: <20200403121859.901838-14-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200403121859.901838-1-lee.jones@linaro.org>
References: <20200403121859.901838-1-lee.jones@linaro.org>
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

