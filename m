Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5640553D06
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355597AbiFUVAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 17:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355810AbiFUU7C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:59:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9DF32EF3;
        Tue, 21 Jun 2022 13:51:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67415B81B01;
        Tue, 21 Jun 2022 20:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DC8C341C6;
        Tue, 21 Jun 2022 20:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655844673;
        bh=wpWPKm77SNgupmJW0iUfC5yFgShXH24OzX4IJWMetxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DbRJ+/oyseJbIHOPkxXKpPv5nbfA8nNqchLhfVRbT0CikelmJsOEU4jqZr2+lEt4r
         ChwWwSgYgxmhQ25VNwZImA+8sgbRiigvUoBge5x/ncgWSzAUUXO+bZg6ePtMEQrSZ4
         dPdr9XLVXUffpqZRbg3XVVCwvBQMY1BFL3fFpvwvKytA+3FClX33VRJ39580qMA54V
         6j0U7fZ8TFr6Ci+l3IDLoxlajtrXgW+/CdIbj6WNf8XYv/WqLkaKPiPlIXe7Hoo/b/
         laAuLrcwyyTCVKReWoAi1cOuTsEAp9E2FgbfbXIMUj9F4GW51qqtUF3i+hSTZIYYFh
         Mp6UX9FmPL6Kw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, axboe@fb.com,
        sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 06/11] nvme-pci: smi has bogus namespace ids
Date:   Tue, 21 Jun 2022 16:51:00 -0400
Message-Id: <20220621205105.250640-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621205105.250640-1-sashal@kernel.org>
References: <20220621205105.250640-1-sashal@kernel.org>
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
index b806fb3f0f3a..610cf8c2a6a8 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3226,7 +3226,8 @@ static const struct pci_device_id nvme_id_table[] = {
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

