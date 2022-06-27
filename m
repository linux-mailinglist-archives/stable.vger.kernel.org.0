Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A16E55D886
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235071AbiF0L0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234967AbiF0LZj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:25:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A6465F6;
        Mon, 27 Jun 2022 04:25:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89A3EB81120;
        Mon, 27 Jun 2022 11:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDB4C3411D;
        Mon, 27 Jun 2022 11:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329130;
        bh=CzEvVMsq7MbqC5iRtVZJf74lx8fGoF1f7lKbuEE3YxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PCzdD8YaF2zmlkCILD8MpxF+IbL7cRgZ2cT0ym9CjnxBx4YYCM5xPNjAdhUc0iLeQ
         nZ+3seCDuIuqgNX5DMgMVsxw9Gc5BO+TnmfNTXsidRD4I/1CCnFQ5Xz1BRnTywpShB
         HZVH6sKY5gm8NtgK4bV+iE6iC1nEYYbxSRdXHMTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Pankaj Raghav <p.raghav@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/102] nvme: move the Samsung X5 quirk entry to the core quirks
Date:   Mon, 27 Jun 2022 13:21:11 +0200
Message-Id: <20220627111935.252321824@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit e6487833182a8a0187f0292aca542fc163ccd03e ]

This device shares the PCI ID with the Samsung 970 Evo Plus that
does not need or want the quirks.  Move the the quirk entry to the
core table based on the model number instead.

Fixes: bc360b0b1611 ("nvme-pci: add quirks for Samsung X5 SSDs")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 14 ++++++++++++++
 drivers/nvme/host/pci.c  |  4 ----
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 9ec3ac367a76..af2902d70b19 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2713,6 +2713,20 @@ static const struct nvme_core_quirk_entry core_quirks[] = {
 		.vid = 0x1e0f,
 		.mn = "KCD6XVUL6T40",
 		.quirks = NVME_QUIRK_NO_APST,
+	},
+	{
+		/*
+		 * The external Samsung X5 SSD fails initialization without a
+		 * delay before checking if it is ready and has a whole set of
+		 * other problems.  To make this even more interesting, it
+		 * shares the PCI ID with internal Samsung 970 Evo Plus that
+		 * does not need or want these quirks.
+		 */
+		.vid = 0x144d,
+		.mn = "Samsung Portable SSD X5",
+		.quirks = NVME_QUIRK_DELAY_BEFORE_CHK_RDY |
+			  NVME_QUIRK_NO_DEEPEST_PS |
+			  NVME_QUIRK_IGNORE_DEV_SUBNQN,
 	}
 };
 
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 31c6938e5045..9e633f4dcec7 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3265,10 +3265,6 @@ static const struct pci_device_id nvme_id_table[] = {
 				NVME_QUIRK_128_BYTES_SQES |
 				NVME_QUIRK_SHARED_TAGS |
 				NVME_QUIRK_SKIP_CID_GEN },
-	{ PCI_DEVICE(0x144d, 0xa808),   /* Samsung X5 */
-		.driver_data =  NVME_QUIRK_DELAY_BEFORE_CHK_RDY|
-				NVME_QUIRK_NO_DEEPEST_PS |
-				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_EXPRESS, 0xffffff) },
 	{ 0, }
 };
-- 
2.35.1



