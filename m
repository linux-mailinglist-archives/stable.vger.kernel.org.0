Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEFD84A8E85
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355339AbiBCUho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:37:44 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41936 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355342AbiBCUfn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:35:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 373FB61A5C;
        Thu,  3 Feb 2022 20:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EBAC340E8;
        Thu,  3 Feb 2022 20:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920542;
        bh=ZIoruihJRDf1q4OFLPrXAa1XVhoSo5Vgetf4aKxnfEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h0Q8g56TUvX/gJMnJulQvHmviv7vLyWpRwJdkK93dwkt7O12rFnOUVhzdxNCGl96D
         gDo+wBenOdLHYCSWh1+nANtLG283gmcUSgw+BHZZ20CuGV5rqg33b8QrU2eZY0lBaF
         DlNwXMLF4flAQsifhFABXtegYDr58b/yMAYjdoKY9PGWbqFRkPHz7btSIlJvmwCNa5
         mmjsX0Ag0d8LiPWk5Hw5WoXi9BrR4TO2OK1QDuRJQorZDPlliJYsZWSrpNrbvDfNkT
         DdfhGNTxAuUZ+ADMHwRs19eVmjrbkJ4w0kiaUwfZ5Lo6+mM1kfDkvV/dUZN6xlne9W
         c5FljZ7sTPRkg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wu Zheng <wu.zheng@intel.com>, Ye Jinhe <jinhe.ye@intel.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, axboe@fb.com,
        sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 24/25] nvme-pci: add the IGNORE_DEV_SUBNQN quirk for Intel P4500/P4600 SSDs
Date:   Thu,  3 Feb 2022 15:34:45 -0500
Message-Id: <20220203203447.3570-24-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203447.3570-1-sashal@kernel.org>
References: <20220203203447.3570-1-sashal@kernel.org>
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
index 1b85349f57af0..97afeb898b253 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3198,7 +3198,8 @@ static const struct pci_device_id nvme_id_table[] = {
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

