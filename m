Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32B27CB703
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 11:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730427AbfJDJEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 05:04:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfJDJEh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 05:04:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7AFB207FF;
        Fri,  4 Oct 2019 09:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570179876;
        bh=/vNnduyW4qIhtyadsCero3VjP5rbhr+1vMhAHY4buYo=;
        h=Subject:To:From:Date:From;
        b=1nAIr7qRnjZqCxv4d1UWVEDZuwJ5dldRKBhjO308dQIBu+LoUgKEY7f0pYy2uirPt
         BEpAB4MtXyf5X3FSJ8CNSDeYkVIsO/23NHfC0NukpUY7PYT7kWV+DQ1DAZnISCVStv
         pTyP8I0tmbUoJQz+ty3l1Q9vupt3noDBonst4O0A=
Subject: patch "USB: dummy-hcd: fix power budget for SuperSpeed mode" added to usb-linus
To:     Jacky.Cao@sony.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Oct 2019 11:04:12 +0200
Message-ID: <1570179852116123@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: dummy-hcd: fix power budget for SuperSpeed mode

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 2636d49b64671d3d90ecc4daf971b58df3956519 Mon Sep 17 00:00:00 2001
From: "Jacky.Cao@sony.com" <Jacky.Cao@sony.com>
Date: Thu, 5 Sep 2019 04:11:57 +0000
Subject: USB: dummy-hcd: fix power budget for SuperSpeed mode

The power budget for SuperSpeed mode should be 900 mA
according to USB specification, so set the power budget
to 900mA for dummy_start_ss which is only used for
SuperSpeed mode.

If the max power consumption of SuperSpeed device is
larger than 500 mA, insufficient available bus power
error happens in usb_choose_configuration function
when the device connects to dummy hcd.

Signed-off-by: Jacky Cao <Jacky.Cao@sony.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/16EA1F625E922C43B00B9D82250220500871CDE5@APYOKXMS108.ap.sony.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/dummy_hcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/dummy_hcd.c b/drivers/usb/gadget/udc/dummy_hcd.c
index 8414fac74493..3d499d93c083 100644
--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -48,6 +48,7 @@
 #define DRIVER_VERSION	"02 May 2005"
 
 #define POWER_BUDGET	500	/* in mA; use 8 for low-power port testing */
+#define POWER_BUDGET_3	900	/* in mA */
 
 static const char	driver_name[] = "dummy_hcd";
 static const char	driver_desc[] = "USB Host+Gadget Emulator";
@@ -2432,7 +2433,7 @@ static int dummy_start_ss(struct dummy_hcd *dum_hcd)
 	dum_hcd->rh_state = DUMMY_RH_RUNNING;
 	dum_hcd->stream_en_ep = 0;
 	INIT_LIST_HEAD(&dum_hcd->urbp_list);
-	dummy_hcd_to_hcd(dum_hcd)->power_budget = POWER_BUDGET;
+	dummy_hcd_to_hcd(dum_hcd)->power_budget = POWER_BUDGET_3;
 	dummy_hcd_to_hcd(dum_hcd)->state = HC_STATE_RUNNING;
 	dummy_hcd_to_hcd(dum_hcd)->uses_new_polling = 1;
 #ifdef CONFIG_USB_OTG
-- 
2.23.0


