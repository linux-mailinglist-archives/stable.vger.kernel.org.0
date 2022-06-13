Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEBFB548E1D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384869AbiFMOl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384938AbiFMOhy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:37:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D49E4D602;
        Mon, 13 Jun 2022 04:49:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 784C36146E;
        Mon, 13 Jun 2022 11:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8374CC34114;
        Mon, 13 Jun 2022 11:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120989;
        bh=aitm0DDS0jj0cpMndljk1lZmzQ3kflQqheX4kr0zhTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQeNFyYSOVAh/wZXcWwT82YQ4yMryC+zQ7UzH3UX6xaTVjEfuN6YSskhFx4u/Iv3b
         sv3zY5U9xO43pEhVwyoV1TTbe6VEyq8TbF1rDdqDFuuZ6RqAxuKVW3au3CRzzgyphB
         xDVIuXll6JbP7kE8IU3T3SHUtBUVrJSrvIk/4+Zw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuwei Wang <wangyuweihx@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 232/298] net, neigh: Set lower cap for neigh_managed_work rearming
Date:   Mon, 13 Jun 2022 12:12:06 +0200
Message-Id: <20220613094932.129477522@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit ed6cd6a17896561b9f51ab4c0d9bbb29e762b597 ]

Yuwei reported that plain reuse of DELAY_PROBE_TIME to rearm work queue
in neigh_managed_work is problematic if user explicitly configures the
DELAY_PROBE_TIME to 0 for a neighbor table. Such misconfig can then hog
CPU to 100% processing the system work queue. Instead, set lower interval
bound to HZ which is totally sufficient. Yuwei is additionally looking
into making the interval separately configurable from DELAY_PROBE_TIME.

Reported-by: Yuwei Wang <wangyuweihx@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/netdev/797c3c53-ce1b-9f60-e253-cda615788f4a@iogearbox.net
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/3b8c5aa906c52c3a8c995d1b2e8ccf650ea7c716.1653432794.git.daniel@iogearbox.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index ec0bf737b076..a252f4090d75 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1579,7 +1579,7 @@ static void neigh_managed_work(struct work_struct *work)
 	list_for_each_entry(neigh, &tbl->managed_list, managed_list)
 		neigh_event_send_probe(neigh, NULL, false);
 	queue_delayed_work(system_power_efficient_wq, &tbl->managed_work,
-			   NEIGH_VAR(&tbl->parms, DELAY_PROBE_TIME));
+			   max(NEIGH_VAR(&tbl->parms, DELAY_PROBE_TIME), HZ));
 	write_unlock_bh(&tbl->lock);
 }
 
-- 
2.35.1



