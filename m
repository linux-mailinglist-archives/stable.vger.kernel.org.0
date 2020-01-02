Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBBDB12F119
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgABWQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:16:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:57764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbgABWQH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:16:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D40622314;
        Thu,  2 Jan 2020 22:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003365;
        bh=P+qkyBskgrpDviv0YM89VHDOIOtINogWuFid//yjjY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fXv8hgjHwgMIpkwzAD47F5VbKEw7x5jYMDzxH7R9irMZq9h7QePjBkVNEuviUnLjp
         CsSscIuqEudxj6gXLabeX5sUJ/OCYNE4BfuPZ+TYWXqJSFVi4MfeeFKbD+y47rMA/W
         PgByUldkTcs6zu2sFgmPmAFQXCGV2B24hWp4BVeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+9a1bc632e78a1a98488b@syzkaller.appspotmail.com,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 131/191] sctp: fix err handling of stream initialization
Date:   Thu,  2 Jan 2020 23:06:53 +0100
Message-Id: <20200102215843.731264631@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

[ Upstream commit 61d5d4062876e21331c3d0ba4b02dbd50c06a658 ]

The fix on 951c6db954a1 fixed the issued reported there but introduced
another. When the allocation fails within sctp_stream_init() it is
okay/necessary to free the genradix. But it is also called when adding
new streams, from sctp_send_add_streams() and
sctp_process_strreset_addstrm_in() and in those situations it cannot
just free the genradix because by then it is a fully operational
association.

The fix here then is to only free the genradix in sctp_stream_init()
and on those other call sites  move on with what it already had and let
the subsequent error handling to handle it.

Tested with the reproducers from this report and the previous one,
with lksctp-tools and sctp-tests.

Reported-by: syzbot+9a1bc632e78a1a98488b@syzkaller.appspotmail.com
Fixes: 951c6db954a1 ("sctp: fix memleak on err handling of stream initialization")
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/stream.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 6a30392068a0..c1a100d2fed3 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -84,10 +84,8 @@ static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
 		return 0;
 
 	ret = genradix_prealloc(&stream->out, outcnt, gfp);
-	if (ret) {
-		genradix_free(&stream->out);
+	if (ret)
 		return ret;
-	}
 
 	stream->outcnt = outcnt;
 	return 0;
@@ -102,10 +100,8 @@ static int sctp_stream_alloc_in(struct sctp_stream *stream, __u16 incnt,
 		return 0;
 
 	ret = genradix_prealloc(&stream->in, incnt, gfp);
-	if (ret) {
-		genradix_free(&stream->in);
+	if (ret)
 		return ret;
-	}
 
 	stream->incnt = incnt;
 	return 0;
@@ -123,7 +119,7 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
 	 * a new one with new outcnt to save memory if needed.
 	 */
 	if (outcnt == stream->outcnt)
-		goto in;
+		goto handle_in;
 
 	/* Filter out chunks queued on streams that won't exist anymore */
 	sched->unsched_all(stream);
@@ -132,24 +128,28 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
 
 	ret = sctp_stream_alloc_out(stream, outcnt, gfp);
 	if (ret)
-		goto out;
+		goto out_err;
 
 	for (i = 0; i < stream->outcnt; i++)
 		SCTP_SO(stream, i)->state = SCTP_STREAM_OPEN;
 
-in:
+handle_in:
 	sctp_stream_interleave_init(stream);
 	if (!incnt)
 		goto out;
 
 	ret = sctp_stream_alloc_in(stream, incnt, gfp);
-	if (ret) {
-		sched->free(stream);
-		genradix_free(&stream->out);
-		stream->outcnt = 0;
-		goto out;
-	}
+	if (ret)
+		goto in_err;
+
+	goto out;
 
+in_err:
+	sched->free(stream);
+	genradix_free(&stream->in);
+out_err:
+	genradix_free(&stream->out);
+	stream->outcnt = 0;
 out:
 	return ret;
 }
-- 
2.20.1



