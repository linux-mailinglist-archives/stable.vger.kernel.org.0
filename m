Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659683C53FD
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349357AbhGLH4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351440AbhGLHvs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E13960FF1;
        Mon, 12 Jul 2021 07:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076139;
        bh=8hL99on/kGHd9SZ0FmxTqw28CrZ+V5Ar0rZUUs7ffcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XBkdgbpXIMSmWJuyI8V49MtkQoPdNHVNiMHbK50LCaRMhQWtMENncSLchyO6r5odt
         VynkChzz/gtMetxSihF5estoDpCaoJXDQ8GioegpTnRfr2sCssLAvHZouIZV2PupQo
         Ul9TmBh1Z7d+J4BP9ehb5WJRtIvZnbJIT0IWSmAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 513/800] udp: Fix a memory leak in udp_read_sock()
Date:   Mon, 12 Jul 2021 08:08:56 +0200
Message-Id: <20210712061021.794224665@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit e00a5c331bf57f41fcfdc5da4f5caeafe5e54c1d ]

sk_psock_verdict_recv() clones the skb and uses the clone
afterward, so udp_read_sock() should free the skb after using
it, regardless of error or not.

This fixes a real kmemleak.

Fixes: d7f571188ecf ("udp: Implement ->read_sock() for sockmap")
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20210615021342.7416-4-xiyou.wangcong@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 1307ad0d3b9e..8091276cb85b 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1798,11 +1798,13 @@ int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
 		if (used <= 0) {
 			if (!copied)
 				copied = used;
+			kfree_skb(skb);
 			break;
 		} else if (used <= skb->len) {
 			copied += used;
 		}
 
+		kfree_skb(skb);
 		if (!desc->count)
 			break;
 	}
-- 
2.30.2



