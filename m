Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469AB1EB2EC
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 03:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgFBBWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 21:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbgFBBWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 21:22:22 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700B1C061A0E;
        Mon,  1 Jun 2020 18:22:20 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id w15so5089713lfe.11;
        Mon, 01 Jun 2020 18:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gTCLA4fS7iJOhl+Ggn935t2jp1dm3H6JOFPXN9B0GZM=;
        b=BbtUWdUHFzYulXhLoOD83xJ2A1QcaLApa5z/emiUXPxUDIamNtJ1vO0WzEMnkc/rja
         xBaT0ibZnlQ6jMLC+J9vmDF7/uhziW3Q8UNMML9+1W5bjMJEv7XTJ133scJEExCdGufw
         VftclsfuELbpb7/Pm6EHwFwG8rL0N6/GydJ5WjwBg0qQLcK3UmSklwynKDbeEBiFQbIS
         8LlJ449+cJffz53qWiSFCHpld0KoF5AzCDDUZfjO7bmnYQudDzUf49OnUHKnz3nC1I7p
         VcSB4HPdTV9P4qID3n+QYV6aYL/U1chZwyHyL34oLYz+gSGOYFtSB2OMfcBi87oaTMfr
         pNoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gTCLA4fS7iJOhl+Ggn935t2jp1dm3H6JOFPXN9B0GZM=;
        b=U4lzdirqUStiIcsXmP9b+yHy81/PIo+FcD9XhlvwJC7TREJqyFcUJR0mHfbtdPqfaS
         xY1NeTSOG6Sg3lEOQLJ2qyIFhI3o+2/9Mf3FAWd+kx5cx8n6PDo4JDqSbTGi1yQ6NqAN
         RdANgIdFVpYdOcgi9RMYWwcFDfVyjNYLdGl6Mde4BW5pMBp/rHy43Hci90x91tonCgHf
         9eY3lhPrnE6/iuk8kl2JTzto4VhSELX8F0VjIUau5UQp7cPNMz+HrZd0b/6kfvbKyhYN
         pOwJSBCIl/HhHv2kiXxpz1xuqYC8x2VL7u2HXb+8WmRUmqgm/lWUQX+kGxlOKkR6rmVg
         J8VQ==
X-Gm-Message-State: AOAM530ExMjg6GxvjnfxZG5Jjrw41YcfnDiXAkUjtbUgp0yPUukrLxCK
        hf+AtaiQILMHbnsT6QK5deCVcVCygMHBcT3f3dc=
X-Google-Smtp-Source: ABdhPJwys0RWbrTiHu+ZdfmiMVQ55D1OmJgF4gAe1aU/NFCo7LujLE/8n9dcANOOP+dle4oss1iOzJ7LdrNeGY1hm5I=
X-Received: by 2002:a19:6105:: with SMTP id v5mr10253806lfb.202.1591060938398;
 Mon, 01 Jun 2020 18:22:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200601174037.904070960@linuxfoundation.org> <20200601174039.942780034@linuxfoundation.org>
In-Reply-To: <20200601174039.942780034@linuxfoundation.org>
From:   Bo YU <tsu.yubo@gmail.com>
Date:   Tue, 2 Jun 2020 09:20:43 +0800
Message-ID: <CAKq8=3LkCVQb9Jt6LF2m3OPEjr6EP8CxNL2jXdn0zWAH_g9NPg@mail.gmail.com>
Subject: Re: [PATCH 5.4 020/142] tipc: block BH before using dst_cache
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Xin Long <lucien.xin@gmail.com>,
        Jon Maloy <jon.maloy@ericsson.com>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 2, 2020 at 2:08 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> [ Upstream commit 1378817486d6860f6a927f573491afe65287abf1 ]
>
> dst_cache_get() documents it must be used with BH disabled.
>
> sysbot reported :

syzbot?

>
> BUG: using smp_processor_id() in preemptible [00000000] code: /21697
> caller is dst_cache_get+0x3a/0xb0 net/core/dst_cache.c:68
> CPU: 0 PID: 21697 Comm:  Not tainted 5.7.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x188/0x20d lib/dump_stack.c:118
>  check_preemption_disabled lib/smp_processor_id.c:47 [inline]
>  debug_smp_processor_id.cold+0x88/0x9b lib/smp_processor_id.c:57
>  dst_cache_get+0x3a/0xb0 net/core/dst_cache.c:68
>  tipc_udp_xmit.isra.0+0xb9/0xad0 net/tipc/udp_media.c:164
>  tipc_udp_send_msg+0x3e6/0x490 net/tipc/udp_media.c:244
>  tipc_bearer_xmit_skb+0x1de/0x3f0 net/tipc/bearer.c:526
>  tipc_enable_bearer+0xb2f/0xd60 net/tipc/bearer.c:331
>  __tipc_nl_bearer_enable+0x2bf/0x390 net/tipc/bearer.c:995
>  tipc_nl_bearer_enable+0x1e/0x30 net/tipc/bearer.c:1003
>  genl_family_rcv_msg_doit net/netlink/genetlink.c:673 [inline]
>  genl_family_rcv_msg net/netlink/genetlink.c:718 [inline]
>  genl_rcv_msg+0x627/0xdf0 net/netlink/genetlink.c:735
>  netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2469
>  genl_rcv+0x24/0x40 net/netlink/genetlink.c:746
>  netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
>  netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
>  netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
>  sock_sendmsg_nosec net/socket.c:652 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:672
>  ____sys_sendmsg+0x6bf/0x7e0 net/socket.c:2362
>  ___sys_sendmsg+0x100/0x170 net/socket.c:2416
>  __sys_sendmsg+0xec/0x1b0 net/socket.c:2449
>  do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
>  entry_SYSCALL_64_after_hwframe+0x49/0xb3
> RIP: 0033:0x45ca29
>
> Fixes: e9c1a793210f ("tipc: add dst_cache support for udp media")
> Cc: Xin Long <lucien.xin@gmail.com>
> Cc: Jon Maloy <jon.maloy@ericsson.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  net/tipc/udp_media.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> --- a/net/tipc/udp_media.c
> +++ b/net/tipc/udp_media.c
> @@ -161,9 +161,11 @@ static int tipc_udp_xmit(struct net *net
>                          struct udp_bearer *ub, struct udp_media_addr *src,
>                          struct udp_media_addr *dst, struct dst_cache *cache)
>  {
> -       struct dst_entry *ndst = dst_cache_get(cache);
> +       struct dst_entry *ndst;
>         int ttl, err = 0;
>
> +       local_bh_disable();
> +       ndst = dst_cache_get(cache);
>         if (dst->proto == htons(ETH_P_IP)) {
>                 struct rtable *rt = (struct rtable *)ndst;
>
> @@ -210,9 +212,11 @@ static int tipc_udp_xmit(struct net *net
>                                            src->port, dst->port, false);
>  #endif
>         }
> +       local_bh_enable();
>         return err;
>
>  tx_error:
> +       local_bh_enable();
>         kfree_skb(skb);
>         return err;
>  }
>
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller/20200601174039.942780034%40linuxfoundation.org.
