Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEB9395F8D
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhEaOMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:12:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233072AbhEaOKk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:10:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AEB761983;
        Mon, 31 May 2021 13:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468449;
        bh=o+7OYa81zDbczAlkQhFxTddeTkO76m7DGereB6yYl1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XhY0l4wSfrkyGARrEHmLKEolr2M3h2CimQvPcm1ML+BL31400Tztt3+gk7EkYCds2
         h9Fxh0GkcqkyveAUsDruGpWuD8+FntXCSxmbhYH3O70JMfgs1MYu5wuKOeiEdRHkgN
         78rP4ShVZmpklBXC8sHrHJ+ycENotXr3B/0/0mzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jussi Maki <joamaki@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 229/252] bpf: Set mac_len in bpf_skb_change_head
Date:   Mon, 31 May 2021 15:14:54 +0200
Message-Id: <20210531130705.777951900@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
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
index 9358bc4a3711..ef6bdbb63ecb 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3782,6 +3782,7 @@ static inline int __bpf_skb_change_head(struct sk_buff *skb, u32 head_room,
 		__skb_push(skb, head_room);
 		memset(skb->data, 0, head_room);
 		skb_reset_mac_header(skb);
+		skb_reset_mac_len(skb);
 	}
 
 	return ret;
-- 
2.30.2



