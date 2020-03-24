Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F404191012
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbgCXNZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:25:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729153AbgCXNZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:25:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97C37208CA;
        Tue, 24 Mar 2020 13:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056304;
        bh=L734DQCsAtgGBQaBPUMxvXOifmfHtf8bfxHJL/1XbNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YWtgM2jgajJVC02Xblk7Zkz7rzD4WbfjYsyffdozhABciXPOvSKMuAcczqIASz/Qz
         BVB9Yo4504xNdDQ7e8YTozDxn0Li//TzpcbCujjyeYiPI7+m/tS44pJYkNzEnh32bv
         eTp/q+ll59RBRXe1P9mJq7JdYKKOlz5+EqQoVzjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ran Wang <ran.wang_1@nxp.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Peter Chen <peter.chen@nxp.com>
Subject: [PATCH 5.5 046/119] usb: host: xhci-plat: add a shutdown
Date:   Tue, 24 Mar 2020 14:10:31 +0100
Message-Id: <20200324130812.926394473@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
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
@@ -445,6 +445,7 @@ MODULE_DEVICE_TABLE(acpi, usb_xhci_acpi_
 static struct platform_driver usb_xhci_driver = {
 	.probe	= xhci_plat_probe,
 	.remove	= xhci_plat_remove,
+	.shutdown = usb_hcd_platform_shutdown,
 	.driver	= {
 		.name = "xhci-hcd",
 		.pm = &xhci_plat_pm_ops,


