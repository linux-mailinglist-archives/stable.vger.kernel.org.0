Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6338C64356D
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 21:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbiLEUQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 15:16:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233224AbiLEUP5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 15:15:57 -0500
Received: from mailfilter02-out40.webhostingserver.nl (mailfilter02-out40.webhostingserver.nl [195.211.72.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C209428729
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 12:15:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=exalondelft.nl; s=whs1;
        h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
         subject:cc:to:from:from;
        bh=AL68zLQaEqSRdRgznjgITv4ps8SL1cEIOEoowj++pC0=;
        b=LdS12PfvgO5v8km82BezuW5J7/N+8R0QJmVHg5WCv4c2rBVONAILw2o5N2+KXgYO91Zy0658TRUPf
         o8lpPyIMVCTlQe5ipASaefd3/OsYLGbhrvKQ8g3e+xtusdTdgrwBZilus7V2RkwbgPLhNF1V1Tlc0Z
         VS/3AT8MmDjNPk9ZfG4vyVS9VCF2K6futTKdwrkRfeXN/WpzXr55i6yaKmaMfgMrOiNOyfN2vkpaQ0
         wNtEah/xcTLXS0v28pHx1ZATXIeYXDSsFjdKg40jkO7SmBKqpbMC3HIPbbN/hGl8pW9xyB/r0wqcMW
         CVGeBWDep4K/pm9cCKIIhUumeLXMMmw==
X-Halon-ID: 9e8bd91a-74d9-11ed-aeca-001a4a4cb922
Received: from s198.webhostingserver.nl (s198.webhostingserver.nl [141.138.168.154])
        by mailfilter02.webhostingserver.nl (Halon) with ESMTPSA
        id 9e8bd91a-74d9-11ed-aeca-001a4a4cb922;
        Mon, 05 Dec 2022 21:15:53 +0100 (CET)
Received: from 2a02-a466-68ed-1-f633-1bb8-92a6-ba5d.fixed6.kpn.net ([2a02:a466:68ed:1:f633:1bb8:92a6:ba5d] helo=delfion.fritz.box)
        by s198.webhostingserver.nl with esmtpa (Exim 4.96)
        (envelope-from <ftoth@exalondelft.nl>)
        id 1p2HsX-001b54-0z;
        Mon, 05 Dec 2022 21:15:53 +0100
From:   Ferry Toth <ftoth@exalondelft.nl>
To:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Liu Shixin <liushixin2@huawei.com>,
        Ferry Toth <fntoth@gmail.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ferry Toth <ftoth@exalondelft.nl>, stable@vger.kernel.org
Subject: [PATCH v5 2/2] usb: dwc3: core: defer probe on ulpi_read_id timeout
Date:   Mon,  5 Dec 2022 21:15:27 +0100
Message-Id: <20221205201527.13525-3-ftoth@exalondelft.nl>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221205201527.13525-1-ftoth@exalondelft.nl>
References: <20221205201527.13525-1-ftoth@exalondelft.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit 0f0101719138 ("usb: dwc3: Don't switch OTG -> peripheral
if extcon is present"), Dual Role support on Intel Merrifield platform
broke due to rearranging the call to dwc3_get_extcon().

It appears to be caused by ulpi_read_id() masking the timeout on the first
test write. In the past dwc3 probe continued by calling dwc3_core_soft_reset()
followed by dwc3_get_extcon() which happend to return -EPROBE_DEFER.
On deferred probe ulpi_read_id() finally succeeded. Due to above mentioned
rearranging -EPROBE_DEFER is not returned and probe completes without phy.

On Intel Merrifield the timeout on the first test write issue is reproducible
but it is difficult to find the root cause. Using a mainline kernel and
rootfs with buildroot ulpi_read_id() succeeds. As soon as adding
ftrace / bootconfig to find out why, ulpi_read_id() fails and we can't
analyze the flow. Using another rootfs ulpi_read_id() fails even without
adding ftrace. We suspect the issue is some kind of timing / race, but
merely retrying ulpi_read_id() does not resolve the issue.

As we now changed ulpi_read_id() to return -ETIMEDOUT in this case, we
need to handle the error by calling dwc3_core_soft_reset() and request
-EPROBE_DEFER. On deferred probe ulpi_read_id() is retried and succeeds.

Fixes: ef6a7bcfb01c ("usb: ulpi: Support device discovery via DT")
Cc: stable@vger.kernel.org
Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>
---
 drivers/usb/dwc3/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 648f1c570021..2779f17bffaf 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1106,8 +1106,13 @@ static int dwc3_core_init(struct dwc3 *dwc)
 
 	if (!dwc->ulpi_ready) {
 		ret = dwc3_core_ulpi_init(dwc);
-		if (ret)
+		if (ret) {
+			if (ret == -ETIMEDOUT) {
+				dwc3_core_soft_reset(dwc);
+				ret = -EPROBE_DEFER;
+			}
 			goto err0;
+		}
 		dwc->ulpi_ready = true;
 	}
 
-- 
2.37.2

