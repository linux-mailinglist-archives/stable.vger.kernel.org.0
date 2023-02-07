Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2723068D7A8
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbjBGNB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbjBGNBr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:01:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01023A5A2
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:01:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A116613EF
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E726C433D2;
        Tue,  7 Feb 2023 13:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774883;
        bh=6a3x3pYdIFItRDCvLgXLx7CVtj/SBa0g8NzkRmSIMIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DikJo4IIcBXRY0t8aHhMzv4kMd2citLDtzDcmwBdlmGI7X+/bKFeXSsu2qT8B0rj5
         Ta1Omu8q39gonCUd1l8TgAFSCindjCjxdPsH/rq3xdzrac65989lpCA45QUIlkUlPj
         mtsZMwuEYabQHXYdCCgMcNSlJuJCxImSn1+liN3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        Wolfgang Nothdurft <wolfgang@linogate.de>
Subject: [PATCH 6.1 066/208] netfilter: br_netfilter: disable sabotage_in hook after first suppression
Date:   Tue,  7 Feb 2023 13:55:20 +0100
Message-Id: <20230207125637.307125985@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 2b272bb558f1d3a5aa95ed8a82253786fd1a48ba ]

When using a xfrm interface in a bridged setup (the outgoing device is
bridged), the incoming packets in the xfrm interface are only tracked
in the outgoing direction.

$ brctl show
bridge name     interfaces
br_eth1         eth1

$ conntrack -L
tcp 115 SYN_SENT src=192... dst=192... [UNREPLIED] ...

If br_netfilter is enabled, the first (encrypted) packet is received onR
eth1, conntrack hooks are called from br_netfilter emulation which
allocates nf_bridge info for this skb.

If the packet is for local machine, skb gets passed up the ip stack.
The skb passes through ip prerouting a second time. br_netfilter
ip_sabotage_in supresses the re-invocation of the hooks.

After this, skb gets decrypted in xfrm layer and appears in
network stack a second time (after decryption).

Then, ip_sabotage_in is called again and suppresses netfilter
hook invocation, even though the bridge layer never called them
for the plaintext incarnation of the packet.

Free the bridge info after the first suppression to avoid this.

I was unable to figure out where the regression comes from, as far as i
can see br_netfilter always had this problem; i did not expect that skb
is looped again with different headers.

Fixes: c4b0e771f906 ("netfilter: avoid using skb->nf_bridge directly")
Reported-and-tested-by: Wolfgang Nothdurft <wolfgang@linogate.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_netfilter_hooks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index f20f4373ff40..9554abcfd5b4 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -871,6 +871,7 @@ static unsigned int ip_sabotage_in(void *priv,
 	if (nf_bridge && !nf_bridge->in_prerouting &&
 	    !netif_is_l3_master(skb->dev) &&
 	    !netif_is_l3_slave(skb->dev)) {
+		nf_bridge_info_free(skb);
 		state->okfn(state->net, state->sk, skb);
 		return NF_STOLEN;
 	}
-- 
2.39.0



