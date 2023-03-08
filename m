Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C06F56B0EBF
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 17:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbjCHQ2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 11:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjCHQ2b (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 11:28:31 -0500
X-Greylist: delayed 469 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 08 Mar 2023 08:27:44 PST
Received: from forward108p.mail.yandex.net (forward108p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43039D5A46
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 08:27:44 -0800 (PST)
Received: from sas1-1970a3fc41d8.qloud-c.yandex.net (sas1-1970a3fc41d8.qloud-c.yandex.net [IPv6:2a02:6b8:c08:48a4:0:640:1970:a3fc])
        by forward108p.mail.yandex.net (Yandex) with ESMTP id 575802679E59;
        Wed,  8 Mar 2023 19:19:52 +0300 (MSK)
Received: by sas1-1970a3fc41d8.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id iJfQDcAc0W21-XUbqcInz;
        Wed, 08 Mar 2023 19:19:51 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mishamosher.com; s=mail;
        t=1678292391; bh=hY0nRoNK6CsDJob1A0jYc6DGsjkhEnhZ4KXWeLmNT3Q=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=BmqiezmtJ9aCFvMH8zOHhJPFN1pqaXCuqtXWzq8/p+vNS17ZCJVooz1VCxVYigwC3
         CblmefuWQUPCpgVvozvNCtufkh+XYIepb5tDDXy9JjCWe6Z2b6fS1wAm5wyXUB7JuU
         CpGnB4E5nhytG7LX48WxExZu96EbIMPASRjBCyBc=
Authentication-Results: sas1-1970a3fc41d8.qloud-c.yandex.net; dkim=pass header.i=@mishamosher.com
From:   Elmer Miroslav Mosher Golovin <miroslav@mishamosher.com>
To:     linux-nvme@lists.infradead.org
Cc:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Elmer Miroslav Mosher Golovin <miroslav@mishamosher.com>,
        stable@vger.kernel.org
Subject: [PATCH] nvme-pci: add NVME_QUIRK_BOGUS_NID for Netac NV3000
Date:   Wed,  8 Mar 2023 19:19:29 +0300
Message-Id: <20230308161929.18446-1-miroslav@mishamosher.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Added a quirk to fix the Netac NV3000 SSD reporting duplicate NGUIDs.

Cc: <stable@vger.kernel.org>
Signed-off-by: Elmer Miroslav Mosher Golovin <miroslav@mishamosher.com>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 5b95c94ee40f..428d3f47760e 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3415,6 +3415,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x2646, 0x501E),   /* KINGSTON OM3PGP4xxxxQ OS21011 NVMe SSD */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x1f40, 0x1202),   /* Netac Technologies Co. NV3000 NVMe SSD */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1f40, 0x5236),   /* Netac Technologies Co. NV7000 NVMe SSD */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1e4B, 0x1001),   /* MAXIO MAP1001 */
-- 
2.39.2

