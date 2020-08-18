Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDAD24838B
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 13:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgHRLGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 07:06:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726273AbgHRLGP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 07:06:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 059C3206B5;
        Tue, 18 Aug 2020 11:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597748772;
        bh=1kA4JArYU/akPZ37L55BNowkjnWgLnrGdSmoM5LXIFY=;
        h=Subject:To:From:Date:From;
        b=1LKAYoypJx4uKPMKmKckfKED0wj8rc3j+/vKptdu/HXpQmX+l44TD2/lDSohkpuLq
         95NIl/JH5cgCY0uCqpUABEaJsxSLr826V5uVqHhrZuje3LT6kKanQHHm05SgeQ3LdA
         2iUUt/NYPoywpECEKP2eiD9DABjsiFQREhYJD/x0=
Subject: patch "usb: host: xhci-tegra: otg usb2/usb3 port init" added to usb-linus
To:     jckuo@nvidia.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Aug 2020 13:06:36 +0200
Message-ID: <1597748796114159@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: host: xhci-tegra: otg usb2/usb3 port init

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 316a2868bc269be8c6e69ccc3a1f902a3f518eb9 Mon Sep 17 00:00:00 2001
From: JC Kuo <jckuo@nvidia.com>
Date: Tue, 11 Aug 2020 17:31:43 +0800
Subject: usb: host: xhci-tegra: otg usb2/usb3 port init

tegra_xusb_init_usb_phy() should initialize "otg_usb2_port" and
"otg_usb3_port" with -EINVAL because "0" is a valid value
represents usb2 port 0 or usb3 port 0.

Signed-off-by: JC Kuo <jckuo@nvidia.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200811093143.699541-1-jckuo@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-tegra.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci-tegra.c b/drivers/usb/host/xhci-tegra.c
index 014d79334f50..0489a316099a 100644
--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -1258,6 +1258,8 @@ static int tegra_xusb_init_usb_phy(struct tegra_xusb *tegra)
 
 	INIT_WORK(&tegra->id_work, tegra_xhci_id_work);
 	tegra->id_nb.notifier_call = tegra_xhci_id_notify;
+	tegra->otg_usb2_port = -EINVAL;
+	tegra->otg_usb3_port = -EINVAL;
 
 	for (i = 0; i < tegra->num_usb_phys; i++) {
 		struct phy *phy = tegra_xusb_get_phy(tegra, "usb2", i);
-- 
2.28.0


