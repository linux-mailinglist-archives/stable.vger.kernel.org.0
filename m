Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D3034A905
	for <lists+stable@lfdr.de>; Fri, 26 Mar 2021 14:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhCZNwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Mar 2021 09:52:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:41260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230059AbhCZNwA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Mar 2021 09:52:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA6AB61971;
        Fri, 26 Mar 2021 13:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616766720;
        bh=3MbDvhRRev3YlswQlMrxxWHF8oVtN5Vo41wYrjcIOlY=;
        h=Subject:To:From:Date:From;
        b=Fm53XHKmlpiFfdQUT12ikasLoo89zgHgJ8nvfju+mj5lCMbElzh7PxBjuAGpbOl4a
         BHDol8zu3IWmkOnKthmz3DEDra3bXh8MW/VxaHiZVtIz3ltzyaOQFQRrV3wdm52/IJ
         7eelrWUDlp6doq6GFl9gcxlAGqeUKMwt2o8C2f1w=
Subject: patch "usb: dwc2: Prevent core suspend when port connection flag is 0" added to usb-linus
To:     Arthur.Petrosyan@synopsys.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 26 Mar 2021 14:51:45 +0100
Message-ID: <16167667054646@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc2: Prevent core suspend when port connection flag is 0

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 93f672804bf2d7a49ef3fd96827ea6290ca1841e Mon Sep 17 00:00:00 2001
From: Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Date: Fri, 26 Mar 2021 14:25:09 +0400
Subject: usb: dwc2: Prevent core suspend when port connection flag is 0

In host mode port connection status flag is "0" when loading
the driver. After loading the driver system asserts suspend
which is handled by "_dwc2_hcd_suspend()" function. Before
the system suspend the port connection status is "0". As
result need to check the "port_connect_status" if it is "0",
then skipping entering to suspend.

Cc: <stable@vger.kernel.org> # 5.2
Fixes: 6f6d70597c15 ("usb: dwc2: bus suspend/resume for hosts with DWC2_POWER_DOWN_PARAM_NONE")
Signed-off-by: Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Link: https://lore.kernel.org/r/20210326102510.BDEDEA005D@mailhost.synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/hcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index 40e5655921bf..1a9789ec5847 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -4322,7 +4322,8 @@ static int _dwc2_hcd_suspend(struct usb_hcd *hcd)
 	if (hsotg->op_state == OTG_STATE_B_PERIPHERAL)
 		goto unlock;
 
-	if (hsotg->params.power_down > DWC2_POWER_DOWN_PARAM_PARTIAL)
+	if (hsotg->params.power_down != DWC2_POWER_DOWN_PARAM_PARTIAL ||
+	    hsotg->flags.b.port_connect_status == 0)
 		goto skip_power_saving;
 
 	/*
-- 
2.31.0


