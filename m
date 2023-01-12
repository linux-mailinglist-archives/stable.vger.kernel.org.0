Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9573667562
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235699AbjALOVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:21:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235975AbjALOTz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:19:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3E95DE59
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:12:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8F12B81DCC
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFF3C433D2;
        Thu, 12 Jan 2023 14:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532717;
        bh=I1or7kUInvwvcmlfSx4LtfI3f7gLsBLred7BH5pc8OA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qZptZgtEa/lo87MPDAAWY8gpsOB2zBzhrogzzI4WRYOtF1saI5kLnt4eIE+ovPWkA
         JrpOv5J4E9qL2QmSvNUfHC6w7g0ASb507nqdwgsw00+snVIDUYwNft7+W+U2UC8tyO
         2a49GZOrpbVUfz9xkDYgJgjo+UIO84iMJAJMoOLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 254/783] ethernet: s2io: dont call dev_kfree_skb() under spin_lock_irqsave()
Date:   Thu, 12 Jan 2023 14:49:30 +0100
Message-Id: <20230112135536.169899429@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 6cee96e09df54ae17784c0f38a49e0ed8229b825 ]

It is not allowed to call kfree_skb() or consume_skb() from hardware
interrupt context or with hardware interrupts being disabled.

It should use dev_kfree_skb_irq() or dev_consume_skb_irq() instead.
The difference between them is free reason, dev_kfree_skb_irq() means
the SKB is dropped in error and dev_consume_skb_irq() means the SKB
is consumed in normal.

In this case, dev_kfree_skb() is called in free_tx_buffers() to drop
the SKBs in tx buffers, when the card is down, so replace it with
dev_kfree_skb_irq() here.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/neterion/s2io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 8a30be698f99..ff46b08ac1f4 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -2384,7 +2384,7 @@ static void free_tx_buffers(struct s2io_nic *nic)
 			skb = s2io_txdl_getskb(&mac_control->fifos[i], txdp, j);
 			if (skb) {
 				swstats->mem_freed += skb->truesize;
-				dev_kfree_skb(skb);
+				dev_kfree_skb_irq(skb);
 				cnt++;
 			}
 		}
-- 
2.35.1



