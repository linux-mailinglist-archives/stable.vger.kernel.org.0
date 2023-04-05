Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80C816D77AE
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 11:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237358AbjDEJDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 05:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237156AbjDEJDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 05:03:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21130E72;
        Wed,  5 Apr 2023 02:03:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A86956232B;
        Wed,  5 Apr 2023 09:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66D2C433D2;
        Wed,  5 Apr 2023 09:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680685411;
        bh=AreqL9r3Yew0sS4T15gu7pKjtnVtIobuhUST+Klm1yw=;
        h=From:To:Cc:Subject:Date:From;
        b=HoiMD4ktg4vcT8DaHpg95N0uDYOIuwAtTu2tfk+coIc2mMWV6gChq++iSqy5GykFX
         HsPr8Dfx6UHNDwBRT5AOUI1VEZr549y6Ej+TP7escZ2cXIw8oILL7x+eaOybITT5rl
         xD50WscOk53x55uLD1MX3jI0CW6KoWP4hm/rbhn5pr52oA7Ar7lIAh0ME6Q9OIQRR2
         2bWp4TYd8i3s17V7Mv4qpDVmINkt4yHhGLXaszEz6Z9HrWUZFqneAmiYmAkXVuvT/V
         kJDAVELtV17iGrnfjzO+EvHHJsvDzmL+oMHSyBoXILjYpc88XGh7hqUoB6aPruoF7A
         jC6d0+RFBprLg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pjz3h-0001uw-Vn; Wed, 05 Apr 2023 11:04:02 +0200
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Mathias Nyman <mathias.nyman@intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] xhci: fix debugfs register accesses while suspended
Date:   Wed,  5 Apr 2023 11:03:42 +0200
Message-Id: <20230405090342.7363-1-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.2
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

Wire up the debugfs regset device pointer so that the controller is
resumed before accessing registers to avoid crashing or locking up if it
happens to be runtime suspended.

Fixes: 02b6fdc2a153 ("usb: xhci: Add debugfs interface for xHCI driver")
Cc: stable@vger.kernel.org # 4.15: 30332eeefec8: debugfs: regset32: Add Runtime PM support
Cc: stable@vger.kernel.org # 4.15
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/usb/host/xhci-debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/xhci-debugfs.c b/drivers/usb/host/xhci-debugfs.c
index 0bc7fe11f749..99baa60ef50f 100644
--- a/drivers/usb/host/xhci-debugfs.c
+++ b/drivers/usb/host/xhci-debugfs.c
@@ -133,6 +133,7 @@ static void xhci_debugfs_regset(struct xhci_hcd *xhci, u32 base,
 	regset->regs = regs;
 	regset->nregs = nregs;
 	regset->base = hcd->regs + base;
+	regset->dev = hcd->self.controller;
 
 	debugfs_create_regset32((const char *)rgs->name, 0444, parent, regset);
 }
-- 
2.39.2

