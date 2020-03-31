Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6F7D199169
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730811AbgCaJRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:17:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730819AbgCaJRt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:17:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10BAF20772;
        Tue, 31 Mar 2020 09:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646269;
        bh=An0gNQn7YMvXnKeG9BQYZZh6VW6cJv6Egsntd0dEeoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LL8cwkBjGeMgnmxDFmvWl94+wXoXugEt1GeUTUl/xny/uRCEiTSrR/IcdCvSkMgWd
         CzMZ8P4i0otfPuVM4cQnl0fN/k2nVjjvhYR4ZsP+kVXUGgYf++gIK31NUppkS9nFVT
         ysUIDASdYRP7yp4L3P6POny1P+XgRISjcsiLMlaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Torsten Hilbrich <torsten.hilbrich@secunet.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.4 133/155] vti6: Fix memory leak of skb if input policy check fails
Date:   Tue, 31 Mar 2020 10:59:33 +0200
Message-Id: <20200331085433.186362372@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Torsten Hilbrich <torsten.hilbrich@secunet.com>

commit 2a9de3af21aa8c31cd68b0b39330d69f8c1e59df upstream.

The vti6_rcv function performs some tests on the retrieved tunnel
including checking the IP protocol, the XFRM input policy, the
source and destination address.

In all but one places the skb is released in the error case. When
the input policy check fails the network packet is leaked.

Using the same goto-label discard in this case to fix this problem.

Fixes: ed1efb2aefbb ("ipv6: Add support for IPsec virtual tunnel interfaces")
Signed-off-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv6/ip6_vti.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -311,7 +311,7 @@ static int vti6_rcv(struct sk_buff *skb)
 
 		if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb)) {
 			rcu_read_unlock();
-			return 0;
+			goto discard;
 		}
 
 		ipv6h = ipv6_hdr(skb);


