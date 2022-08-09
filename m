Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10AD858DDA2
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245325AbiHISDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343501AbiHISCu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:02:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA05626110;
        Tue,  9 Aug 2022 11:01:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E0EEB816EC;
        Tue,  9 Aug 2022 18:01:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FABC433D6;
        Tue,  9 Aug 2022 18:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068091;
        bh=K/+z6RtiqdIGnLZ1gtlrGutH0ZaIuy+G3NLRTJq9AYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=azgY44G7ups9UT8kZLIOATI1omjjSCU0cXV+9d5PDWOKenMKkWCj19JU4eq0j1fdq
         BOf8Nv1+20QhUlLCuvT9MkocR+NassIy1dSm5VWz5Zt0PegUwu9WcMGidWdHD9kHT5
         N5fz2TMvgc2S3OO8DaP5dKCEsWGnA+vMUC6GsZKE=
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
Subject: [PATCH 4.19 11/32] net: ping6: Fix memleak in ipv6_renew_options().
Date:   Tue,  9 Aug 2022 20:00:02 +0200
Message-Id: <20220809175513.451194988@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175513.082573955@linuxfoundation.org>
References: <20220809175513.082573955@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -27,6 +27,11 @@
 #include <linux/proc_fs.h>
 #include <net/ping.h>
 
+static void ping_v6_destroy(struct sock *sk)
+{
+	inet6_destroy_sock(sk);
+}
+
 /* Compatibility glue so we can support IPv6 when it's compiled as a module */
 static int dummy_ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len,
 				 int *addr_len)
@@ -170,6 +175,7 @@ struct proto pingv6_prot = {
 	.owner =	THIS_MODULE,
 	.init =		ping_init_sock,
 	.close =	ping_close,
+	.destroy =	ping_v6_destroy,
 	.connect =	ip6_datagram_connect_v6_only,
 	.disconnect =	__udp_disconnect,
 	.setsockopt =	ipv6_setsockopt,


