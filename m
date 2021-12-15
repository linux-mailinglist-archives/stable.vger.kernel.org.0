Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDFB9475F96
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbhLORnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232645AbhLORnj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:43:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060DFC061574
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 09:43:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2DE1B82029
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 17:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FD5C36AE3;
        Wed, 15 Dec 2021 17:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639590216;
        bh=Y5W29O5vV0a1LXLzha/4bU6Pk/PCYcouJ5VqIs7q7sI=;
        h=Subject:To:From:Date:From;
        b=a6BHZXGg6TXWM0iV1pyZFISBG9Db8HY15SXXUU6ZPTtASGmeUyhE+gvOId8kYwbG+
         j6t1ntWTJCqgkb42sI/2bpAB85UsGcOdgftwhLVmnNZCopj6coW0T1m0ak/2QUyaiK
         NQYvcfFGrvpS+5U9HiqfjqbH6q8YeeC3aT1UrKRY=
Subject: patch "usb: dwc2: fix STM ID/VBUS detection startup delay in" added to usb-linus
To:     amelie.delaunay@foss.st.com, Minas.Harutyunyan@synopsys.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Dec 2021 18:43:33 +0100
Message-ID: <163959021395244@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc2: fix STM ID/VBUS detection startup delay in

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From fac6bf87c55f7f0733efb0375565fb6a50cf2caf Mon Sep 17 00:00:00 2001
From: Amelie Delaunay <amelie.delaunay@foss.st.com>
Date: Tue, 7 Dec 2021 13:45:10 +0100
Subject: usb: dwc2: fix STM ID/VBUS detection startup delay in
 dwc2_driver_probe

When activate_stm_id_vb_detection is enabled, ID and Vbus detection relies
on sensing comparators. This detection needs time to stabilize.
A delay was already applied in dwc2_resume() when reactivating the
detection, but it wasn't done in dwc2_probe().
This patch adds delay after enabling STM ID/VBUS detection. Then, ID state
is good when initializing gadget and host, and avoid to get a wrong
Connector ID Status Change interrupt.

Fixes: a415083a11cc ("usb: dwc2: add support for STM32MP15 SoCs USB OTG HS and FS")
Cc: stable <stable@vger.kernel.org>
Acked-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/20211207124510.268841-1-amelie.delaunay@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/platform.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index c8f18f3ba9e3..c331a5128c2c 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -575,6 +575,9 @@ static int dwc2_driver_probe(struct platform_device *dev)
 		ggpio |= GGPIO_STM32_OTG_GCCFG_IDEN;
 		ggpio |= GGPIO_STM32_OTG_GCCFG_VBDEN;
 		dwc2_writel(hsotg, ggpio, GGPIO);
+
+		/* ID/VBUS detection startup time */
+		usleep_range(5000, 7000);
 	}
 
 	retval = dwc2_drd_init(hsotg);
-- 
2.34.1


