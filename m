Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA1C50B8C3
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 15:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357995AbiDVNmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 09:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381342AbiDVNmW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 09:42:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D87158E5F
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 06:39:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE74D620B3
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 13:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A2BC385A0;
        Fri, 22 Apr 2022 13:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650634768;
        bh=UKzl8h/4LWhFP7qD53Jxr/Ms50DytroeJbF4Nc6kmco=;
        h=Subject:To:From:Date:From;
        b=2lSMHcQEOEotWxtjX3b9rhDJuGpaC0hIbeH621B5tXoTyQ+PRojY+e6aX8nvOmatE
         kZfC5cDnvw6GbGHE4hEDtLajayohh8zoRaoVkcChoS4gC2KTw+G/1zsmnPXleuyJ26
         ouJ6WXAPafC0Ic6Lvy1gsOz2L/vyTa/SJl/oWD2Y=
Subject: patch "usb: dwc3: core: Only handle soft-reset in DCTL" added to usb-linus
To:     Thinh.Nguyen@synopsys.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 22 Apr 2022 15:39:25 +0200
Message-ID: <165063476515911@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: core: Only handle soft-reset in DCTL

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f4fd84ae0765a80494b28c43b756a95100351a94 Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Thu, 21 Apr 2022 19:33:56 -0700
Subject: usb: dwc3: core: Only handle soft-reset in DCTL

Make sure not to set run_stop bit or link state change request while
initiating soft-reset. Register read-modify-write operation may
unintentionally start the controller before the initialization completes
with its previous DCTL value, which can cause initialization failure.

Fixes: f59dcab17629 ("usb: dwc3: core: improve reset sequence")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/6aecbd78328f102003d40ccf18ceeebd411d3703.1650594792.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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
-- 
2.36.0


