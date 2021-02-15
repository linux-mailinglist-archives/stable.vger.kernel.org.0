Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66BED31BDAE
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhBOPv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:51:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:53692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231951AbhBOPtj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:49:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F09DD64E40;
        Mon, 15 Feb 2021 15:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403294;
        bh=hiQF/kE50FNymjssLrp3Cu0Zy1HYv4Dh1/FJ+d5gpPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aDlxdZo6LeiY/IQY4gJkdW4667sapeX7QmmXEYlUYZGDTs+2UH9hmqa5TwY1/Ej4Z
         00Ig3ogGjmaaAiMGApTzbw3OUg+bruq9GkGikG4dvrtV5Px+2dHBy4sem4MdDb69+L
         qQBznjw+N+JvzWVQi165ODQjniDhrP7SC6Ep7hpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+1bd2b07f93745fa38425@syzkaller.appspotmail.com,
        Sabyrzhan Tasbolatov <snovitoll@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 101/104] net/rds: restrict iovecs length for RDS_CMSG_RDMA_ARGS
Date:   Mon, 15 Feb 2021 16:27:54 +0100
Message-Id: <20210215152722.729594843@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>

commit a11148e6fcce2ae53f47f0a442d098d860b4f7db upstream.

syzbot found WARNING in rds_rdma_extra_size [1] when RDS_CMSG_RDMA_ARGS
control message is passed with user-controlled
0x40001 bytes of args->nr_local, causing order >= MAX_ORDER condition.

The exact value 0x40001 can be checked with UIO_MAXIOV which is 0x400.
So for kcalloc() 0x400 iovecs with sizeof(struct rds_iovec) = 0x10
is the closest limit, with 0x10 leftover.

Same condition is currently done in rds_cmsg_rdma_args().

[1] WARNING: mm/page_alloc.c:5011
[..]
Call Trace:
 alloc_pages_current+0x18c/0x2a0 mm/mempolicy.c:2267
 alloc_pages include/linux/gfp.h:547 [inline]
 kmalloc_order+0x2e/0xb0 mm/slab_common.c:837
 kmalloc_order_trace+0x14/0x120 mm/slab_common.c:853
 kmalloc_array include/linux/slab.h:592 [inline]
 kcalloc include/linux/slab.h:621 [inline]
 rds_rdma_extra_size+0xb2/0x3b0 net/rds/rdma.c:568
 rds_rm_size net/rds/send.c:928 [inline]

Reported-by: syzbot+1bd2b07f93745fa38425@syzkaller.appspotmail.com
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Link: https://lore.kernel.org/r/20210201203233.1324704-1-snovitoll@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rds/rdma.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -565,6 +565,9 @@ int rds_rdma_extra_size(struct rds_rdma_
 	if (args->nr_local == 0)
 		return -EINVAL;
 
+	if (args->nr_local > UIO_MAXIOV)
+		return -EMSGSIZE;
+
 	iov->iov = kcalloc(args->nr_local,
 			   sizeof(struct rds_iovec),
 			   GFP_KERNEL);


