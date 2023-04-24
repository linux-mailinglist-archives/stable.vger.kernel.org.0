Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571EA6D474F
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbjDCOTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbjDCOTF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:19:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280652C9F2
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:19:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 998A4B81BA3
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED66C433EF;
        Mon,  3 Apr 2023 14:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531541;
        bh=tHwk9/r/WDvRoc05Y1C3ntAttYDGx+o/WrfiprrAmdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u2yt5qZrjYg47iYv795ZG75A3o1FtXiHMimfy0Rsn3WS2uwDYqujtKSbuTyM/eQay
         SuF9/9PgWBsR5PT2etCSc86VpNY6QDt87lDk4QiImTLhYL3JDGfQInbtzo09gHbkkL
         6nLs6SgT81omRCVv2mMyjPkMsrMqaZWnPdRULUjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Zetao <lizetao1@huawei.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 018/104] atm: idt77252: fix kmemleak when rmmod idt77252
Date:   Mon,  3 Apr 2023 16:08:10 +0200
Message-Id: <20230403140404.922912843@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Zetao <lizetao1@huawei.com>

[ Upstream commit 4fe3c88552a3fbe1944426a4506a18cdeb457b5a ]

There are memory leaks reported by kmemleak:

  unreferenced object 0xffff888106500800 (size 128):
    comm "modprobe", pid 1017, jiffies 4297787785 (age 67.152s)
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<00000000970ce626>] __kmem_cache_alloc_node+0x20c/0x380
      [<00000000fb5f78d9>] kmalloc_trace+0x2f/0xb0
      [<000000000e947e2a>] idt77252_init_one+0x2847/0x3c90 [idt77252]
      [<000000006efb048e>] local_pci_probe+0xeb/0x1a0
    ...

  unreferenced object 0xffff888106500b00 (size 128):
    comm "modprobe", pid 1017, jiffies 4297787785 (age 67.152s)
    hex dump (first 32 bytes):
      00 20 3d 01 80 88 ff ff 00 20 3d 01 80 88 ff ff  . =...... =.....
      f0 23 3d 01 80 88 ff ff 00 20 3d 01 00 00 00 00  .#=...... =.....
    backtrace:
      [<00000000970ce626>] __kmem_cache_alloc_node+0x20c/0x380
      [<00000000fb5f78d9>] kmalloc_trace+0x2f/0xb0
      [<00000000f451c5be>] alloc_scq.constprop.0+0x4a/0x400 [idt77252]
      [<00000000e6313849>] idt77252_init_one+0x28cf/0x3c90 [idt77252]

The root cause is traced to the vc_maps which alloced in open_card_oam()
are not freed in close_card_oam(). The vc_maps are used to record
open connections, so when close a vc_map in close_card_oam(), the memory
should be freed. Moreover, the ubr0 is not closed when close a idt77252
device, leading to the memory leak of vc_map and scq_info.

Fix them by adding kfree in close_card_oam() and implementing new
close_card_ubr0() to close ubr0.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
Reviewed-by: Francois Romieu <romieu@fr.zoreil.com>
Link: https://lore.kernel.org/r/20230320143318.2644630-1-lizetao1@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/idt77252.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index a95a9448984fe..c60611196786f 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -2914,6 +2914,7 @@ close_card_oam(struct idt77252_dev *card)
 
 				recycle_rx_pool_skb(card, &vc->rcv.rx_pool);
 			}
+			kfree(vc);
 		}
 	}
 }
@@ -2957,6 +2958,15 @@ open_card_ubr0(struct idt77252_dev *card)
 	return 0;
 }
 
+static void
+close_card_ubr0(struct idt77252_dev *card)
+{
+	struct vc_map *vc = card->vcs[0];
+
+	free_scq(card, vc->scq);
+	kfree(vc);
+}
+
 static int
 idt77252_dev_open(struct idt77252_dev *card)
 {
@@ -3006,6 +3016,7 @@ static void idt77252_dev_close(struct atm_dev *dev)
 	struct idt77252_dev *card = dev->dev_data;
 	u32 conf;
 
+	close_card_ubr0(card);
 	close_card_oam(card);
 
 	conf = SAR_CFG_RXPTH |	/* enable receive path           */
-- 
2.39.2



