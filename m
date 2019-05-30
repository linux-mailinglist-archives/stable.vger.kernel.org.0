Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB4E22F50F
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388513AbfE3EoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:44:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728818AbfE3DME (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:04 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5500824527;
        Thu, 30 May 2019 03:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185924;
        bh=yYGoknExD25rv43GhJWukBjgwkkj0hKIngRtHHtfmE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ugRcnlSP6LV6XViW8pCimVx4+le96zDHWSUW1CIzjeL8SXXOVFoQ2SIc2POTqGsux
         Z2VdwFrMGJJGI8/yakiw2O1L1Gv3dAcVpYz2zVvTxbkS4AzftpVgtTj7DpxgubOO1z
         peJZtr3y1tjmUUo9EwvGz5tKAZ3Vona+k5WZd+2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 313/405] usb: core: Add PM runtime calls to usb_hcd_platform_shutdown
Date:   Wed, 29 May 2019 20:05:11 -0700
Message-Id: <20190530030556.636318479@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
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
index 975d7c1288e36..e9f740484001f 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -3020,6 +3020,9 @@ usb_hcd_platform_shutdown(struct platform_device *dev)
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



