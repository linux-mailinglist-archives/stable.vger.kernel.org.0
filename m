Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF4411954A
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbfLJVTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:19:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:36158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728559AbfLJVMX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:12:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B9DB246AA;
        Tue, 10 Dec 2019 21:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012342;
        bh=IeNIQDPcwkickLJ2DTiLL8BG+ZNio8sQfsfdhilggbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ItQSSk9jFpbz/E0FHEHmXkGvivCgXdBXsNINdkmGAchGxrtRVSSb2GQ4LnC/OFKdz
         Y9xaidAG3xKF72x2T0hPCa+jSD8u6xe9heFznxNMDBOzsO4ssoilBcxTFskGrStMYu
         71zU/9JIXyqC+xHbol8R9mUZ/+u6qyUnMKXjrGAU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 273/350] mailbox: tegra: Fix superfluous IRQ error message
Date:   Tue, 10 Dec 2019 16:06:18 -0500
Message-Id: <20191210210735.9077-234-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit c745da8d4320c49e54662c0a8f7cb6b8204f44c4 ]

Commit 7723f4c5ecdb ("driver core: platform: Add an error message to
platform_get_irq*()") added an error message to avoid drivers having
to print an error message when IRQ lookup fails. However, there are
some cases where IRQs are optional and so new optional versions of
the platform_get_irq*() APIs have been added for these cases.

The IRQs for Tegra HSP module are optional because not all instances
of the module have the doorbell and all of the shared interrupts.
Hence, since the above commit was applied the following error messages
are now seen on Tegra194 ...

 ERR KERN tegra-hsp c150000.hsp: IRQ doorbell not found
 ERR KERN tegra-hsp c150000.hsp: IRQ shared0 not found

The Tegra HSP driver deliberately does not fail if these are not found
and so fix the above errors by updating the Tegra HSP driver to use
the platform_get_irq_byname_optional() API.

Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20191011083459.11551-1-jonathanh@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/tegra-hsp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mailbox/tegra-hsp.c b/drivers/mailbox/tegra-hsp.c
index 4c5ba35d48d43..834b35dc3b137 100644
--- a/drivers/mailbox/tegra-hsp.c
+++ b/drivers/mailbox/tegra-hsp.c
@@ -657,7 +657,7 @@ static int tegra_hsp_probe(struct platform_device *pdev)
 	hsp->num_db = (value >> HSP_nDB_SHIFT) & HSP_nINT_MASK;
 	hsp->num_si = (value >> HSP_nSI_SHIFT) & HSP_nINT_MASK;
 
-	err = platform_get_irq_byname(pdev, "doorbell");
+	err = platform_get_irq_byname_optional(pdev, "doorbell");
 	if (err >= 0)
 		hsp->doorbell_irq = err;
 
@@ -677,7 +677,7 @@ static int tegra_hsp_probe(struct platform_device *pdev)
 			if (!name)
 				return -ENOMEM;
 
-			err = platform_get_irq_byname(pdev, name);
+			err = platform_get_irq_byname_optional(pdev, name);
 			if (err >= 0) {
 				hsp->shared_irqs[i] = err;
 				count++;
-- 
2.20.1

