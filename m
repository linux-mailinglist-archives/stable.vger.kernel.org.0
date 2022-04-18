Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41EB950510E
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238984AbiDRMaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238998AbiDRM1h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:27:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63FB1DA6E;
        Mon, 18 Apr 2022 05:21:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CD4BB80EDA;
        Mon, 18 Apr 2022 12:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0E8C385A1;
        Mon, 18 Apr 2022 12:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284464;
        bh=5hLQUV35+tzlBH6zdxatGjjvCJQpxT0R3ebZCnvvka8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g8uV//ZJiWpvEgrAKhn3LqygY/wcVpREwtV0eSwMmuf5UOtVAg9G5L507yBnc7EWx
         toKsBJlXtbPQ3Ofzu8PRKDqaYkBcv8FHui8suKDA+xffTeAh3aRan5imUkj8HLEiP9
         Dk7B3MuSvm4gvTjBSKZn/UZt996DpZTVbun7eR/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 123/219] tun: annotate access to queue->trans_start
Date:   Mon, 18 Apr 2022 14:11:32 +0200
Message-Id: <20220418121210.340561914@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 968a1a5d6541cd24e37dadc1926eab9c10aeb09b ]

Commit 5337824f4dc4 ("net: annotate accesses to queue->trans_start")
introduced a new helper, txq_trans_cond_update, to update
queue->trans_start using WRITE_ONCE. One snippet in drivers/net/tun.c
was missed, as it was introduced roughly at the same time.

Fixes: 5337824f4dc4 ("net: annotate accesses to queue->trans_start")
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20220412135852.466386-1-atenart@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index de999e0fedbc..aa78d7e00289 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1106,7 +1106,7 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	/* NETIF_F_LLTX requires to do our own update of trans_start */
 	queue = netdev_get_tx_queue(dev, txq);
-	queue->trans_start = jiffies;
+	txq_trans_cond_update(queue);
 
 	/* Notify and wake up reader process */
 	if (tfile->flags & TUN_FASYNC)
-- 
2.35.1



