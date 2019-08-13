Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40EBE8C0A8
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 20:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbfHMSdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 14:33:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726195AbfHMSdw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 14:33:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B370920842;
        Tue, 13 Aug 2019 18:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565721231;
        bh=+4of0sjSp0CXWtFOwyeK8NyF6Pvef8MvVQUdLDhj53k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UkRsel32ivfDyZOxOXeSF+EMMv2zdC0Uq7oM9dHkgvjfcX2qCGKEkTMnv0bnyVlK8
         8Oqp/4dacLr50dWl5hywANGXxnnR7PnpyacVyBYPJT2GdFdQvg12R4LAcgcmEiulaV
         CRPcFWj17S7gIIfuifWFbxOgJF2ueOFqUHpi+xvE=
Date:   Tue, 13 Aug 2019 20:33:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Denis Andzakovic <denis.andzakovic@pulsesecurity.co.nz>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH 3.16-4.14] tcp: Clear sk_send_head after purging the
 write queue
Message-ID: <20190813183348.GB6582@kroah.com>
References: <20190813115317.6cgml2mckd3c6u7z@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813115317.6cgml2mckd3c6u7z@decadent.org.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 13, 2019 at 12:53:17PM +0100, Ben Hutchings wrote:
> Denis Andzakovic discovered a potential use-after-free in older kernel
> versions, using syzkaller.  tcp_write_queue_purge() frees all skbs in
> the TCP write queue and can leave sk->sk_send_head pointing to freed
> memory.  tcp_disconnect() clears that pointer after calling
> tcp_write_queue_purge(), but tcp_connect() does not.  It is
> (surprisingly) possible to add to the write queue between
> disconnection and reconnection, so this needs to be done in both
> places.
> 
> This bug was introduced by backports of commit 7f582b248d0a ("tcp:
> purge write queue in tcp_connect_init()") and does not exist upstream
> because of earlier changes in commit 75c119afe14f ("tcp: implement
> rb-tree based retransmit queue").  The latter is a major change that's
> not suitable for stable.
> 
> Reported-by: Denis Andzakovic <denis.andzakovic@pulsesecurity.co.nz>
> Bisected-by: Salvatore Bonaccorso <carnil@debian.org>
> Fixes: 7f582b248d0a ("tcp: purge write queue in tcp_connect_init()")
> Cc: <stable@vger.kernel.org> # before 4.15
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  include/net/tcp.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index fed2a78fb8cb..f9b985d4d779 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -1517,6 +1517,8 @@ struct tcp_fastopen_context {
>  	struct rcu_head		rcu;
>  };
>  
> +static inline void tcp_init_send_head(struct sock *sk);
> +
>  /* write queue abstraction */
>  static inline void tcp_write_queue_purge(struct sock *sk)
>  {
> @@ -1524,6 +1526,7 @@ static inline void tcp_write_queue_purge(struct sock *sk)
>  
>  	while ((skb = __skb_dequeue(&sk->sk_write_queue)) != NULL)
>  		sk_wmem_free_skb(sk, skb);
> +	tcp_init_send_head(sk);
>  	sk_mem_reclaim(sk);
>  	tcp_clear_all_retrans_hints(tcp_sk(sk));
>  	inet_csk(sk)->icsk_backoff = 0;


Nice catch, thanks for this.  Now queued up everywhere.

greg k-h
