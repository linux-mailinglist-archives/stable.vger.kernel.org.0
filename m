Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21853553D2F
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355430AbiFUVBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 17:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355338AbiFUU50 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:57:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3094532044;
        Tue, 21 Jun 2022 13:50:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C84F0B81B38;
        Tue, 21 Jun 2022 20:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7A5C341C7;
        Tue, 21 Jun 2022 20:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655844654;
        bh=vYAOtJIbQpgVQtzt6pH+NKd0bbm6APv6baei1cRDblE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Swri0b0HMCP8/PrE+dcON566yzNyRiIOYzN407xIPPteeyOffouFkUsXTiTnzJN1C
         YY8y+5fZSLhMMHbDLofM+7ibZn1y9YYP9JDmRTlUhpyyvhNuqRYynjcxZypamEp7BJ
         gaIn6GPC0oNSuRut3fVVkQpNAn1u+YfZi8eFXgJAzV50hOut5xHIHCnyYT3C8+FbfJ
         wZb7nq6uMu9T5DpP87rIAs0ZhATSV/i6PQoR4VHgLTuwfFuad/qkx2TE0nNyy/gPg7
         tcr5kdJ8mG4nqhqZO7CEtamBXm5DWaejVRIrKpEHz9gRudIY8gxKj2TcLNS9PvHl4J
         bJJQC4IoEcUYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, axboe@fb.com,
        sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 08/17] nvme-pci: smi has bogus namespace ids
Date:   Tue, 21 Jun 2022 16:50:31 -0400
Message-Id: <20220621205041.250426-8-sashal@kernel.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit c98a879312caf775c9768faed25ce1c013b4df04 ]

Add the quirk.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216096
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 93d1f12f31bb..f06bc7596e2b 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3328,7 +3328,8 @@ static const struct pci_device_id nvme_id_table[] = {
 	{ PCI_VDEVICE(REDHAT, 0x0010),	/* Qemu emulated controller */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x126f, 0x2263),	/* Silicon Motion unidentified */
-		.driver_data = NVME_QUIRK_NO_NS_DESC_LIST, },
+		.driver_data = NVME_QUIRK_NO_NS_DESC_LIST |
+				NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1bb1, 0x0100),   /* Seagate Nytro Flash Storage */
 		.driver_data = NVME_QUIRK_DELAY_BEFORE_CHK_RDY |
 				NVME_QUIRK_NO_NS_DESC_LIST, },
-- 
2.35.1

