Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDD6A19C9C7
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389069AbgDBTRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:17:23 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38028 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388452AbgDBTRX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:17:23 -0400
Received: by mail-wr1-f65.google.com with SMTP id c7so5587913wrx.5
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=tivNM/PEWJwAHGJj+MV6vEaMnomGFhEGX1VywED1rVs=;
        b=UOdamzfSwkhpyTPC+9IvvOBkzPiVIpmr3X6LAJfJNCGon+oL2xCZur5kEsAiT64bTM
         j7KMD+I9ATH2k+0/+v2zjnr+X3QzNnZdDsW7f73xkI2A2Ud1qlUvmebGPEor02+CVVnw
         RCl+eauMiNL8RVZl7wPSql7C6HskUJ9aT3c4RqZNKLAKmNE/AK0rMNR9MmvCH/a/VRU2
         TjuDOPfWq00hDGjvMM2PYFHqYAvHD1CnVhmFeHrlIdxIsNddAZPoqt/0CFxR6rBsNevZ
         pf1vY9OJaDk9Al68GkXB5fNubhIXFSeUbRuluRw9NuInCIW7BNdsJAfrCLgwnbVpKngL
         lP+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tivNM/PEWJwAHGJj+MV6vEaMnomGFhEGX1VywED1rVs=;
        b=hsoywLJ1nWmPQm2x1YXUWiPOoV16Ft6V6AeCQ+bWbU0Sjry7jW972qDSiuwsob6Bv8
         euIF8RTlqRUfl9ZrKwqvGvSorhytXB4CVb2PAIm/S3wGUioHaYZZYBjN7GAEusx+Koye
         CiLmZrnGvEtUbBDsm6LgGrcMdVjxKfducANLz54c1voJiL8DZP22JOAvowtKxbZOC0iB
         aL7ojY9v1leHxiebYESLu8mTPiQKj4VBAzvAyDOFyAlnNwwSyZf0GfrDj/P+SGYFg9a6
         uo+Z6dY96bx0IPptWsFANgKpxgjBv8BgPLOCJ1aV8M9Hxl5mn45q8a+kj0IBBMeex7VX
         m/gQ==
X-Gm-Message-State: AGi0PuZoeWlDBRhuuykmWmCnI4Aq2TP8FP1eGdk5J8961HtmCsX+2dwZ
        kKV4NjVUQXaNAGSpcKgkifv0vN/5wPLVtQ==
X-Google-Smtp-Source: APiQypJoImhX0wrzHjvMxFAHCxbM4QN+eXeDREW0GvdLbTqIXepYpTqUZFrVDb9bXkZ2gv2WatDlNw==
X-Received: by 2002:adf:e288:: with SMTP id v8mr3552652wri.141.1585855038813;
        Thu, 02 Apr 2020 12:17:18 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y1sm879050wmd.14.2020.04.02.12.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:17:17 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 23/24] usb: dwc3: don't set gadget->is_otg flag
Date:   Thu,  2 Apr 2020 20:17:46 +0100
Message-Id: <20200402191747.789097-23-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191747.789097-1-lee.jones@linaro.org>
References: <20200402191747.789097-1-lee.jones@linaro.org>
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

