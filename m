Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 543F8419BDB
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237287AbhI0RW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:22:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235925AbhI0RVM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:21:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5B8361355;
        Mon, 27 Sep 2021 17:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762817;
        bh=HumXbEoNAHL7SJ7zWMzLlvnNalPCWSrRbVhMYK+ggOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qq+9wls67y2+no61t4K0xKsNNQOtCOpnaaGkbS3W+ydKS1BTHy4LNOcRgix0zuWZi
         7RQMxHfHzMkrVQ9NEtVXcwqctl0oO8B7q8VvOnuuv7EwTUsWPLNBIvc/eYNN4k0caL
         53pyHs+uH56zYgdwCIz64L60UCG/PeVAurCPmFHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 055/162] virtio-net: fix pages leaking when building skb in big mode
Date:   Mon, 27 Sep 2021 19:01:41 +0200
Message-Id: <20210927170235.395318090@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit afd92d82c9d715fb97565408755acad81573591a ]

We try to use build_skb() if we had sufficient tailroom. But we forget
to release the unused pages chained via private in big mode which will
leak pages. Fixing this by release the pages after building the skb in
big mode.

Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Fixes: fb32856b16ad ("virtio-net: page_to_skb() use build_skb when there's sufficient tailroom")
Signed-off-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index eee493685aad..fb96658bb91f 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -435,6 +435,10 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 
 		skb_reserve(skb, p - buf);
 		skb_put(skb, len);
+
+		page = (struct page *)page->private;
+		if (page)
+			give_pages(rq, page);
 		goto ok;
 	}
 
-- 
2.33.0



