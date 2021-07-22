Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F65A3D293A
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhGVQCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:02:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233215AbhGVQB4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:01:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F41DB613D2;
        Thu, 22 Jul 2021 16:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972151;
        bh=bIzTXGsHr8QHJ+5atn7vpgyCBEq5bSAhFCqbgLtBvxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lsdDwkg7jrTYP5uB8PbAJiUnmUWdhCGD+NqIHHiHdSQDrOk3np154VisJeRgVgGWY
         9Ytzejs/FhU/LgY6opLwIjH5HqieGgaCjTzhnH0Wl9lByZTsHFDvLmadETlBKJd8jV
         OXmlqxQ0wwgRpbCBmoYHyxfcnd/Y1eWSjdFamEvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Talal Ahmad <talalahmad@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Wei Wang <weiwan@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 119/125] tcp: call sk_wmem_schedule before sk_mem_charge in zerocopy path
Date:   Thu, 22 Jul 2021 18:31:50 +0200
Message-Id: <20210722155628.661907281@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
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
@@ -1361,6 +1361,9 @@ new_segment:
 			}
 			pfrag->offset += copy;
 		} else {
+			if (!sk_wmem_schedule(sk, copy))
+				goto wait_for_space;
+
 			err = skb_zerocopy_iter_stream(sk, skb, msg, copy, uarg);
 			if (err == -EMSGSIZE || err == -EEXIST) {
 				tcp_mark_push(tp, skb);


