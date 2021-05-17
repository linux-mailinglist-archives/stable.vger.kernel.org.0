Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E6038300D
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239066AbhEQOXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:23:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238780AbhEQOVa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:21:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B2D0613B6;
        Mon, 17 May 2021 14:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260704;
        bh=G5ssfBGRLK53uQMuqh6icA54W4r/oxerTpHLqKs707Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hk5gUGwSjFBZNjRQy4auAm8z4s2gYskeg0qNGa+jR8AmqRnHLNoOyMdq9jmIzcgPV
         pipmB5ke4l1kk2Iie1zBu1qb/Hvrwl/IdhFdNykePR0uPz/x+GbThP5wjRDt9Wlosq
         cnUAJtbhDAxkoAxeehWtz6qmN8eqvUwZUIRDXIk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brendan Jackman <jackmanb@google.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 202/363] libbpf: Fix signed overflow in ringbuf_process_ring
Date:   Mon, 17 May 2021 16:01:08 +0200
Message-Id: <20210517140309.415856477@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brendan Jackman <jackmanb@google.com>

[ Upstream commit 2a30f9440640c418bcfbea9b2b344d268b58e0a2 ]

One of our benchmarks running in (Google-internal) CI pushes data
through the ringbuf faster htan than userspace is able to consume
it. In this case it seems we're actually able to get >INT_MAX entries
in a single ring_buffer__consume() call. ASAN detected that cnt
overflows in this case.

Fix by using 64-bit counter internally and then capping the result to
INT_MAX before converting to the int return type. Do the same for
the ring_buffer__poll().

Fixes: bf99c936f947 (libbpf: Add BPF ring buffer support)
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210429130510.1621665-1-jackmanb@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/ringbuf.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/tools/lib/bpf/ringbuf.c b/tools/lib/bpf/ringbuf.c
index e7a8d847161f..1d80ad4e0de8 100644
--- a/tools/lib/bpf/ringbuf.c
+++ b/tools/lib/bpf/ringbuf.c
@@ -202,9 +202,11 @@ static inline int roundup_len(__u32 len)
 	return (len + 7) / 8 * 8;
 }
 
-static int ringbuf_process_ring(struct ring* r)
+static int64_t ringbuf_process_ring(struct ring* r)
 {
-	int *len_ptr, len, err, cnt = 0;
+	int *len_ptr, len, err;
+	/* 64-bit to avoid overflow in case of extreme application behavior */
+	int64_t cnt = 0;
 	unsigned long cons_pos, prod_pos;
 	bool got_new_data;
 	void *sample;
@@ -244,12 +246,14 @@ done:
 }
 
 /* Consume available ring buffer(s) data without event polling.
- * Returns number of records consumed across all registered ring buffers, or
- * negative number if any of the callbacks return error.
+ * Returns number of records consumed across all registered ring buffers (or
+ * INT_MAX, whichever is less), or negative number if any of the callbacks
+ * return error.
  */
 int ring_buffer__consume(struct ring_buffer *rb)
 {
-	int i, err, res = 0;
+	int64_t err, res = 0;
+	int i;
 
 	for (i = 0; i < rb->ring_cnt; i++) {
 		struct ring *ring = &rb->rings[i];
@@ -259,18 +263,24 @@ int ring_buffer__consume(struct ring_buffer *rb)
 			return err;
 		res += err;
 	}
+	if (res > INT_MAX)
+		return INT_MAX;
 	return res;
 }
 
 /* Poll for available data and consume records, if any are available.
- * Returns number of records consumed, or negative number, if any of the
- * registered callbacks returned error.
+ * Returns number of records consumed (or INT_MAX, whichever is less), or
+ * negative number, if any of the registered callbacks returned error.
  */
 int ring_buffer__poll(struct ring_buffer *rb, int timeout_ms)
 {
-	int i, cnt, err, res = 0;
+	int i, cnt;
+	int64_t err, res = 0;
 
 	cnt = epoll_wait(rb->epoll_fd, rb->events, rb->ring_cnt, timeout_ms);
+	if (cnt < 0)
+		return -errno;
+
 	for (i = 0; i < cnt; i++) {
 		__u32 ring_id = rb->events[i].data.fd;
 		struct ring *ring = &rb->rings[ring_id];
@@ -280,7 +290,9 @@ int ring_buffer__poll(struct ring_buffer *rb, int timeout_ms)
 			return err;
 		res += err;
 	}
-	return cnt < 0 ? -errno : res;
+	if (res > INT_MAX)
+		return INT_MAX;
+	return res;
 }
 
 /* Get an fd that can be used to sleep until data is available in the ring(s) */
-- 
2.30.2



