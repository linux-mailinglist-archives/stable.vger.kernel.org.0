Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5617966AE
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 18:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbfHTQpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 12:45:44 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38192 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbfHTQpn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 12:45:43 -0400
Received: by mail-ed1-f65.google.com with SMTP id r12so7065364edo.5
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 09:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:cc:references:to:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YjpUxLIQIpAYSYvoLJK0Q0G1kjf8gU/xjpYiHc5Pi98=;
        b=de6NSWU1Qek+fqoFCcPTHtytSpgt3i9fYYepSEn3SFrvFf/YteXIVJg2qtDO/KrGM2
         Q+8Jk7envDeQIyK06Kpky5jvARvV1pRFkBkvrLZbVp0UNEp+dN0UTNK06RU/z/MOof1m
         mTxBOblf+bxpFWdbgfXndbg3iyxK/a4G2+bzLq5LPpCvzr221gdH/ZzSAkoaqAWuI3x4
         N4Jhp3TTPqQNMVhclDQD9aGpIOPOY4EzcP7a7RskgSggVNRKYoskVDdTl4tVfDzQbitn
         djW5PGBKV4XQTHBg4ejr/Os+PIK0f/mobzEkYcU6JcPonJOCEjqbphOf1FBT7Xw8wpcB
         UbsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:cc:references:to:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=YjpUxLIQIpAYSYvoLJK0Q0G1kjf8gU/xjpYiHc5Pi98=;
        b=eO/omODs95HWKXbzlMC2IY0mQaOXtqYnxCoSQFrIyQmjD+d995a03iECg1mi6P1WFc
         SDutAGvT1H9FKn7k0a3+4WpLcvxg66kzNoacRL2ypB7B/7v1FvON6a+0llvzzhzBQeCW
         w8jruJmbRihlgfJshr5sD90X5zjYCXbKd4Tqu/X/q/uqBDozBR630UGDPaq4Epdqx/cX
         y/2ml+F54BeOybjV2Qo1R9BWtjwpntDqZx5nK44JsNtcVS63zyk0bc8HJWZKa4zgoNGB
         q9BcSHzOBffXgrLA7rHKcZONQQbyjpCwafPBt5mwcr/d5lyHSh4kYNx7ESMI5pyq+o+C
         0XUA==
X-Gm-Message-State: APjAAAWzs+mj8Ju/lObVSx442iE0uVI7naYPhHFxs1XpQxBTVSx2Rl4I
        U6fPyXS0MxECeQW5xJQ31QIzqg==
X-Google-Smtp-Source: APXvYqwLAe3qWjZnH3iB4uhjNPLrVGxKN4wQN35oFw08szQCeYwyN/zoglSRkQZGCjnuUp5I7dGTOw==
X-Received: by 2002:a17:906:191b:: with SMTP id a27mr27221012eje.84.1566319540535;
        Tue, 20 Aug 2019 09:45:40 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net (hag0-main.tessares.net. [87.98.252.165])
        by smtp.gmail.com with ESMTPSA id v15sm2004000ejh.15.2019.08.20.09.45.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 09:45:39 -0700 (PDT)
Subject: Re: [PATCH 4.14 04/33] tcp: be more careful in tcp_fragment()
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andrew Prout <aprout@ll.mit.edu>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Jonathan Looney <jtl@netflix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Tim Froidcoeur <tim.froidcoeur@tessares.net>
References: <20190808190453.582417307@linuxfoundation.org>
 <20190808190453.790722103@linuxfoundation.org>
To:     Eric Dumazet <edumazet@google.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Openpgp: preference=signencrypt
Autocrypt: addr=matthieu.baerts@tessares.net; keydata=
 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
 fQpO7wDE/Q==
Message-ID: <529376a4-cf63-f225-ce7c-4747e9966938@tessares.net>
Date:   Tue, 20 Aug 2019 18:45:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190808190453.790722103@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Eric,

On 08/08/2019 21:05, Greg Kroah-Hartman wrote:
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
> 	struct sk_buff *skb = tcp_send_head(sk);
> 
> 	return skb ? tcp_write_queue_prev(sk, skb) : tcp_write_queue_tail(sk);
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
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  include/net/tcp.h     | 17 +++++++++++++++++
>  net/ipv4/tcp_output.c | 11 ++++++++++-
>  2 files changed, 27 insertions(+), 1 deletion(-)

I am sorry to bother you again with the recent modifications in
tcp_fragment() but it seems we have a new kernel BUG with this patch in
v4.14.

Here is the call trace.


