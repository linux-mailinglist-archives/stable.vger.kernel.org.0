Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35FC23D2A5C
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234921AbhGVQK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:10:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234329AbhGVQI7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:08:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85CFA61DCB;
        Thu, 22 Jul 2021 16:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972533;
        bh=CgAkO8xDP7qkSFNREO/D4boR9S9gZJ6SUDTPj1UaQKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PxbmnVqTlvAW13w5XsGxbcCYGCtOt1YRvSag21tYS7gQXrUHyzGoXg6apuInTWsfn
         e2WkuJDiL+ZhT2Xs+JL/V92CDcWRj7rXCsAElIgWmixiyG/afkVEKbDsuxKdrTf+91
         Pz8KisBRQfgCAaSjyZ80cSDG4DI4b+tB5EgLd9to=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Talal Ahmad <talalahmad@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Wei Wang <weiwan@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.13 147/156] tcp: call sk_wmem_schedule before sk_mem_charge in zerocopy path
Date:   Thu, 22 Jul 2021 18:32:02 +0200
Message-Id: <20210722155633.094808345@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Talal Ahmad <talalahmad@google.com>

commit 358ed624207012f03318235017ac6fb41f8af592 upstream.

sk_wmem_schedule makes sure that sk_forward_alloc has enough
bytes for charging that is going to be done by sk_mem_charge.

In the transmit zerocopy path, there is sk_mem_charge but there was
no call to sk_wmem_schedule. This change adds that call.

Without this call to sk_wmem_schedule, sk_forward_alloc can go
negetive which is a bug because sk_forward_alloc is a per-socket
space that has been forward charged so this can't be negative.

Fixes: f214f915e7db ("tcp: enable MSG_ZEROCOPY")
Signed-off-by: Talal Ahmad <talalahmad@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Wei Wang <weiwan@google.com>
Reviewed-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1375,6 +1375,9 @@ new_segment:
 			}
 			pfrag->offset += copy;
 		} else {
+			if (!sk_wmem_schedule(sk, copy))
+				goto wait_for_space;
+
 			err = skb_zerocopy_iter_stream(sk, skb, msg, copy, uarg);
 			if (err == -EMSGSIZE || err == -EEXIST) {
 				tcp_mark_push(tp, skb);


