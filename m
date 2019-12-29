Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACDB12C776
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730091AbfL2Rl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:41:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730230AbfL2Rly (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:41:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE5A6206A4;
        Sun, 29 Dec 2019 17:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641314;
        bh=NIuAt9TT1IE3oNLvGLjJPZdiQtuJ4SGu65HGioD9l0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ow8jfSuRQnMVj4uiiUfkYpydeHBclJPz8xmYc7fGbmSCuZPQIRspwfxutTRvKshp7
         cGKYiwu5f11u+f2WrfO6H9s2P3uFyDKtrdFKojNtlQbfWJ5ar7ZczcpJm4Ey7OytrJ
         T8dkS8k3m93yaeQp4KBBzxJcf+5rR9VOYLZj4y/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+772d9e36c490b18d51d1@syzkaller.appspotmail.com,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 015/434] sctp: fix memleak on err handling of stream initialization
Date:   Sun, 29 Dec 2019 18:21:08 +0100
Message-Id: <20191229172703.230497527@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

[ Upstream commit 951c6db954a1adefab492f6da805decacabbd1a7 ]

syzbot reported a memory leak when an allocation fails within
genradix_prealloc() for output streams. That's because
genradix_prealloc() leaves initialized members initialized when the
issue happens and SCTP stack will abort the current initialization but
without cleaning up such members.

The fix here is to always call genradix_free() when genradix_prealloc()
fails, for output and also input streams, as it suffers from the same
issue.

Reported-by: syzbot+772d9e36c490b18d51d1@syzkaller.appspotmail.com
Fixes: 2075e50caf5e ("sctp: convert to genradix")
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Tested-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/stream.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -84,8 +84,10 @@ static int sctp_stream_alloc_out(struct
 		return 0;
 
 	ret = genradix_prealloc(&stream->out, outcnt, gfp);
-	if (ret)
+	if (ret) {
+		genradix_free(&stream->out);
 		return ret;
+	}
 
 	stream->outcnt = outcnt;
 	return 0;
@@ -100,8 +102,10 @@ static int sctp_stream_alloc_in(struct s
 		return 0;
 
 	ret = genradix_prealloc(&stream->in, incnt, gfp);
-	if (ret)
+	if (ret) {
+		genradix_free(&stream->in);
 		return ret;
+	}
 
 	stream->incnt = incnt;
 	return 0;


