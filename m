Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C99C36C56B3
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbjCVUIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbjCVUIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:08:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B656B966;
        Wed, 22 Mar 2023 13:02:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AF15622B9;
        Wed, 22 Mar 2023 20:01:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C011C433EF;
        Wed, 22 Mar 2023 20:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515264;
        bh=AQ6nU7SHgrEcWyO/dDeU3DSDaMiK10FMK2chPHbMoog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BdlZ+gwU2/pHkvwm80zox2c7v+qHZHS9edyn7L9nrPFhlhjCp7yThd4hc3cf9U8oi
         464dXSpIrD7gsj+KepN2ZHtGQgCCEtaDPn60Hes+iVkolxnxUC8oo+PufzOhlPl3nS
         2ZViN/2uBMebD0IvDwqH7LpWwa0RJg+zSD6Tswja1vx3oVkxZc3fOpGu0GKv8cKaN5
         Xngo9pXmwDBZ6wgxWizbSIRHf6mN+6ZFjYkpP2pV7dAdnIfy2x9MAM1usQVbqYWfdi
         cAYtMDSuWra4BxJzklmzLBatsb8TWCtFwtO3QJszNHDOJQCSPjwx18B/ltJsp46SXe
         vnl4jQNS2BvZg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philipp Geulen <p.geulen@js-elektronik.de>,
        Chaitanya Kulkarni <kkch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kbusch@kernel.org,
        axboe@fb.com, sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 6.1 25/34] nvme-pci: add NVME_QUIRK_BOGUS_NID for Lexar NM620
Date:   Wed, 22 Mar 2023 15:59:17 -0400
Message-Id: <20230322195926.1996699-25-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195926.1996699-1-sashal@kernel.org>
References: <20230322195926.1996699-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Geulen <p.geulen@js-elektronik.de>

[ Upstream commit b65d44fa0fe072c91bf41cd8756baa2b4c77eff2 ]

Added a quirk to fix Lexar NM620 1TB SSD reporting duplicate NGUIDs.

Signed-off-by: Philipp Geulen <p.geulen@js-elektronik.de>
Reviewed-by: Chaitanya Kulkarni <kkch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 778f94e9a4453..7893b52294553 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3545,6 +3545,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1d97, 0x2263), /* Lexar NM610 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x1d97, 0x1d97), /* Lexar NM620 */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1d97, 0x2269), /* Lexar NM760 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0061),
-- 
2.39.2

