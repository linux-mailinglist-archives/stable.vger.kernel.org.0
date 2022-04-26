Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A74A350F3A4
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344615AbiDZI0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344299AbiDZI0C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:26:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1770D39B8F;
        Tue, 26 Apr 2022 01:22:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7EB26179E;
        Tue, 26 Apr 2022 08:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A0CC385A0;
        Tue, 26 Apr 2022 08:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961375;
        bh=yx8av04Y5xxLJJnNv+WtjSdUDUvPluHDdTSScXGxX4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eH01vc+/dD+5dznQIdPe/TJ4fF+Mu44+rhak/8KVRGl+bNDqLTxsxIEpw9jjU6W71
         iiwXBCGL0WoXjHty6c1GROqwyFQIEKyLFh9MFpToLFvl7KoTbRntWWIZ2ksUqwKMdZ
         edj/uUKf2zPXWQ9jcKiOB5lPeITdRusUdoX2rV1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 4.9 15/24] ata: pata_marvell: Check the bmdma_addr beforing reading
Date:   Tue, 26 Apr 2022 10:21:09 +0200
Message-Id: <20220426081731.823926698@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081731.370823950@linuxfoundation.org>
References: <20220426081731.370823950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

commit aafa9f958342db36c17ac2a7f1b841032c96feb4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/pata_marvell.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -82,6 +82,8 @@ static int marvell_cable_detect(struct a
 	switch(ap->port_no)
 	{
 	case 0:
+		if (!ap->ioaddr.bmdma_addr)
+			return ATA_CBL_PATA_UNK;
 		if (ioread8(ap->ioaddr.bmdma_addr + 1) & 1)
 			return ATA_CBL_PATA40;
 		return ATA_CBL_PATA80;


