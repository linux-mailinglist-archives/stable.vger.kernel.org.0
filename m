Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8071510874
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 21:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236231AbiDZTHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 15:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353916AbiDZTGY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 15:06:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1600419A48F;
        Tue, 26 Apr 2022 12:03:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84F9D61A04;
        Tue, 26 Apr 2022 19:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6CF0C385B2;
        Tue, 26 Apr 2022 19:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999786;
        bh=mptsVlstBe9PgiegdjZZsGPgQatHpBsJM0+b0sy31Is=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RgNX0khZqqBfR/mbD9tASrHelk4oeNR5hjundNRBkVC0aSQojftOPVFWbUKDWpcpQ
         bsTsCkkYUuCp1zLsxX2wBOW7xm/httwsET1uMz0GtjlVZMBkXZERF0vXGFZuayLEDu
         LDwXUfgYfsybu04j/RuNAZKlLAWXU4Dij8P2eGhmHxn7k+Z4Lnwe9aQT3HPS2KZbvf
         VE1bNz77BCRKuLWRwMHLZkOmEYv8Ap8NpgboyoYFhRSX3f7ZaDtftpXogGSsV8Adn/
         bRoVQdLaBvr/7WfT5QeV5/98XTfrX7Ehqbh6QnIXvG4PAKB1Iw+mQsV0hfi8mRYBPa
         LW8mSkuY81now==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>, linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 3/3] ata: pata_marvell: Check the 'bmdma_addr' beforing reading
Date:   Tue, 26 Apr 2022 15:03:03 -0400
Message-Id: <20220426190304.2351976-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426190304.2351976-1-sashal@kernel.org>
References: <20220426190304.2351976-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit aafa9f958342db36c17ac2a7f1b841032c96feb4 ]

Before detecting the cable type on the dma bar, the driver should check
whether the 'bmdma_addr' is zero, which means the adapter does not
support DMA, otherwise we will get the following error:

[    5.146634] Bad IO access at port 0x1 (return inb(port))
[    5.147206] WARNING: CPU: 2 PID: 303 at lib/iomap.c:44 ioread8+0x4a/0x60
[    5.150856] RIP: 0010:ioread8+0x4a/0x60
[    5.160238] Call Trace:
[    5.160470]  <TASK>
[    5.160674]  marvell_cable_detect+0x6e/0xc0 [pata_marvell]
[    5.161728]  ata_eh_recover+0x3520/0x6cc0
[    5.168075]  ata_do_eh+0x49/0x3c0

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_marvell.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index ff468a6fd8dd..677f582cf3d6 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -82,6 +82,8 @@ static int marvell_cable_detect(struct ata_port *ap)
 	switch(ap->port_no)
 	{
 	case 0:
+		if (!ap->ioaddr.bmdma_addr)
+			return ATA_CBL_PATA_UNK;
 		if (ioread8(ap->ioaddr.bmdma_addr + 1) & 1)
 			return ATA_CBL_PATA40;
 		return ATA_CBL_PATA80;
-- 
2.35.1

