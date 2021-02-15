Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF51431BCCF
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhBOPgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:36:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:45590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231376AbhBOPdH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:33:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 891C864E64;
        Mon, 15 Feb 2021 15:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403046;
        bh=r2yip97vPP4YlZD2qpuCsmsTqFzhko98rZRcExv9fjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=enI9cw1Xz+FMvO2mQWkTALmoipHLemgWgsFq5M8FgUr95U/TzBOgtC0JiEfz2DzV7
         1InSzc0gkOVE1kPQvysgS6fO+okBGuXqlIyp/XO+Bc0tBQ4RyvyIdh/q0+fIN9qV/G
         j6+uak/GBRvNvfXsL3A6FqNeU7cnb9FL4dEeR5KQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+1bd2b07f93745fa38425@syzkaller.appspotmail.com,
        Sabyrzhan Tasbolatov <snovitoll@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 58/60] net/rds: restrict iovecs length for RDS_CMSG_RDMA_ARGS
Date:   Mon, 15 Feb 2021 16:27:46 +0100
Message-Id: <20210215152717.240042606@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152715.401453874@linuxfoundation.org>
References: <20210215152715.401453874@linuxfoundation.org>
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
@@ -532,6 +532,9 @@ int rds_rdma_extra_size(struct rds_rdma_
 	if (args->nr_local == 0)
 		return -EINVAL;
 
+	if (args->nr_local > UIO_MAXIOV)
+		return -EMSGSIZE;
+
 	iov->iov = kcalloc(args->nr_local,
 			   sizeof(struct rds_iovec),
 			   GFP_KERNEL);


