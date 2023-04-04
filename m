Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448376D597D
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 09:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbjDDHZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 03:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233855AbjDDHZz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 03:25:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88DD211D;
        Tue,  4 Apr 2023 00:25:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0463262F78;
        Tue,  4 Apr 2023 07:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3355C433A1;
        Tue,  4 Apr 2023 07:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680593145;
        bh=iHqtt6aurKW7xgkS/ixqd4KPAJ1KczXFGt1nLIx2xMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K1n6F5eZDdBbjegK2Acko97lmDHxG+NTTtvQTtgWDZ3YLV/JkOFqyyTl9NugKPJKN
         6gwjOnmOfE3FaRi7du198wWXpF4+LvQC1SI97DtBu4fEtK6I0DFDOsjdNs+mMppL4C
         76xYgYCwRC9wRjJy8zW2E+QbsMVKdFpejzGBccOaJyWe5mQK53qH+4gTIuNyKhJI18
         +T4JjiQpt7J4cAMja2s/FvYaQ9kKOfw6hARV+9GpLlgAdq4a2LF82l25dX/+EqNF3y
         yXnuPq+x3JFQET+GIPHY1K+vEwqDlJc2iHkAeAGQGM5BPxqyJmJVrdujo3v6su/zGf
         W/QpAiQUCz/2A==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pjb3U-0004xQ-Lg; Tue, 04 Apr 2023 09:26:12 +0200
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH 01/11] USB: dwc3: fix runtime pm imbalance on probe errors
Date:   Tue,  4 Apr 2023 09:25:14 +0200
Message-Id: <20230404072524.19014-2-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404072524.19014-1-johan+linaro@kernel.org>
References: <20230404072524.19014-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure not to suspend the device when probe fails to avoid disabling
clocks and phys multiple times.

Fixes: 328082376aea ("usb: dwc3: fix runtime PM in error path")
Cc: stable@vger.kernel.org      # 4.8
Cc: Roger Quadros <rogerq@ti.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/usb/dwc3/core.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 476b63618511..5058bd8d56ca 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1883,13 +1883,11 @@ static int dwc3_probe(struct platform_device *pdev)
 	spin_lock_init(&dwc->lock);
 	mutex_init(&dwc->mutex);
 
+	pm_runtime_get_noresume(dev);
 	pm_runtime_set_active(dev);
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_set_autosuspend_delay(dev, DWC3_DEFAULT_AUTOSUSPEND_DELAY);
 	pm_runtime_enable(dev);
-	ret = pm_runtime_get_sync(dev);
-	if (ret < 0)
-		goto err1;
 
 	pm_runtime_forbid(dev);
 
@@ -1954,12 +1952,10 @@ static int dwc3_probe(struct platform_device *pdev)
 	dwc3_free_event_buffers(dwc);
 
 err2:
-	pm_runtime_allow(&pdev->dev);
-
-err1:
-	pm_runtime_put_sync(&pdev->dev);
-	pm_runtime_disable(&pdev->dev);
-
+	pm_runtime_allow(dev);
+	pm_runtime_disable(dev);
+	pm_runtime_set_suspended(dev);
+	pm_runtime_put_noidle(dev);
 disable_clks:
 	dwc3_clk_disable(dwc);
 assert_reset:
-- 
2.39.2

