Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88341586A64
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbiHAMQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234422AbiHAMPy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:15:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6814D7AC17;
        Mon,  1 Aug 2022 04:58:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDA0AB81171;
        Mon,  1 Aug 2022 11:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 422B2C433C1;
        Mon,  1 Aug 2022 11:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355110;
        bh=eJKRV90rG1YYkyI0zQh3lPHiACffaEECIn1A0+30NFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hFNowBi6OWKyMFe1Yc1XRpzRcfZrp1NJfFGyfb7b/24T2fCCstY139t3uKaxa6lbt
         oOp1/Cs165Z32tCYsOCmnWrzP+L6ssStveMn41QXpBWIJ8se9qx0E4Pu3+wtSpoGvD
         BdZY8z6wAE6c5hsYPb4IsBpmWQMdWVc3pt+N9Fps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Benjamin Poirier <bpoirier@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.18 26/88] bridge: Do not send empty IFLA_AF_SPEC attribute
Date:   Mon,  1 Aug 2022 13:46:40 +0200
Message-Id: <20220801114139.231282517@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Poirier <bpoirier@nvidia.com>

commit 9b134b1694ec8926926ba6b7b80884ea829245a0 upstream.

After commit b6c02ef54913 ("bridge: Netlink interface fix."),
br_fill_ifinfo() started to send an empty IFLA_AF_SPEC attribute when a
bridge vlan dump is requested but an interface does not have any vlans
configured.

iproute2 ignores such an empty attribute since commit b262a9becbcb
("bridge: Fix output with empty vlan lists") but older iproute2 versions as
well as other utilities have their output changed by the cited kernel
commit, resulting in failed test cases. Regardless, emitting an empty
attribute is pointless and inefficient.

Avoid this change by canceling the attribute if no AF_SPEC data was added.

Fixes: b6c02ef54913 ("bridge: Netlink interface fix.")
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20220725001236.95062-1-bpoirier@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_netlink.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -589,9 +589,13 @@ static int br_fill_ifinfo(struct sk_buff
 	}
 
 done:
+	if (af) {
+		if (nlmsg_get_pos(skb) - (void *)af > nla_attr_size(0))
+			nla_nest_end(skb, af);
+		else
+			nla_nest_cancel(skb, af);
+	}
 
-	if (af)
-		nla_nest_end(skb, af);
 	nlmsg_end(skb, nlh);
 	return 0;
 


