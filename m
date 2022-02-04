Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD1F94A9618
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357718AbiBDJWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:22:41 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51402 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357592AbiBDJWG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:22:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1ADF5B836F1;
        Fri,  4 Feb 2022 09:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F869C004E1;
        Fri,  4 Feb 2022 09:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966524;
        bh=KwSx78kgBSkfwQnzakgw/kHlw0YgW+uZsnXilQghTBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=irTwuUejgrHR3KysG1pWcUaSUYzpkaWuR6tNwMtpXKavNy9Yz0GkBc/wRyzmLkvk8
         2v1pnVWjGOdd8ZJh7+rRz849SiegozvfxwizANpFBe/AC5Z++jITe2tHhcrkhBx3bj
         371JvSR6+0TmkxVXEl8nYUfGrhS3WELxGl8eWyu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Talal Ahmad <talalahmad@google.com>,
        Arjun Roy <arjunroy@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 25/25] tcp: add missing tcp_skb_can_collapse() test in tcp_shift_skb_data()
Date:   Fri,  4 Feb 2022 10:20:32 +0100
Message-Id: <20220204091915.087224273@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091914.280602669@linuxfoundation.org>
References: <20220204091914.280602669@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit b67985be400969578d4d4b17299714c0e5d2c07b upstream.

tcp_shift_skb_data() might collapse three packets into a larger one.

P_A, P_B, P_C  -> P_ABC

Historically, it used a single tcp_skb_can_collapse_to(P_A) call,
because it was enough.

In commit 85712484110d ("tcp: coalesce/collapse must respect MPTCP extensions"),
this call was replaced by a call to tcp_skb_can_collapse(P_A, P_B)

But the now needed test over P_C has been missed.

This probably broke MPTCP.

Then later, commit 9b65b17db723 ("net: avoid double accounting for pure zerocopy skbs")
added an extra condition to tcp_skb_can_collapse(), but the missing call
from tcp_shift_skb_data() is also breaking TCP zerocopy, because P_A and P_C
might have different skb_zcopy_pure() status.

Fixes: 85712484110d ("tcp: coalesce/collapse must respect MPTCP extensions")
Fixes: 9b65b17db723 ("net: avoid double accounting for pure zerocopy skbs")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc: Talal Ahmad <talalahmad@google.com>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/20220201184640.756716-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1620,6 +1620,8 @@ static struct sk_buff *tcp_shift_skb_dat
 	    (mss != tcp_skb_seglen(skb)))
 		goto out;
 
+	if (!tcp_skb_can_collapse(prev, skb))
+		goto out;
 	len = skb->len;
 	pcount = tcp_skb_pcount(skb);
 	if (tcp_skb_shift(prev, skb, pcount, len))


