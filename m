Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553AF553CF4
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355424AbiFUU5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 16:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355245AbiFUU4x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:56:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4894831DD3;
        Tue, 21 Jun 2022 13:50:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82390B81B43;
        Tue, 21 Jun 2022 20:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB47C36AE5;
        Tue, 21 Jun 2022 20:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655844631;
        bh=ubsDXvkeA2rUxRYMGsugwHpPN0jkhxvBZaBP/AzP0wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ymo/IUb09ZsVcgyjG3UvQmVpoMGflD2yvspsRxGZsndQ4XPRTC101agxYqe+5orpP
         nKv+qCpWWNd4OLNprJWqP7BKmk7gy0I3wGPG+8hTrPvf6nK16SPK/YQZIjhHOV4mBJ
         DYp0U8a5uY5hZYqXom8KSQuIjdddtkPnxmbJXb6eVKi3l6spb3nmV2gCsUQen/SuGc
         JaJ6iOqainRNip2BCuGAJI98uyYmvMD/SC2Q4e0lkTE1PyTbewcL0Rd+Dx6ShJOtq5
         U5YgMPWj9ghFNBBG5kiunfj3JBxYCTGoHZqHtFuvXcjgp8Aativx38zCOdiuEJ1uG6
         nYlgqP5g0beaQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "rasheed.hsueh" <rasheed.hsueh@lcfc.corp-partner.google.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kbusch@kernel.org,
        axboe@fb.com, sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.17 12/20] nvme-pci: disable write zeros support on UMIC and Samsung SSDs
Date:   Tue, 21 Jun 2022 16:50:02 -0400
Message-Id: <20220621205010.250185-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621205010.250185-1-sashal@kernel.org>
References: <20220621205010.250185-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "rasheed.hsueh" <rasheed.hsueh@lcfc.corp-partner.google.com>

[ Upstream commit 43047e082b90ead395c44b0e8497bc853bd13845 ]

Like commit 5611ec2b9814 ("nvme-pci: prevent SK hynix PC400 from using
Write Zeroes command"), UMIS and Samsung has the same issue:
[ 6305.633887] blk_update_request: operation not supported error,
dev nvme0n1, sector 340812032 op 0x9:(WRITE_ZEROES) flags 0x0
phys_seg 0 prio class 0

So also disable Write Zeroes command on UMIS and Samsung.

Signed-off-by: rasheed.hsueh <rasheed.hsueh@lcfc.corp-partner.google.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 70dc05c60f2b..d2655cdd46c3 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3456,6 +3456,14 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x1d97, 0x2263),   /* SPCC */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x144d, 0xa80b),   /* Samsung PM9B1 256G and 512G */
+		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x144d, 0xa809),   /* Samsung MZALQ256HBJD 256G */
+		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x1cc4, 0x6303),   /* UMIS RPJTJ512MGE1QDY 512G */
+		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x1cc4, 0x6302),   /* UMIS RPJTJ256MGE1QDY 256G */
+		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x2646, 0x2262),   /* KINGSTON SKC2000 NVMe SSD */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(0x2646, 0x2263),   /* KINGSTON A2000 NVMe SSD  */
-- 
2.35.1

