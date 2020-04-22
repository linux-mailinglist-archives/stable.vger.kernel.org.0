Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B645B1B431A
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgDVLUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 07:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726812AbgDVLUd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 07:20:33 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBEAC03C1A9
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:32 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x18so1939044wrq.2
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tivNM/PEWJwAHGJj+MV6vEaMnomGFhEGX1VywED1rVs=;
        b=TsWHUHPIAAGKQUxOls/HGDOWRvbuRNxazFNW/ZKnhdIsqn4doHdp41ID/nO/jR0OqI
         LMHSfSGeGRglRnxzWWFWd1m2o6w6nrldccAOMT4wrMIWAU16r4FjaJjecadzkrTKC7dc
         kq/yXhEKPGpICzR78J1l8C5Nn1vIVd5iQfCNbnjTffLOIJjnPZJkKWiWaL7hiYY1XRHf
         LzUP91/lU3gyMW/MJ+LEzJ3IoF1Ie+OEKhjtnePIYis9/5g4g8nnsl9iTC89OZ5VwHgg
         SKtmeW+KdWVZzt5JQD3SMH465En7Ts5T+AMx1Ru9mNi2dC2IcTRxeEg4eJekKlAUiiZD
         n01A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tivNM/PEWJwAHGJj+MV6vEaMnomGFhEGX1VywED1rVs=;
        b=K7yBtyoOpUt9szps259gJiaPak4YPE47C+78tr3JqijZafgNT/p4Lfd9of6wlLGhit
         gmC/ouw+Wipd4kOcljCOe9JmlYgWCX8/fobThutX0gKK6kA7D4jQxvof1HfHnI/5MW1A
         LKab0q6MRmYlncMKJgEuvfE7wu/2+eWNsd51S6Dt/DKul6iBbtIQzolABM6ysd6C8cXp
         l6p5cQq1pHWG6s/4s9kOFAJHaY9YRGTlVzg5zDRIbNEfdvsFdn0s2eAdDbUuJSxSxpFF
         BdctiHxNk3yrQZG5ix/oTAo/590ITQdiZHHSorNjuEG9dH2ncldEIgTLqzLc5W/AKm5/
         sTTw==
X-Gm-Message-State: AGi0PuadQ/T7eKWL7NKYBirrI0/yseW72aQMhwX+ncuokh1TctOMw3hS
        vWbViajxpjDa3gzPrce432GGDwi5Xf8=
X-Google-Smtp-Source: APiQypKl+dGjLDF8REV4SA0gv576SkBB0rT5/7FN96os/kXVXoZV2k/giCAOsAXm43yjY9PBYisCRA==
X-Received: by 2002:adf:a74b:: with SMTP id e11mr120257wrd.99.1587554431438;
        Wed, 22 Apr 2020 04:20:31 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id n6sm8247255wrs.81.2020.04.22.04.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 04:20:30 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Roger Quadros <rogerq@ti.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 21/21] usb: dwc3: don't set gadget->is_otg flag
Date:   Wed, 22 Apr 2020 12:19:57 +0100
Message-Id: <20200422111957.569589-22-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200422111957.569589-1-lee.jones@linaro.org>
References: <20200422111957.569589-1-lee.jones@linaro.org>
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
index 712bd450f8573..bf36eda082d65 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2996,7 +2996,6 @@ int dwc3_gadget_init(struct dwc3 *dwc)
 	dwc->gadget.speed		= USB_SPEED_UNKNOWN;
 	dwc->gadget.sg_supported	= true;
 	dwc->gadget.name		= "dwc3-gadget";
-	dwc->gadget.is_otg		= dwc->dr_mode == USB_DR_MODE_OTG;
 
 	/*
 	 * FIXME We might be setting max_speed to <SUPER, however versions
-- 
2.25.1

