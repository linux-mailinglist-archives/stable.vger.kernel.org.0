Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE17019B165
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732411AbgDAQek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:34:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388529AbgDAQek (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:34:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D501A20772;
        Wed,  1 Apr 2020 16:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758879;
        bh=zoIs6g3QiQF1Pb10geW1fimpOpcLW6YJQTXtrUPp+rY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JOPJD4cGXyePPb+T9EczDJauw5Q/AlmJJOKmNsPPmSGhwXfWjONmaxuSyxoBhsZ1+
         jtttcTNzGKFO3UP7m5/2im3pZdG4wPLk2B3/U8ZQT9v7S/ZFaV9ovI2cRDcRqUJGj6
         b3BL0d0ljeRof7ysSeRVItedRtx5YdGWHjt3Ew+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ran Wang <ran.wang_1@nxp.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Peter Chen <peter.chen@nxp.com>
Subject: [PATCH 4.9 011/102] usb: host: xhci-plat: add a shutdown
Date:   Wed,  1 Apr 2020 18:17:14 +0200
Message-Id: <20200401161533.922470748@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161530.451355388@linuxfoundation.org>
References: <20200401161530.451355388@linuxfoundation.org>
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
@@ -335,6 +335,7 @@ MODULE_DEVICE_TABLE(acpi, usb_xhci_acpi_
 static struct platform_driver usb_xhci_driver = {
 	.probe	= xhci_plat_probe,
 	.remove	= xhci_plat_remove,
+	.shutdown = usb_hcd_platform_shutdown,
 	.driver	= {
 		.name = "xhci-hcd",
 		.pm = DEV_PM_OPS,


