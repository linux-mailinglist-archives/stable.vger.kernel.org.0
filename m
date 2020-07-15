Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB10A220C00
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 13:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbgGOLjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 07:39:17 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15656 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725924AbgGOLjR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 07:39:17 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f0eea730001>; Wed, 15 Jul 2020 04:37:23 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 15 Jul 2020 04:39:17 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 15 Jul 2020 04:39:17 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 15 Jul
 2020 11:39:12 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 15 Jul 2020 11:39:12 +0000
Received: from moonraker.nvidia.com (Not Verified[10.26.73.219]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5f0eeade0000>; Wed, 15 Jul 2020 04:39:11 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC:     <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jon Hunter <jonathanh@nvidia.com>, <stable@vger.kernel.org>
Subject: [PATCH V2] usb: tegra: Fix allocation for the FPCI context
Date:   Wed, 15 Jul 2020 12:38:42 +0100
Message-ID: <20200715113842.30680-1-jonathanh@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200712102837.24340-1-jonathanh@nvidia.com>
References: <20200712102837.24340-1-jonathanh@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1594813043; bh=uuPzFrd79X6snwWrV1rXcJChGJVyio56NAiQtRIpVMc=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=KMonAL2NbiHVsPl3rkICVkx73w8mC+CLtMefaqfM1KgIRQsRrVud30eixHuu3Zm0c
         YF5DXh1QC43if5k/v50J6t7ajWSsTt0YEaXxyENBVBSLRIAobeVQU4FNheHuVb9R0R
         Ay+/3YyQaGcMePqWIvUGnW9YuKZDNvaWBjC/F1ziF5ga3sGJiPjpzODCiRqJv33TRU
         6KsW+6oeB85vHFI9FRD0Z1gizhPwW6g4hwh+NzsYUQHknuqsSK8eUX9UOEVEIjKrOb
         uXM1GjDqHQts882dmRP3XnmWs6AJ/Ts1co3nV0WlbuQi9aPjL6KJms8FtLivukX/lf
         p6rf6QuZ1gMHA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 5c4e8d3781bc ("usb: host: xhci-tegra: Add support for XUSB
context save/restore") is using the IPFS 'num_offsets' value when
allocating memory for FPCI context instead of the FPCI 'num_offsets'.

After commit cad064f1bd52 ("devres: handle zero size in devm_kmalloc()")
was added system suspend started failing on Tegra186. The kernel log
showed that the Tegra XHCI driver was crashing on entry to suspend when
attempting the save the USB context. On Tegra186, the IPFS context has a
zero length but the FPCI content has a non-zero length, and because of
the bug in the Tegra XHCI driver we are incorrectly allocating a zero
length array for the FPCI context. The crash seen on entering suspend
when we attempt to save the FPCI context and following commit
cad064f1bd52 ("devres: handle zero size in devm_kmalloc()") this now
causes a NULL pointer deference when we access the memory. Fix this by
correcting the amount of memory we are allocating for FPCI contexts.

Cc: stable@vger.kernel.org

Fixes: 5c4e8d3781bc ("usb: host: xhci-tegra: Add support for XUSB context save/restore")

Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
---

Changes since V1:
- Corrected commit message
- Added Thierry's ACK

 drivers/usb/host/xhci-tegra.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-tegra.c b/drivers/usb/host/xhci-tegra.c
index 9ce28ab47f4b..014d79334f50 100644
--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -856,7 +856,7 @@ static int tegra_xusb_init_context(struct tegra_xusb *tegra)
 	if (!tegra->context.ipfs)
 		return -ENOMEM;
 
-	tegra->context.fpci = devm_kcalloc(tegra->dev, soc->ipfs.num_offsets,
+	tegra->context.fpci = devm_kcalloc(tegra->dev, soc->fpci.num_offsets,
 					   sizeof(u32), GFP_KERNEL);
 	if (!tegra->context.fpci)
 		return -ENOMEM;
-- 
2.17.1

