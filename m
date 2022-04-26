Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2838A510835
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 21:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353977AbiDZTGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 15:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353838AbiDZTGA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 15:06:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2C419A4AE;
        Tue, 26 Apr 2022 12:02:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D2D6B8225A;
        Tue, 26 Apr 2022 19:02:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0094C385AA;
        Tue, 26 Apr 2022 19:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999769;
        bh=OHTg+xiRClRmND9KQSuB7CsN17t/zbL4VTawcUn5Ao8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bZ00GZAEzWIs+F9ZBSnH935nI9+jqkshG/DzwmbfAoONzNAU5S27JqR1k3WBZkJaz
         K5zXF7mz7vv99CNMIUgWpNh7ds+fO6InEjBQrS+HMzfRvQe9jNUi6zEpCkPS+FIpFo
         sHmY8XAMc+1MALp5Xu9w6KuASfEGod563kh5iGJVoLaJfYceOBGmN7fq9WqFCs95/E
         jfjhpaBlUqZdwkN9/fRSUdWK21b2/zIBuKgdTLKtwdeFxMPyLLdNl09ZA6b2rldqIn
         RB++FXG0K6zhAuUknVmq+9rCBVoutKGWfPyVTmKiMxp3n7Sh9hzYCgAzzZA2zBqW/T
         8PTzHYkVa8QIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>, linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 6/6] ata: pata_marvell: Check the 'bmdma_addr' beforing reading
Date:   Tue, 26 Apr 2022 15:02:42 -0400
Message-Id: <20220426190243.2351733-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426190243.2351733-1-sashal@kernel.org>
References: <20220426190243.2351733-1-sashal@kernel.org>
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
index b066809ba9a1..c56f4043b0cc 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -83,6 +83,8 @@ static int marvell_cable_detect(struct ata_port *ap)
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

