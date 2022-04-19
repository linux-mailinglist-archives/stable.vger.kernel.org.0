Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12654507848
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356756AbiDSSV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354832AbiDSSUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:20:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76ED43FDA3;
        Tue, 19 Apr 2022 11:13:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C2B5B818FE;
        Tue, 19 Apr 2022 18:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E946BC385BB;
        Tue, 19 Apr 2022 18:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392030;
        bh=blG1BoqgDz4cY3SBTCFsQD2tkAE2zYDC7RKtOQpGP2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TxJFfnx4YueM6BxDJh1c2w69rTWAzu2HoLOOfpcN3jGwQQ/xSRWfnLVMk+FREIt8U
         LbZyBI32aDjIuksH8YXVfUej6uF44tRYSIbulDs9ZeycqQzzx5AEJiXauf0cnfUQuA
         mcAUKvzckoRqfaBmrZxc2sV/3DvkNovjtquufI5EvmpILus/yd1xLuryWknKKtyDfv
         2FwbggQmfC80lP+4f2Gy+YEYlz9xGaHJsauT0BIggaqnQMNL3aOQyQQDExa+jiZcI0
         3+8AqwkyTtjFU7m47VQKEnMN5rbEexNc6FMPRXD84iSJs3x5/wZHvI7iFbvZKr+pTs
         D/XYcrIGlERLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        =?UTF-8?q?=E9=87=91=E9=9F=AC?= <me@kingtous.cn>,
        Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>, axboe@fb.com,
        sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 26/27] nvme-pci: disable namespace identifiers for the MAXIO MAP1002/1202
Date:   Tue, 19 Apr 2022 14:12:41 -0400
Message-Id: <20220419181242.485308-26-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181242.485308-1-sashal@kernel.org>
References: <20220419181242.485308-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit a98a945b80f8684121d477ae68ebc01da953da1f ]

The MAXIO MAP1002/1202 controllers reports completely bogus Namespace
identifiers that even change after suspend cycles.  Disable using
the Identifiers entirely.

Reported-by: 金韬 <me@kingtous.cn>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Tested-by: 金韬 <me@kingtous.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index b925a5f4afc3..61f01f5afdc1 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3352,6 +3352,10 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(0x2646, 0x2263),   /* KINGSTON A2000 NVMe SSD  */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
+	{ PCI_DEVICE(0x1e4B, 0x1002),   /* MAXIO MAP1002 */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x1e4B, 0x1202),   /* MAXIO MAP1202 */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0061),
 		.driver_data = NVME_QUIRK_DMA_ADDRESS_BITS_48, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0065),
-- 
2.35.1

