Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD555621470
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbiKHOBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234962AbiKHOBT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:01:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC78686B0
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:01:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22717615AF
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0013C433C1;
        Tue,  8 Nov 2022 14:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916075;
        bh=J0lO1Hkm9OQk30DzFUC7aVCH65HlCZ87jqMokj+da5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZC19zvtOwxLdQi5X8r+aFtjtyUcXtmL1VXy40fJCorOtP6cOzpmlbT6LOaTHSBZMN
         1QdIhPtaEqnMQgSAqi07gkTi1vrAp9fXmUPG+mm+2N2VLUFuLUr22k3On+4yTlFeup
         SlLs/bXaYtaaUQk4jbs9KZNRLdPe76s5su+yHUZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        "Denis V. Lunev" <den@openvz.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/144] net, neigh: Fix null-ptr-deref in neigh_table_clear()
Date:   Tue,  8 Nov 2022 14:38:53 +0100
Message-Id: <20221108133347.634553697@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit f8017317cb0b279b8ab98b0f3901a2e0ac880dad ]

When IPv6 module gets initialized but hits an error in the middle,
kenel panic with:

KASAN: null-ptr-deref in range [0x0000000000000598-0x000000000000059f]
CPU: 1 PID: 361 Comm: insmod
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
RIP: 0010:__neigh_ifdown.isra.0+0x24b/0x370
RSP: 0018:ffff888012677908 EFLAGS: 00000202
...
Call Trace:
 <TASK>
 neigh_table_clear+0x94/0x2d0
 ndisc_cleanup+0x27/0x40 [ipv6]
 inet6_init+0x21c/0x2cb [ipv6]
 do_one_initcall+0xd3/0x4d0
 do_init_module+0x1ae/0x670
...
Kernel panic - not syncing: Fatal exception

When ipv6 initialization fails, it will try to cleanup and calls:

neigh_table_clear()
  neigh_ifdown(tbl, NULL)
    pneigh_queue_purge(&tbl->proxy_queue, dev_net(dev == NULL))
    # dev_net(NULL) triggers null-ptr-deref.

Fix it by passing NULL to pneigh_queue_purge() in neigh_ifdown() if dev
is NULL, to make kernel not panic immediately.

Fixes: 66ba215cb513 ("neigh: fix possible DoS due to net iface start/stop loop")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Denis V. Lunev <den@openvz.org>
Link: https://lore.kernel.org/r/20221101121552.21890-1-chenzhongjin@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index b3556c5c1c08..0e22ecb46977 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -372,7 +372,7 @@ static int __neigh_ifdown(struct neigh_table *tbl, struct net_device *dev,
 	write_lock_bh(&tbl->lock);
 	neigh_flush_dev(tbl, dev, skip_perm);
 	pneigh_ifdown_and_unlock(tbl, dev);
-	pneigh_queue_purge(&tbl->proxy_queue, dev_net(dev));
+	pneigh_queue_purge(&tbl->proxy_queue, dev ? dev_net(dev) : NULL);
 	if (skb_queue_empty_lockless(&tbl->proxy_queue))
 		del_timer_sync(&tbl->proxy_timer);
 	return 0;
-- 
2.35.1



