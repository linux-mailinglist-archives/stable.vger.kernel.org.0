Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4DC3EA94D
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 19:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235327AbhHLRRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 13:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235044AbhHLRRb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 13:17:31 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55787C061756
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 10:17:06 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id t9so14793267lfc.6
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 10:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LjrU9k0cXOS1w5BQXAwU+RejY/N5vivrkzc/UFmCECk=;
        b=vXvZTM5pSgzHzFrb56dPXE5fgDfw8i5/bcwGF/ZwWb4JEClBcZAe2v9pLNMa3hRCVN
         Aaod/ovXAexrExrElPgAWlAAHUglUkkwFAUmR5qsrSucybv+8p6z/DJOUEeS7vQSoreB
         EvM+gPAg0GftW98ZOrhHaTVwJNeQhomw76bJCCmSUYsl9RkvkCU5B2pI2GdmOENLLkAM
         G6MrHR5yKbDjLOgU9rTsp+oRlNTj7/CW/yruhlXBcp6BsPtRX3jLtYx1VrmWlAt237o1
         TgCnadyKwuuwwcFGYflx+QJfocS/6MpB4DBOa0CT9JePBypms9TnkHVBaw9edXp/2peS
         Wacg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LjrU9k0cXOS1w5BQXAwU+RejY/N5vivrkzc/UFmCECk=;
        b=YFu9yi5eFfTepabfdP77mv+7/9XyCUUGaPnPPIlUx8lnGrm3v3jyHtJwbybvlNvj/V
         rX4OXxI724LQe+yN9WE2N5lKcYm4u4bHjfUVToSQdfnLghPnDWdapDCSNlpZgKoDsxu+
         Cdl6B9jSnvNW5ajxf62cg2w/kI19223/8Vcu4DVGyGTqFGoM7DWAYdgeQkOVyID5DwaF
         gYI9Dm9Qgu12P5cx5QYne2s7bJKCCA0cZF5fEYGpuSk4NKqe0L9bkTyxPaTANGqERuHA
         cVR0KN3oQ/dIdtyLpljFoPYk6TAcO2FcZpVG1ubih7vJ8h6UabIJZ2zquYKGCKmVLTGn
         PKEg==
X-Gm-Message-State: AOAM5312jUiEIBRVemjoINHzrD0bujLF3gdIs+oUflrCEXjadn8PBCgO
        4sYgdZigjrRXbakkM6l0zvHBUg==
X-Google-Smtp-Source: ABdhPJyMtYHx4D1I39ZJCDL//pHiZzZ6JADJadgN9IU/sUBRquKxgvrEldHa5ZMH7FWGJSsj1MBIpw==
X-Received: by 2002:ac2:4852:: with SMTP id 18mr862714lfy.214.1628788624697;
        Thu, 12 Aug 2021 10:17:04 -0700 (PDT)
Received: from localhost ([31.134.121.151])
        by smtp.gmail.com with ESMTPSA id u10sm316738lft.252.2021.08.12.10.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 10:17:04 -0700 (PDT)
From:   Sam Protsenko <semen.protsenko@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 5.4 7/7] usb: dwc3: gadget: Avoid runtime resume if disabling pullup
Date:   Thu, 12 Aug 2021 20:16:52 +0300
Message-Id: <20210812171652.23803-8-semen.protsenko@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210812171652.23803-1-semen.protsenko@linaro.org>
References: <20210812171652.23803-1-semen.protsenko@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Cheng <wcheng@codeaurora.org>

[ Upstream commit cb10f68ad8150f243964b19391711aaac5e8ff42 ]

If the device is already in the runtime suspended state, any call to
the pullup routine will issue a runtime resume on the DWC3 core
device.  If the USB gadget is disabling the pullup, then avoid having
to issue a runtime resume, as DWC3 gadget has already been
halted/stopped.

This fixes an issue where the following condition occurs:

usb_gadget_remove_driver()
-->usb_gadget_disconnect()
 -->dwc3_gadget_pullup(0)
  -->pm_runtime_get_sync() -> ret = 0
  -->pm_runtime_put() [async]
-->usb_gadget_udc_stop()
 -->dwc3_gadget_stop()
  -->dwc->gadget_driver = NULL
...

dwc3_suspend_common()
-->dwc3_gadget_suspend()
 -->DWC3 halt/stop routine skipped, driver_data == NULL

This leads to a situation where the DWC3 gadget is not properly
stopped, as the runtime resume would have re-enabled EP0 and event
interrupts, and since we avoided the DWC3 gadget suspend, these
resources were never disabled.

Fixes: 77adb8bdf422 ("usb: dwc3: gadget: Allow runtime suspend if UDC unbinded")
Cc: stable <stable@vger.kernel.org>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Link: https://lore.kernel.org/r/1628058245-30692-1-git-send-email-wcheng@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 78a4b9e438b7..8a3752fcf7b4 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2018,6 +2018,17 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 		}
 	}
 
+	/*
+	 * Avoid issuing a runtime resume if the device is already in the
+	 * suspended state during gadget disconnect.  DWC3 gadget was already
+	 * halted/stopped during runtime suspend.
+	 */
+	if (!is_on) {
+		pm_runtime_barrier(dwc->dev);
+		if (pm_runtime_suspended(dwc->dev))
+			return 0;
+	}
+
 	/*
 	 * Check the return value for successful resume, or error.  For a
 	 * successful resume, the DWC3 runtime PM resume routine will handle
-- 
2.30.2

