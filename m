Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5376A2141D0
	for <lists+stable@lfdr.de>; Sat,  4 Jul 2020 00:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbgGCWvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jul 2020 18:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbgGCWvD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jul 2020 18:51:03 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F231C061794;
        Fri,  3 Jul 2020 15:51:03 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id d16so22417379edz.12;
        Fri, 03 Jul 2020 15:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HoJnjAdizKBcZS/TwdGFdcCHABPJEEKDcGriqvJQXl8=;
        b=Aiyn4tkw+Jk2iDxJZDgHIBFvm9nZgBHvWtXlIUf9vqGwapr6RkAV3nJJskM7upei6H
         V5qqqpyT33351Iiuer3bl4rf1DwooFpyugOWE8idDf5lgT8JqUUh0gaU0voAiFM6BJs5
         Nxgyl6jmvNUejqWCQ2gYSWLQBfPR0AatS5MhiyhXA+tHVoNztHf31QL2Njn+TeW0zM6n
         noHEoDYP266+Ds2VpCDzJiAnf/p/mKwoz1q4mzR0ZV26P0O7uDdYJrwHUARVKap0UZwk
         zxxQExzAGCVKv56hc7Jbxx7AT4Al4J9HfvMg4eNadGN6Sk6Jyt/gdaebsu/lrh/9OXlA
         6jng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HoJnjAdizKBcZS/TwdGFdcCHABPJEEKDcGriqvJQXl8=;
        b=j0u5W56Br2Ey5btpQRCvcAHoaKqAHIoGSDYWSQZ2STNA4W2na5N6Aq0S66H7pNVvJu
         rPW5BWZdqY/iupKQgEZ6DLZ/aJuzpmZWK1ZPJF7kLioyIAJxwDH3SitwaZPFqiAZasws
         0RBIFsxd0Sipy6zRN4dgW1GQe+xBA6eCuirwPO+Tz4R/2iJleViuWAEROCaIx6sOCy9E
         OAoIejxxA2ISSxPhSOICM4eS5kV1ZES2tdTdC5QNIfIX2zpMhi/0gpDxtu7nQk7SlRSk
         OxT76n3W+osXAV49SomAmqQfDBxZOvX/osJz7uQ04OvycDFsUrCq6yTCJnT6LmHF6Qd/
         687Q==
X-Gm-Message-State: AOAM530AliTeFH9LfLboLeddmAGT2AvePcInC6eQYmWCte3H4RSYW4j5
        cPqhz6uYQXptrN9vtUuDiD8AbMqW
X-Google-Smtp-Source: ABdhPJwzOg7dxuPJBFeLCeyTj/hsz8BnW4Iwx8qroFdpbIfmXqPMr62Dvp/Am75GDKR2JIvVscEi+Q==
X-Received: by 2002:aa7:d3ca:: with SMTP id o10mr44560137edr.138.1593816661803;
        Fri, 03 Jul 2020 15:51:01 -0700 (PDT)
Received: from localhost.localdomain (p200300f1372b7a00428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:372b:7a00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id q25sm10440839ejz.97.2020.07.03.15.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 15:51:00 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     hminas@synopsys.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marex@denx.de,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH for-5.8 v2] usb: dwc2: Add missing cleanups when usb_add_gadget_udc() fails
Date:   Sat,  4 Jul 2020 00:50:43 +0200
Message-Id: <20200703225043.387769-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Call dwc2_debugfs_exit() and dwc2_hcd_remove() (if the HCD was enabled
earlier) when usb_add_gadget_udc() has failed. This ensures that the
debugfs entries created by dwc2_debugfs_init() as well as the HCD are
cleaned up in the error path.

Fixes: 207324a321a866 ("usb: dwc2: Postponed gadget registration to the udc class driver")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
Changes since v1 at [0]
- also cleanup the HCD as suggested by Minas (thank you!)
- updated the subject accordingly


[0] https://patchwork.kernel.org/patch/11631381/


 drivers/usb/dwc2/platform.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index c347d93eae64..9febae441069 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -582,12 +582,16 @@ static int dwc2_driver_probe(struct platform_device *dev)
 		retval = usb_add_gadget_udc(hsotg->dev, &hsotg->gadget);
 		if (retval) {
 			dwc2_hsotg_remove(hsotg);
-			goto error_init;
+			goto error_debugfs;
 		}
 	}
 #endif /* CONFIG_USB_DWC2_PERIPHERAL || CONFIG_USB_DWC2_DUAL_ROLE */
 	return 0;
 
+error_debugfs:
+	dwc2_debugfs_exit(hsotg);
+	if (hsotg->hcd_enabled)
+		dwc2_hcd_remove(hsotg);
 error_init:
 	if (hsotg->params.activate_stm_id_vb_detection)
 		regulator_disable(hsotg->usb33d);
-- 
2.27.0

