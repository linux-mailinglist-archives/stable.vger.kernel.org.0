Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09EB06ECD73
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbjDXNXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232122AbjDXNXZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:23:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBB94C33
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:23:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5047A61F23
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:23:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6588FC433D2;
        Mon, 24 Apr 2023 13:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342592;
        bh=Q+d9kzfViQFRkv0SboafWVIWrwbOn1it+2BFsFJBFaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eCI+Krh/PlrwooCuTBv02xcC6yqC2c0u5OOorkfEFKtocBVxxwd/0+VXOlJ/yvMem
         fBAM3NpZ2agu1yn2b5whoICf+kqS7z9av5KsjQ5vY6MqEyu5unzGZT1zzKVWsY5AcZ
         NY6nb2g6MviXP9YlNw9ZEuxgzr3e5Qi+woXfLxq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 06/39] virtio_net: bugfix overflow inside xdp_linearize_page()
Date:   Mon, 24 Apr 2023 15:17:09 +0200
Message-Id: <20230424131123.276625533@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131123.040556994@linuxfoundation.org>
References: <20230424131123.040556994@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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
index 5212d9cb03728..59d4449450ee8 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -646,8 +646,13 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
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
 
@@ -655,7 +660,6 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
 	page_off += *len;
 
 	while (--*num_buf) {
-		int tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 		unsigned int buflen;
 		void *buf;
 		int off;
-- 
2.39.2



