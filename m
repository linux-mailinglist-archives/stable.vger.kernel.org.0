Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A23A4A96C4
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357808AbiBDJ3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357892AbiBDJ1Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:27:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9864C0613AB;
        Fri,  4 Feb 2022 01:26:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85B39B836EE;
        Fri,  4 Feb 2022 09:26:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C073BC004E1;
        Fri,  4 Feb 2022 09:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966797;
        bh=FfufDGP0vbrB1uqDzoCXWRh1tSI+gT7AO7hV+VpPMYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uppvAPa3OfxNHXDdXhXk3hqLxadu661GiM1YghAJq/tPiC7RnL9UQnU9ZSCyNl7Nx
         uknYVcO47eIQO0vF4HmOQuS/c0jgpI44axg2r2J9DreqJvQ2LpGSTEhUk1lUAAOw6H
         MPCdjgb1jKzIdSC2XZ2xqZH8U2B6U+5RgCiaoH8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Talal Ahmad <talalahmad@google.com>,
        Arjun Roy <arjunroy@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 42/43] tcp: fix mem under-charging with zerocopy sendmsg()
Date:   Fri,  4 Feb 2022 10:22:49 +0100
Message-Id: <20220204091918.536012051@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
References: <20220204091917.166033635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 479f5547239d970d3833f15f54a6481fffdb91ec upstream.

We got reports of following warning in inet_sock_destruct()

	WARN_ON(sk_forward_alloc_get(sk));

Whenever we add a non zero-copy fragment to a pure zerocopy skb,
we have to anticipate that whole skb->truesize will be uncharged
when skb is finally freed.

skb->data_len is the payload length. But the memory truesize
estimated by __zerocopy_sg_from_iter() is page aligned.

Fixes: 9b65b17db723 ("net: avoid double accounting for pure zerocopy skbs")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Talal Ahmad <talalahmad@google.com>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Link: https://lore.kernel.org/r/20220201065254.680532-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1321,10 +1321,13 @@ new_segment:
 
 			/* skb changing from pure zc to mixed, must charge zc */
 			if (unlikely(skb_zcopy_pure(skb))) {
-				if (!sk_wmem_schedule(sk, skb->data_len))
+				u32 extra = skb->truesize -
+					    SKB_TRUESIZE(skb_end_offset(skb));
+
+				if (!sk_wmem_schedule(sk, extra))
 					goto wait_for_space;
 
-				sk_mem_charge(sk, skb->data_len);
+				sk_mem_charge(sk, extra);
 				skb_shinfo(skb)->flags &= ~SKBFL_PURE_ZEROCOPY;
 			}
 


