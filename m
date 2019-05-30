Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2569C2EE95
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729202AbfE3Dsc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:48:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732157AbfE3DUT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:20:19 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7552E2490E;
        Thu, 30 May 2019 03:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186419;
        bh=MiooSD0rWkqKK4flaOwrfWB+eO0A5ruYrhlxcARL354=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VMYV0f/OpgilxawMY5EysJ7tdtHC1U/AKl5bG5aQfrCmAzec9mV2XqnpsvEFyWuBk
         gvlp1p0FidwgbQHOSSEEsv7yAATJK6RLXnUNbm0XuB2lCDwh1xL/jVRmtAD5m/ymbC
         +bXGAE0+AQ3uRMqffaEm1kivAlUCFUAxpACzFo5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 172/193] usb: core: Add PM runtime calls to usb_hcd_platform_shutdown
Date:   Wed, 29 May 2019 20:07:06 -0700
Message-Id: <20190530030511.898815094@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
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
index d0b2e0ed9babb..5fcea1114e2f6 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -3053,6 +3053,9 @@ usb_hcd_platform_shutdown(struct platform_device *dev)
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



