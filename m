Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C14345ECA7
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 12:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344269AbhKZLd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 06:33:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239743AbhKZLb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 06:31:27 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77BEC061D73
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 02:50:19 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id l190so7814325pge.7
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 02:50:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CCHFJxxsdX+DmEApgNw9BkhjpFB9zppcHHtRUaYVLaQ=;
        b=TksuyglKyZG6tsHN7PLqWMKDh+fiB7/PZFu7q98MqJ1AqcTbl5rOeRIRmzuU9fkL2r
         3jeLsHUjBHn6Oj2Q2bmHsVPKUNeXr6pdPzcgbaxnqjtrPunmdruGkustO/oPzjW57tbN
         R6GoOMH1xn0EN5D2WHzJ+asHRmWxXJhKRPHcrmVMA2EWpX7lEqDiAlmddXBp6eUAMSP4
         QWJaY1AZeZSJLoGG0785APc6ZQH/21pRd1k1jfc+mq1+wuMhiM8V0BGFRMysZ1X7pXw9
         ZmzpQO+r3io5CTHpy2Ys1DRO+hjcBoKthsjr5OesnMthTUmcqGUCecIPVkEC9BClVj/I
         z45w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CCHFJxxsdX+DmEApgNw9BkhjpFB9zppcHHtRUaYVLaQ=;
        b=oEZvhaRYr2LOfMhfA5xQ2z9XMQThxITLyP9tUFXqaGnq+WQKh5TR9RsH4S2rOKHKaJ
         Y7fM8OsUz4cfl5I5SwVy8+AnBRSemnCIMbAN9dB70jGWZCGGbuQI3f1ubF9q6J+BdJJ8
         VKiy3FS9HgBrWtWQZutBSqpQSXKZ2T1dTuDAY4YMutb4AtYA5iVhuKDTFfXshAcn6MJ6
         txTaU++8WOPfGPcxs1EH64enKsMDRJtzcoiT/scZPX2g4hVTYncGw2tYxhTwtJuuNG7u
         IkgslAhih5pjsX0hbRhkObX6nyTc8UE1K7kA6FIVOYis9MGPLUZvCnWRf9+8eTGDpYJa
         fQRw==
X-Gm-Message-State: AOAM530m1ghTjlz3TKncYdjQ+iLXsv94iRJw3TmY2tjUeyhL6CPKFTwF
        VlQUnyVhVo+rUyotTG81aCmJ
X-Google-Smtp-Source: ABdhPJz0N+2woirIzl2W9de+xjq8Ufw5l0Ic8eqq7+4NVf9XiphAYqFIaD5HMM42E0tsdGhPBinWJA==
X-Received: by 2002:aa7:8394:0:b0:4a7:e88c:284b with SMTP id u20-20020aa78394000000b004a7e88c284bmr15115851pfm.10.1637923819097;
        Fri, 26 Nov 2021 02:50:19 -0800 (PST)
Received: from localhost.localdomain ([117.215.117.247])
        by smtp.gmail.com with ESMTPSA id 95sm5277452pjo.2.2021.11.26.02.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 02:50:18 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     mhi@lists.linux.dev, slark_xiao@163.com,
        linux-arm-msm@vger.kernel.org, hemantk@codeaurora.org,
        stable@vger.kernel.org, Manivannan Sadhasivam <mani@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 1/1] bus: mhi: pci_generic: Fix device recovery failed issue
Date:   Fri, 26 Nov 2021 16:19:51 +0530
Message-Id: <20211126104951.35685-2-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211126104951.35685-1-manivannan.sadhasivam@linaro.org>
References: <20211126104951.35685-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Slark Xiao <slark_xiao@163.com>

For Foxconn T99W175 device(sdx55 platform) in some host platform,
it would be unavailable once the host execute the err handler.

After checking, it's caused by the delay time too short to
get a successful reset.

