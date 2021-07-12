Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EFC3C5451
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348321AbhGLH5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:57:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352187AbhGLHyR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:54:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A50B61186;
        Mon, 12 Jul 2021 07:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076288;
        bh=Wbd/qaS45WkBuHQ9fU4fspsYClrMDKhEBurmMrV78T4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qOQp7/6eBIa+2xNI1vqyOGw5HGR27UgOHA7NlxZ6thGit7WVbakaX2fXljmhFY/2n
         JgQQPkX8mqNgjFaLZWH/XCyEBFji2sc6RfLYdpmqHzPZaQ/YFMoooiY8sBhMDSCCSv
         8IlbdV1dxNDhaZwlnUW6AaLw9MNYPYOGoQdQ1hr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 580/800] Bluetooth: virtio_bt: add missing null pointer check on alloc_skb call return
Date:   Mon, 12 Jul 2021 08:10:03 +0200
Message-Id: <20210712061029.038538404@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 1cb027f2f803d0a7abe9c291f0625e6bccd25999 ]

The call to alloc_skb with the GFP_KERNEL flag can return a null sk_buff
pointer, so add a null check to avoid any null pointer deference issues.

Addresses-Coverity: ("Dereference null return value")
Fixes: afd2daa26c7a ("Bluetooth: Add support for virtio transport driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/virtio_bt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/virtio_bt.c b/drivers/bluetooth/virtio_bt.c
index c804db7e90f8..57908ce4fae8 100644
--- a/drivers/bluetooth/virtio_bt.c
+++ b/drivers/bluetooth/virtio_bt.c
@@ -34,6 +34,9 @@ static int virtbt_add_inbuf(struct virtio_bluetooth *vbt)
 	int err;
 
 	skb = alloc_skb(1000, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
 	sg_init_one(sg, skb->data, 1000);
 
 	err = virtqueue_add_inbuf(vq, sg, 1, skb, GFP_KERNEL);
-- 
2.30.2



