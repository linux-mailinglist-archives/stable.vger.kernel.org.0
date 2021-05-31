Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6167C3960C4
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbhEaOba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:31:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233807AbhEaO3Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:29:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F12DC61C21;
        Mon, 31 May 2021 13:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468890;
        bh=1u35W/3FJW3aqzFqG70FQkWEI0vEjNAboO4K4dfb+Zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fFLA3v5wDB/dQ/oSDT9lzB1J0I+F/gr+GknTS5JNKfeFAzyD7JDVahMy/ATSVnqEo
         cGAd4SVReFZKWU23z7NbXefYbjUDZoMiQMNP3UWWr5iCNIagELSRK+X5bQCzo/CHLN
         qXn1UALAp/49oNS4uvYuWvp0gFansVyYK+8vovNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jussi Maki <joamaki@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 160/177] bpf: Set mac_len in bpf_skb_change_head
Date:   Mon, 31 May 2021 15:15:17 +0200
Message-Id: <20210531130653.448880687@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
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
index 7fbb274b7fe3..108bcf600052 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3331,6 +3331,7 @@ static inline int __bpf_skb_change_head(struct sk_buff *skb, u32 head_room,
 		__skb_push(skb, head_room);
 		memset(skb->data, 0, head_room);
 		skb_reset_mac_header(skb);
+		skb_reset_mac_len(skb);
 	}
 
 	return ret;
-- 
2.30.2