Please see my test evidence as bewlow(BTW, I add some extra test logs
in function mhi_pci_reset_prepare and mhi_pci_reset_done):
  When MHI_POST_RESET_DELAY_MS equals to 500ms:
   Nov  4 14:30:03 jbd-ThinkEdge kernel: [  146.222477] mhi mhi0: Device MHI is not in valid state
   Nov  4 14:30:03 jbd-ThinkEdge kernel: [  146.222628] mhi-pci-generic 0000:2d:00.0: mhi_pci_reset_prepare reset
   Nov  4 14:30:03 jbd-ThinkEdge kernel: [  146.222631] mhi-pci-generic 0000:2d:00.0: mhi_pci_reset_prepare mhi_soc_reset
   Nov  4 14:30:03 jbd-ThinkEdge kernel: [  146.222632] mhi mhi0:  mhi_soc_reset write soc to reset
   Nov  4 14:30:05 jbd-ThinkEdge kernel: [  147.839993] mhi-pci-generic 0000:2d:00.0: mhi_pci_reset_done
   Nov  4 14:30:05 jbd-ThinkEdge kernel: [  147.902063] mhi-pci-generic 0000:2d:00.0: reset failed

  When MHI_POST_RESET_DELAY_MS equals to 1000ms or 1500ms:
   Nov  4 19:07:26 jbd-ThinkEdge kernel: [  157.067857] mhi mhi0: Device MHI is not in valid state
   Nov  4 19:07:26 jbd-ThinkEdge kernel: [  157.068029] mhi-pci-generic 0000:2d:00.0: mhi_pci_reset_prepare reset
   Nov  4 19:07:26 jbd-ThinkEdge kernel: [  157.068032] mhi-pci-generic 0000:2d:00.0: mhi_pci_reset_prepare mhi_soc_reset
   Nov  4 19:07:26 jbd-ThinkEdge kernel: [  157.068034] mhi mhi0:  mhi_soc_reset write soc to reset
   Nov  4 19:07:29 jbd-ThinkEdge kernel: [  159.607006] mhi-pci-generic 0000:2d:00.0: mhi_pci_reset_done
   Nov  4 19:07:29 jbd-ThinkEdge kernel: [  159.607152] mhi mhi0: Requested to power ON
   Nov  4 19:07:51 jbd-ThinkEdge kernel: [  181.302872] mhi mhi0: Failed to reset MHI due to syserr state
   Nov  4 19:07:51 jbd-ThinkEdge kernel: [  181.303011] mhi-pci-generic 0000:2d:00.0: failed to power up MHI controller

  When MHI_POST_RESET_DELAY_MS equals to 2000ms:
   Nov  4 17:51:08 jbd-ThinkEdge kernel: [  147.180527] mhi mhi0: Failed to transition from PM state: Linkdown or Error Fatal Detect to: SYS ERROR Process
   Nov  4 17:51:08 jbd-ThinkEdge kernel: [  147.180535] mhi mhi0: Device MHI is not in valid state
   Nov  4 17:51:08 jbd-ThinkEdge kernel: [  147.180722] mhi-pci-generic 0000:2d:00.0: mhi_pci_reset_prepare reset
   Nov  4 17:51:08 jbd-ThinkEdge kernel: [  147.180725] mhi-pci-generic 0000:2d:00.0: mhi_pci_reset_prepare mhi_soc_reset
   Nov  4 17:51:08 jbd-ThinkEdge kernel: [  147.180727] mhi mhi0:  mhi_soc_reset write soc to reset
   Nov  4 17:51:11 jbd-ThinkEdge kernel: [  150.230787] mhi-pci-generic 0000:2d:00.0: mhi_pci_reset_done
   Nov  4 17:51:11 jbd-ThinkEdge kernel: [  150.230928] mhi mhi0: Requested to power ON
   Nov  4 17:51:11 jbd-ThinkEdge kernel: [  150.231173] mhi mhi0: Power on setup success
   Nov  4 17:51:14 jbd-ThinkEdge kernel: [  153.254747] mhi mhi0: Wait for device to enter SBL or Mission mode

I also tried big data like 3000, and it worked as well. 500ms may not be
enough for all support mhi device. We shall increase it to 2000ms
at least.

Cc: stable@vger.kernel.org
Fixes: 8ccc3279fcad ("mhi: pci_generic: Add support for reset")
Signed-off-by: Slark Xiao <slark_xiao@163.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://lore.kernel.org/r/20211108113127.3938-1-slark_xiao@163.com
[mani: massaged commit message little bit, added Fixes tag and CCed stable]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/pci_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
index 59a4896a8030..4c577a731709 100644
--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -20,7 +20,7 @@
 
 #define MHI_PCI_DEFAULT_BAR_NUM 0
 
-#define MHI_POST_RESET_DELAY_MS 500
+#define MHI_POST_RESET_DELAY_MS 2000
 
 #define HEALTH_CHECK_PERIOD (HZ * 2)
 
-- 
2.25.1

