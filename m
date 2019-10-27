Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44B3EE6710
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfJ0VRm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:17:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731091AbfJ0VRi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:17:38 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57E4C2070B;
        Sun, 27 Oct 2019 21:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211057;
        bh=R3+/hJX/2rD8flEe2XZwxCvvYNQNQxgQCV+Xkg2vBdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jG/b8fSjQNXNzbVgQggGu2pt3V0hZQ0zUCOy0ZJpzhxeX/Lzz0VIQpLmaFdyPcaHO
         jFT+JajxhS8NJiNqCRUgTf9+oiVSG9BA8T3Rne2AlxXVQixTr7/TxbCCFw4vhfWHRL
         rG3RmyddbZ3EwYONSh+L9lHbIgcWwoTHonq2CeS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@dell.com>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 018/197] nvme-pci: Save PCI state before putting drive into deepest state
Date:   Sun, 27 Oct 2019 21:58:56 +0100
Message-Id: <20191027203352.659130294@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@dell.com>

[ Upstream commit 7cbb5c6f9aa7cfda7175d82a9cf77a92965b0c5e ]

The action of saving the PCI state will cause numerous PCI configuration
space reads which depending upon the vendor implementation may cause
the drive to exit the deepest NVMe state.

In these cases ASPM will typically resolve the PCIe link state and APST
may resolve the NVMe power state.  However it has also been observed
that this register access after quiesced will cause PC10 failure
on some device combinations.

To resolve this, move the PCI state saving to before SetFeatures has been
called.  This has been proven to resolve the issue across a 5000 sample
test on previously failing disk/system combinations.

Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 732d5b63ec054..19458e85dab34 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2894,11 +2894,21 @@ static int nvme_suspend(struct device *dev)
 	if (ret < 0)
 		goto unfreeze;
 
+	/*
+	 * A saved state prevents pci pm from generically controlling the
+	 * device's power. If we're using protocol specific settings, we don't
+	 * want pci interfering.
+	 */
+	pci_save_state(pdev);
+
 	ret = nvme_set_power_state(ctrl, ctrl->npss);
 	if (ret < 0)
 		goto unfreeze;
 
 	if (ret) {
+		/* discard the saved state */
+		pci_load_saved_state(pdev, NULL);
+
 		/*
 		 * Clearing npss forces a controller reset on resume. The
 		 * correct value will be resdicovered then.
@@ -2906,14 +2916,7 @@ static int nvme_suspend(struct device *dev)
 		nvme_dev_disable(ndev, true);
 		ctrl->npss = 0;
 		ret = 0;
-		goto unfreeze;
 	}
-	/*
-	 * A saved state prevents pci pm from generically controlling the
-	 * device's power. If we're using protocol specific settings, we don't
-	 * want pci interfering.
-	 */
-	pci_save_state(pdev);
 unfreeze:
 	nvme_unfreeze(ctrl);
 	return ret;
-- 
2.20.1



