Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D691E2DFC
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404066AbgEZTZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:25:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391643AbgEZTGc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:06:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E430E20873;
        Tue, 26 May 2020 19:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519991;
        bh=GUuK0ABC3jZqZ0Rvg0S0uULvtjY5PAQW5rWG5iALkwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x5eThrGP46roDrv21WTXox8Gs6MKSH5Jc7/EiADHPkw2kz1ija8t4tN8WD5r4ieGT
         pPOAtofMIRiBAbm6ysaSo5anbBD4e6ZvA6/eIGeBOs0tFYFt/rhF3JTG6LOsThUUGU
         iQVxriMneE80SdsTtzpYIwMMf0E0zcL0oF3tywJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 016/111] afs: Dont unlock fetched data pages until the op completes successfully
Date:   Tue, 26 May 2020 20:52:34 +0200
Message-Id: <20200526183934.153530259@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 9d1be4f4dc5ff1c66c86acfd2c35765d9e3776b3 ]

Don't call req->page_done() on each page as we finish filling it with
the data coming from the network.  Whilst this might speed up the
application a bit, it's a problem if there's a network failure and the
operation has to be reissued.

If this happens, an oops occurs because afs_readpages_page_done() clears
the pointer to each page it unlocks and when a retry happens, the
pointers to the pages it wants to fill are now NULL (and the pages have
been unlocked anyway).

Instead, wait till the operation completes successfully and only then
release all the pages after clearing any terminal gap (the server can
give us less data than we requested as we're allowed to ask for more
than is available).

KASAN produces a bug like the following, and even without KASAN, it can
oops and panic.

    BUG: KASAN: wild-memory-access in _copy_to_iter+0x323/0x5f4
    Write of size 1404 at addr 0005088000000000 by task md5sum/5235

    CPU: 0 PID: 5235 Comm: md5sum Not tainted 5.7.0-rc3-fscache+ #250
    Hardware name: ASUS All Series/H97-PLUS, BIOS 2306 10/09/2014
    Call Trace:
     memcpy+0x39/0x58
     _copy_to_iter+0x323/0x5f4
     __skb_datagram_iter+0x89/0x2a6
     skb_copy_datagram_iter+0x129/0x135
     rxrpc_recvmsg_data.isra.0+0x615/0xd42
     rxrpc_kernel_recv_data+0x1e9/0x3ae
     afs_extract_data+0x139/0x33a
     yfs_deliver_fs_fetch_data64+0x47a/0x91b
     afs_deliver_to_call+0x304/0x709
     afs_wait_for_call_to_complete+0x1cc/0x4ad
     yfs_fs_fetch_data+0x279/0x288
     afs_fetch_data+0x1e1/0x38d
     afs_readpages+0x593/0x72e
     read_pages+0xf5/0x21e
     __do_page_cache_readahead+0x128/0x23f
     ondemand_readahead+0x36e/0x37f
     generic_file_buffered_read+0x234/0x680
     new_sync_read+0x109/0x17e
     vfs_read+0xe6/0x138
     ksys_read+0xd8/0x14d
     do_syscall_64+0x6e/0x8a
     entry_SYSCALL_64_after_hwframe+0x49/0xb3

Fixes: 196ee9cd2d04 ("afs: Make afs_fs_fetch_data() take a list of pages")
Fixes: 30062bd13e36 ("afs: Implement YFS support in the fs client")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/fsclient.c  | 8 ++++----
 fs/afs/yfsclient.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
index 6805a469d13c..0a4fed9e706b 100644
--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -385,8 +385,6 @@ static int afs_deliver_fs_fetch_data(struct afs_call *call)
 		ASSERTCMP(req->offset, <=, PAGE_SIZE);
 		if (req->offset == PAGE_SIZE) {
 			req->offset = 0;
-			if (req->page_done)
-				req->page_done(req);
 			req->index++;
 			if (req->remain > 0)
 				goto begin_page;
@@ -440,11 +438,13 @@ static int afs_deliver_fs_fetch_data(struct afs_call *call)
 		if (req->offset < PAGE_SIZE)
 			zero_user_segment(req->pages[req->index],
 					  req->offset, PAGE_SIZE);
-		if (req->page_done)
-			req->page_done(req);
 		req->offset = 0;
 	}
 
+	if (req->page_done)
+		for (req->index = 0; req->index < req->nr_pages; req->index++)
+			req->page_done(req);
+
 	_leave(" = 0 [done]");
 	return 0;
 }
diff --git a/fs/afs/yfsclient.c b/fs/afs/yfsclient.c
index 39230880f372..8af7f093305d 100644
--- a/fs/afs/yfsclient.c
+++ b/fs/afs/yfsclient.c
@@ -497,8 +497,6 @@ static int yfs_deliver_fs_fetch_data64(struct afs_call *call)
 		ASSERTCMP(req->offset, <=, PAGE_SIZE);
 		if (req->offset == PAGE_SIZE) {
 			req->offset = 0;
-			if (req->page_done)
-				req->page_done(req);
 			req->index++;
 			if (req->remain > 0)
 				goto begin_page;
@@ -556,11 +554,13 @@ static int yfs_deliver_fs_fetch_data64(struct afs_call *call)
 		if (req->offset < PAGE_SIZE)
 			zero_user_segment(req->pages[req->index],
 					  req->offset, PAGE_SIZE);
-		if (req->page_done)
-			req->page_done(req);
 		req->offset = 0;
 	}
 
+	if (req->page_done)
+		for (req->index = 0; req->index < req->nr_pages; req->index++)
+			req->page_done(req);
+
 	_leave(" = 0 [done]");
 	return 0;
 }
-- 
2.25.1



