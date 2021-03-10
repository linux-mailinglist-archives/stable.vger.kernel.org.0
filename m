Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D56333E1D
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233380AbhCJNZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:46432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233130AbhCJNY5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5517364FEF;
        Wed, 10 Mar 2021 13:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382696;
        bh=bkk9e+K0PeWR2B3vg6L3EGwP4rJSltn/D6guNeruDvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q+M52O+N44dlIHFCSkMIJEaU5HPk65dmNbj8fg9g5ZCWDIKVBB0NOvpJvULvK+pEx
         b2khhxVFA4vfjhc19Mg7MNzstXATgPlQvwO4TOoJMH9sKlzXIcrkR6c5/MJiOvo1y/
         HxXx6wGKqmlRrY4yvweFU/XUqJ6CdIwnePDe3/WM=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nishanth Menon <nm@ti.com>,
        Roger Quadros <rogerq@ti.com>,
        Pawel Laszczak <pawell@cadence.com>,
        Peter Chen <peter.chen@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 28/49] usb: cdns3: fix NULL pointer dereference on no platform data
Date:   Wed, 10 Mar 2021 14:23:39 +0100
Message-Id: <20210310132322.836195902@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132321.948258062@linuxfoundation.org>
References: <20210310132321.948258062@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Roger Quadros <rogerq@ti.com>

[ Upstream commit 448373d9db1a7000072f65103af19e20503f0c0c ]

Some platforms (e.g. TI) will not have any platform data which will
lead to NULL pointer dereference if we don't check for NULL pdata.

Fixes: 7cea9657756b ("usb: cdns3: add quirk for enable runtime pm by default")
Reported-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Pawel Laszczak <pawell@cadence.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/core.c | 2 +-
 drivers/usb/cdns3/host.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/cdns3/core.c b/drivers/usb/cdns3/core.c
index 29affbf1e828..6eeb7ed8e91f 100644
--- a/drivers/usb/cdns3/core.c
+++ b/drivers/usb/cdns3/core.c
@@ -569,7 +569,7 @@ static int cdns3_probe(struct platform_device *pdev)
 	device_set_wakeup_capable(dev, true);
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
-	if (!(cdns->pdata->quirks & CDNS3_DEFAULT_PM_RUNTIME_ALLOW))
+	if (!(cdns->pdata && (cdns->pdata->quirks & CDNS3_DEFAULT_PM_RUNTIME_ALLOW)))
 		pm_runtime_forbid(dev);
 
 	/*
diff --git a/drivers/usb/cdns3/host.c b/drivers/usb/cdns3/host.c
index c3b29a9c77a5..102977790d60 100644
--- a/drivers/usb/cdns3/host.c
+++ b/drivers/usb/cdns3/host.c
@@ -59,7 +59,7 @@ static int __cdns3_host_init(struct cdns3 *cdns)
 		goto err1;
 	}
 
-	if (cdns->pdata->quirks & CDNS3_DEFAULT_PM_RUNTIME_ALLOW)
+	if (cdns->pdata && (cdns->pdata->quirks & CDNS3_DEFAULT_PM_RUNTIME_ALLOW))
 		cdns->xhci_plat_data->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
 
 	ret = platform_device_add_data(xhci, cdns->xhci_plat_data,
-- 
2.30.1



