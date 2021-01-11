Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28CF02F163B
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730926AbhAKNJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:09:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:56990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730922AbhAKNJj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:09:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA4A222D2C;
        Mon, 11 Jan 2021 13:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370539;
        bh=2oF1xm8tCBpOayJ3t4YzHCy8Kx1yxxEBHrgYOTGnDiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2qYyI5QK98vykrC9OLJIKt328/jf/vMfcBBM/wDZVPo86jVpgEVA4aeYG4nKdI7Ca
         BG8zR2wuLgCugCSyZ+g1DvZt4/V2vL5uUDiXH4XlVOWmAdBYx6pqorKj3F4NsZN4KI
         J5l0+nakrsXEq7wdzPEYU6MoeIqpnFA78erACDNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunjian Wang <wangyunjian@huawei.com>,
        Willem de Bruijn <willemb@google.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 26/77] tun: fix return value when the number of iovs exceeds MAX_SKB_FRAGS
Date:   Mon, 11 Jan 2021 14:01:35 +0100
Message-Id: <20210111130037.667158711@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130036.414620026@linuxfoundation.org>
References: <20210111130036.414620026@linuxfoundation.org>
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
@@ -1450,7 +1450,7 @@ static struct sk_buff *tun_napi_alloc_fr
 	int i;
 
 	if (it->nr_segs > MAX_SKB_FRAGS + 1)
-		return ERR_PTR(-ENOMEM);
+		return ERR_PTR(-EMSGSIZE);
 
 	local_bh_disable();
 	skb = napi_get_frags(&tfile->napi);


