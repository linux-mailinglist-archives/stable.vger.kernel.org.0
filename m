Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D81C820120C
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393294AbgFSPYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:24:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393288AbgFSPYk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:24:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14A77217A0;
        Fri, 19 Jun 2020 15:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580279;
        bh=9hnYe63g3vNUWbLOB/FO/gxg7KJj1oQxrmXrsSdDF5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UNnUjEi3NmxkJ87Ws/gH9eCjx5AjQSDmwV+lmkE1g23XUgeZYmk76Gv15moZkI9Do
         DXae9FuLwFnWPLLwRdzTYvuJ9E4kWswODm/UwzXIav9q7UMPuf1P7B39t7ddQ/egPZ
         c5P5ud/VYmT1xm6UYem3K7/AMHkUN5UyLko4bsyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mao Wenan <maowenan@huawei.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 190/376] veth: Adjust hard_start offset on redirect XDP frames
Date:   Fri, 19 Jun 2020 16:31:48 +0200
Message-Id: <20200619141719.343785866@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

[ Upstream commit 5c8572251fabc5bb49fd623c064e95a9daf6a3e3 ]

When native XDP redirect into a veth device, the frame arrives in the
xdp_frame structure. It is then processed in veth_xdp_rcv_one(),
which can run a new XDP bpf_prog on the packet. Doing so requires
converting xdp_frame to xdp_buff, but the tricky part is that
xdp_frame memory area is located in the top (data_hard_start) memory
area that xdp_buff will point into.

The current code tried to protect the xdp_frame area, by assigning
xdp_buff.data_hard_start past this memory. This results in 32 bytes
less headroom to expand into via BPF-helper bpf_xdp_adjust_head().

This protect step is actually not needed, because BPF-helper
bpf_xdp_adjust_head() already reserve this area, and don't allow
BPF-prog to expand into it. Thus, it is safe to point data_hard_start
directly at xdp_frame memory area.

Fixes: 9fc8d518d9d5 ("veth: Handle xdp_frames in xdp napi ring")
Reported-by: Mao Wenan <maowenan@huawei.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/bpf/158945338331.97035.5923525383710752178.stgit@firesoul
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index aece0e5eec8c..d5691bb84448 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -564,13 +564,15 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 					struct veth_stats *stats)
 {
 	void *hard_start = frame->data - frame->headroom;
-	void *head = hard_start - sizeof(struct xdp_frame);
 	int len = frame->len, delta = 0;
 	struct xdp_frame orig_frame;
 	struct bpf_prog *xdp_prog;
 	unsigned int headroom;
 	struct sk_buff *skb;
 
+	/* bpf_xdp_adjust_head() assures BPF cannot access xdp_frame area */
+	hard_start -= sizeof(struct xdp_frame);
+
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
 	if (likely(xdp_prog)) {
@@ -592,7 +594,6 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 			break;
 		case XDP_TX:
 			orig_frame = *frame;
-			xdp.data_hard_start = head;
 			xdp.rxq->mem = frame->mem;
 			if (unlikely(veth_xdp_tx(rq, &xdp, bq) < 0)) {
 				trace_xdp_exception(rq->dev, xdp_prog, act);
@@ -605,7 +606,6 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 			goto xdp_xmit;
 		case XDP_REDIRECT:
 			orig_frame = *frame;
-			xdp.data_hard_start = head;
 			xdp.rxq->mem = frame->mem;
 			if (xdp_do_redirect(rq->dev, &xdp, xdp_prog)) {
 				frame = &orig_frame;
@@ -629,7 +629,7 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 	rcu_read_unlock();
 
 	headroom = sizeof(struct xdp_frame) + frame->headroom - delta;
-	skb = veth_build_skb(head, headroom, len, 0);
+	skb = veth_build_skb(hard_start, headroom, len, 0);
 	if (!skb) {
 		xdp_return_frame(frame);
 		stats->rx_drops++;
-- 
2.25.1



