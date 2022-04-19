Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F6A50786D
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356531AbiDSSV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356799AbiDSSUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:20:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB5E3FDA1;
        Tue, 19 Apr 2022 11:13:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E816160AC0;
        Tue, 19 Apr 2022 18:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55316C385A5;
        Tue, 19 Apr 2022 18:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392032;
        bh=ji0RFgXR37v47Ioji/Ek0sxM2Xxd8cjtq5D9oiSiFpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YEHaHB2UIm3BJwsCySanI+F+djOBdJjokYvn7r44Zits6AROC9SH/QNYOxmmXnO63
         lgEJqnyBNWIRkpaH1V72z7UmHEJZAP5tvnsmTBU2CJDEqa5mvUO4i3Lzc2GprCicB8
         mr+i2PA9CJEuAu6gist/hi2HmQqsjNL9t7AYdziH8f5/p43qgIXmoMPMEFCtpy19N7
         bfFEmi2nuziyxoZZn6haCSrWzZ5y6UnndmkjpRr+H+7Df//V13K6yFxbYM/OvaocnK
         1Mbat5D+3KnKjS5TVf7SPFjG4i41HwMkg5qT+MJ7RxEA6ncTPKgbdftOUcxh3glkQL
         +jx+kkrtFz8pg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>, axboe@fb.com,
        linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 27/27] nvme-pci: disable namespace identifiers for Qemu controllers
Date:   Tue, 19 Apr 2022 14:12:42 -0400
Message-Id: <20220419181242.485308-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181242.485308-1-sashal@kernel.org>
References: <20220419181242.485308-1-sashal@kernel.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 66dd346b84d79fde20832ed691a54f4881eac20d ]

Qemu unconditionally reports a UUID, which depending on the qemu version
is either all-null (which is incorrect but harmless) or contains a single
bit set for all controllers.  In addition it can also optionally report
a eui64 which needs to be manually set.  Disable namespace identifiers
for Qemu controlles entirely even if in some cases they could be set
correctly through manual intervention.

Reported-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 61f01f5afdc1..d7695bdbde8d 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3314,7 +3314,10 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_VDEVICE(INTEL, 0x5845),	/* Qemu emulated controller */
 		.driver_data = NVME_QUIRK_IDENTIFY_CNS |
-				NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+				NVME_QUIRK_DISABLE_WRITE_ZEROES |
+				NVME_QUIRK_BOGUS_NID, },
+	{ PCI_VDEVICE(REDHAT, 0x0010),	/* Qemu emulated controller */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x126f, 0x2263),	/* Silicon Motion unidentified */
 		.driver_data = NVME_QUIRK_NO_NS_DESC_LIST, },
 	{ PCI_DEVICE(0x1bb1, 0x0100),   /* Seagate Nytro Flash Storage */
-- 
2.35.1

