Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316884B4621
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243549AbiBNJcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:32:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242948AbiBNJcA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:32:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32B81AD88;
        Mon, 14 Feb 2022 01:30:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8849260F8F;
        Mon, 14 Feb 2022 09:30:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A37C340E9;
        Mon, 14 Feb 2022 09:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831045;
        bh=iWIBNLBJO5CJdZKiHtFwcviHl/A29NlmVmJ+y4S9YPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVjST7WT1Hnl9zydBskqyYXGmt5Aq/epCiHkjRyHi9CiWvtbYAk+HD+Yo0aiwJKGF
         SetvrqrHDNgqjfOm94RYcI3SjFMfgHRui4dsTfZp83hn8hkRF5AXmuUUiY+aHHkgvE
         aKp4Oh1U2yX/JO2VQzPmH5wFr+Cq7f0AVJcFHFK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Antoine Tenart <atenart@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 25/44] net: do not keep the dst cache when uncloning an skb dst and its metadata
Date:   Mon, 14 Feb 2022 10:25:48 +0100
Message-Id: <20220214092448.724623719@linuxfoundation.org>
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
index 0b3c2aaed3c82..bf820c54e7ccd 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -121,6 +121,19 @@ static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *skb)
 
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



