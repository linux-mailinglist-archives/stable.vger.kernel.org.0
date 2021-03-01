Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A8C328FD9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242571AbhCAT6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:58:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:55162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240364AbhCATqi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:46:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74D8765120;
        Mon,  1 Mar 2021 17:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618176;
        bh=xmI+xH5TJI+0iWuL1ogIbW3fvfnqtxq3qULo2d1GKUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yB/x0zQ6f/CH9OXZg/38u1YucfTiFfItVxRMxKxCyQZTBQxb3DGFZlgeHuBtxdhrc
         x1FlBu+Bu/BZlk4UPWiIBI8Fqx6U6hrgW+SjKhDfJV2PbSk0TWO9OpAcuyw6EEeLXk
         v9h8JTjBsw2Li53rt9vjB9O1/FURl/Jz+XhGWwyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 334/340] xfrm: interface: use icmp_ndo_send helper
Date:   Mon,  1 Mar 2021 17:14:38 +0100
Message-Id: <20210301161104.731520824@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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


