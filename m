Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3399362E632
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 21:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbiKQUzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 15:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239716AbiKQUzn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 15:55:43 -0500
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 17 Nov 2022 12:55:42 PST
Received: from mailfilter01-out40.webhostingserver.nl (mailfilter01-out40.webhostingserver.nl [195.211.73.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A748D7FF2F
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 12:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=exalondelft.nl; s=whs1;
        h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
         subject:cc:to:from:from;
        bh=c3TOJ8pLm5BTTzG2jJheyd3COeod2HsVvmxYNZzeA0Y=;
        b=OitFVDhGl+xE2L/yPPVmM2x/+/zb0GEoILRwTaL/meW8inP2r9oXA9+HZ+L7SCnbZ3RD+HrihIz9a
         OnHHU2AE/+fstcLs8lM6JOSHNo2Gqc76oE2DzIpHI/qghZvrb+YZ0WtQvQucS9LXhgRKRgkIBPCEIt
         RcqHnVW1glSUtUKKKa8/tQHne9fEMujKdoYnNbRU9lOUyr23XxItvw8dDdXivoZRCyXiTR7BHlDhZs
         DR8x/hidI+6685pGo3LWrkiZ4qM8Xr2NVwp/yyqswuFz2pK0A1qrvq5NhHHYlqsVRrNq/bB5ryK2fS
         dcEaMExaVLZ3ujtlwbzcP4KtA84ZikA==
X-Halon-ID: 0c702c26-66ba-11ed-a6af-001a4a4cb906
Received: from s198.webhostingserver.nl (s198.webhostingserver.nl [141.138.168.154])
        by mailfilter01.webhostingserver.nl (Halon) with ESMTPSA
        id 0c702c26-66ba-11ed-a6af-001a4a4cb906;
        Thu, 17 Nov 2022 21:54:37 +0100 (CET)
Received: from 2a02-a466-68ed-1-6f6f-9a68-8ab0-3e9e.fixed6.kpn.net ([2a02:a466:68ed:1:6f6f:9a68:8ab0:3e9e] helo=delfion.fritz.box)
        by s198.webhostingserver.nl with esmtpa (Exim 4.96)
        (envelope-from <ftoth@exalondelft.nl>)
        id 1ovlu9-0054mk-31;
        Thu, 17 Nov 2022 21:54:38 +0100
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
        stable@vger.kernel.org, Ferry Toth <ftoth@exalondelft.nl>
Subject: [PATCH v3 2/2] usb: dwc3: core: defer probe on ulpi_read_id timeout
Date:   Thu, 17 Nov 2022 21:54:11 +0100
Message-Id: <20221117205411.11489-3-ftoth@exalondelft.nl>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221117205411.11489-1-ftoth@exalondelft.nl>
References: <20221117205411.11489-1-ftoth@exalondelft.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit 0f010171
Dual Role support on Intel Merrifield platform broke due to rearranging
the call to dwc3_get_extcon().

It appears to be caused by ulpi_read_id() masking the timeout on the first
test write. In the past dwc3 probe continued by calling dwc3_core_soft_reset()
followed by dwc3_get_extcon() which happend to return -EPROBE_DEFER.
On deferred probe ulpi_read_id() finally succeeded.

As we now changed ulpi_read_id() to return -ETIMEDOUT in this case, we
need to handle the error by calling dwc3_core_soft_reset() and request
-EPROBE_DEFER. On deferred probe ulpi_read_id() is retried and succeeds.

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

