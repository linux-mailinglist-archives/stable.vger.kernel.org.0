Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E312A8352E
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 17:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729898AbfHFPZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 11:25:49 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:43209 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728156AbfHFPZt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 11:25:49 -0400
Received: by mail-yb1-f196.google.com with SMTP id y123so27723833yby.10
        for <stable@vger.kernel.org>; Tue, 06 Aug 2019 08:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QAOyPYCTFHaQlh2oW/BJkLl++1lrHY+xhWx1bCgsKh0=;
        b=nnbjtXtiZDj03cfYRcbxi3pxOio7LaJMtTJl/9k/WSHMtfEvncN/bLMYFcd766APxb
         sn3hYy6NCHx3EzLYm7xEPtPkwr+Pprkaf/9B91sXkVnGvWwUKHtrIUiE1WMFaQ38jTv4
         7cBT+8g8cO0grlj5lAEHr2ytFdGE3091nGC0qABy2M3YlMitWNk9mXEbWg1uG885gWaB
         WCl/vRfNvl5rdUVmeLmAGgXUqrI9sy7YCVxHCWE75UwnknWyGuhsfgzbmZYbfg9pKUMc
         BVnLjHF9j266EsMHAbFPlh9lMcVWDI1dhuCoJy65XCpYeqWq4ieUeEqyVEffIdb7r+2E
         XAYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QAOyPYCTFHaQlh2oW/BJkLl++1lrHY+xhWx1bCgsKh0=;
        b=fCpDdWcKv8rdniAMmpxcmvYAgiE6Du6dMLOiANpMULrK9aZG/E1pubtWvedC8TLrYe
         eCUNrSdWWEDE7rcIcQkZLzEsKJ1JgJ/8/Iq/BgF+s+cOOXalObffWpngnxw4NzxCTHMv
         2dDkEvvT7qV7fap7/tOplHExLQADAeySV0X0JZcWe3dNx7RjrskJBD3yrcxyf1mC3Z8C
         /fro8lNzJ94obkYTt6MBRYbx36MGo8upCmYobFOehSWs9IeJSE2Npa5cNkLKEkbZs03l
         kAoihddqO0qWCI6mL25LuEAltNq/MWW9/PkddGoR9TpWLc9zkWQtIRrHQKEThKQFt93x
         7ClA==
X-Gm-Message-State: APjAAAWzVis+QzO7FWHO9LaIKxQCo/YxAkClJZm3ENdfeuzKgkShZoYz
        ikpjZFguPNC2O8aFJFx2EAYVWsJPWL6lrskxflCttA==
X-Google-Smtp-Source: APXvYqxRiU0SYj4jZphgvRnpAvZ6jw8T4RYvQlt+0gkW0DWYJEdEfLVyaWzO/I2qwAUsVty35FB9EG2EV49MOaD4hos=
X-Received: by 2002:a25:9343:: with SMTP id g3mr3096718ybo.234.1565105147317;
 Tue, 06 Aug 2019 08:25:47 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89iKr7vYoLD_o-zhR72rQ8a4OQr=VW6oVRCYBDi1kmN6=dg@mail.gmail.com>
 <20190806150914.8797-1-matthieu.baerts@tessares.net>
