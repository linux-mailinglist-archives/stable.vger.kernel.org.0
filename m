Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD07820DF07
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389114AbgF2Ubn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:31:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732476AbgF2TZT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F4FC2544A;
        Mon, 29 Jun 2020 15:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445397;
        bh=C4pLqg9guNpwTOM939XRXDfQJWlayJHsoVrefLXAvhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ruj4C4Wof3bOyExsX3JnN6Kd1TJitdIf8BIoI88L2xbZYu7Wc48vwsFEmvc+3GVBX
         oR1yP8lzTvkAJjJUU9sK4nZ1YMjgiZj0oKVEdQQ+9bJSI/bZimM7MqQK0cVwvPlbJF
         171equJJ8gpi+XueIfPOsIkxDi0XGMJxy0im/1mY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tang Bin <tangbin@cmss.chinamobile.com>,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 150/191] usb: host: ehci-exynos: Fix error check in exynos_ehci_probe()
Date:   Mon, 29 Jun 2020 11:39:26 -0400
Message-Id: <20200629154007.2495120-151-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tang Bin <tangbin@cmss.chinamobile.com>

commit 44ed240d62736ad29943ec01e41e194b96f7c5e9 upstream.

If the function platform_get_irq() failed, the negative value
returned will not be detected here. So fix error handling in
exynos_ehci_probe(). And when get irq failed, the function
platform_get_irq() logs an error message, so remove redundant
message here.

Fixes: 1bcc5aa87f04 ("USB: Add initial S5P EHCI driver")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Link: https://lore.kernel.org/r/20200602114708.28620-1-tangbin@cmss.chinamobile.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ehci-exynos.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ehci-exynos.c b/drivers/usb/host/ehci-exynos.c
index 7a603f66a9bc5..44b7c3e780f67 100644
--- a/drivers/usb/host/ehci-exynos.c
+++ b/drivers/usb/host/ehci-exynos.c
@@ -199,9 +199,8 @@ static int exynos_ehci_probe(struct platform_device *pdev)
 	hcd->rsrc_len = resource_size(res);
 
 	irq = platform_get_irq(pdev, 0);
-	if (!irq) {
-		dev_err(&pdev->dev, "Failed to get IRQ\n");
-		err = -ENODEV;
+	if (irq < 0) {
+		err = irq;
 		goto fail_io;
 	}
 
-- 
2.25.1

