Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107FE22DF8E
	for <lists+stable@lfdr.de>; Sun, 26 Jul 2020 15:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgGZNwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jul 2020 09:52:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:40766 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgGZNwd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Jul 2020 09:52:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BD24FB64D;
        Sun, 26 Jul 2020 13:52:41 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     sagi@grimberg.me, philipp.reisner@linbit.com,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        linux-bcache@vger.kernel.org, hch@lst.de
Cc:     Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Jan Kara <jack@suse.com>,
        Jens Axboe <axboe@kernel.dk>,
        Mikhail Skorzhinskii <mskorzhinskiy@solarflare.com>,
        Vlastimil Babka <vbabka@suse.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] nvme-tcp: use sendpage_ok() to check page for kernel_sendpage()
Date:   Sun, 26 Jul 2020 21:52:23 +0800
Message-Id: <20200726135224.107516-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently nvme_tcp_try_send_data() doesn't use kernel_sendpage() to
send slab pages. But for pages allocated by __get_free_pages() without
__GFP_COMP, which also have refcount as 0, they are still sent by
kernel_sendpage() to remote end, this is problematic.

When bcache uses a remote NVMe SSD via nvme-over-tcp as its cache
device, writing meta data e.g. cache_set->disk_buckets to remote SSD may
trigger a kernel panic due to the above problem. Bcause the meta data
pages for cache_set->disk_buckets are allocated by __get_free_pages()
without __GFP_COMP.

This problem should be fixed both in upper layer driver (bcache) and
nvme-over-tcp code. This patch fixes the nvme-over-tcp code by checking
whether the page refcount is 0, if yes then don't use kernel_sendpage()
and call sock_no_sendpage() to send the page into network stack.

Such check is done by macro sendpage_ok() in this patch, which is defined
in include/linux/net.h as,
	(!PageSlab(page) && page_count(page) >= 1)
If sendpage_ok() returns false, sock_no_sendpage() will handle the page
other than kernel_sendpage().

The code comments in this patch is copied and modified from drbd where
the similar problem already gets solved by Philipp Reisner. This is the
best code comment including my own version.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Jan Kara <jack@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Mikhail Skorzhinskii <mskorzhinskiy@solarflare.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Vlastimil Babka <vbabka@suse.com>
Cc: stable@vger.kernel.org
---
Changelog:
v3: introduce a more common name sendpage_ok() for the open coded check
v2: fix typo in patch subject.
v1: the initial version.

 drivers/nvme/host/tcp.c | 13 +++++++++++--
 include/linux/net.h     |  2 ++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 79ef2b8e2b3c..f9952f6d94b9 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -887,8 +887,17 @@ static int nvme_tcp_try_send_data(struct nvme_tcp_request *req)
 		else
 			flags |= MSG_MORE | MSG_SENDPAGE_NOTLAST;
 
-		/* can't zcopy slab pages */
-		if (unlikely(PageSlab(page))) {
+		/*
+		 * e.g. XFS meta- & log-data is in slab pages, or bcache meta
+		 * data pages, or other high order pages allocated by
+		 * __get_free_pages() without __GFP_COMP, which have a page_count
+		 * of 0 and/or have PageSlab() set. We cannot use send_page for
+		 * those, as that does get_page(); put_page(); and would cause
+		 * either a VM_BUG directly, or __page_cache_release a page that
+		 * would actually still be referenced by someone, leading to some
+		 * obscure delayed Oops somewhere else.
+		 */
+		if (unlikely(!sendpage_ok(page))) {
 			ret = sock_no_sendpage(queue->sock, page, offset, len,
 					flags);
 		} else {
diff --git a/include/linux/net.h b/include/linux/net.h
index 016a9c5faa34..41e5d2898e97 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -290,6 +290,8 @@ do {									\
 #define net_get_random_once_wait(buf, nbytes)			\
 	get_random_once_wait((buf), (nbytes))
 
+#define sendpage_ok(page)	(!PageSlab(page) && page_count(page) >= 1)
+
 int kernel_sendmsg(struct socket *sock, struct msghdr *msg, struct kvec *vec,
 		   size_t num, size_t len);
 int kernel_sendmsg_locked(struct sock *sk, struct msghdr *msg,
-- 
2.26.2