In-Reply-To: <20190806150914.8797-1-matthieu.baerts@tessares.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 6 Aug 2019 17:25:35 +0200
Message-ID: <CANn89iL5au7KJQaw9JvMF9Q6-KqA3yMo-vrff33t7ozRZvyPvA@mail.gmail.com>
Subject: Re: [PATCH] tcp: be more careful in tcp_fragment()
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Prout <aprout@ll.mit.edu>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Jonathan Looney <jtl@netflix.com>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 6, 2019 at 5:09 PM Matthieu Baerts
<matthieu.baerts@tessares.net> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> commit b617158dc096709d8600c53b6052144d12b89fab upstream.
>
> Some applications set tiny SO_SNDBUF values and expect
> TCP to just work. Recent patches to address CVE-2019-11478
> broke them in case of losses, since retransmits might
> be prevented.
>
> We should allow these flows to make progress.
>
> This patch allows the first and last skb in retransmit queue
> to be split even if memory limits are hit.
>
> It also adds the some room due to the fact that tcp_sendmsg()
> and tcp_sendpage() might overshoot sk_wmem_queued by about one full
> TSO skb (64KB size). Note this allowance was already present
> in stable backports for kernels < 4.15
>
> Note for < 4.15 backports :
>  tcp_rtx_queue_tail() will probably look like :
>
> static inline struct sk_buff *tcp_rtx_queue_tail(const struct sock *sk)
> {
>         struct sk_buff *skb = tcp_send_head(sk);
>
>         return skb ? tcp_write_queue_prev(sk, skb) : tcp_write_queue_tail(sk);
> }
>
> Fixes: f070ef2ac667 ("tcp: tcp_fragment() should apply sane memory limits")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Andrew Prout <aprout@ll.mit.edu>
> Tested-by: Andrew Prout <aprout@ll.mit.edu>
> Tested-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> Tested-by: Michal Kubecek <mkubecek@suse.cz>
> Acked-by: Neal Cardwell <ncardwell@google.com>
> Acked-by: Yuchung Cheng <ycheng@google.com>
> Acked-by: Christoph Paasch <cpaasch@apple.com>
> Cc: Jonathan Looney <jtl@netflix.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> ---
>
> Notes:
>     Hello,
>
>     Here is the backport for linux-4.14.y branch simply by implementing
>     functions written by Eric here in the commit message and in this email
>     thread. It might be valid for older versions, I didn't check.
>
>     In my setup with MPTCP, I had the same bug other had where TCP flows
>     were stalled. The initial fix b6653b3629e5 (tcp: refine memory limit
>     test in tcp_fragment()) from Eric was helping but the backport in
>     < 4.15 was not looking safe: 1bc13903773b (tcp: refine memory limit
>     test in tcp_fragment()).
>
>     I then decided to test the new fix and it is working fine in my test
>     environment, no stalled TCP flows in a few hours.
>
>     In this email thread I see that Eric will push a patch for v4.14. I
>     absolutely do not want to add pressure or steal his work but because I
>     have the patch here and it is tested, I was thinking it could be a good
>     idea to share it with others. Feel free to ignore this patch if needed.
>     But if this patch can reduce a tiny bit Eric's workload, I would be
>     very glad if it helps :)
>     Because at the end, it is Eric's work, feel free to change my
>     "Signed-off-by" by "Tested-By" if it is how it work or nothing if you
>     prefer to wait for Eric's patch.

This patch is fine, I was simply on vacation last week, and wanted to
truly take full advantage of them ;)

Thanks !

>
>     Cheers,
>     Matt
>
>  include/net/tcp.h     | 17 +++++++++++++++++
>  net/ipv4/tcp_output.c | 11 ++++++++++-
>  2 files changed, 27 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 0b477a1e1177..7994e569644e 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -1688,6 +1688,23 @@ static inline void tcp_check_send_head(struct sock *sk, struct sk_buff *skb_unli
>                 tcp_sk(sk)->highest_sack = NULL;
>  }
>
> +static inline struct sk_buff *tcp_rtx_queue_head(const struct sock *sk)
> +{
> +       struct sk_buff *skb = tcp_write_queue_head(sk);
> +
> +       if (skb == tcp_send_head(sk))
> +               skb = NULL;
> +
> +       return skb;
> +}
> +
> +static inline struct sk_buff *tcp_rtx_queue_tail(const struct sock *sk)
> +{
> +       struct sk_buff *skb = tcp_send_head(sk);
> +
> +       return skb ? tcp_write_queue_prev(sk, skb) : tcp_write_queue_tail(sk);
> +}
> +
>  static inline void __tcp_add_write_queue_tail(struct sock *sk, struct sk_buff *skb)
>  {
>         __skb_queue_tail(&sk->sk_write_queue, skb);
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index a5960b9b6741..a99086bf26ea 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -1264,6 +1264,7 @@ int tcp_fragment(struct sock *sk, struct sk_buff *skb, u32 len,
>         struct tcp_sock *tp = tcp_sk(sk);
>         struct sk_buff *buff;
>         int nsize, old_factor;
> +       long limit;
>         int nlen;
>         u8 flags;
>
> @@ -1274,7 +1275,15 @@ int tcp_fragment(struct sock *sk, struct sk_buff *skb, u32 len,
>         if (nsize < 0)
>                 nsize = 0;
>
> -       if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf + 0x20000)) {
> +       /* tcp_sendmsg() can overshoot sk_wmem_queued by one full size skb.
> +        * We need some allowance to not penalize applications setting small
> +        * SO_SNDBUF values.
> +        * Also allow first and last skb in retransmit queue to be split.
> +        */
> +       limit = sk->sk_sndbuf + 2 * SKB_TRUESIZE(GSO_MAX_SIZE);
> +       if (unlikely((sk->sk_wmem_queued >> 1) > limit &&
> +                    skb != tcp_rtx_queue_head(sk) &&
> +                    skb != tcp_rtx_queue_tail(sk))) {
>                 NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPWQUEUETOOBIG);
>                 return -ENOMEM;
>         }
> --
> 2.20.1
>
