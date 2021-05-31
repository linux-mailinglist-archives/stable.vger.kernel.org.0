Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6BD395D7C
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhEaNqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:46:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233046AbhEaNoc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:44:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D328E61581;
        Mon, 31 May 2021 13:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467763;
        bh=LziqiJxWimC3gHL1WLXsLiuG+LG8itRP/PI0D2fhZbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qS7KYdqL+yX88ZxFTgfGwDqg1s/OTMpu+BxTDYoStpXImwZiV/ExKl2UCzwTxnRIn
         EG8n7ein1sSSg8zQkkaY83YSPiXUrbawiWylOQM8N3DBeWO3Z0rILyUrYvwaWb6Oen
         LW5r+utbRa+9lL+y25xxCL4xW7NotW0NEukzoLIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jussi Maki <joamaki@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 70/79] bpf: Set mac_len in bpf_skb_change_head
Date:   Mon, 31 May 2021 15:14:55 +0200
Message-Id: <20210531130638.237257360@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.002722319@linuxfoundation.org>
References: <20210531130636.002722319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jussi Maki <joamaki@gmail.com>

[ Upstream commit 84316ca4e100d8cbfccd9f774e23817cb2059868 ]

The skb_change_head() helper did not set "skb->mac_len", which is
problematic when it's used in combination with skb_redirect_peer().
Without it, redirecting a packet from a L3 device such as wireguard to
the veth peer device will cause skb->data to point to the middle of the
IP header on entry to tcp_v4_rcv() since the L2 header is not pulled
correctly due to mac_len=0.

Fixes: 3a0af8fd61f9 ("bpf: BPF for lightweight tunnel infrastructure")
Signed-off-by: Jussi Maki <joamaki@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20210519154743.2554771-2-joamaki@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index a33cf7b28e4d..40b378bed603 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2438,6 +2438,7 @@ BPF_CALL_3(bpf_skb_change_head, struct sk_buff *, skb, u32, head_room,
 		__skb_push(skb, head_room);
 		memset(skb->data, 0, head_room);
 		skb_reset_mac_header(skb);
+		skb_reset_mac_len(skb);
 	}
 
 	bpf_compute_data_end(skb);
-- 
2.30.2



