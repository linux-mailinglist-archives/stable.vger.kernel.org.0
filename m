Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCF8014B7F7
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730836AbgA1OTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:19:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:43476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730368AbgA1OTM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:19:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77FA521739;
        Tue, 28 Jan 2020 14:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221152;
        bh=Aby7x+mCBw7j5lzoe2MiqhlI2mkx6GH5atF2p99QOHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nbMQbVufyiLImGEn+jk5JGYGKzqUwVtRHxt3hYq703vcvX0DJKNR+pbjKs9A7lZ3l
         Djkp/ZwxvjKy6RSoaCncpCWb7yPkQsET/pqujPnYI7HcAEdZA8fd9chnaMozwrYbcy
         cUiOJ1DXZoaqztKs8oBMBCC0jnPMoLFCj/j4ccnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Bin Liu <b-liu@ti.com>,
        Sven Van Asbroeck <TheSven73@gmail.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 072/271] usb: phy: twl6030-usb: fix possible use-after-free on remove
Date:   Tue, 28 Jan 2020 15:03:41 +0100
Message-Id: <20200128135857.942817171@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a72e8d670adc8..cf0b67433ac95 100644
--- a/drivers/usb/phy/phy-twl6030-usb.c
+++ b/drivers/usb/phy/phy-twl6030-usb.c
@@ -422,7 +422,7 @@ static int twl6030_usb_remove(struct platform_device *pdev)
 {
 	struct twl6030_usb *twl = platform_get_drvdata(pdev);
 
-	cancel_delayed_work(&twl->get_status_work);
+	cancel_delayed_work_sync(&twl->get_status_work);
 	twl6030_interrupt_mask(TWL6030_USBOTG_INT_MASK,
 		REG_INT_MSK_LINE_C);
 	twl6030_interrupt_mask(TWL6030_USBOTG_INT_MASK,
-- 
2.20.1



