Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D18919B0CE
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387963AbgDAQ3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:29:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387909AbgDAQ3c (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:29:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13B5F2063A;
        Wed,  1 Apr 2020 16:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758572;
        bh=6nJ3X+Xe0Q7+B4viy3y2JJP90Gl2H3Wk9z+ds7EAw+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WM15C80elXV3KSDehnk87wrBkenr6oBA9+zGnnKCdbaxK7+4NQtf+iFnpEczwUE7T
         Wq5pgUSIVe1CUxVr7BFVh+ypV70JPC+SisT35SCyCQwLKtWjtEpLPFMI9YId9BE76i
         dygtiBwpkRq7QpJRPEQ13mYh7471cGBp5TPrX2Eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ran Wang <ran.wang_1@nxp.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Peter Chen <peter.chen@nxp.com>
Subject: [PATCH 4.4 11/91] usb: host: xhci-plat: add a shutdown
Date:   Wed,  1 Apr 2020 18:17:07 +0200
Message-Id: <20200401161517.078410391@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161512.917494101@linuxfoundation.org>
References: <20200401161512.917494101@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ran Wang <ran.wang_1@nxp.com>

commit b433e340e7565110b0ce9ca4b3e26f4b97a1decf upstream.

When loading new kernel via kexec, we need to shutdown host controller to
avoid any un-expected memory accessing during new kernel boot.

Signed-off-by: Ran Wang <ran.wang_1@nxp.com>
Cc: stable <stable@vger.kernel.org>
Tested-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Link: https://lore.kernel.org/r/20200306092328.41253-1-ran.wang_1@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-plat.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -284,6 +284,7 @@ MODULE_DEVICE_TABLE(acpi, usb_xhci_acpi_
 static struct platform_driver usb_xhci_driver = {
 	.probe	= xhci_plat_probe,
 	.remove	= xhci_plat_remove,
+	.shutdown = usb_hcd_platform_shutdown,
 	.driver	= {
 		.name = "xhci-hcd",
 		.pm = DEV_PM_OPS,


