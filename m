Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9AD26ECE20
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbjDXN3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbjDXN3X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:29:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A3672AB
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:29:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D22D06230D
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83E2C433EF;
        Mon, 24 Apr 2023 13:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342943;
        bh=Hk4dGeyjOuZfk3Gngq2yK8PI4r8t7qZqEoLBC/w7M7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DWYRyjUWOas32y/b/YkxrPGg07o1qLkIBzNTxf8bs9iSMX57hqRvCNNIxZ9MY201k
         ESh1+fAIN3eiss6IYKTEahIaYHcnEc9V1oc//BUVjc5Zni6SW+XMTKhqO9HGvvpx72
         NddEl/3qFchwR3a8BkOzpmrcu15N2wzcdeQW3ADI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 018/110] virtio_net: bugfix overflow inside xdp_linearize_page()
Date:   Mon, 24 Apr 2023 15:16:40 +0200
Message-Id: <20230424131136.805853987@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

[ Upstream commit 853618d5886bf94812f31228091cd37d308230f7 ]

Here we copy the data from the original buf to the new page. But we
not check that it may be overflow.

As long as the size received(including vnethdr) is greater than 3840
(PAGE_SIZE -VIRTIO_XDP_HEADROOM). Then the memcpy will overflow.

And this is completely possible, as long as the MTU is large, such
as 4096. In our test environment, this will cause crash. Since crash is
caused by the written memory, it is meaningless, so I do not include it.

Fixes: 72979a6c3590 ("virtio_net: xdp, add slowpath case for non contiguous buffers")
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 61e33e4dd0cd6..0644069592211 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -728,8 +728,13 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
 				       int page_off,
 				       unsigned int *len)
 {
-	struct page *page = alloc_page(GFP_ATOMIC);
+	int tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	struct page *page;
 
+	if (page_off + *len + tailroom > PAGE_SIZE)
+		return NULL;
+
+	page = alloc_page(GFP_ATOMIC);
 	if (!page)
 		return NULL;
 
@@ -737,7 +742,6 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
 	page_off += *len;
 
 	while (--*num_buf) {
-		int tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 		unsigned int buflen;
 		void *buf;
 		int off;
-- 
2.39.2



