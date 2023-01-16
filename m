Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D3066C922
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbjAPQqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:46:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233816AbjAPQpz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:45:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFA11CACC
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:33:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAAD5B81059
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13742C433EF;
        Mon, 16 Jan 2023 16:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886825;
        bh=iCK/XCW+ajCYDylAXX6zFN0+z3UQJEar7QxRALFhGGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cxCsPIviLX4hpZHs94PKUYqQFSmgOvwROwvtgivwSukOQgMXTRBcJ7Vxyfa2Mf1qs
         kuk2FMs7hl8j+3u50tPj7Sr0jwiuSUoiAbpT0+5dyZfr0oE0LIkeLMqaSoBndeUiTp
         hQqUUbNXkCBNAygFVEf0/28WUW6FXQpo8teiomQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 575/658] vhost: fix range used in translate_desc()
Date:   Mon, 16 Jan 2023 16:51:03 +0100
Message-Id: <20230116154935.816355454@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit 98047313cdb46828093894d0ac8b1183b8b317f9 ]

vhost_iotlb_itree_first() requires `start` and `last` parameters
to search for a mapping that overlaps the range.

In translate_desc() we cyclically call vhost_iotlb_itree_first(),
incrementing `addr` by the amount already translated, so rightly
we move the `start` parameter passed to vhost_iotlb_itree_first(),
but we should hold the `last` parameter constant.

Let's fix it by saving the `last` parameter value before incrementing
`addr` in the loop.

Fixes: a9709d6874d5 ("vhost: convert pre sorted vhost memory array to interval tree")
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Message-Id: <20221109102503.18816-3-sgarzare@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vhost.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 97be299f0a8d..fdfa399700fe 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2050,7 +2050,7 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
 	struct vhost_dev *dev = vq->dev;
 	struct vhost_umem *umem = dev->iotlb ? dev->iotlb : dev->umem;
 	struct iovec *_iov;
-	u64 s = 0;
+	u64 s = 0, last = addr + len - 1;
 	int ret = 0;
 
 	while ((u64)len > s) {
@@ -2061,7 +2061,7 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
 		}
 
 		node = vhost_umem_interval_tree_iter_first(&umem->umem_tree,
-							addr, addr + len - 1);
+							addr, last);
 		if (node == NULL || node->start > addr) {
 			if (umem != dev->iotlb) {
 				ret = -EFAULT;
-- 
2.35.1



