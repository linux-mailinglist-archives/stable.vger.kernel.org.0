Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB144B4607
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238336AbiBNJcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:32:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243293AbiBNJcB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:32:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05B81ADA5;
        Mon, 14 Feb 2022 01:30:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D22EB80DC4;
        Mon, 14 Feb 2022 09:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7101FC340E9;
        Mon, 14 Feb 2022 09:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831048;
        bh=qH5C2MIZZSUsnft6+Hfq14w5C40qpkh3d9Peu90YZeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0bYNEwJeOpbuGN1sY/NpDATz8+9TG/duQzlbv4AooQATajh4LzDsqTLLvnhwepMgW
         tL0qBNIp6tphzu/+Z7DvQf8svo6Uk5bpu9BVNFPkQsXJ/6YkaOQzw5KojMsMqJcOxo
         kPx36eOizWDdFv3QNsrPPjZGsO7nYzdSdAsNLgIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        Vlad Buslov <vladbu@nvidia.com>,
        Antoine Tenart <atenart@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 26/44] net: fix a memleak when uncloning an skb dst and its metadata
Date:   Mon, 14 Feb 2022 10:25:49 +0100
Message-Id: <20220214092448.756130347@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092447.897544753@linuxfoundation.org>
References: <20220214092447.897544753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 9eeabdf17fa0ab75381045c867c370f4cc75a613 ]

When uncloning an skb dst and its associated metadata, a new
dst+metadata is allocated and later replaces the old one in the skb.
This is helpful to have a non-shared dst+metadata attached to a specific
skb.

The issue is the uncloned dst+metadata is initialized with a refcount of
1, which is increased to 2 before attaching it to the skb. When
tun_dst_unclone returns, the dst+metadata is only referenced from a
single place (the skb) while its refcount is 2. Its refcount will never
drop to 0 (when the skb is consumed), leading to a memory leak.

Fix this by removing the call to dst_hold in tun_dst_unclone, as the
dst+metadata refcount is already 1.

Fixes: fc4099f17240 ("openvswitch: Fix egress tunnel info.")
Cc: Pravin B Shelar <pshelar@ovn.org>
Reported-by: Vlad Buslov <vladbu@nvidia.com>
Tested-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dst_metadata.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index bf820c54e7ccd..177b1aabf95d1 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -135,7 +135,6 @@ static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *skb)
 #endif
 
 	skb_dst_drop(skb);
-	dst_hold(&new_md->dst);
 	skb_dst_set(skb, &new_md->dst);
 	return new_md;
 }
-- 
2.34.1



