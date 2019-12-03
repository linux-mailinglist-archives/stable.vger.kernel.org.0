Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1598D111E9A
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbfLCXCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:02:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:48302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728033AbfLCWy0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:54:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2925620674;
        Tue,  3 Dec 2019 22:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413665;
        bh=ihPG//jNFj6mdLcSyAiHByfXaouHt8MxyYWi42hQ/NQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q4++BbNGtEKxJMh9D6x1cMzoOzZ6iuHfiaJwN3fq//nd7sWRtNPoXap3O5WofYDwx
         fYi+l3JFbSc3epfwVnuSkzThhHo/+BzkyL0VbfF0J+pGGY1gLOfWvnjMAkWdhvTIq4
         ouwM2nyCQrslPf5TkyR1MWZ9XOIYIQ/se+ZBo4Ac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 176/321] bpf/cpumap: make sure frame_size for build_skb is aligned if headroom isnt
Date:   Tue,  3 Dec 2019 23:34:02 +0100
Message-Id: <20191203223436.285585148@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

[ Upstream commit 77ea5f4cbe2084db9ab021ba73fb7eadf1610884 ]

The frame_size passed to build_skb must be aligned, else it is
possible that the embedded struct skb_shared_info gets unaligned.

For correctness make sure that xdpf->headroom in included in the
alignment. No upstream drivers can hit this, as all XDP drivers provide
an aligned headroom.  This was discovered when playing with implementing
XDP support for mvneta, which have a 2 bytes DSA header, and this
Marvell ARM64 platform didn't like doing atomic operations on an
unaligned skb_shinfo(skb)->dataref addresses.

Fixes: 1c601d829ab0 ("bpf: cpumap xdp_buff to skb conversion and allocation")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cpumap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 24aac0d0f4127..8974b3755670e 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -183,7 +183,7 @@ static struct sk_buff *cpu_map_build_skb(struct bpf_cpu_map_entry *rcpu,
 	 * is not at a fixed memory location, with mixed length
 	 * packets, which is bad for cache-line hotness.
 	 */
-	frame_size = SKB_DATA_ALIGN(xdpf->len) + xdpf->headroom +
+	frame_size = SKB_DATA_ALIGN(xdpf->len + xdpf->headroom) +
 		SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 
 	pkt_data_start = xdpf->data - xdpf->headroom;
-- 
2.20.1



