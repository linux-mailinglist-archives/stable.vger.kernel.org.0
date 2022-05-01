Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55EC051656F
	for <lists+stable@lfdr.de>; Sun,  1 May 2022 18:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350834AbiEAQzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 May 2022 12:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352572AbiEAQye (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 May 2022 12:54:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429D624976
        for <stable@vger.kernel.org>; Sun,  1 May 2022 09:50:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B211EB80E98
        for <stable@vger.kernel.org>; Sun,  1 May 2022 16:50:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685DBC385BC;
        Sun,  1 May 2022 16:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651423849;
        bh=j+vOT3OBH3iHXOVNVhu/JLJFqfdEh9gBXjjerIX85JM=;
        h=Subject:To:Cc:From:Date:From;
        b=PXTtpA+zSfPLM6ElJ3eBEMRxPAdzHQgUjEkIfNj92VC3P3qscxZiCIdQN5s+v2vGh
         NAFLrdMxrspvUyWfZkUB9rfujJeM7LSYTdctxezaRdujL9T1gjItmIz9M2ooJS4FAq
         UBkTVtvlMKYNZa0XUkfN89g4S3VX2ujLbyHiDOvE=
Subject: FAILED: patch "[PATCH] usb: dwc3: core: Only handle soft-reset in DCTL" failed to apply to 5.4-stable tree
To:     Thinh.Nguyen@synopsys.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 01 May 2022 18:44:30 +0200
Message-ID: <165142347045148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f4fd84ae0765a80494b28c43b756a95100351a94 Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Thu, 21 Apr 2022 19:33:56 -0700
Subject: [PATCH] usb: dwc3: core: Only handle soft-reset in DCTL

Make sure not to set run_stop bit or link state change request while
initiating soft-reset. Register read-modify-write operation may
unintentionally start the controller before the initialization completes
with its previous DCTL value, which can cause initialization failure.

Fixes: f59dcab17629 ("usb: dwc3: core: improve reset sequence")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/6aecbd78328f102003d40ccf18ceeebd411d3703.1650594792.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 1ca9dae57855..d28cd1a6709b 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -274,7 +274,8 @@ int dwc3_core_soft_reset(struct dwc3 *dwc)
 
 	reg = dwc3_readl(dwc->regs, DWC3_DCTL);
 	reg |= DWC3_DCTL_CSFTRST;
-	dwc3_writel(dwc->regs, DWC3_DCTL, reg);
+	reg &= ~DWC3_DCTL_RUN_STOP;
+	dwc3_gadget_dctl_write_safe(dwc, reg);
 
 	/*
 	 * For DWC_usb31 controller 1.90a and later, the DCTL.CSFRST bit

