Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A06C6AE897
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjCGRRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:17:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbjCGRRR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:17:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE7816AFB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:12:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78F7A614E7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:12:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706EAC433EF;
        Tue,  7 Mar 2023 17:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209169;
        bh=RjLut2ejJIbCFRA2lCvOTojkatcBxvS8gouBh9IDL6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ry0GXE86/tRRj26auDN7XBGlj8u3FEB/Sedy8vnATNkl8kwVtzBiIFn68kdJOYehG
         cEabAWcZn3eGlfc2q1OHt5ye8uTpi/0bVUEgn/ROeDx0OiCgY0udyFhMrGc34gTnjf
         Sjd5McWs/DmtU30iTKAS7LFfsBsNGnyBKTtRwMzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lorenzo Bianconi <lorenzo@kernel.org>,
        YN Chen <YN.Chen@mediatek.com>,
        Deren Wu <deren.wu@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0133/1001] wifi: mt76: mt7921s: fix slab-out-of-bounds access in sdio host
Date:   Tue,  7 Mar 2023 17:48:25 +0100
Message-Id: <20230307170027.842688585@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deren Wu <deren.wu@mediatek.com>

[ Upstream commit aec4cf2ea0797e28f18f8dbe01943a56d987fe56 ]

SDIO may need addtional 511 bytes to align bus operation. If the tailroom
of this skb is not big enough, we would access invalid memory region.
For low level operation, increase skb size to keep valid memory access in
SDIO host.

Error message:
[69.951] BUG: KASAN: slab-out-of-bounds in sg_copy_buffer+0xe9/0x1a0
[69.951] Read of size 64 at addr ffff88811c9cf000 by task kworker/u16:7/451
[69.951] CPU: 4 PID: 451 Comm: kworker/u16:7 Tainted: G W  OE  6.1.0-rc5 #1
[69.951] Workqueue: kvub300c vub300_cmndwork_thread [vub300]
[69.951] Call Trace:
[69.951]  <TASK>
[69.952]  dump_stack_lvl+0x49/0x63
[69.952]  print_report+0x171/0x4a8
[69.952]  kasan_report+0xb4/0x130
[69.952]  kasan_check_range+0x149/0x1e0
[69.952]  memcpy+0x24/0x70
[69.952]  sg_copy_buffer+0xe9/0x1a0
[69.952]  sg_copy_to_buffer+0x12/0x20
[69.952]  __command_write_data.isra.0+0x23c/0xbf0 [vub300]
[69.952]  vub300_cmndwork_thread+0x17f3/0x58b0 [vub300]
[69.952]  process_one_work+0x7ee/0x1320
[69.952]  worker_thread+0x53c/0x1240
[69.952]  kthread+0x2b8/0x370
[69.952]  ret_from_fork+0x1f/0x30
[69.952]  </TASK>

[69.952] Allocated by task 854:
[69.952]  kasan_save_stack+0x26/0x50
[69.952]  kasan_set_track+0x25/0x30
[69.952]  kasan_save_alloc_info+0x1b/0x30
[69.952]  __kasan_kmalloc+0x87/0xa0
[69.952]  __kmalloc_node_track_caller+0x63/0x150
[69.952]  kmalloc_reserve+0x31/0xd0
[69.952]  __alloc_skb+0xfc/0x2b0
[69.952]  __mt76_mcu_msg_alloc+0xbf/0x230 [mt76]
[69.952]  mt76_mcu_send_and_get_msg+0xab/0x110 [mt76]
[69.952]  __mt76_mcu_send_firmware.cold+0x94/0x15d [mt76]
[69.952]  mt76_connac_mcu_send_ram_firmware+0x415/0x54d [mt76_connac_lib]
[69.952]  mt76_connac2_load_ram.cold+0x118/0x4bc [mt76_connac_lib]
[69.952]  mt7921_run_firmware.cold+0x2e9/0x405 [mt7921_common]
[69.952]  mt7921s_mcu_init+0x45/0x80 [mt7921s]
[69.953]  mt7921_init_work+0xe1/0x2a0 [mt7921_common]
[69.953]  process_one_work+0x7ee/0x1320
[69.953]  worker_thread+0x53c/0x1240
[69.953]  kthread+0x2b8/0x370
[69.953]  ret_from_fork+0x1f/0x30
[69.953] The buggy address belongs to the object at ffff88811c9ce800
             which belongs to the cache kmalloc-2k of size 2048
[69.953] The buggy address is located 0 bytes to the right of
             2048-byte region [ffff88811c9ce800, ffff88811c9cf000)

[69.953] Memory state around the buggy address:
[69.953]  ffff88811c9cef00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[69.953]  ffff88811c9cef80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[69.953] >ffff88811c9cf000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[69.953]                    ^
[69.953]  ffff88811c9cf080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[69.953]  ffff88811c9cf100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc

Fixes: 764dee47e2c1 ("mt76: sdio: move common code in mt76_sdio module")
Suggested-by: Lorenzo Bianconi <lorenzo@kernel.org>
Tested-by: YN Chen <YN.Chen@mediatek.com>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/sdio_txrx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/sdio_txrx.c b/drivers/net/wireless/mediatek/mt76/sdio_txrx.c
index bfc4de50a4d23..ddd8c0cc744df 100644
--- a/drivers/net/wireless/mediatek/mt76/sdio_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/sdio_txrx.c
@@ -254,6 +254,10 @@ static int mt76s_tx_run_queue(struct mt76_dev *dev, struct mt76_queue *q)
 
 		if (!test_bit(MT76_STATE_MCU_RUNNING, &dev->phy.state)) {
 			__skb_put_zero(e->skb, 4);
+			err = __skb_grow(e->skb, roundup(e->skb->len,
+							 sdio->func->cur_blksize));
+			if (err)
+				return err;
 			err = __mt76s_xmit_queue(dev, e->skb->data,
 						 e->skb->len);
 			if (err)
-- 
2.39.2



