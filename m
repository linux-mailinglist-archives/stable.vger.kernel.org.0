Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57B171EAA2A
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730357AbgFASFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:05:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730351AbgFASFm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:05:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D6752068D;
        Mon,  1 Jun 2020 18:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034741;
        bh=hr+aE4vMyCm2J9i/HYfT1scmVwkjoweSmSyJiGUBJ00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7jI2olt2d1nEn24HmbQerIt28JviB1G0O5DhcNe4LGOIgn1PInkKGdAKCKqeYyJO
         tE1TPylVbQJd1OPWweuAnx2q1FJfVEyL7epe9IwAy+svlxCzrVhbL2aWXjrFCV8gLN
         vgWlLfKbUD0RL4IWjW2wYQ8AGrzldm6ioKh0z2GI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Minh=20B=C3=B9i=20Quang?= <minhquangbui99@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: [PATCH 4.19 89/95] xsk: Add overflow check for u64 division, stored into u32
Date:   Mon,  1 Jun 2020 19:54:29 +0200
Message-Id: <20200601174034.017831101@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174020.759151073@linuxfoundation.org>
References: <20200601174020.759151073@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

commit b16a87d0aef7a6be766f6618976dc5ff2c689291 upstream.

The npgs member of struct xdp_umem is an u32 entity, and stores the
number of pages the UMEM consumes. The calculation of npgs

  npgs = size / PAGE_SIZE

can overflow.

To avoid overflow scenarios, the division is now first stored in a
u64, and the result is verified to fit into 32b.

An alternative would be storing the npgs as a u64, however, this
wastes memory and is an unrealisticly large packet area.

Fixes: c0c77d8fb787 ("xsk: add user memory registration support sockopt")
Reported-by: "Minh Bùi Quang" <minhquangbui99@gmail.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Link: https://lore.kernel.org/bpf/CACtPs=GGvV-_Yj6rbpzTVnopgi5nhMoCcTkSkYrJHGQHJWFZMQ@mail.gmail.com/
Link: https://lore.kernel.org/bpf/20200525080400.13195-1-bjorn.topel@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/xdp/xdp_umem.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -258,8 +258,8 @@ static int xdp_umem_account_pages(struct
 static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 {
 	u32 chunk_size = mr->chunk_size, headroom = mr->headroom;
+	u64 npgs, addr = mr->addr, size = mr->len;
 	unsigned int chunks, chunks_per_page;
-	u64 addr = mr->addr, size = mr->len;
 	int err, i;
 
 	if (chunk_size < XDP_UMEM_MIN_CHUNK_SIZE || chunk_size > PAGE_SIZE) {
@@ -285,6 +285,10 @@ static int xdp_umem_reg(struct xdp_umem
 	if ((addr + size) < addr)
 		return -EINVAL;
 
+	npgs = div_u64(size, PAGE_SIZE);
+	if (npgs > U32_MAX)
+		return -EINVAL;
+
 	chunks = (unsigned int)div_u64(size, chunk_size);
 	if (chunks == 0)
 		return -EINVAL;
@@ -303,7 +307,7 @@ static int xdp_umem_reg(struct xdp_umem
 	umem->props.size = size;
 	umem->headroom = headroom;
 	umem->chunk_size_nohr = chunk_size - headroom;
-	umem->npgs = size / PAGE_SIZE;
+	umem->npgs = (u32)npgs;
 	umem->pgs = NULL;
 	umem->user = NULL;
 	INIT_LIST_HEAD(&umem->xsk_list);


