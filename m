Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 078554B494D
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240924AbiBNKLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:11:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345613AbiBNKKR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:10:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB818596D;
        Mon, 14 Feb 2022 01:50:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE681B80DC4;
        Mon, 14 Feb 2022 09:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE8DC340E9;
        Mon, 14 Feb 2022 09:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832226;
        bh=h/90sFQJ4ADpeoVXdbJhADLAI2IKpcQnwVbtczvVWjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OnlsUtoiNxzNt7BFEzwCq+8HqjNqKh1DI9hggkVYyZcMn+5tuFc0c5mgWiUbyNZPF
         S8COhxnq/ZRWL83fIE19abQxDdfHFnEPh+mN8HFyxqyGxpD2QNG2QOE9LJJC7+BP7A
         YbHdVXS7mZn/7qN8J5UaSmAS/ZbOvLVHQPlK3jZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Antoine Tenart <atenart@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 119/172] net: do not keep the dst cache when uncloning an skb dst and its metadata
Date:   Mon, 14 Feb 2022 10:26:17 +0100
Message-Id: <20220214092510.537425287@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
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
index 14efa0ded75dd..b997e0c1e3627 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -123,6 +123,19 @@ static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *skb)
 
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



