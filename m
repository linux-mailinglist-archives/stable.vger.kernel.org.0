Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49EB93CE353
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236705AbhGSPhW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:37:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235578AbhGSPeK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:34:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D06A0613BB;
        Mon, 19 Jul 2021 16:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711065;
        bh=q2An+mu1ao07rcVJygd5q0JKjr0hlytbk9vYI4g09tU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FdG2UNXJi14RJ2Ck3cwG9VZrXQHKT35/cl9oHzDuR/yRr88VeMfehdqC85hYYgmJf
         1yfppQJdQtbHwTR6qqok7MchRYUUR+OhMGyvAz0KWndNh+tgcnAGzi0nvlVQ5QAIZb
         2PjZEALVuJi9VDk53pig1qIZmw4IjIObbR/x1x9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 215/351] sunrpc: Avoid a KASAN slab-out-of-bounds bug in xdr_set_page_base()
Date:   Mon, 19 Jul 2021 16:52:41 +0200
Message-Id: <20210719144952.071555317@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anna Schumaker <Anna.Schumaker@Netapp.com>

[ Upstream commit 6d1c0f3d28f98ea2736128ed3e46821496dc3a8c ]

This seems to happen fairly easily during READ_PLUS testing on NFS v4.2.
I found that we could end up accessing xdr->buf->pages[pgnr] with a pgnr
greater than the number of pages in the array. So let's just return
early if we're setting base to a point at the end of the page data and
let xdr_set_tail_base() handle setting up the buffer pointers instead.

Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Fixes: 8d86e373b0ef ("SUNRPC: Clean up helpers xdr_set_iov() and xdr_set_page_base()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xdr.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index 3964ff74ee51..ca10ba2626f2 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -1230,10 +1230,9 @@ static unsigned int xdr_set_page_base(struct xdr_stream *xdr,
 	void *kaddr;
 
 	maxlen = xdr->buf->page_len;
-	if (base >= maxlen) {
-		base = maxlen;
-		maxlen = 0;
-	} else
+	if (base >= maxlen)
+		return 0;
+	else
 		maxlen -= base;
 	if (len > maxlen)
 		len = maxlen;
-- 
2.30.2



