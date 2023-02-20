Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6919969CD87
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbjBTNuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbjBTNuU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:50:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760284230
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:50:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1482360EAB
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2600AC433D2;
        Mon, 20 Feb 2023 13:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901004;
        bh=P4Cr3lOuiAs9Yp1sNoWbomSBpHWr0eJFuCUyNcxmlD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZcJNFNXhYrLboG6Lb7HqeFzih3IKHrmzHs0NSKt9h9XP0YYxC3xJdd3wu2b+PXAW
         c8cMyChU+P0SCq54Vv4nIheiLP5ua4GccY7nq6BsrEWl/9xKr9g50YtzA0JzBugCHM
         33VQwBrJluRWhMSkllxpM8ZpST0Mu/mt4hvRIoak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Guillaume Nault <gnault@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 150/156] ipv6: Fix tcp socket connection with DSCP.
Date:   Mon, 20 Feb 2023 14:36:34 +0100
Message-Id: <20230220133608.911454308@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

commit 8230680f36fd1525303d1117768c8852314c488c upstream.

Take into account the IPV6_TCLASS socket option (DSCP) in
tcp_v6_connect(). Otherwise fib6_rule_match() can't properly
match the DSCP value, resulting in invalid route lookup.

For example:

  ip route add unreachable table main 2001:db8::10/124

  ip route add table 100 2001:db8::10/124 dev eth0
  ip -6 rule add dsfield 0x04 table 100

  echo test | socat - TCP6:[2001:db8::11]:54321,ipv6-tclass=0x04

Without this patch, socat fails at connect() time ("No route to host")
because the fib-rule doesn't jump to table 100 and the lookup ends up
being done in the main table.

Fixes: 2cc67cc731d9 ("[IPV6] ROUTE: Routing by Traffic Class.")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/tcp_ipv6.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -264,6 +264,7 @@ static int tcp_v6_connect(struct sock *s
 	fl6.flowi6_proto = IPPROTO_TCP;
 	fl6.daddr = sk->sk_v6_daddr;
 	fl6.saddr = saddr ? *saddr : np->saddr;
+	fl6.flowlabel = ip6_make_flowinfo(np->tclass, np->flow_label);
 	fl6.flowi6_oif = sk->sk_bound_dev_if;
 	fl6.flowi6_mark = sk->sk_mark;
 	fl6.fl6_dport = usin->sin6_port;


