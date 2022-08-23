Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3DCF59D861
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350254AbiHWJby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351056AbiHWJbP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:31:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B993862C5;
        Tue, 23 Aug 2022 01:38:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E70A861540;
        Tue, 23 Aug 2022 08:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2BCC433D6;
        Tue, 23 Aug 2022 08:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243822;
        bh=Ko2KFsJXefQC6uhU20nFUKfN9T0HQZh3ccGCRZW+100=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h2bV2RwNPOWxMUgYuD0TWHvShDz3kE7hpH4u5auRO+4hQRDAYdDuqBGIvCFndtPMG
         YJkAgncBQxa/yud5oa7Nz7TruNg3sazZIc6mNUtF9WwwY3iUPJRjtZWaf5PNnqpqFi
         sULqjmKYThmykm7WxTZEew07ph1ujDZwbmqPMQWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+a8430774139ec3ab7176@syzkaller.appspotmail.com,
        Ayushman Dutta <ayudutta@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 005/229] net: ping6: Fix memleak in ipv6_renew_options().
Date:   Tue, 23 Aug 2022 10:22:46 +0200
Message-Id: <20220823080053.481732597@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit e27326009a3d247b831eda38878c777f6f4eb3d1 upstream.

When we close ping6 sockets, some resources are left unfreed because
pingv6_prot is missing sk->sk_prot->destroy().  As reported by
syzbot [0], just three syscalls leak 96 bytes and easily cause OOM.

    struct ipv6_sr_hdr *hdr;
    char data[24] = {0};
    int fd;

    hdr = (struct ipv6_sr_hdr *)data;
    hdr->hdrlen = 2;
    hdr->type = IPV6_SRCRT_TYPE_4;

    fd = socket(AF_INET6, SOCK_DGRAM, NEXTHDR_ICMP);
    setsockopt(fd, IPPROTO_IPV6, IPV6_RTHDR, data, 24);
    close(fd);

To fix memory leaks, let's add a destroy function.

Note the socket() syscall checks if the GID is within the range of
net.ipv4.ping_group_range.  The default value is [1, 0] so that no
GID meets the condition (1 <= GID <= 0).  Thus, the local DoS does
not succeed until we change the default value.  However, at least
Ubuntu/Fedora/RHEL loosen it.

    $ cat /usr/lib/sysctl.d/50-default.conf
    ...
    -net.ipv4.ping_group_range = 0 2147483647

Also, there could be another path reported with these options, and
some of them require CAP_NET_RAW.

  setsockopt
      IPV6_ADDRFORM (inet6_sk(sk)->pktoptions)
      IPV6_RECVPATHMTU (inet6_sk(sk)->rxpmtu)
      IPV6_HOPOPTS (inet6_sk(sk)->opt)
      IPV6_RTHDRDSTOPTS (inet6_sk(sk)->opt)
      IPV6_RTHDR (inet6_sk(sk)->opt)
      IPV6_DSTOPTS (inet6_sk(sk)->opt)
      IPV6_2292PKTOPTIONS (inet6_sk(sk)->opt)

  getsockopt
      IPV6_FLOWLABEL_MGR (inet6_sk(sk)->ipv6_fl_list)

For the record, I left a different splat with syzbot's one.

  unreferenced object 0xffff888006270c60 (size 96):
    comm "repro2", pid 231, jiffies 4294696626 (age 13.118s)
    hex dump (first 32 bytes):
      01 00 00 00 44 00 00 00 00 00 00 00 00 00 00 00  ....D...........
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<00000000f6bc7ea9>] sock_kmalloc (net/core/sock.c:2564 net/core/sock.c:2554)
      [<000000006d699550>] do_ipv6_setsockopt.constprop.0 (net/ipv6/ipv6_sockglue.c:715)
      [<00000000c3c3b1f5>] ipv6_setsockopt (net/ipv6/ipv6_sockglue.c:1024)
      [<000000007096a025>] __sys_setsockopt (net/socket.c:2254)
      [<000000003a8ff47b>] __x64_sys_setsockopt (net/socket.c:2265 net/socket.c:2262 net/socket.c:2262)
      [<000000007c409dcb>] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
      [<00000000e939c4a9>] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)

[0]: https://syzkaller.appspot.com/bug?extid=a8430774139ec3ab7176

Fixes: 6d0bfe226116 ("net: ipv6: Add IPv6 support to the ping socket.")
Reported-by: syzbot+a8430774139ec3ab7176@syzkaller.appspotmail.com
Reported-by: Ayushman Dutta <ayudutta@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20220728012220.46918-1-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ping.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -26,6 +26,11 @@
 #include <net/transp_v6.h>
 #include <net/ping.h>
 
+static void ping_v6_destroy(struct sock *sk)
+{
+	inet6_destroy_sock(sk);
+}
+
 /* Compatibility glue so we can support IPv6 when it's compiled as a module */
 static int dummy_ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len,
 				 int *addr_len)
@@ -173,6 +178,7 @@ struct proto pingv6_prot = {
 	.owner =	THIS_MODULE,
 	.init =		ping_init_sock,
 	.close =	ping_close,
+	.destroy =	ping_v6_destroy,
 	.connect =	ip6_datagram_connect_v6_only,
 	.disconnect =	__udp_disconnect,
 	.setsockopt =	ipv6_setsockopt,


