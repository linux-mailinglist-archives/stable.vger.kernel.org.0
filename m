Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241C33CDE47
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344653AbhGSPCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:02:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344267AbhGSO7c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FD0B61002;
        Mon, 19 Jul 2021 15:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709165;
        bh=dmoVFB9WV8nDf/ZrKMj21XqmZ8SkQGHGeuBLktOpNMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=thFyBgxMaF0Ci2m4v4xT+vn2nEAoWUgGu0e3H1QW89ncN62pM55iHBqRwFXgrnGgd
         ZOzVXhgaHabDvfsHNrK9nFuNpjtpyU+vNxXsMRd3v0iFqTZCtXRCQ/XArFML3g50gk
         bBK8bxs7gQNTb+ixk9Q4SuajQ7LsUXoFjSmFL39k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 277/421] sctp: add size validation when walking chunks
Date:   Mon, 19 Jul 2021 16:51:28 +0200
Message-Id: <20210719144955.949115171@linuxfoundation.org>
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

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

[ Upstream commit 50619dbf8db77e98d821d615af4f634d08e22698 ]

The first chunk in a packet is ensured to be present at the beginning of
sctp_rcv(), as a packet needs to have at least 1 chunk. But the second
one, may not be completely available and ch->length can be over
uninitialized memory.

Fix here is by only trying to walk on the next chunk if there is enough to
hold at least the header, and then proceed with the ch->length validation
that is already there.

Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index e17c8359571c..203aaefd8d04 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -1204,7 +1204,7 @@ static struct sctp_association *__sctp_rcv_walk_lookup(struct net *net,
 
 		ch = (struct sctp_chunkhdr *)ch_end;
 		chunk_num++;
-	} while (ch_end < skb_tail_pointer(skb));
+	} while (ch_end + sizeof(*ch) < skb_tail_pointer(skb));
 
 	return asoc;
 }
-- 
2.30.2



