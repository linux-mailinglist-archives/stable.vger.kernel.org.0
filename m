Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEA7113F20A
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390699AbgAPSci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:32:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:60294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391833AbgAPRY5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:24:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F9952468D;
        Thu, 16 Jan 2020 17:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195497;
        bh=pApbjpB3M1WpmYu3P2kMlD3KDQd2NJxdcECDY4o+trk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3bUW5hictFEyspyE7/eNRE8AEiyZ7hOTlQoCZu+jCkz3PaPbyvIW0hZeQ8en+ClZ
         joPV/MAOPUJiSirVzg7grx88IQoN6Q2oVYflchJ73XTOuUuzsGa/4tjg8fpE4vSRLE
         OLIDg3tHBqzKO33XP7ZkJXVyJzUIW5xuMw2mFulQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Bin Liu <b-liu@ti.com>,
        Sven Van Asbroeck <TheSven73@gmail.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 098/371] usb: phy: twl6030-usb: fix possible use-after-free on remove
Date:   Thu, 16 Jan 2020 12:19:30 -0500
Message-Id: <20200116172403.18149-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

[ Upstream commit 5895d311d28f2605e2f71c1a3e043ed38f3ac9d2 ]

In remove(), use cancel_delayed_work_sync() to cancel the
delayed work. Otherwise there's a chance that this work
will continue to run until after the device has been removed.

This issue was detected with the help of Coccinelle.

Cc: Tony Lindgren <tony@atomide.com>
Cc: Bin Liu <b-liu@ti.com>
Fixes: b6a619a883c3 ("usb: phy: Check initial state for twl6030")
Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/phy/phy-twl6030-usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/phy/phy-twl6030-usb.c b/drivers/usb/phy/phy-twl6030-usb.c
index b5dc077ed7d3..8e14fa221191 100644
--- a/drivers/usb/phy/phy-twl6030-usb.c
+++ b/drivers/usb/phy/phy-twl6030-usb.c
@@ -413,7 +413,7 @@ static int twl6030_usb_remove(struct platform_device *pdev)
 {
 	struct twl6030_usb *twl = platform_get_drvdata(pdev);
 
-	cancel_delayed_work(&twl->get_status_work);
+	cancel_delayed_work_sync(&twl->get_status_work);
 	twl6030_interrupt_mask(TWL6030_USBOTG_INT_MASK,
 		REG_INT_MSK_LINE_C);
 	twl6030_interrupt_mask(TWL6030_USBOTG_INT_MASK,
-- 
2.20.1

