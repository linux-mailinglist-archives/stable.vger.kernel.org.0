Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1534B462F
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243021AbiBNJ3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:29:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243079AbiBNJ3B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:29:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E2D60AAF;
        Mon, 14 Feb 2022 01:28:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E107160F87;
        Mon, 14 Feb 2022 09:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4135C340E9;
        Mon, 14 Feb 2022 09:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644830933;
        bh=De5s6O1Q/mpgBB7MSS/zLALmsk1o5Msqf9qPTvT22tM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KmlyN04+IyMnt/fLbuzBm8oQIxzWfjB6Oq/NErOrXQPTz/ZXYuvSNqarmULwjZs8l
         cMMVIDW5tTtYEpLA3TUcSqeS2rGWaAYFeRonA9HzjIBlZiknnc3Ffz3hJS4pHgB5Zs
         SFbXn5gS3YhYmSgfnZItQ7hhZ8u9aGivAMuHEVuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Antoine Tenart <atenart@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 19/34] net: do not keep the dst cache when uncloning an skb dst and its metadata
Date:   Mon, 14 Feb 2022 10:25:45 +0100
Message-Id: <20220214092446.567775131@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092445.946718557@linuxfoundation.org>
References: <20220214092445.946718557@linuxfoundation.org>
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

[ Upstream commit cfc56f85e72f5b9c5c5be26dc2b16518d36a7868 ]

When uncloning an skb dst and its associated metadata a new dst+metadata
is allocated and the tunnel information from the old metadata is copied
over there.

The issue is the tunnel metadata has references to cached dst, which are
copied along the way. When a dst+metadata refcount drops to 0 the
metadata is freed including the cached dst entries. As they are also
referenced in the initial dst+metadata, this ends up in UaFs.

In practice the above did not happen because of another issue, the
dst+metadata was never freed because its refcount never dropped to 0
(this will be fixed in a subsequent patch).

Fix this by initializing the dst cache after copying the tunnel
information from the old metadata to also unshare the dst cache.

Fixes: d71785ffc7e7 ("net: add dst_cache to ovs vxlan lwtunnel")
Cc: Paolo Abeni <pabeni@redhat.com>
Reported-by: Vlad Buslov <vladbu@nvidia.com>
Tested-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dst_metadata.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index 5a23535a5018d..33ca53057f318 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -97,6 +97,19 @@ static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *skb)
 
 	memcpy(&new_md->u.tun_info, &md_dst->u.tun_info,
 	       sizeof(struct ip_tunnel_info) + md_size);
+#ifdef CONFIG_DST_CACHE
+	/* Unclone the dst cache if there is one */
+	if (new_md->u.tun_info.dst_cache.cache) {
+		int ret;
+
+		ret = dst_cache_init(&new_md->u.tun_info.dst_cache, GFP_ATOMIC);
+		if (ret) {
+			metadata_dst_free(new_md);
+			return ERR_PTR(ret);
+		}
+	}
+#endif
+
 	skb_dst_drop(skb);
 	dst_hold(&new_md->dst);
 	skb_dst_set(skb, &new_md->dst);
-- 
2.34.1



