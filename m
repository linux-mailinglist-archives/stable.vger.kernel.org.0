Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2193287B9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238472AbhCAR2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:28:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:37358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236972AbhCARSv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:18:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B232A64EEC;
        Mon,  1 Mar 2021 16:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617214;
        bh=xmI+xH5TJI+0iWuL1ogIbW3fvfnqtxq3qULo2d1GKUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PkZuVPtFoQzFL3kRHi7TVlYMAtkgQ3ILGPA8KM1RzPjV/OBNX7H38wpQLDll8DOAN
         0liEgy8c7a/HAIH65QF5SjNZCzDUl8IrbgUAfANPHwzP1Mxuxiqv2rwCZECDVaCGgm
         JNj7iYT9CH8F+9D8p5PqAd31HC+A4VaXbxPqeueU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 242/247] xfrm: interface: use icmp_ndo_send helper
Date:   Mon,  1 Mar 2021 17:14:22 +0100
Message-Id: <20210301161043.554355228@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 45942ba890e6f35232727a5fa33d732681f4eb9f upstream.

Because xfrmi is calling icmp from network device context, it should use
the ndo helper so that the rate limiting applies correctly.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_interface.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -300,10 +300,10 @@ xfrmi_xmit2(struct sk_buff *skb, struct
 			if (mtu < IPV6_MIN_MTU)
 				mtu = IPV6_MIN_MTU;
 
-			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
+			icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
 		} else {
-			icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
-				  htonl(mtu));
+			icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
+				      htonl(mtu));
 		}
 
 		dst_release(dst);


