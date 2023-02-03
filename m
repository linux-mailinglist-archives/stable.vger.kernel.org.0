Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAA36895E1
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbjBCKWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:22:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233222AbjBCKWC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:22:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6054F93AD9
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:21:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 034C3B82A6F
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C366C433EF;
        Fri,  3 Feb 2023 10:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419700;
        bh=86x9vvKHbucsBW2OPMoE2wOAMraFJXYuGgdCZbln5+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mZ+Iv3rWHGQjmgodHorn1yuckQ8Jqd61tUHBm6FHUpzSJSSBXLWHoxsz2IRfFuOrS
         3i2xhCxC+b6w7UdcoSkpFD6QZuH5GkfQsGcQrdyGSDpOx/h4EhBmxwULwE3HE2kNnf
         WOJg1t5XpnFTkIt131P9hfiGvNfbgyVHIoHrRyO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Matthias Kaehlcke <mka@chromium.org>,
        Peter Chen <peter.chen@nxp.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 4.19 80/80] usb: host: xhci-plat: add wakeup entry at sysfs
Date:   Fri,  3 Feb 2023 11:13:14 +0100
Message-Id: <20230203101018.686081716@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

commit 4bb4fc0dbfa23acab9b762949b91ffd52106fe4b upstream.

With this change, there will be a wakeup entry at /sys/../power/wakeup,
and the user could use this entry to choose whether enable xhci wakeup
features (wake up system from suspend) or not.

Tested-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200918131752.16488-6-mathias.nyman@linux.intel.com
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-plat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -261,7 +261,7 @@ static int xhci_plat_probe(struct platfo
 			*priv = *priv_match;
 	}
 
-	device_wakeup_enable(hcd->self.controller);
+	device_set_wakeup_capable(&pdev->dev, true);
 
 	xhci->clk = clk;
 	xhci->reg_clk = reg_clk;


