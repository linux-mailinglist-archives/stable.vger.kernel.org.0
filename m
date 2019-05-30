Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3126F2EC12
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731451AbfE3DSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:18:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731445AbfE3DSK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:10 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 804BD24778;
        Thu, 30 May 2019 03:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186289;
        bh=70s3YOyXPI3ofGOKPOZfbV7HhpNjL5lq8q5a97hEo7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rjDgGtpTuFy2hyiy26XD8rmYrE9F4ny39Z9u32PFnUXevmv7bThX3LRgvC3S3k5Cl
         GUAHOMZek1/TtaDxut7SZa89DeYU6y0bXYwKUNqy2vWQaBNFCNJ7d399l6JaZgR2bd
         xXp4WLrkiOn9bXnVpjqdquntIlquW3KbYPHbz3cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 246/276] e1000e: Disable runtime PM on CNP+
Date:   Wed, 29 May 2019 20:06:44 -0700
Message-Id: <20190530030540.530777016@linuxfoundation.org>
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

[ Upstream commit 459d69c407f9ba122f12216555c3012284dc9fd7 ]

There are some new e1000e devices can only be woken up from D3 one time,
by plugging Ethernet cable. Subsequent cable plugging does set PME bit
correctly, but it still doesn't get woken up.

Since e1000e connects to the root complex directly, we rely on ACPI to
wake it up. In this case, the GPE from _PRW only works once and stops
working after that. Though it appears to be a platform bug, e1000e
maintainers confirmed that I219 does not support D3.

So disable runtime PM on CNP+ chips. We may need to disable earlier
generations if this bug also hit older platforms.

Bugzilla: https://bugzilla.kernel.org/attachment.cgi?id=280819
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 8b11682ebba22..8cd339c92c1af 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7329,7 +7329,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	dev_pm_set_driver_flags(&pdev->dev, DPM_FLAG_NEVER_SKIP);
 
-	if (pci_dev_run_wake(pdev))
+	if (pci_dev_run_wake(pdev) && hw->mac.type < e1000_pch_cnp)
 		pm_runtime_put_noidle(&pdev->dev);
 
 	return 0;
-- 
2.20.1



