Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75050667811
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240041AbjALOwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbjALOv1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:51:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6EC1CFFE
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:38:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41646B81E76
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74379C433F0;
        Thu, 12 Jan 2023 14:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534312;
        bh=RS16Se8Kty/JZgJ2ZbSawEAw2WVNzbAjZtwniDgCzKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3vz3/YNTu8DjfeB7HHPIe4/DSVyUUHuaM5ZXYZyGgXOklU4Zq860fBsHyww916/I
         +2Idx5vqSAtZLaG+CESboHOFQ+VwHAAJh6I4cy25jYLyKbBK0irhTCpIxVI75BAtc2
         cAXR2Jk3S8PQMc9Xk4LjrIxUfWDLXG4YzvDX2J/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 736/783] vhost: fix range used in translate_desc()
Date:   Thu, 12 Jan 2023 14:57:32 +0100
Message-Id: <20230112135558.465629487@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index f41463ab4031..da00a5c57db6 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2041,7 +2041,7 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
 	struct vhost_dev *dev = vq->dev;
 	struct vhost_iotlb *umem = dev->iotlb ? dev->iotlb : dev->umem;
 	struct iovec *_iov;
-	u64 s = 0;
+	u64 s = 0, last = addr + len - 1;
 	int ret = 0;
 
 	while ((u64)len > s) {
@@ -2051,7 +2051,7 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
 			break;
 		}
 
-		map = vhost_iotlb_itree_first(umem, addr, addr + len - 1);
+		map = vhost_iotlb_itree_first(umem, addr, last);
 		if (map == NULL || map->start > addr) {
 			if (umem != dev->iotlb) {
 				ret = -EFAULT;
-- 
2.35.1



