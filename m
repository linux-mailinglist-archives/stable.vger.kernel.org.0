Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA4823687
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388965AbfETMZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:25:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388944AbfETMZC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:25:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D58020815;
        Mon, 20 May 2019 12:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355101;
        bh=0pBuoUQ/MsGpZKKsbJ6wezWXwWTvffx32ikV0Olb63c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xp2ucKI8RI8CseTIFuWRYTdwkeQgtEkud/Y50X7idZKFTPLV5T3FRJaerixvEBCuL
         gmuAINJFkYiw0bXtquqYjGOOGHlNZGoKxkVK+tbhowWp4SGJRudtegZgD8q1N9UlQl
         jfHxVcOaHHljcGPio+0+1x6eeaFn7Fn8BjD+w8QU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 4.19 098/105] iov_iter: optimize page_copy_sane()
Date:   Mon, 20 May 2019 14:14:44 +0200
Message-Id: <20190520115253.993660256@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 6daef95b8c914866a46247232a048447fff97279 upstream.

Avoid cache line miss dereferencing struct page if we can.

page_copy_sane() mostly deals with order-0 pages.

Extra cache line miss is visible on TCP recvmsg() calls dealing
with GRO packets (typically 45 page frags are attached to one skb).

Bringing the 45 struct pages into cpu cache while copying the data
is not free, since the freeing of the skb (and associated
page frags put_page()) can happen after cache lines have been evicted.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/iov_iter.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -817,8 +817,21 @@ EXPORT_SYMBOL(_copy_from_iter_full_nocac
 
 static inline bool page_copy_sane(struct page *page, size_t offset, size_t n)
 {
-	struct page *head = compound_head(page);
-	size_t v = n + offset + page_address(page) - page_address(head);
+	struct page *head;
+	size_t v = n + offset;
+
+	/*
+	 * The general case needs to access the page order in order
+	 * to compute the page size.
+	 * However, we mostly deal with order-0 pages and thus can
+	 * avoid a possible cache line miss for requests that fit all
+	 * page orders.
+	 */
+	if (n <= v && v <= PAGE_SIZE)
+		return true;
+
+	head = compound_head(page);
+	v += (page - head) << PAGE_SHIFT;
 
 	if (likely(n <= v && v <= (PAGE_SIZE << compound_order(head))))
 		return true;


