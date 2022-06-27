Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEC7A55D2EB
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238182AbiF0Lu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238562AbiF0Lsq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944FE101FA;
        Mon, 27 Jun 2022 04:42:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12CDA61208;
        Mon, 27 Jun 2022 11:42:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27290C3411D;
        Mon, 27 Jun 2022 11:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330141;
        bh=Ovg5KfB61gT914x/8BIG61Aa3Dqe0xiyAs4tQvKXrZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UTMagV/1B473pk7V174topPJNhaiFx/jb+NASVaRTAnIYQlbBO3ncMsXVbIxgliaz
         vaRdFWWnOMWdgT7D4UMB5NrrFnZNvRrSMv0g5s93hhNNHcLiExBpIkA4QYrTkkeT1M
         4aFKJOkHuArgTDYtRIi4DMVDjAIJUT9uMB7qrK5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Pankaj Raghav <p.raghav@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 099/181] nvme: move the Samsung X5 quirk entry to the core quirks
Date:   Mon, 27 Jun 2022 13:21:12 +0200
Message-Id: <20220627111947.566413521@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
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
index 1ea85c88d795..a2862a56fadc 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2487,6 +2487,20 @@ static const struct nvme_core_quirk_entry core_quirks[] = {
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
index 17aeb7d5c485..ddea0fb90c28 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3475,10 +3475,6 @@ static const struct pci_device_id nvme_id_table[] = {
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



