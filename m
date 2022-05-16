Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF043529184
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbiEPUIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350037AbiEPUAp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:00:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC1A44A1C;
        Mon, 16 May 2022 12:54:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49A1860A1C;
        Mon, 16 May 2022 19:53:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5DCC385AA;
        Mon, 16 May 2022 19:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730825;
        bh=OY7ZwR9sMWRyWDjAT5nOLctSSRKNzgghfWhmkOvZy+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hxJOkrWWxO5SvVJTdyIrALoz9go2v/AhECTE1HDqgPSGRRcEg0yOMlfDRxwoLDGPf
         RwLIk2tl/NGmUc5o3OrDXMsyFrDvYVrSupsmXdoSYLcmxzv1v++RHXB4xWO1nNXkOt
         I9pcXDrjU1/b2p8hJsGiiBjV6NT3eSSHf3hUuhCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lokesh Dhoundiyal <lokesh.dhoundiyal@alliedtelesis.co.nz>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 018/114] ipv4: drop dst in multicast routing path
Date:   Mon, 16 May 2022 21:35:52 +0200
Message-Id: <20220516193626.019507712@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lokesh Dhoundiyal <lokesh.dhoundiyal@alliedtelesis.co.nz>

[ Upstream commit 9e6c6d17d1d6a3f1515ce399f9a011629ec79aa0 ]

kmemleak reports the following when routing multicast traffic over an
ipsec tunnel.

Kmemleak output:
unreferenced object 0x8000000044bebb00 (size 256):
  comm "softirq", pid 0, jiffies 4294985356 (age 126.810s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 80 00 00 00 05 13 74 80  ..............t.
    80 00 00 00 04 9b bf f9 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000f83947e0>] __kmalloc+0x1e8/0x300
    [<00000000b7ed8dca>] metadata_dst_alloc+0x24/0x58
    [<0000000081d32c20>] __ipgre_rcv+0x100/0x2b8
    [<00000000824f6cf1>] gre_rcv+0x178/0x540
    [<00000000ccd4e162>] gre_rcv+0x7c/0xd8
    [<00000000c024b148>] ip_protocol_deliver_rcu+0x124/0x350
    [<000000006a483377>] ip_local_deliver_finish+0x54/0x68
    [<00000000d9271b3a>] ip_local_deliver+0x128/0x168
    [<00000000bd4968ae>] xfrm_trans_reinject+0xb8/0xf8
    [<0000000071672a19>] tasklet_action_common.isra.16+0xc4/0x1b0
    [<0000000062e9c336>] __do_softirq+0x1fc/0x3e0
    [<00000000013d7914>] irq_exit+0xc4/0xe0
    [<00000000a4d73e90>] plat_irq_dispatch+0x7c/0x108
    [<000000000751eb8e>] handle_int+0x16c/0x178
    [<000000001668023b>] _raw_spin_unlock_irqrestore+0x1c/0x28

The metadata dst is leaked when ip_route_input_mc() updates the dst for
the skb. Commit f38a9eb1f77b ("dst: Metadata destinations") correctly
handled dropping the dst in ip_route_input_slow() but missed the
multicast case which is handled by ip_route_input_mc(). Drop the dst in
ip_route_input_mc() avoiding the leak.

Fixes: f38a9eb1f77b ("dst: Metadata destinations")
Signed-off-by: Lokesh Dhoundiyal <lokesh.dhoundiyal@alliedtelesis.co.nz>
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20220505020017.3111846-1-chris.packham@alliedtelesis.co.nz
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index d5d058de3664..eef07b62b2d8 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1748,6 +1748,7 @@ static int ip_route_input_mc(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 #endif
 	RT_CACHE_STAT_INC(in_slow_mc);
 
+	skb_dst_drop(skb);
 	skb_dst_set(skb, &rth->dst);
 	return 0;
 }
-- 
2.35.1



