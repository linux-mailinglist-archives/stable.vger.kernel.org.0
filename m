Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA9D34A908
	for <lists+stable@lfdr.de>; Fri, 26 Mar 2021 14:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhCZNwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Mar 2021 09:52:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229986AbhCZNvz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Mar 2021 09:51:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B5C861A18;
        Fri, 26 Mar 2021 13:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616766714;
        bh=caXpoE+bwEEORKCuGz7kGHuHrxHcWYk0kbCWAhnS1RQ=;
        h=Subject:To:From:Date:From;
        b=0XrmNuXOFy31d+mbTKr/2LPAHWWf2ZVvZfOoJTBK6GgAZiBY1mavPSD4rtMnDNWwR
         RWHNpwFxwG+Rk6u7M68he4/WB4VKBqTjT/lcdFYXaAxm4ncKbDyzXlGMDipOHc7B4S
         grtcM7t31fU7c7j7CA4Wg6gyPQeZWubj3LnOzowo=
Subject: patch "usb: dwc2: Fix HPRT0.PrtSusp bit setting for HiKey 960 board." added to usb-linus
To:     Arthur.Petrosyan@synopsys.com, Minas.Harutyunyan@synopsys.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 26 Mar 2021 14:51:44 +0100
Message-ID: <1616766704148224@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc2: Fix HPRT0.PrtSusp bit setting for HiKey 960 board.

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5e3bbae8ee3d677a0aa2919dc62b5c60ea01ba61 Mon Sep 17 00:00:00 2001
From: Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Date: Fri, 26 Mar 2021 14:24:46 +0400
Subject: usb: dwc2: Fix HPRT0.PrtSusp bit setting for HiKey 960 board.

Increased the waiting timeout for HPRT0.PrtSusp register field
to be set, because on HiKey 960 board HPRT0.PrtSusp wasn't
generated with the existing timeout.

Cc: <stable@vger.kernel.org> # 4.18
Fixes: 22bb5cfdf13a ("usb: dwc2: Fix host exit from hibernation flow.")
Signed-off-by: Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Acked-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Link: https://lore.kernel.org/r/20210326102447.8F7FEA005D@mailhost.synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/hcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index fc3269f5faf1..40e5655921bf 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -5398,7 +5398,7 @@ int dwc2_host_enter_hibernation(struct dwc2_hsotg *hsotg)
 	dwc2_writel(hsotg, hprt0, HPRT0);
 
 	/* Wait for the HPRT0.PrtSusp register field to be set */
-	if (dwc2_hsotg_wait_bit_set(hsotg, HPRT0, HPRT0_SUSP, 3000))
+	if (dwc2_hsotg_wait_bit_set(hsotg, HPRT0, HPRT0_SUSP, 5000))
 		dev_warn(hsotg->dev, "Suspend wasn't generated\n");
 
 	/*
-- 
2.31.0


