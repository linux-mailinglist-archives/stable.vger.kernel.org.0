Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D3D20E665
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403948AbgF2VrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:47:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbgF2Sfo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C5E42464B;
        Mon, 29 Jun 2020 15:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443965;
        bh=IKelftiZ9ImxACJoOD+/3abTRq4GDRhKV/15KeQ/qaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N/nBVbvmX3C/RCNzOuZOvm2xo+GCWmGAxr9vpAnfrMB/9JbqvELpnBe57YlfNi3Xi
         np8xL/exToM5qsmmasTvdcIt9ID0N47OKWqV6OYItaAHFY10JvFgZ46SocmKnD41hP
         rNZnM8fq+x0lW0BjOY54nJqNx/i40jbltMH8wlJc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tang Bin <tangbin@cmss.chinamobile.com>,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 069/265] usb: host: ehci-exynos: Fix error check in exynos_ehci_probe()
Date:   Mon, 29 Jun 2020 11:15:02 -0400
Message-Id: <20200629151818.2493727-70-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
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
index a4e9abcbdc4fc..1a9b7572e17fe 100644
--- a/drivers/usb/host/ehci-exynos.c
+++ b/drivers/usb/host/ehci-exynos.c
@@ -203,9 +203,8 @@ static int exynos_ehci_probe(struct platform_device *pdev)
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

