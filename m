Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5724D8454
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241947AbiCNMXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243592AbiCNMVD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:21:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55AEA54F88;
        Mon, 14 Mar 2022 05:16:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1D6C60C7C;
        Mon, 14 Mar 2022 12:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2971C340E9;
        Mon, 14 Mar 2022 12:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260184;
        bh=M8Eeilr5uQ1QF/9Jfq+fvvZOlyudlq7lw2ET7bOjG5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pEbARkhaEGTFYUlWyjhbwbBmUslCXXlItL6IdNpWiPRjtUajJlN6PsNotB/C6knIF
         G81D233XZmwFobVzdfuwc9Bpd/NdogcXS41d4Yx+yLHL6S9FzMCBtwSkubLbKytoNy
         Bahld3Wt3Cq0FR//ZriPSW8/ZgIZHh1o92LmUs14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niels Dossche <dossche.niels@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Niels Dossche <niels.dossche@ugent.be>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 080/121] ipv6: prevent a possible race condition with lifetimes
Date:   Mon, 14 Mar 2022 12:54:23 +0100
Message-Id: <20220314112746.354570388@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niels Dossche <dossche.niels@gmail.com>

[ Upstream commit 6c0d8833a605e195ae219b5042577ce52bf71fff ]

valid_lft, prefered_lft and tstamp are always accessed under the lock
"lock" in other places. Reading these without taking the lock may result
in inconsistencies regarding the calculation of the valid and preferred
variables since decisions are taken on these fields for those variables.

Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Niels Dossche <niels.dossche@ugent.be>
Link: https://lore.kernel.org/r/20220223131954.6570-1-niels.dossche@ugent.be
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 7c78e1215ae3..e92ca415756a 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5002,6 +5002,7 @@ static int inet6_fill_ifaddr(struct sk_buff *skb, struct inet6_ifaddr *ifa,
 	    nla_put_s32(skb, IFA_TARGET_NETNSID, args->netnsid))
 		goto error;
 
+	spin_lock_bh(&ifa->lock);
 	if (!((ifa->flags&IFA_F_PERMANENT) &&
 	      (ifa->prefered_lft == INFINITY_LIFE_TIME))) {
 		preferred = ifa->prefered_lft;
@@ -5023,6 +5024,7 @@ static int inet6_fill_ifaddr(struct sk_buff *skb, struct inet6_ifaddr *ifa,
 		preferred = INFINITY_LIFE_TIME;
 		valid = INFINITY_LIFE_TIME;
 	}
+	spin_unlock_bh(&ifa->lock);
 
 	if (!ipv6_addr_any(&ifa->peer_addr)) {
 		if (nla_put_in6_addr(skb, IFA_LOCAL, &ifa->addr) < 0 ||
-- 
2.34.1



