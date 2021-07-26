Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA443D6014
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236396AbhGZPUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237056AbhGZPUi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:20:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75E5B60E09;
        Mon, 26 Jul 2021 16:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315267;
        bh=t+368inyZXG7DCMhc4qa3uvkQfiW/mX7WJ+EOKEMkzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mGSyfjZwqCRY2mt5EmxNOcIi0gvoGC5daIZy+ubi2aATDOhSyBWKh5KOP0q+nQs2K
         QJNSBvcsIp/qOZuBoje4mGVkk02kE4PDPRE8nFuaXntVg2TH5psGK6LeJdx1LWOMME
         lgGAALWfsV5cj8W+Jk4zWH/+dJiGFVEZf7daySS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Lobakin <alobakin@pm.me>,
        Antoine Tenart <atenart@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 029/167] net: do not reuse skbuff allocated from skbuff_fclone_cache in the skb cache
Date:   Mon, 26 Jul 2021 17:37:42 +0200
Message-Id: <20210726153840.350300456@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 28b34f01a73435a754956ebae826e728c03ffa38 ]

Some socket buffers allocated in the fclone cache (in __alloc_skb) can
end-up in the following path[1]:

napi_skb_finish
  __kfree_skb_defer
    napi_skb_cache_put

The issue is napi_skb_cache_put is not fclone friendly and will put
those skbuff in the skb cache to be reused later, although this cache
only expects skbuff allocated from skbuff_head_cache. When this happens
the skbuff is eventually freed using the wrong origin cache, and we can
see traces similar to:

[ 1223.947534] cache_from_obj: Wrong slab cache. skbuff_head_cache but object is from skbuff_fclone_cache
[ 1223.948895] WARNING: CPU: 3 PID: 0 at mm/slab.h:442 kmem_cache_free+0x251/0x3e0
[ 1223.950211] Modules linked in:
[ 1223.950680] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 5.13.0+ #474
[ 1223.951587] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-3.fc34 04/01/2014
[ 1223.953060] RIP: 0010:kmem_cache_free+0x251/0x3e0

Leading sometimes to other memory related issues.

Fix this by using __kfree_skb for fclone skbuff, similar to what is done
the other place __kfree_skb_defer is called.

[1] At least in setups using veth pairs and tunnels. Building a kernel
    with KASAN we can for example see packets allocated in
    sk_stream_alloc_skb hit the above path and later the issue arises
    when the skbuff is reused.

Fixes: 9243adfc311a ("skbuff: queue NAPI_MERGED_FREE skbs into NAPI cache instead of freeing")
Cc: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 6b08de52bf0e..86a0fe0f4c02 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6100,6 +6100,8 @@ static gro_result_t napi_skb_finish(struct napi_struct *napi,
 	case GRO_MERGED_FREE:
 		if (NAPI_GRO_CB(skb)->free == NAPI_GRO_FREE_STOLEN_HEAD)
 			napi_skb_free_stolen_head(skb);
+		else if (skb->fclone != SKB_FCLONE_UNAVAILABLE)
+			__kfree_skb(skb);
 		else
 			__kfree_skb(skb);
 		break;
-- 
2.30.2



