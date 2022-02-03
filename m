Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0529E4A8E4F
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354360AbiBCUgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:36:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36678 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355009AbiBCUeN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:34:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89320B835AD;
        Thu,  3 Feb 2022 20:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B67C36AE2;
        Thu,  3 Feb 2022 20:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920451;
        bh=SlsAxB7GlVdFg1xsl04fZWbORDq09QyWjRaYXy2tIvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b0zJLDIzQsan7YmqbhrTCBgmh38qyuDbK/XAMu7W1uF5pY12d+EtowCy6RdRgwvag
         nZEPSP9rcM8u5LRWIR6KPf5CUtxHeLxsrj4bjD0bEORLDCYEKCUgUoqE/koe1L6+pA
         8dADNI40eGAEJMNhGDRE6PPcEuIxd7iynSoV/ljrftthudOS7UIg79qNnJg2SRqWCt
         vXcFiPxrmu1J8EWt2fioReBqhap1rsHuiSQ3j+vHq/C+1qyRihUVZhnNS0naMIo+V2
         ac0VpZFfMqpDd0oOCuNPL4fE4FQxTl/w5bFxYMXufmqIqAZNwBhmhX3C5zsnFMuXyn
         vkOe6gZWwA+/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wu Zheng <wu.zheng@intel.com>, Ye Jinhe <jinhe.ye@intel.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, axboe@fb.com,
        sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 38/41] nvme-pci: add the IGNORE_DEV_SUBNQN quirk for Intel P4500/P4600 SSDs
Date:   Thu,  3 Feb 2022 15:32:42 -0500
Message-Id: <20220203203245.3007-38-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203245.3007-1-sashal@kernel.org>
References: <20220203203245.3007-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wu Zheng <wu.zheng@intel.com>

[ Upstream commit 25e58af4be412d59e056da65cc1cefbd89185bd2 ]

The Intel P4500/P4600 SSDs do not report a subsystem NQN despite claiming
compliance to a standards version where reporting one is required.

Add the IGNORE_DEV_SUBNQN quirk to not fail the initialization of a
second such SSDs in a system.

Signed-off-by: Zheng Wu <wu.zheng@intel.com>
Signed-off-by: Ye Jinhe <jinhe.ye@intel.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 149ecf73df384..b925a5f4afc3a 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3300,7 +3300,8 @@ static const struct pci_device_id nvme_id_table[] = {
 				NVME_QUIRK_DEALLOCATE_ZEROES, },
 	{ PCI_VDEVICE(INTEL, 0x0a54),	/* Intel P4500/P4600 */
 		.driver_data = NVME_QUIRK_STRIPE_SIZE |
-				NVME_QUIRK_DEALLOCATE_ZEROES, },
+				NVME_QUIRK_DEALLOCATE_ZEROES |
+				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_VDEVICE(INTEL, 0x0a55),	/* Dell Express Flash P4600 */
 		.driver_data = NVME_QUIRK_STRIPE_SIZE |
 				NVME_QUIRK_DEALLOCATE_ZEROES, },
-- 
2.34.1

