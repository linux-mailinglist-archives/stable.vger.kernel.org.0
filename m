Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13DD0282937
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 08:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbgJDGlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Oct 2020 02:41:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgJDGlI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Oct 2020 02:41:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB1A5206A1;
        Sun,  4 Oct 2020 06:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601793668;
        bh=jE/6zRmP2c+3pnXG71d4Lk412M5PlYy/QmuyiNhSZL4=;
        h=Subject:To:From:Date:From;
        b=X4eTKJxllZ80CdcDUgWRPWJ9noMYuOc2I9rOvuKH4hQzilAJ8A+iaiTEKDGtpY0J7
         5f6o/NpWYukSE6nKNwBwSzgGfLJ7NhTcgSTl0kJEsKk0GS9aEvf+9JV0MoIKg83mie
         /furlIAqzTVjMTiRCe+EXJ0BGWICaOAlsNnpJjIg=
Subject: patch "usb: dwc3: core: add phy cleanup for probe error handling" added to usb-next
To:     jun.li@nxp.com, balbi@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 04 Oct 2020 08:39:24 +0200
Message-ID: <16017935645177@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: core: add phy cleanup for probe error handling

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 03c1fd622f72c7624c81b64fdba4a567ae5ee9cb Mon Sep 17 00:00:00 2001
From: Li Jun <jun.li@nxp.com>
Date: Tue, 28 Jul 2020 20:42:41 +0800
Subject: usb: dwc3: core: add phy cleanup for probe error handling

Add the phy cleanup if dwc3 mode init fail, which is the missing part of
de-init for dwc3 core init.

Fixes: c499ff71ff2a ("usb: dwc3: core: re-factor init and exit paths")
Cc: <stable@vger.kernel.org>
Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
---
 drivers/usb/dwc3/core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 24fba4ca3d12..385262f6747d 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1564,6 +1564,17 @@ static int dwc3_probe(struct platform_device *pdev)
 
 err5:
 	dwc3_event_buffers_cleanup(dwc);
+
+	usb_phy_shutdown(dwc->usb2_phy);
+	usb_phy_shutdown(dwc->usb3_phy);
+	phy_exit(dwc->usb2_generic_phy);
+	phy_exit(dwc->usb3_generic_phy);
+
+	usb_phy_set_suspend(dwc->usb2_phy, 1);
+	usb_phy_set_suspend(dwc->usb3_phy, 1);
+	phy_power_off(dwc->usb2_generic_phy);
+	phy_power_off(dwc->usb3_generic_phy);
+
 	dwc3_ulpi_exit(dwc);
 
 err4:
-- 
2.28.0


