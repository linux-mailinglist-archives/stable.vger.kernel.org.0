Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059B43CDDDE
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344687AbhGSPBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:01:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344040AbhGSO71 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7580060238;
        Mon, 19 Jul 2021 15:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709092;
        bh=VdodptyE2GAk1rTtpPV2NfeKVvsJfvOCXSVUuquwcyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gRz1dqXQF1R4BhiUGrfyR5si537irG4YrHCJt5GJ8uRKi8W89Htm3CzLp8bKRQD3e
         q/KyzSBMbeEhHbBioHZoRYkHu5XzVPOJy5xrEc3m5rDKcPQ0zFje0Er0bYGaOdrBLT
         W/7XY+xpn2mj6LGu/TXXYAh8XGGZ90qOrnlmym70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 248/421] virtio_net: Remove BUG() to avoid machine dead
Date:   Mon, 19 Jul 2021 16:50:59 +0200
Message-Id: <20210719144955.003159077@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xianting Tian <xianting.tian@linux.alibaba.com>

[ Upstream commit 85eb1389458d134bdb75dad502cc026c3753a619 ]

We should not directly BUG() when there is hdr error, it is
better to output a print when such error happens. Currently,
the caller of xmit_skb() already did it.

Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 0b1c6a8906b9..84a82c4a9535 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1550,7 +1550,7 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
 	if (virtio_net_hdr_from_skb(skb, &hdr->hdr,
 				    virtio_is_little_endian(vi->vdev), false,
 				    0))
-		BUG();
+		return -EPROTO;
 
 	if (vi->mergeable_rx_bufs)
 		hdr->num_buffers = 0;
-- 
2.30.2



