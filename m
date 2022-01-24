Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3712749A02D
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842402AbiAXXBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382775AbiAXWxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:53:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7843C061A10;
        Mon, 24 Jan 2022 13:08:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 831A0B80FA3;
        Mon, 24 Jan 2022 21:08:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB209C340E5;
        Mon, 24 Jan 2022 21:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058519;
        bh=XVfbMr+0bam4xryzd7On8rKa6GlVOXgJT+vvJ89vSBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v5TDG/ZebXH84R+DJhR9it98WcAEmXCcn2wNwx3tQpKQZRmIjEdwna8pC0nvIfGu1
         Q29ER5MxBQahmLlEblDWJNx1K5pWtQZ9zl5bM13gvXO/mNoysxTrpS2q9JqwwcN8cT
         dMejYdw0mbuY9jhmoTmKf5lCMCuhCxlxipqql8Bo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0316/1039] mt76: mt7921s: fix possible kernel crash due to invalid Rx count
Date:   Mon, 24 Jan 2022 19:35:05 +0100
Message-Id: <20220124184135.922658007@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 2b7f3574ca9a7ff4a6b4ec1ae4dfdfde481ac80b ]

Return the proper error code when out-of-range the Rx aggregation count
are reported from the hardware that would create the unreasonable extreme
large Rx buffer.

[  100.873810]  show_stack+0x20/0x2c
[  100.873823]  dump_stack+0xc4/0x140
[  100.873839]  bad_page+0x110/0x114
[  100.873854]  check_new_pages+0xf8/0xfc
[  100.873869]  rmqueue+0x5a0/0x640
[  100.873884]  get_page_from_freelist+0x124/0x20c
[  100.873898]  __alloc_pages_nodemask+0x114/0x2a4
[  100.873918]  mt76s_rx_run_queue+0xd4/0x2e4 [mt76_sdio 8280a88a0c8c9cf203f16e194f99ac293bdbb2f5]
[  100.873938]  mt76s_rx_handler+0xd4/0x2a0 [mt76_sdio 8280a88a0c8c9cf203f16e194f99ac293bdbb2f5]
[  100.873957]  mt76s_txrx_worker+0xac/0x17c [mt76_sdio 8280a88a0c8c9cf203f16e194f99ac293bdbb2f5]
[  100.873977]  mt7921s_txrx_worker+0x5c/0xd8 [mt7921s d0bdbc018082dbc8dc1407614be3c2e7bd64423b]
[  100.874003]  __mt76_worker_fn+0xe8/0x170 [mt76 b80af3483a8f9d48e916c12d8dbfaa0d3cd15337]
[  100.874018]  kthread+0x148/0x3ac
[  100.874032]  ret_from_fork+0x10/0x30
[  100.874067] Kernel Offset: 0x1fe2000000 from 0xffffffc010000000
[  100.874079] PHYS_OFFSET: 0xffffffe800000000
[  100.874090] CPU features: 0x0240002,2188200c

Fixes: 48fab5bbef40 ("mt76: mt7921: introduce mt7921s support")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/sdio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c b/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
index 5c88b6b8d0979..84be229a899da 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
@@ -62,6 +62,10 @@ static int mt7921s_parse_intr(struct mt76_dev *dev, struct mt76s_intr *intr)
 	if (err < 0)
 		return err;
 
+	if (irq_data->rx.num[0] > 16 ||
+	    irq_data->rx.num[1] > 128)
+		return -EINVAL;
+
 	intr->isr = irq_data->isr;
 	intr->rec_mb = irq_data->rec_mb;
 	intr->tx.wtqcr = irq_data->tx.wtqcr;
-- 
2.34.1



