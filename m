Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D63D036AEC0
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233225AbhDZHq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:46:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234358AbhDZHpJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:45:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03668613FB;
        Mon, 26 Apr 2021 07:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422933;
        bh=I5kr/ZJURQoJQ6ScNBJC0SibW9GWi8X8EIj3ro4wxSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0tpTKZxvfI4jwOwochtWFuIaXnVhMirlYJlRCORYLffMLesmMD+1AIy5sf6rxdoKz
         OD84qpUNxxIG7ZoTZET9d3n8oStP6iqzU7H1PhMnQswiSuBDwaOZOxzssTMR1N28AN
         AI3oUjcPdTLaK8Qih4/hMes7aoHhQzZAE3pGYmcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot+2e406a9ac75bb71d4b7a@syzkaller.appspotmail.com,
        Phillip Potter <phil@philpotter.co.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 32/41] net: geneve: check skb is large enough for IPv4/IPv6 header
Date:   Mon, 26 Apr 2021 09:30:19 +0200
Message-Id: <20210426072820.778691031@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072819.666570770@linuxfoundation.org>
References: <20210426072819.666570770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phillip Potter <phil@philpotter.co.uk>

[ Upstream commit 6628ddfec7580882f11fdc5c194a8ea781fdadfa ]

Check within geneve_xmit_skb/geneve6_xmit_skb that sk_buff structure
is large enough to include IPv4 or IPv6 header, and reject if not. The
geneve_xmit_skb portion and overall idea was contributed by Eric Dumazet.
Fixes a KMSAN-found uninit-value bug reported by syzbot at:
https://syzkaller.appspot.com/bug?id=abe95dc3e3e9667fc23b8d81f29ecad95c6f106f

Suggested-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot+2e406a9ac75bb71d4b7a@syzkaller.appspotmail.com
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/geneve.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index f35b0b83fe85..040edc6fc560 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -891,6 +891,9 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be16 sport;
 	int err;
 
+	if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
+		return -EINVAL;
+
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
 	rt = geneve_get_v4_rt(skb, dev, gs4, &fl4, info,
 			      geneve->cfg.info.key.tp_dst, sport);
@@ -985,6 +988,9 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be16 sport;
 	int err;
 
+	if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
+		return -EINVAL;
+
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
 	dst = geneve_get_v6_dst(skb, dev, gs6, &fl6, info,
 				geneve->cfg.info.key.tp_dst, sport);
-- 
2.30.2



