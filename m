Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C9F20DC0B
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730387AbgF2UMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:12:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732884AbgF2TaV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC58625231;
        Mon, 29 Jun 2020 15:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444949;
        bh=ZqVkW5DCNTL9+xwdwfkcsXa7a/Y5WRQd3g9Iryktsdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WBwnUbZQVC7sIA2IRZPlH6amUcu4yg91h3pRSHh9q0ZET7189+9fM4Nm2BFbyKrrx
         YTj+KIRTzWuXv9Mpf4cNZ/sTG6J9siHQteFkV7ZiHCpRja0FNRZm+SgHhmwZZldaiE
         ShLdcTCp6MSyu9h47K4YnSiCvukIEzFGvhQCaBVc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tang Bin <tangbin@cmss.chinamobile.com>,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 047/131] usb: host: ehci-exynos: Fix error check in exynos_ehci_probe()
Date:   Mon, 29 Jun 2020 11:33:38 -0400
Message-Id: <20200629153502.2494656-48-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
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
index 8e3bab1e0c1f6..f433883ca2bf1 100644
--- a/drivers/usb/host/ehci-exynos.c
+++ b/drivers/usb/host/ehci-exynos.c
@@ -188,9 +188,8 @@ static int exynos_ehci_probe(struct platform_device *pdev)
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