[26665.934461] ------------[ cut here ]------------
[26665.936152] kernel BUG at ./include/linux/skbuff.h:1406!
[26665.937941] invalid opcode: 0000 [#1] SMP PTI
[26665.977252] Call Trace:
[26665.978267]  <IRQ>
[26665.979163]  tcp_fragment+0x9c/0x2cf
[26665.980562]  tcp_write_xmit+0x68f/0x988
[26665.982031]  __tcp_push_pending_frames+0x3b/0xa0
[26665.983684]  tcp_data_snd_check+0x2a/0xc8
[26665.985196]  tcp_rcv_established+0x2a8/0x30d
[26665.986736]  tcp_v4_do_rcv+0xb2/0x158
[26665.988140]  tcp_v4_rcv+0x692/0x956
[26665.989533]  ip_local_deliver_finish+0xeb/0x169
[26665.991250]  __netif_receive_skb_core+0x51c/0x582
[26665.993028]  ? inet_gro_receive+0x239/0x247
[26665.994581]  netif_receive_skb_internal+0xab/0xc6
[26665.996340]  napi_gro_receive+0x8a/0xc0
[26665.997790]  receive_buf+0x9a1/0x9cd
[26665.999232]  ? load_balance+0x17a/0x7b7
[26666.000711]  ? vring_unmap_one+0x18/0x61
[26666.002196]  ? detach_buf+0x60/0xfa
[26666.003526]  virtnet_poll+0x128/0x1e1
[26666.004860]  net_rx_action+0x12a/0x2b1
[26666.006309]  __do_softirq+0x11c/0x26b
[26666.007734]  ? handle_irq_event+0x44/0x56
[26666.009275]  irq_exit+0x61/0xa0
[26666.010511]  do_IRQ+0x9d/0xbb
[26666.011685]  common_interrupt+0x85/0x85


We are doing the tests with the MPTCP stack[1], the error might come
from there but the call trace is free of MPTCP functions. We are still
working on having a reproducible setup with MPTCP before doing the same
without MPTCP but please see below the analysis we did so far with some
questions.

[1] https://github.com/multipath-tcp/mptcp/tree/mptcp_v0.94

> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 0b477a1e11770..7994e569644e0 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -1688,6 +1688,23 @@ static inline void tcp_check_send_head(struct sock *sk, struct sk_buff *skb_unli
>  		tcp_sk(sk)->highest_sack = NULL;
>  }
>  
> +static inline struct sk_buff *tcp_rtx_queue_head(const struct sock *sk)
> +{
> +	struct sk_buff *skb = tcp_write_queue_head(sk);
> +
> +	if (skb == tcp_send_head(sk))
> +		skb = NULL;
> +
> +	return skb;
> +}
> +
> +static inline struct sk_buff *tcp_rtx_queue_tail(const struct sock *sk)
> +{
> +	struct sk_buff *skb = tcp_send_head(sk);
> +
> +	return skb ? tcp_write_queue_prev(sk, skb) : tcp_write_queue_tail(sk);
> +}
> +
>  static inline void __tcp_add_write_queue_tail(struct sock *sk, struct sk_buff *skb)
>  {
>  	__skb_queue_tail(&sk->sk_write_queue, skb);
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index a5960b9b6741c..a99086bf26eaf 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -1264,6 +1264,7 @@ int tcp_fragment(struct sock *sk, struct sk_buff *skb, u32 len,
>  	struct tcp_sock *tp = tcp_sk(sk);
>  	struct sk_buff *buff;
>  	int nsize, old_factor;
> +	long limit;
>  	int nlen;
>  	u8 flags;
>  
> @@ -1274,7 +1275,15 @@ int tcp_fragment(struct sock *sk, struct sk_buff *skb, u32 len,
>  	if (nsize < 0)
>  		nsize = 0;
>  
> -	if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf + 0x20000)) {
> +	/* tcp_sendmsg() can overshoot sk_wmem_queued by one full size skb.
> +	 * We need some allowance to not penalize applications setting small
> +	 * SO_SNDBUF values.
> +	 * Also allow first and last skb in retransmit queue to be split.
> +	 */
> +	limit = sk->sk_sndbuf + 2 * SKB_TRUESIZE(GSO_MAX_SIZE);
> +	if (unlikely((sk->sk_wmem_queued >> 1) > limit &&
> +		     skb != tcp_rtx_queue_head(sk) &&

If the skb returned by tcp_rtx_queue_head() is null -- because skb ==
tcp_send_head(sk), please see above -- should we not do something else
than going to the next condition?

> +		     skb != tcp_rtx_queue_tail(sk))) {

It seems that behind, tcp_write_queue_prev() can be called -- please see
above -- which will directly called skb_queue_prev() which does this:

	/* This BUG_ON may seem severe, but if we just return then we
	 * are going to dereference garbage.
	 */
	BUG_ON(skb_queue_is_first(list, skb));
	return skb->prev;

Should we do the same check before to avoid the BUG_ON()?

Could it be normal to hit this BUG_ON() with regular TCP or is it due to
other changes in MPTCP stack? We hope not having bothered you for
something not in the upstream kernel (yet) :)

Cheers,
Matt

>  		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPWQUEUETOOBIG);
>  		return -ENOMEM;
>  	}
> 

-- 
Matthieu Baerts | R&D Engineer
matthieu.baerts@tessares.net
Tessares SA | Hybrid Access Solutions
www.tessares.net
1 Avenue Jean Monnet, 1348 Louvain-la-Neuve, Belgium
