Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8F2406778
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 09:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhIJHIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 03:08:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231223AbhIJHH7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 03:07:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF9D5610A3;
        Fri, 10 Sep 2021 07:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631257609;
        bh=H7u+IYveVFJjsSjjPSWU0zPWfsdzgNOeHJDR3TvGOuo=;
        h=Subject:To:Cc:From:Date:From;
        b=cemQAND+1B61HUJz6ZPVNE8ijloZ09NWyfCaVQqRh5ixARQoYIF4Uin2e1rOYYQnt
         6GIzwvtsPlj0gJMnosAclWDW/AYmRlIVkQjQscUZ2IWe1Uqpikp5IMy0WN8pIYKyCt
         o/8lkXiYCifi/4/1wP9t+KIlR38hQCmGYgGUDmTM=
Subject: FAILED: patch "[PATCH] usb: host: xhci-rcar: Don't reload firmware after the" failed to apply to 4.4-stable tree
To:     yoshihiro.shimoda.uh@renesas.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Sep 2021 09:06:47 +0200
Message-ID: <16312576074216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 57f3ffdc11143f56f1314972fe86fe17a0dcde85 Mon Sep 17 00:00:00 2001
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Date: Fri, 27 Aug 2021 15:32:27 +0900
Subject: [PATCH] usb: host: xhci-rcar: Don't reload firmware after the
 completion

According to the datasheet, "Upon the completion of FW Download,
there is no need to write or reload FW.". Otherwise, it's possible
to cause unexpected behaviors. So, adds such a condition.

Fixes: 4ac8918f3a73 ("usb: host: xhci-plat: add support for the R-Car H2 and M2 xHCI controllers")
Cc: stable@vger.kernel.org # v3.17+
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/20210827063227.81990-1-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/host/xhci-rcar.c b/drivers/usb/host/xhci-rcar.c
index 1bc4fe7b8c75..9888ba7d85b6 100644
--- a/drivers/usb/host/xhci-rcar.c
+++ b/drivers/usb/host/xhci-rcar.c
@@ -134,6 +134,13 @@ static int xhci_rcar_download_firmware(struct usb_hcd *hcd)
 	const struct soc_device_attribute *attr;
 	const char *firmware_name;
 
+	/*
+	 * According to the datasheet, "Upon the completion of FW Download,
+	 * there is no need to write or reload FW".
+	 */
+	if (readl(regs + RCAR_USB3_DL_CTRL) & RCAR_USB3_DL_CTRL_FW_SUCCESS)
+		return 0;
+
 	attr = soc_device_match(rcar_quirks_match);
 	if (attr)
 		quirks = (uintptr_t)attr->data;

