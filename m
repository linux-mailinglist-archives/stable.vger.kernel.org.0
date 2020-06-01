Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038B51EAF33
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 21:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgFAR4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 13:56:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728710AbgFAR4p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:56:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD523206E2;
        Mon,  1 Jun 2020 17:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034205;
        bh=TN8/J+KS8OaAxt0HQk59vONqZA/Y2/WNw/CL3FuuG00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qx0ZRXsOIFNHXYqsLOsUeoTiScMWhHBlXHtgJREcFiTcR/OEgPw0rsTtQh3dMYx0H
         CbHwh4uDPoSxtxtbrVIaeHbSUMlXexQFMZi6qwyfwAJrKjD+1nBnHmw8w8rPvU2nMn
         EuN3mDpIjXTZN6/kSYaILRyUCXf4ucRDLX4lkdLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiumei Mu <xmu@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 4.4 31/48] ip_vti: receive ipip packet by calling ip_tunnel_rcv
Date:   Mon,  1 Jun 2020 19:53:41 +0200
Message-Id: <20200601174001.696274292@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601173952.175939894@linuxfoundation.org>
References: <20200601173952.175939894@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit 976eba8ab596bab94b9714cd46d38d5c6a2c660d upstream.

In Commit dd9ee3444014 ("vti4: Fix a ipip packet processing bug in
'IPCOMP' virtual tunnel"), it tries to receive IPIP packets in vti
by calling xfrm_input(). This case happens when a small packet or
frag sent by peer is too small to get compressed.

However, xfrm_input() will still get to the IPCOMP path where skb
sec_path is set, but never dropped while it should have been done
in vti_ipcomp4_protocol.cb_handler(vti_rcv_cb), as it's not an
ipcomp4 packet. This will cause that the packet can never pass
xfrm4_policy_check() in the upper protocol rcv functions.

So this patch is to call ip_tunnel_rcv() to process IPIP packets
instead.

Fixes: dd9ee3444014 ("vti4: Fix a ipip packet processing bug in 'IPCOMP' virtual tunnel")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/ip_vti.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -99,7 +99,28 @@ static int vti_rcv_proto(struct sk_buff
 
 static int vti_rcv_tunnel(struct sk_buff *skb)
 {
-	return vti_rcv(skb, ip_hdr(skb)->saddr, true);
+	struct ip_tunnel_net *itn = net_generic(dev_net(skb->dev), vti_net_id);
+	const struct iphdr *iph = ip_hdr(skb);
+	struct ip_tunnel *tunnel;
+
+	tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex, TUNNEL_NO_KEY,
+				  iph->saddr, iph->daddr, 0);
+	if (tunnel) {
+		struct tnl_ptk_info tpi = {
+			.proto = htons(ETH_P_IP),
+		};
+
+		if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
+			goto drop;
+		if (iptunnel_pull_header(skb, 0, tpi.proto))
+			goto drop;
+		return ip_tunnel_rcv(tunnel, skb, &tpi, NULL, false);
+	}
+
+	return -EINVAL;
+drop:
+	kfree_skb(skb);
+	return 0;
 }
 
 static int vti_rcv_cb(struct sk_buff *skb, int err)


