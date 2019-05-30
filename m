Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05AA02EDCD
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbfE3DlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:41:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732526AbfE3DVV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:21:21 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28DEB248FC;
        Thu, 30 May 2019 03:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186480;
        bh=eLnA3TCUZw3mt9N2WqAhU+mxgcnznVC7qAxRzjMRZv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xWECkO40a9SGJb880MbdY39kIjo2QJRnVvWRvLBvw2tynECUTs2WHD0V6xMdOjW0U
         Xxbl3u8R5UhvD7g7acHUgNmxdKNRsKwRlyEGbXMprOPVDaJsT4m9Xlew0iXeVPbhtM
         xy3Aj5NigvlnZih0REUBIOiHtd6H2rKvLL8dMLrc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 116/128] usb: core: Add PM runtime calls to usb_hcd_platform_shutdown
Date:   Wed, 29 May 2019 20:07:28 -0700
Message-Id: <20190530030455.379251731@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8ead7e817224d7832fe51a19783cb8fcadc79467 ]

If ohci-platform is runtime suspended, we can currently get an "imprecise
external abort" on reboot with ohci-platform loaded when PM runtime
is implemented for the SoC.

Let's fix this by adding PM runtime support to usb_hcd_platform_shutdown.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/hcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index bdb0d7a08ff9b..1dd4c65e9188a 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -3033,6 +3033,9 @@ usb_hcd_platform_shutdown(struct platform_device *dev)
 {
 	struct usb_hcd *hcd = platform_get_drvdata(dev);
 
+	/* No need for pm_runtime_put(), we're shutting down */
+	pm_runtime_get_sync(&dev->dev);
+
 	if (hcd->driver->shutdown)
 		hcd->driver->shutdown(hcd);
 }
-- 
2.20.1



