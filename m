Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39A2439195
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 10:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbhJYInR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 04:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbhJYInR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 04:43:17 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244D3C061745
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 01:40:55 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id y78so4633511wmc.0
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 01:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=PXO9vIvASbXW/KezcJEkCWT7bDbSSwlLiI7vdiVw5cE=;
        b=znCzIaxlm6qkunSFMXwlFrJ6COaG7wwhBk1n9z+BxFvEO40H/JYCrbOJJGbYyw52u5
         gbNlnl15ZcuoUAOlAMQcI2dp4ZEbZsbv+4lpEnSR2FlHsiS+5HAlNzBu+KOsVpHZxC3y
         Gm3Cijl6MSIp6jb+ewgMJ65/+KTQxyYiOE4rurEiNj73Jx4mu4rQ4H17syVd6WpOmJfr
         2On03RxstJ0STrzbEvBS/upsmGXgUhQk+eCxdHvN7VNZ4tsdFCc5cx70X0HLoRFvkKue
         M0zcJ7UQWwIATfYnfiSUCOQb+AGaBew6d9HUtHQLVeIIoh0fhCq8iBXHTLTP+aK0cqHn
         rRuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PXO9vIvASbXW/KezcJEkCWT7bDbSSwlLiI7vdiVw5cE=;
        b=gOaDDqYSDHRCM8iEMOXl41JzQgYWDWMm2eEAnysZHce0WAYPuKXMuscHtsBaMTeOh/
         AiZftLc0X1xqjVXRsCbHw0TKjEnZ4UenlqYEMqOz10GhWmKOx+cFbBsriZ4PClT+wtNR
         bDlDxcEziesJQ9gDy6QAGIun2wGJ3JdIM1d3SoTvmJUkIP/z/a4PQjgz6FDKw9v0mtF6
         X7xU/W+H8dXA1VNyMqLpa8Wz4y/RGgRWq/Zq48tSE48f/tYzS+7HtINwvh1amLeQqSKi
         VY0TAz5sfS+NH5ffrtvN2Wvk1KZCT4GbSREUZ7ox12pSlWjb/xUTijZy4DeiCAdhvO03
         tVVQ==
X-Gm-Message-State: AOAM530XrrMSJ+XICcjokbr5rSYtGH6QqvL/8Dxewzy7kLD/+loH2NjK
        5K/QEagViTtYkGAbF4vCLiPMdsk8ZA0=
X-Google-Smtp-Source: ABdhPJwbsL5sfXXoXBA09rJMwqJ+FinTCoxAqG4Vn/lbZZbZ5xxQTAqk0lkApv+lXgjEi+Y749fOZg==
X-Received: by 2002:a1c:ac03:: with SMTP id v3mr48056418wme.13.1635151253493;
        Mon, 25 Oct 2021 01:40:53 -0700 (PDT)
Received: from localhost.localdomain ([88.160.176.23])
        by smtp.gmail.com with ESMTPSA id u1sm9239414wrt.97.2021.10.25.01.40.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Oct 2021 01:40:53 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     mani@kernel.org
Cc:     linux-arm-msm@vger.kernel.org, hemantk@codeaurora.org,
        bbhatt@codeaurora.org, Loic Poulain <loic.poulain@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] mhi: pci_generic: Graceful shutdown on freeze
Date:   Mon, 25 Oct 2021 10:52:20 +0200
Message-Id: <1635151940-22147-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is no reason for shutting down MHI ungracefully on freeze,
this causes the MHI host stack & device stack to not be aligned
anymore since the proper MHI reset sequence is not performed for
ungraceful shutdown.

Cc: stable@vger.kernel.org
Fixes: 5f0c2ee1fe8d ("bus: mhi: pci-generic: Fix hibernation")
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/bus/mhi/pci_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
index 6a42425..d4a3ce2 100644
--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -1018,7 +1018,7 @@ static int __maybe_unused mhi_pci_freeze(struct device *dev)
 	 * context.
 	 */
 	if (test_and_clear_bit(MHI_PCI_DEV_STARTED, &mhi_pdev->status)) {
-		mhi_power_down(mhi_cntrl, false);
+		mhi_power_down(mhi_cntrl, true);
 		mhi_unprepare_after_power_down(mhi_cntrl);
 	}
 
-- 
2.7.4

