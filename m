Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86CF4225AD
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 13:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbhJELv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 07:51:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230500AbhJELvY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 07:51:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6617761244;
        Tue,  5 Oct 2021 11:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633434573;
        bh=/2WlDXtCTfuy6HsykQv4xRXXanM2m2ygCrEeECVklJ4=;
        h=Subject:To:From:Date:From;
        b=A4LgAbj23NVDUKiDYfh9wkQFUcJqZZIDOVEOzsaxO+hY3ijuNVYA8wBUXnZ2rBMfm
         Mddvtllj/CQK+kSdeR2pBLDCwBLVTE7bW1zziH9Sf6XgjiLr/RIbfVhodptD9Amndm
         EJ3bjatdzNRzBbffvZubSw1R+5In0Tfu8yV+K5Hg=
Subject: patch "usb: cdc-wdm: Fix check for WWAN" added to usb-linus
To:     rikard.falkeborn@gmail.com, gregkh@linuxfoundation.org,
        oneukum@suse.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 Oct 2021 13:49:31 +0200
Message-ID: <1633434571634@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: cdc-wdm: Fix check for WWAN

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 04d2b75537085cb0c85d73a2e0e50317bffa883f Mon Sep 17 00:00:00 2001
From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Date: Wed, 29 Sep 2021 21:45:46 +0200
Subject: usb: cdc-wdm: Fix check for WWAN

CONFIG_WWAN_CORE was with CONFIG_WWAN in commit 89212e160b81 ("net: wwan:
Fix WWAN config symbols"), but did not update all users of it. Change it
back to use CONFIG_WWAN instead.

Fixes: 89212e160b81 ("net: wwan: Fix WWAN config symbols")
Cc: <stable@vger.kernel.org>
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20210929194547.46954-2-rikard.falkeborn@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-wdm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 35d5908b5478..fdf79bcf7eb0 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -824,7 +824,7 @@ static struct usb_class_driver wdm_class = {
 };
 
 /* --- WWAN framework integration --- */
-#ifdef CONFIG_WWAN_CORE
+#ifdef CONFIG_WWAN
 static int wdm_wwan_port_start(struct wwan_port *port)
 {
 	struct wdm_device *desc = wwan_port_get_drvdata(port);
@@ -963,11 +963,11 @@ static void wdm_wwan_rx(struct wdm_device *desc, int length)
 	/* inbuf has been copied, it is safe to check for outstanding data */
 	schedule_work(&desc->service_outs_intr);
 }
-#else /* CONFIG_WWAN_CORE */
+#else /* CONFIG_WWAN */
 static void wdm_wwan_init(struct wdm_device *desc) {}
 static void wdm_wwan_deinit(struct wdm_device *desc) {}
 static void wdm_wwan_rx(struct wdm_device *desc, int length) {}
-#endif /* CONFIG_WWAN_CORE */
+#endif /* CONFIG_WWAN */
 
 /* --- error handling --- */
 static void wdm_rxwork(struct work_struct *work)
-- 
2.33.0


