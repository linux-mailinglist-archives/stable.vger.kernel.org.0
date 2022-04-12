Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC614FDAF6
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352962AbiDLH2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351617AbiDLHMs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:12:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409ED11C13;
        Mon, 11 Apr 2022 23:50:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4684614AD;
        Tue, 12 Apr 2022 06:50:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4502C385A1;
        Tue, 12 Apr 2022 06:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746238;
        bh=cfbxvSeSy5I+mpC8I9GSA3K1byPd/JZby9OSQekDQxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pQ+YdxD6sjJ6sWzmc5ZagMJhu7I4wGaK2WCSI+NqLfiTJn5vtfnKSB6+Hf7DCnW4X
         DSa8hfhUChuEB8EW1danS5FP/y87TeUza1Cd9fbzLulGlFVeRSM0ZjYFWU19ORulM6
         olWPaxuco9FEt6o5Za+g+bESa896Oc3688rXcno0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Pudak, Filip" <Filip.Pudak@windriver.com>,
        "Xiao, Jiguang" <Jiguang.Xiao@windriver.com>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, Pudak@vger.kernel.org,
        Xiao@vger.kernel.org
Subject: [PATCH 5.15 183/277] ipv6: Fix stats accounting in ip6_pkt_drop
Date:   Tue, 12 Apr 2022 08:29:46 +0200
Message-Id: <20220412062947.331978667@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@kernel.org>

[ Upstream commit 1158f79f82d437093aeed87d57df0548bdd68146 ]

VRF devices are the loopbacks for VRFs, and a loopback can not be
assigned to a VRF. Accordingly, the condition in ip6_pkt_drop should
be '||' not '&&'.

Fixes: 1d3fd8a10bed ("vrf: Use orig netdev to count Ip6InNoRoutes and a fresh route lookup when sending dest unreach")
Reported-by: Pudak, Filip <Filip.Pudak@windriver.com>
Reported-by: Xiao, Jiguang <Jiguang.Xiao@windriver.com>
Signed-off-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20220404150908.2937-1-dsahern@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index e0766bdf20e7..6b269595efaa 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4509,7 +4509,7 @@ static int ip6_pkt_drop(struct sk_buff *skb, u8 code, int ipstats_mib_noroutes)
 	struct inet6_dev *idev;
 	int type;
 
-	if (netif_is_l3_master(skb->dev) &&
+	if (netif_is_l3_master(skb->dev) ||
 	    dst->dev == net->loopback_dev)
 		idev = __in6_dev_get_safely(dev_get_by_index_rcu(net, IP6CB(skb)->iif));
 	else
-- 
2.35.1



