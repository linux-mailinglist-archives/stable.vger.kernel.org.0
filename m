Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 493AF2F042
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730754AbfE3ECG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:02:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731398AbfE3DSD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:03 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD15E2475D;
        Thu, 30 May 2019 03:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186282;
        bh=yIgeGhkdPB5M6GuadWfHBcGZhxxwD9M3hoixq8qO45I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ztT2CE1lt5mrvtfjGS8oMZcj1kCK7JMAXajH0qFegEg3mbyrYqxmgDCAxBAxL6T4Z
         w7k+kvzRYNZjcx4t+ejvBmLQVHaY4mGdbzJIY6GgV89y5YZ7yzEGk2fhjBiqk0OoN1
         FmzFYsWT/yTPk668C7BXzwbzSjxS2rMrMEUpE+hM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 235/276] usb: core: Add PM runtime calls to usb_hcd_platform_shutdown
Date:   Wed, 29 May 2019 20:06:33 -0700
Message-Id: <20190530030539.824340594@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
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
index 1c21955fe7c00..b82a7d787add8 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -3017,6 +3017,9 @@ usb_hcd_platform_shutdown(struct platform_device *dev)
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



