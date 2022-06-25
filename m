Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D33155A9EF
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 14:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbiFYMQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 08:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbiFYMQS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 08:16:18 -0400
Received: from mail2.sp2max.com.br (mail2.sp2max.com.br [138.185.4.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D0F7D140EC;
        Sat, 25 Jun 2022 05:16:17 -0700 (PDT)
Received: from fedora.. (unknown [190.245.244.131])
        (Authenticated sender: pablo@fliagreco.com.ar)
        by mail2.sp2max.com.br (Postfix) with ESMTPSA id 40ADF7B092A;
        Sat, 25 Jun 2022 09:10:35 -0300 (-03)
From:   Pablo Greco <pgreco@centosproject.org>
Cc:     Pablo Greco <pgreco@centosproject.org>, stable@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] nvme-pci: add NVME_QUIRK_BOGUS_NID for ADATA XPG SX6000LNP (AKA XPECTRIX S40G)
Date:   Sat, 25 Jun 2022 09:10:11 -0300
Message-Id: <20220625121011.8103-1-pgreco@centosproject.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SP2Max-MailScanner-Information: Please contact the ISP for more information
X-SP2Max-MailScanner-ID: 40ADF7B092A.A2A42
X-SP2Max-MailScanner: Sem Virus encontrado
X-SP2Max-MailScanner-SpamCheck: nao spam, SpamAssassin (not cached,
        escore=-2.91, requerido 6, autolearn=not spam, ALL_TRUSTED -1.00,
        BAYES_00 -1.90, T_SCC_BODY_TEXT_LINE -0.01)
X-SP2Max-MailScanner-From: pgreco@centosproject.org
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ADATA XPG SPECTRIX S40G drives report bogus eui64 values that appear to
be the same across drives in one system. Quirk them out so they are
not marked as "non globally unique" duplicates.

Before:
[    2.258919] nvme nvme1: pci function 0000:06:00.0
[    2.264898] nvme nvme2: pci function 0000:05:00.0
[    2.323235] nvme nvme1: failed to set APST feature (2)
[    2.326153] nvme nvme2: failed to set APST feature (2)
[    2.333935] nvme nvme1: allocated 64 MiB host memory buffer.
[    2.336492] nvme nvme2: allocated 64 MiB host memory buffer.
[    2.339611] nvme nvme1: 7/0/0 default/read/poll queues
[    2.341805] nvme nvme2: 7/0/0 default/read/poll queues
[    2.346114]  nvme1n1: p1
[    2.347197] nvme nvme2: globally duplicate IDs for nsid 1
After:
[    2.427715] nvme nvme1: pci function 0000:06:00.0
[    2.427771] nvme nvme2: pci function 0000:05:00.0
[    2.488154] nvme nvme2: failed to set APST feature (2)
[    2.489895] nvme nvme1: failed to set APST feature (2)
[    2.498773] nvme nvme2: allocated 64 MiB host memory buffer.
[    2.500587] nvme nvme1: allocated 64 MiB host memory buffer.
[    2.504113] nvme nvme2: 7/0/0 default/read/poll queues
[    2.507026] nvme nvme1: 7/0/0 default/read/poll queues
[    2.509467] nvme nvme2: Ignoring bogus Namespace Identifiers
[    2.512804] nvme nvme1: Ignoring bogus Namespace Identifiers
[    2.513698]  nvme1n1: p1

Signed-off-by: Pablo Greco <pgreco@centosproject.org>
Cc: <stable@vger.kernel.org>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index d7b24ee17285..c9ebe6072498 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3470,7 +3470,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_NO_NS_DESC_LIST |
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE(0x10ec, 0x5762),   /* ADATA SX6000LNP */
-		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN, },
+		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN |
+				NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1cc1, 0x8201),   /* ADATA SX8200PNP 512GB */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS |
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
-- 
2.36.1

