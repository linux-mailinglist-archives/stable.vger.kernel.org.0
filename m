Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF1CF37CD64
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240000AbhELQys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:54:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243881AbhELQmL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4D9D61C3B;
        Wed, 12 May 2021 16:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835669;
        bh=mA9WkzbfdPXuWHWAix469IF1+31mfDhXVxZl2nwyaGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z/EYP0EM6zZ/45bN6EeDzif/OwSmyZDq67yE2SEvrnAOBMCgn2MzzMdR2Htxchq4k
         1evUiSa6ImtDmrCeya/jch3fHzkAUD+7xMs2kg8pJcNPrdvWUdo+rmeegNWAwqdsFI
         QekmoNG53SitPyKknJFUWBlplSO70OX6WkaMRX+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Lobakin <alobakin@pm.me>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 437/677] xsk: Respect devices headroom and tailroom on generic xmit path
Date:   Wed, 12 May 2021 16:48:03 +0200
Message-Id: <20210512144851.860267896@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@pm.me>

[ Upstream commit 3914d88f7608e6c2e80e344474fa289370c32451 ]

xsk_generic_xmit() allocates a new skb and then queues it for
xmitting. The size of new skb's headroom is desc->len, so it comes
to the driver/device with no reserved headroom and/or tailroom.
Lots of drivers need some headroom (and sometimes tailroom) to
prepend (and/or append) some headers or data, e.g. CPU tags,
device-specific headers/descriptors (LSO, TLS etc.), and if case
of no available space skb_cow_head() will reallocate the skb.
Reallocations are unwanted on fast-path, especially when it comes
to XDP, so generic XSK xmit should reserve the spaces declared in
dev->needed_headroom and dev->needed tailroom to avoid them.

Note on max(NET_SKB_PAD, L1_CACHE_ALIGN(dev->needed_headroom)):

Usually, output functions reserve LL_RESERVED_SPACE(dev), which
consists of dev->hard_header_len + dev->needed_headroom, aligned
by 16.

However, on XSK xmit hard header is already here in the chunk, so
hard_header_len is not needed. But it'd still be better to align
data up to cacheline, while reserving no less than driver requests
for headroom. NET_SKB_PAD here is to double-insure there will be
no reallocations even when the driver advertises no needed_headroom,
but in fact need it (not so rare case).

Fixes: 35fcde7f8deb ("xsk: support for Tx")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20210218204908.5455-5-alobakin@pm.me
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 4faabd1ecfd1..143979ea4165 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -454,12 +454,16 @@ static int xsk_generic_xmit(struct sock *sk)
 	struct sk_buff *skb;
 	unsigned long flags;
 	int err = 0;
+	u32 hr, tr;
 
 	mutex_lock(&xs->mutex);
 
 	if (xs->queue_id >= xs->dev->real_num_tx_queues)
 		goto out;
 
+	hr = max(NET_SKB_PAD, L1_CACHE_ALIGN(xs->dev->needed_headroom));
+	tr = xs->dev->needed_tailroom;
+
 	while (xskq_cons_peek_desc(xs->tx, &desc, xs->pool)) {
 		char *buffer;
 		u64 addr;
@@ -471,11 +475,13 @@ static int xsk_generic_xmit(struct sock *sk)
 		}
 
 		len = desc.len;
-		skb = sock_alloc_send_skb(sk, len, 1, &err);
+		skb = sock_alloc_send_skb(sk, hr + len + tr, 1, &err);
 		if (unlikely(!skb))
 			goto out;
 
+		skb_reserve(skb, hr);
 		skb_put(skb, len);
+
 		addr = desc.addr;
 		buffer = xsk_buff_raw_get_data(xs->pool, addr);
 		err = skb_store_bits(skb, 0, buffer, len);
-- 
2.30.2



