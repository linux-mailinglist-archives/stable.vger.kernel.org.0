Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF3B29C1AC
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1819057AbgJ0R06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:26:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1763872AbgJ0Owp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:52:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DBA52225E;
        Tue, 27 Oct 2020 14:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810364;
        bh=ro+V+vfyBViFU+IQk25XqhrlsTqN/XR3mcngCP6obHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hv4PS9ZUHrqezNk4p1cS+/eJoDkmxiXd/M/DGeT+/RaVlUmlJkfUeSzQ/RIQ2h7qM
         IYye/XEwnVedwMzd4zFQjrTmHpG08zWjFipOUB5aqc78IARLBWcnVsO6EqCSclmbD6
         IUC9ZNQl2gT0SnWTRT0wFQ/12rNx4ttX85lFaxP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 082/633] EDAC/i5100: Fix error handling order in i5100_init_one()
Date:   Tue, 27 Oct 2020 14:47:05 +0100
Message-Id: <20201027135526.539352871@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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
index 191aa7c19ded7..324a46b8479b0 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -1061,16 +1061,15 @@ static int i5100_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -1136,14 +1135,14 @@ static int i5100_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
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



