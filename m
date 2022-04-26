Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D894850F49E
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345121AbiDZIgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345463AbiDZIei (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:34:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB90C762BC;
        Tue, 26 Apr 2022 01:27:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08D31617AE;
        Tue, 26 Apr 2022 08:27:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1591EC385A4;
        Tue, 26 Apr 2022 08:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961645;
        bh=yx8av04Y5xxLJJnNv+WtjSdUDUvPluHDdTSScXGxX4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DpQErN2DhSeYA6wcJ6KvCvBZiR4SFgjy2gLUn22zwV+uxYOrKeMEZe8tYxrXQaNlk
         Exow5PpkFamT+kX0LtN18+LxRzUwjGhTeydH1t+akvvmyKYIELgPUFCjtScfJrVNF9
         zCD158MiESEYvgRJZx2lDUsjwLe99ITPRR1NMNcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 4.19 29/53] ata: pata_marvell: Check the bmdma_addr beforing reading
Date:   Tue, 26 Apr 2022 10:21:09 +0200
Message-Id: <20220426081736.502980807@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081735.651926456@linuxfoundation.org>
References: <20220426081735.651926456@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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


