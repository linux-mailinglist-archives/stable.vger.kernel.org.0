Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1F4411A53
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243641AbhITQtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:49:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243713AbhITQsJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:48:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4432611C2;
        Mon, 20 Sep 2021 16:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156402;
        bh=B9ttuQe0TrkIN+TYK1ll3WOyuwE+Z8wNTzRJBA6xKt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PQzizoPDLFJsatnamXPOESmTEuwRRX1m9aebmitnFslzk2t8MEajPrHDKcG6/KN0F
         tEyN/jpH1oySnFQog1GW011Ls6GOUQoz7v5CdVSDhoSTThzfiwtT219L5yzv0ZJYzv
         xdEVnpVyzSA29A7e2ZiMDq6q44pW7in4t6oCpFXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 042/133] tcp: seq_file: Avoid skipping sk during tcp_seek_last_pos
Date:   Mon, 20 Sep 2021 18:42:00 +0200
Message-Id: <20210920163914.027770724@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin KaFai Lau <kafai@fb.com>

[ Upstream commit 525e2f9fd0229eb10cb460a9e6d978257f24804e ]

st->bucket stores the current bucket number.
st->offset stores the offset within this bucket that is the sk to be
seq_show().  Thus, st->offset only makes sense within the same
st->bucket.

These two variables are an optimization for the common no-lseek case.
When resuming the seq_file iteration (i.e. seq_start()),
tcp_seek_last_pos() tries to continue from the st->offset
at bucket st->bucket.

However, it is possible that the bucket pointed by st->bucket
has changed and st->offset may end up skipping the whole st->bucket
without finding a sk.  In this case, tcp_seek_last_pos() currently
continues to satisfy the offset condition in the next (and incorrect)
bucket.  Instead, regardless of the offset value, the first sk of the
next bucket should be returned.  Thus, "bucket == st->bucket" check is
added to tcp_seek_last_pos().

The chance of hitting this is small and the issue is a decade old,
so targeting for the next tree.

Fixes: a8b690f98baf ("tcp: Fix slowness in read /proc/net/tcp")
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20210701200541.1033917-1-kafai@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index bb6d251ce103..f9d55dd2dec8 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2033,6 +2033,7 @@ static void *tcp_get_idx(struct seq_file *seq, loff_t pos)
 static void *tcp_seek_last_pos(struct seq_file *seq)
 {
 	struct tcp_iter_state *st = seq->private;
+	int bucket = st->bucket;
 	int offset = st->offset;
 	int orig_num = st->num;
 	void *rc = NULL;
@@ -2043,7 +2044,7 @@ static void *tcp_seek_last_pos(struct seq_file *seq)
 			break;
 		st->state = TCP_SEQ_STATE_LISTENING;
 		rc = listening_get_next(seq, NULL);
-		while (offset-- && rc)
+		while (offset-- && rc && bucket == st->bucket)
 			rc = listening_get_next(seq, rc);
 		if (rc)
 			break;
@@ -2054,7 +2055,7 @@ static void *tcp_seek_last_pos(struct seq_file *seq)
 		if (st->bucket > tcp_hashinfo.ehash_mask)
 			break;
 		rc = established_get_first(seq);
-		while (offset-- && rc)
+		while (offset-- && rc && bucket == st->bucket)
 			rc = established_get_next(seq, rc);
 	}
 
-- 
2.30.2



