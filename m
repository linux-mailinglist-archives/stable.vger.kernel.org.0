Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918694862FE
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 11:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237815AbiAFKg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 05:36:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232212AbiAFKg5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 05:36:57 -0500
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841C1C061245;
        Thu,  6 Jan 2022 02:36:55 -0800 (PST)
Received: by mail-vk1-xa33.google.com with SMTP id o2so1395476vkn.0;
        Thu, 06 Jan 2022 02:36:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xpS8ezCc8Pka5IjVzU/K7N3Lqy0sr6MhO9RG6CfQZmg=;
        b=am5cN9niyQVWwMBzLPewPaoKkrgLfi7NwM7CYeleuvRAVivUiOZUV69E4ebpTybSPs
         n330uONOGjL08z+CcUdRjGW/x6JJmjDh+TpD0RCqjPDcyB5M4PdDzZ1WHe0qSTEl58J/
         DK6rry3WIdOdK78dXQDQLNk5KV5QvcO56y4DgQljULBz63GmDghwxuEcNmu5hFqONNaX
         2NvxiLk9B1Eofd0AkZbYYeJe2RaWGghjupV2CWGUz7RAvZNco84X5nY63au7+SSQClnU
         ad7IgMFO/Jk2tKhk4stqoKG1ZYgcqlfWUE7Z+Mkw3TqrnqNpTAd5FVYN794ryNZHybfz
         bcSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xpS8ezCc8Pka5IjVzU/K7N3Lqy0sr6MhO9RG6CfQZmg=;
        b=LaP5xGPU/bo8XdO81VtlBwt0OAXVuVtYxBj3WJEJ71clhoTp3W5il5rSL1JgbvR0zo
         2GH3cdhXznarAulZmFm2Pj0RbDMn1gDbk74pCFXBvLAAiwTVqaLXJMR1NZYeLWOoX7p5
         409u0ifKZNlwXsNQSJobWsk36nLrOLnPktEZ9y0eXpTWVEpgHbxPADZCs4qYzXsqPwhM
         uwBlcCKFKz2fdpGuqRlUfIb1G2zqNKc42vWrgd9TyGHu7d0dbfnsiYiDqpUe4/gNtDWk
         XQ3Ur3VlZ8PYuuw4YaxSmcH/mS4LAG2exP2BAuPCbphd40WeCuWoed+R5DC9mK6gFEne
         NcXg==
X-Gm-Message-State: AOAM533O0Ufd6vpbp8O1SkLM+DZ28HzeSuWeJjFehP7tZC+4fbAgJK6s
        EjmoUvAbpzIFj2ZxO6KHZdWeZUy059w=
X-Google-Smtp-Source: ABdhPJwRxRk9RgolgPCrFk+eqevVcJiwrXZhw8mWAMOspBdlcrNHgcGYHBz2TWbAtWOIBBvpbtPLBA==
X-Received: by 2002:a05:6122:792:: with SMTP id k18mr19506818vkr.25.1641465414620;
        Thu, 06 Jan 2022 02:36:54 -0800 (PST)
Received: from localhost.localdomain ([2804:14c:485:504a:2169:9589:878d:2b28])
        by smtp.gmail.com with ESMTPSA id k135sm876302vke.53.2022.01.06.02.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 02:36:54 -0800 (PST)
From:   Fabio Estevam <festevam@gmail.com>
To:     bhelgaas@google.com
Cc:     lorenzo.pieralisi@arm.com, robh@kernel.org, l.stach@pengutronix.de,
        hongxing.zhu@nxp.com, linux-pci@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v2] PCI: imx6: Allow to probe when dw_pcie_wait_for_link() fails
Date:   Thu,  6 Jan 2022 07:36:45 -0300
Message-Id: <20220106103645.2790803-1-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The intention of commit 886a9c134755 ("PCI: dwc: Move link handling into
common code") was to standardize the behavior of link down as explained
in its commit log:

"The behavior for a link down was inconsistent as some drivers would fail
probe in that case while others succeed. Let's standardize this to
succeed as there are usecases where devices (and the link) appear later
even without hotplug. For example, a reconfigured FPGA device."

The pci-imx6 still fails to probe when the link is not present, which
causes the following warning:

imx6q-pcie 8ffc000.pcie: Phy link never came up
imx6q-pcie: probe of 8ffc000.pcie failed with error -110
------------[ cut here ]------------
WARNING: CPU: 0 PID: 30 at drivers/regulator/core.c:2257 _regulator_put.part.0+0x1b8/0x1dc
Modules linked in:
CPU: 0 PID: 30 Comm: kworker/u2:2 Not tainted 5.15.0-next-20211103 #1
Hardware name: Freescale i.MX6 SoloX (Device Tree)
Workqueue: events_unbound async_run_entry_fn
[<c0111730>] (unwind_backtrace) from [<c010bb74>] (show_stack+0x10/0x14)
[<c010bb74>] (show_stack) from [<c0f90290>] (dump_stack_lvl+0x58/0x70)
[<c0f90290>] (dump_stack_lvl) from [<c012631c>] (__warn+0xd4/0x154)
[<c012631c>] (__warn) from [<c0f87b00>] (warn_slowpath_fmt+0x74/0xa8)
[<c0f87b00>] (warn_slowpath_fmt) from [<c076b4bc>] (_regulator_put.part.0+0x1b8/0x1dc)
[<c076b4bc>] (_regulator_put.part.0) from [<c076b574>] (regulator_put+0x2c/0x3c)
[<c076b574>] (regulator_put) from [<c08c3740>] (release_nodes+0x50/0x178)

Fix this problem by ignoring the dw_pcie_wait_for_link() error like
it is done on the other dwc drivers.

Tested on imx6sx-sdb and imx6q-sabresd boards.

Cc: <stable@vger.kernel.org>
Fixes: 886a9c134755 ("PCI: dwc: Move link handling into common code")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
Changes since v1:
- Remove the printk timestamp from the kernel warning log (Richard).

 drivers/pci/controller/dwc/pci-imx6.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/controller/dwc/pci-imx6.c b/drivers/pci/controller/dwc/pci-imx6.c
index 2ac081510632..5e8a03061b31 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -807,9 +807,7 @@ static int imx6_pcie_start_link(struct dw_pcie *pci)
 	/* Start LTSSM. */
 	imx6_pcie_ltssm_enable(dev);
 
-	ret = dw_pcie_wait_for_link(pci);
-	if (ret)
-		goto err_reset_phy;
+	dw_pcie_wait_for_link(pci);
 
 	if (pci->link_gen == 2) {
 		/* Allow Gen2 mode after the link is up. */
@@ -845,11 +843,7 @@ static int imx6_pcie_start_link(struct dw_pcie *pci)
 		}
 
 		/* Make sure link training is finished as well! */
-		ret = dw_pcie_wait_for_link(pci);
-		if (ret) {
-			dev_err(dev, "Failed to bring link up!\n");
-			goto err_reset_phy;
-		}
+		dw_pcie_wait_for_link(pci);
 	} else {
 		dev_info(dev, "Link: Gen2 disabled\n");
 	}
-- 
2.25.1

