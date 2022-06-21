Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED374553C88
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355168AbiFUU4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 16:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355718AbiFUUyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:54:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B19313B4;
        Tue, 21 Jun 2022 13:50:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34AAF6188A;
        Tue, 21 Jun 2022 20:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017FBC341C4;
        Tue, 21 Jun 2022 20:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655844591;
        bh=r/ki/nn5lDRi/fmgq8xrIpBItw40es9Cpxv7lHYtyd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGpD27CnziA9dXi+tldVs48JKnS5pGfeQ8z46buKWKYa7eU7BPgpbUcj2agrVMPbh
         wrgEpMCd9edrZarGiLymkhzKat4lKJGcuX7HCQGIcpmoM295DT0GhZA/y6kqQrOOX+
         LxcKkuD6xZhObtZ5VTIKueOgum2LVYosKnUOwyHJMgwBUIs9VFm7Wr+B7OOwDbs/J3
         n7Um5P8mvZOYWYa4U7shC+Fgv1O59ZaKnmULfUv9xGMvNrOYgzGn/G3w1OohP+ZiPx
         75Rk1YCElWoWGp+7JDs0JjOrPs4ekU/fm1hRsnjKxZjiICwCXMLATvlxXnAzqXILoW
         7vheTmXbuqpmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, axboe@fb.com,
        sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.18 09/22] nvme-pci: phison e12 has bogus namespace ids
Date:   Tue, 21 Jun 2022 16:49:15 -0400
Message-Id: <20220621204928.249907-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621204928.249907-1-sashal@kernel.org>
References: <20220621204928.249907-1-sashal@kernel.org>
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

[ Upstream commit 2cf7a77ed5f8903606f4f7833d02d67b08650442 ]

Add the quirk.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216049
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 37a2a88d35c9..a14f204b07c1 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3455,6 +3455,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_DELAY_BEFORE_CHK_RDY |
 				NVME_QUIRK_DISABLE_WRITE_ZEROES|
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
+	{ PCI_DEVICE(0x1987, 0x5012),	/* Phison E12 */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1987, 0x5016),	/* Phison E16 */
 		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE(0x1b4b, 0x1092),	/* Lexar 256 GB SSD */
-- 
2.35.1

