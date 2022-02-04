Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B964A96C6
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358440AbiBDJ3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358201AbiBDJ1R (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:27:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43A9C0613B0;
        Fri,  4 Feb 2022 01:26:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CE93617CB;
        Fri,  4 Feb 2022 09:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE24FC004E1;
        Fri,  4 Feb 2022 09:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966800;
        bh=IrH3Lq742IEwdP6JdFAIufJs3bG7n3Dw3Q/CAabNvN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h/2udK2YXekoS+5iq2NB51aPywb6DCg1/bb1WRmzT7Jl7gluVaxrdYlE2bsucjeAC
         uwFP+fkZoJsX7+KvZbIJwxovGP7GIkeuaKYa1oSH68sD7zrQv0a0KjhLiFzkFAyTFv
         fGRlnIzzMdMp3V0BXgqHet9qNuKEZ4D/GUmibMOM=
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
Subject: [PATCH 5.16 43/43] tcp: add missing tcp_skb_can_collapse() test in tcp_shift_skb_data()
Date:   Fri,  4 Feb 2022 10:22:50 +0100
Message-Id: <20220204091918.568507348@linuxfoundation.org>
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
@@ -1660,6 +1660,8 @@ static struct sk_buff *tcp_shift_skb_dat
 	    (mss != tcp_skb_seglen(skb)))
 		goto out;
 
+	if (!tcp_skb_can_collapse(prev, skb))
+		goto out;
 	len = skb->len;
 	pcount = tcp_skb_pcount(skb);
 	if (tcp_skb_shift(prev, skb, pcount, len))


