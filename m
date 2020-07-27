Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798D722EF79
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730933AbgG0OQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:16:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730925AbgG0OQp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:16:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 989642075A;
        Mon, 27 Jul 2020 14:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859404;
        bh=91ffLANxLOwAuoNFDVOlxC77GKnLIuKMsFT1hDppkWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rx5O6kX57R9EWYMutefH1K+/w4TJLLRWF+Vig8FWdvUzeNYmEr9UsCbffe770zBVP
         sz9dw1r9l1DM34lEWpbupLI2fcYYMR6jXL27MtFiEFnE7GBJTy96ZKMiCtzsdjk4wi
         B6K+xKCUh+vx6XdVMWW0ExFw6S1/AFhRIwGlaFRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 094/138] platform/x86: ISST: Add new PCI device ids
Date:   Mon, 27 Jul 2020 16:04:49 +0200
Message-Id: <20200727134930.076410898@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit e1eea3f839f41368d7cb4eb2d872d5b288677e94 ]

Added new PCI device ids for supporting mailbox and MMIO interface for
Sapphire Rapids.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_speed_select_if/isst_if_common.h   | 3 +++
 drivers/platform/x86/intel_speed_select_if/isst_if_mbox_pci.c | 1 +
 drivers/platform/x86/intel_speed_select_if/isst_if_mmio.c     | 1 +
 3 files changed, 5 insertions(+)

diff --git a/drivers/platform/x86/intel_speed_select_if/isst_if_common.h b/drivers/platform/x86/intel_speed_select_if/isst_if_common.h
index 1409a5bb55820..4f6f7f0761fc1 100644
--- a/drivers/platform/x86/intel_speed_select_if/isst_if_common.h
+++ b/drivers/platform/x86/intel_speed_select_if/isst_if_common.h
@@ -13,6 +13,9 @@
 #define INTEL_RAPL_PRIO_DEVID_0	0x3451
 #define INTEL_CFG_MBOX_DEVID_0	0x3459
 
+#define INTEL_RAPL_PRIO_DEVID_1 0x3251
+#define INTEL_CFG_MBOX_DEVID_1  0x3259
+
 /*
  * Validate maximum commands in a single request.
  * This is enough to handle command to every core in one ioctl, or all
diff --git a/drivers/platform/x86/intel_speed_select_if/isst_if_mbox_pci.c b/drivers/platform/x86/intel_speed_select_if/isst_if_mbox_pci.c
index de4169d0796bd..9a055fd54053f 100644
--- a/drivers/platform/x86/intel_speed_select_if/isst_if_mbox_pci.c
+++ b/drivers/platform/x86/intel_speed_select_if/isst_if_mbox_pci.c
@@ -148,6 +148,7 @@ static long isst_if_mbox_proc_cmd(u8 *cmd_ptr, int *write_only, int resume)
 
 static const struct pci_device_id isst_if_mbox_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, INTEL_CFG_MBOX_DEVID_0)},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, INTEL_CFG_MBOX_DEVID_1)},
 	{ 0 },
 };
 MODULE_DEVICE_TABLE(pci, isst_if_mbox_ids);
diff --git a/drivers/platform/x86/intel_speed_select_if/isst_if_mmio.c b/drivers/platform/x86/intel_speed_select_if/isst_if_mmio.c
index ad8c7c0df4d9a..e3778204b7a60 100644
--- a/drivers/platform/x86/intel_speed_select_if/isst_if_mmio.c
+++ b/drivers/platform/x86/intel_speed_select_if/isst_if_mmio.c
@@ -72,6 +72,7 @@ static long isst_if_mmio_rd_wr(u8 *cmd_ptr, int *write_only, int resume)
 
 static const struct pci_device_id isst_if_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, INTEL_RAPL_PRIO_DEVID_0)},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, INTEL_RAPL_PRIO_DEVID_1)},
 	{ 0 },
 };
 MODULE_DEVICE_TABLE(pci, isst_if_ids);
-- 
2.25.1



