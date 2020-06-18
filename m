Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111C01FE239
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731201AbgFRBY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:24:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731199AbgFRBY1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:24:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 675B0221EC;
        Thu, 18 Jun 2020 01:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443467;
        bh=0V7dE6479ka7p+b1cgEb56ZJP10pjJxIG98AhJLSwms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IK5Y1HXefTpPyLrjCzv7zokiywmNexBa6o9/59jnkoj+qSouMZQT2ulqoADiAY2Zy
         CAGZDdO5tdxhjFNfw/BzY6S9jOAFUYBvGZ6B3KzD5HRsT4Ar8ahjp26+qFBp6EFfBn
         7zbcPEDHOlBGKelm80UUxR65RfQFDO5g2Y1MHTgY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tang Bin <tangbin@cmss.chinamobile.com>,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>,
        Peter Chen <peter.chen@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 099/172] USB: host: ehci-mxc: Add error handling in ehci_mxc_drv_probe()
Date:   Wed, 17 Jun 2020 21:21:05 -0400
Message-Id: <20200618012218.607130-99-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012218.607130-1-sashal@kernel.org>
References: <20200618012218.607130-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tang Bin <tangbin@cmss.chinamobile.com>

[ Upstream commit d49292025f79693d3348f8e2029a8b4703be0f0a ]

The function ehci_mxc_drv_probe() does not perform sufficient error
checking after executing platform_get_irq(), thus fix it.

Fixes: 7e8d5cd93fac ("USB: Add EHCI support for MX27 and MX31 based boards")
Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Link: https://lore.kernel.org/r/20200513132647.5456-1-tangbin@cmss.chinamobile.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ehci-mxc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/ehci-mxc.c b/drivers/usb/host/ehci-mxc.c
index c9f91e6c72b6..7f65c86047dd 100644
--- a/drivers/usb/host/ehci-mxc.c
+++ b/drivers/usb/host/ehci-mxc.c
@@ -50,6 +50,8 @@ static int ehci_mxc_drv_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
 
 	hcd = usb_create_hcd(&ehci_mxc_hc_driver, dev, dev_name(dev));
 	if (!hcd)
-- 
2.25.1

