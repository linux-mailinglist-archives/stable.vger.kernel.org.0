Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D529B3AFDF5
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 09:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhFVHgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 03:36:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229695AbhFVHgY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Jun 2021 03:36:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61CEB6113D;
        Tue, 22 Jun 2021 07:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624347248;
        bh=pkRjf1RTpsl/PZ/tOuMY2bEGTT5yHlw/QusZXAs54tk=;
        h=Subject:To:From:Date:From;
        b=SwnzKzI/s6niM28hRbygJ0u2wWE6962bQBh18Fsgr4WMZu5/Ms/FlL2QkRfNrrsw+
         ja+mehkNioZ+twdXSU/w3amrnI1XN8bMV3flOztD9WOrSaqBbnygukbgDTgHdus2m4
         whOv0NcJHgM2PuPcu8G8TnUPOXb3BbTR+//8pEyk=
Subject: patch "usb: dwc3: Fix debugfs creation flow" added to usb-next
To:     Minas.Harutyunyan@synopsys.com, gregkh@linuxfoundation.org,
        jackp@codeaurora.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 22 Jun 2021 09:32:54 +0200
Message-ID: <162434717412587@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: Fix debugfs creation flow

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 84524d1232ecca7cf8678e851b254f05cff4040a Mon Sep 17 00:00:00 2001
From: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Date: Thu, 17 Jun 2021 09:55:24 -0700
Subject: usb: dwc3: Fix debugfs creation flow

Creation EP's debugfs called earlier than debugfs folder for dwc3
device created. As result EP's debugfs are created in '/sys/kernel/debug'
instead of '/sys/kernel/debug/usb/dwc3.1.auto'.

Moved dwc3_debugfs_init() function call before calling
dwc3_core_init_mode() to allow create dwc3 debugfs parent before
creating EP's debugfs's.

Fixes: 8d396bb0a5b6 ("usb: dwc3: debugfs: Add and remove endpoint dirs dynamically")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Jack Pham <jackp@codeaurora.org>
Signed-off-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Link: https://lore.kernel.org/r/01fafb5b2d8335e98e6eadbac61fc796bdf3ec1a.1623948457.git.Minas.Harutyunyan@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index e0a8e796c158..ba74ad7f6995 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1620,17 +1620,18 @@ static int dwc3_probe(struct platform_device *pdev)
 	}
 
 	dwc3_check_params(dwc);
+	dwc3_debugfs_init(dwc);
 
 	ret = dwc3_core_init_mode(dwc);
 	if (ret)
 		goto err5;
 
-	dwc3_debugfs_init(dwc);
 	pm_runtime_put(dev);
 
 	return 0;
 
 err5:
+	dwc3_debugfs_exit(dwc);
 	dwc3_event_buffers_cleanup(dwc);
 
 	usb_phy_shutdown(dwc->usb2_phy);
-- 
2.32.0


