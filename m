Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04BB46E637D
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbjDRMk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbjDRMkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:40:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A8613C3B
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:40:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E99996331A
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:40:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACF4C433EF;
        Tue, 18 Apr 2023 12:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821653;
        bh=LQSsPFWcfI9+lKOI0FmyNxjNyg5abFg8Xgv/Opy3b3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZVYgxp7FDSvYz6i0OtSpXtgwQw0g/48qlV5g3+a7/k01kS2xDSuYVw2esz8zF1Q5
         TEj/rBP/fa0pm/IcIP1JaPFWtSZ8yhe9lb7jnQbDTfYKOz5pZo2Z4G92oPH2zyXt4K
         F8BWaDI1wsJmmnuP1Zz+Sp8NHg0/+ftWB5Nr672U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Duy Truong <dory@dory.moe>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 83/91] nvme-pci: add NVME_QUIRK_BOGUS_NID for T-FORCE Z330 SSD
Date:   Tue, 18 Apr 2023 14:22:27 +0200
Message-Id: <20230418120308.446030203@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duy Truong <dory@dory.moe>

[ Upstream commit 74391b3e69855e7dd65a9cef36baf5fc1345affd ]

Added a quirk to fix the TeamGroup T-Force Cardea Zero Z330 SSDs reporting
duplicate NGUIDs.

Signed-off-by: Duy Truong <dory@dory.moe>
Cc: stable@vger.kernel.org
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index bd8dbaaa3715c..30c730a9f5188 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3399,6 +3399,8 @@ static const struct pci_device_id nvme_id_table[] = {
 	{ PCI_DEVICE(0x1d97, 0x2269), /* Lexar NM760 */
 		.driver_data = NVME_QUIRK_BOGUS_NID |
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
+	{ PCI_DEVICE(0x10ec, 0x5763), /* TEAMGROUP T-FORCE CARDEA ZERO Z330 SSD */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0061),
 		.driver_data = NVME_QUIRK_DMA_ADDRESS_BITS_48, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0065),
-- 
2.39.2



