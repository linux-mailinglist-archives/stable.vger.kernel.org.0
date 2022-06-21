Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B05B553C81
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355719AbiFUVA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 17:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355548AbiFUU6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:58:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39A9326E7;
        Tue, 21 Jun 2022 13:51:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE3D86188D;
        Tue, 21 Jun 2022 20:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61FE5C3411C;
        Tue, 21 Jun 2022 20:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655844652;
        bh=F/Q8v9xOna4LqCh0X9VxEmi6WL3SrcJg/w9zCVR4nzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cib0Io00dFaRfZihQSko8Jc3oODIigIWlymexCwa/NDFV3DWKQhGJzppwrgrJQa3j
         xTt/FptiUk9snCGN+ZTqKL8uk2vYYWCBFuaHMCf0Fe56sDB52CPWkpJwUTYDr8N3Mn
         bZVcA7MA78TuoJixSAuvKG7r1/i9Isk5LrrvSkQy1Jk/MHMcv+FabjD4vdUKDio06C
         DcZkIRt/1Xkj8gSjXFlhU01mWb57oEKP+e8eGgDNGknmm9Umvyr13ca5bn3ZrBsQco
         L9W669aD3/bqJy82ntK0GlUkFiUV3ikeYwFvT7ftnQIQIMGkLk76hRw50ZwVY9gT/W
         BkHuNI/8Yzpig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Reiter <stefan@pimaker.at>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kbusch@kernel.org,
        axboe@fb.com, sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 06/17] nvme-pci: add NVME_QUIRK_BOGUS_NID for ADATA XPG GAMMIX S50
Date:   Tue, 21 Jun 2022 16:50:29 -0400
Message-Id: <20220621205041.250426-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621205041.250426-1-sashal@kernel.org>
References: <20220621205041.250426-1-sashal@kernel.org>
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

From: Stefan Reiter <stefan@pimaker.at>

[ Upstream commit 3765fad508964f433ac111c127d6bedd19bdfa04 ]

ADATA XPG GAMMIX S50 drives report bogus eui64 values that appear to
be the same across drives in one system. Quirk them out so they are
not marked as "non globally unique" duplicates.

Signed-off-by: Stefan Reiter <stefan@pimaker.at>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index e0accbf40f49..700857af5b79 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3368,6 +3368,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1e4B, 0x1202),   /* MAXIO MAP1202 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x1cc1, 0x5350),   /* ADATA XPG GAMMIX S50 */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0061),
 		.driver_data = NVME_QUIRK_DMA_ADDRESS_BITS_48, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0065),
-- 
2.35.1

