Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6D64B471C
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243952AbiBNJhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:37:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243086AbiBNJgy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:36:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908DD652E2;
        Mon, 14 Feb 2022 01:34:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42CC4B80DC4;
        Mon, 14 Feb 2022 09:34:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EAEC340E9;
        Mon, 14 Feb 2022 09:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831274;
        bh=hVUHZ5WyxrV1PseGE0Vyr2SlFfdW6bD0RR9iZNJtdkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L0WknKPVtRxxDbjf4Ij7DbyeK9cC/b9s7giVRFNJlOz8ZmqjoxuZypsUkhMrR2Z+x
         oMwM8gnoDjEqaKA/k6E9C7tt36xo3ta41rVPKZXbUPnecu5o8xUs2molBpOqOOO1m/
         6lW44MK8L7zQxw+SiRNYeG1wvMFSzzGd5IaP45SQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        Vlad Buslov <vladbu@nvidia.com>,
        Antoine Tenart <atenart@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 30/49] net: fix a memleak when uncloning an skb dst and its metadata
Date:   Mon, 14 Feb 2022 10:25:56 +0100
Message-Id: <20220214092449.284111169@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092448.285381753@linuxfoundation.org>
References: <20220214092448.285381753@linuxfoundation.org>
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
index b997e0c1e3627..adab27ba1ecbf 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -137,7 +137,6 @@ static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *skb)
 #endif
 
 	skb_dst_drop(skb);
-	dst_hold(&new_md->dst);
 	skb_dst_set(skb, &new_md->dst);
 	return new_md;
 }
-- 
2.34.1



