Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6010A6281A7
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235819AbiKNNwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:52:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiKNNwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:52:09 -0500
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E036321E2F;
        Mon, 14 Nov 2022 05:52:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1668433742;
    s=strato-dkim-0002; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=XaFRuyuAWQLKXs82lMqlPI52kvHdbMsiwZzz0MVOz54=;
    b=sjlHKKS0i50fNiba9s72G3UDHr5J1glruCcTyntjCaJxW7eTqHKquqKXLwPNCUwyTX
    dxsFbDDpWo5DqMHhssNbR3XLT9Fzm+643ZltdvbkBmXplA49zDs2nkwAt3+Azn2uoxiM
    Y+aMgzO88ptwPYDTMxxDvrvSCis3qUwijyFDwfhKmf0Zn85gtXpOwEtUmmaGxVqkQjxL
    m8qilyCLokvfC1r80n5jkg/b2363t51rqle9ZRBiVgnWiSYTX2c9VgQVZQugCL9dWZ3o
    CUBe6loRUI9ltV3MVCtNGn9C1jyG4KSuS1iuelCV2kZkSCusk1eoID3fKohhlvEav2sL
    qHaw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSedrgBzPc9DUyubU4DD2QzemV2tdlNlNRZBXiUw="
X-RZG-CLASS-ID: mo00
Received: from blinux.micron.com
    by smtp.strato.de (RZmta 48.2.1 AUTH)
    with ESMTPSA id z9cfbfyAEDmw9Qh
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 14 Nov 2022 14:48:58 +0100 (CET)
From:   Bean Huo <beanhuo@iokpp.de>
To:     beanhuo@micron.com, kbusch@kernel.org, axboe@fb.com, hch@lst.de,
        sagi@grimberg.me
Cc:     linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] nvme-pci: add NVME_QUIRK_BOGUS_NID for Micron Nitro
Date:   Mon, 14 Nov 2022 14:48:52 +0100
Message-Id: <20221114134852.73402-1-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Added a quirk to fix Micron Nitro NVMe reporting duplicate NGUIDs.

Cc: <stable@vger.kernel.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index bcbef6bc5672..5ded5703e06e 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3491,6 +3491,8 @@ static const struct pci_device_id nvme_id_table[] = {
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	 { PCI_DEVICE(0x1344, 0x5407), /* Micron Technology Inc NVMe SSD */
 		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN },
+	 { PCI_DEVICE(0x1344, 0x6001),   /* Micron Nitro NVMe */
+		 .driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1c5c, 0x1504),   /* SK Hynix PC400 */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x1c5c, 0x174a),   /* SK Hynix P31 SSD */
-- 
2.25.1

