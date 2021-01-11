Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7CA2F15AC
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387714AbhAKNnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:43:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:58908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730792AbhAKNL7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:11:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF7EB2255F;
        Mon, 11 Jan 2021 13:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370704;
        bh=6R25EZ9NDxWxuLAw08CwEgyMKSZFbQhVTswTkVPgFZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VErvCGozU8V0l5YTIfLkIGeo+Cnzq1bcd5iYbjKKuXH6HJZV33TXfkzOjuk74oLI5
         6sHwf9aPoaShR0qMosa74oGCcIkMv/XfjOubXzgd/W+pjJ+iLX+sjmg9MI83njoQJ4
         bK4AVFtgGYNYwOUBDMd2kGLQGkkzhzTWb6j3LIPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunjian Wang <wangyunjian@huawei.com>,
        Willem de Bruijn <willemb@google.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 31/92] tun: fix return value when the number of iovs exceeds MAX_SKB_FRAGS
Date:   Mon, 11 Jan 2021 14:01:35 +0100
Message-Id: <20210111130040.648412742@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

[ Upstream commit 950271d7cc0b4546af3549d8143c4132d6e1f138 ]

Currently the tun_napi_alloc_frags() function returns -ENOMEM when the
number of iovs exceeds MAX_SKB_FRAGS + 1. However this is inappropriate,
we should use -EMSGSIZE instead of -ENOMEM.

The following distinctions are matters:
1. the caller need to drop the bad packet when -EMSGSIZE is returned,
   which means meeting a persistent failure.
2. the caller can try again when -ENOMEM is returned, which means
   meeting a transient failure.

Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://lore.kernel.org/r/1608864736-24332-1-git-send-email-wangyunjian@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1469,7 +1469,7 @@ static struct sk_buff *tun_napi_alloc_fr
 	int i;
 
 	if (it->nr_segs > MAX_SKB_FRAGS + 1)
-		return ERR_PTR(-ENOMEM);
+		return ERR_PTR(-EMSGSIZE);
 
 	local_bh_disable();
 	skb = napi_get_frags(&tfile->napi);


