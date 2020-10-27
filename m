Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFAB229AE9B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411651AbgJ0OCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:02:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753794AbgJ0OCO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:02:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8381422258;
        Tue, 27 Oct 2020 14:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807334;
        bh=A8mQgoHE6DBtAR93xHZCQvHDjal3IdrVm1mBSBx1oPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fyL12LK3XWoUWPBHuH7O10AmB9RqgULju/oLnDnDB7QrQqiLuYixJ+8WgRqNZNV1V
         0x3rrGvdNNrBkW3wTTrIsLCERHcbrt/hs8uO4rng+VioCdLTlSbhL3SQS97nVqCA77
         pLbDw2rqZ8FsSCIr4Fcd0SL1UgPNa+SBxvsoE5wo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 015/139] EDAC/i5100: Fix error handling order in i5100_init_one()
Date:   Tue, 27 Oct 2020 14:48:29 +0100
Message-Id: <20201027134902.870595477@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134902.130312227@linuxfoundation.org>
References: <20201027134902.130312227@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 857a3139bd8be4f702c030c8ca06f3fd69c1741a ]

When pci_get_device_func() fails, the driver doesn't need to execute
pci_dev_put(). mci should still be freed, though, to prevent a memory
leak. When pci_enable_device() fails, the error injection PCI device
"einj" doesn't need to be disabled either.

 [ bp: Massage commit message, rename label to "bail_mc_free". ]

Fixes: 52608ba205461 ("i5100_edac: probe for device 19 function 0")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20200826121437.31606-1-dinghao.liu@zju.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/i5100_edac.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index c655162caf08f..599038edd90d3 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -1073,16 +1073,15 @@ static int i5100_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 				    PCI_DEVICE_ID_INTEL_5100_19, 0);
 	if (!einj) {
 		ret = -ENODEV;
-		goto bail_einj;
+		goto bail_mc_free;
 	}
 
 	rc = pci_enable_device(einj);
 	if (rc < 0) {
 		ret = rc;
-		goto bail_disable_einj;
+		goto bail_einj;
 	}
 
-
 	mci->pdev = &pdev->dev;
 
 	priv = mci->pvt_info;
@@ -1149,14 +1148,14 @@ static int i5100_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 bail_scrub:
 	priv->scrub_enable = 0;
 	cancel_delayed_work_sync(&(priv->i5100_scrubbing));
-	edac_mc_free(mci);
-
-bail_disable_einj:
 	pci_disable_device(einj);
 
 bail_einj:
 	pci_dev_put(einj);
 
+bail_mc_free:
+	edac_mc_free(mci);
+
 bail_disable_ch1:
 	pci_disable_device(ch1mm);
 
-- 
2.25.1



