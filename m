Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434222059E7
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 19:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387730AbgFWRos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 13:44:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733128AbgFWRor (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 13:44:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41C8F20781;
        Tue, 23 Jun 2020 17:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592934286;
        bh=JC1anIg52iQ91nUX1Wg98PfJNloEzw3qVno1XsNiYWw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YZWrI/QitWzGnGPSnQLXIqts5kkAGXsuaNjAxawvXLMzL9ZfUGvzeBLdoe9YGcX2g
         Vrlyda2Qka/ozFLaZEFFjNBFenUhiP52Ff+cZmzI+A2sWsL3NNZXdrofLhTKUliTSs
         wcGV1j22wIorEAoqgr8Gfwq8OZaa4yWylrevSKaM=
Date:   Tue, 23 Jun 2020 19:44:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.4] net: Revert "pkt_sched: fq: use proper locking in
 fq_dump_stats()"
Message-ID: <20200623174446.GA17865@kroah.com>
References: <20200623150053.272985-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200623150053.272985-1-toke@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 23, 2020 at 05:00:53PM +0200, Toke Høiland-Jørgensen wrote:
> This reverts commit 191cf872190de28a92e1bd2b56d8860e37e07443.
> 
> That commit should never have been backported since it relies on a change in
> locking semantics that was introduced in v4.8 and not backported. Because of
> this, the backported commit to sch_fq leads to lockups because of the double
> locking.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  net/sched/sch_fq.c | 32 ++++++++++++++------------------
>  1 file changed, 14 insertions(+), 18 deletions(-)
> 
> diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
> index f4aa2ab4713a..eb814ffc0902 100644
> --- a/net/sched/sch_fq.c
> +++ b/net/sched/sch_fq.c
> @@ -830,24 +830,20 @@ nla_put_failure:
>  static int fq_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
>  {
>  	struct fq_sched_data *q = qdisc_priv(sch);
> -	struct tc_fq_qd_stats st;
> -
> -	sch_tree_lock(sch);
> -
> -	st.gc_flows		  = q->stat_gc_flows;
> -	st.highprio_packets	  = q->stat_internal_packets;
> -	st.tcp_retrans		  = q->stat_tcp_retrans;
> -	st.throttled		  = q->stat_throttled;
> -	st.flows_plimit		  = q->stat_flows_plimit;
> -	st.pkts_too_long	  = q->stat_pkts_too_long;
> -	st.allocation_errors	  = q->stat_allocation_errors;
> -	st.time_next_delayed_flow = q->time_next_delayed_flow - ktime_get_ns();
> -	st.flows		  = q->flows;
> -	st.inactive_flows	  = q->inactive_flows;
> -	st.throttled_flows	  = q->throttled_flows;
> -	st.pad			  = 0;
> -
> -	sch_tree_unlock(sch);
> +	u64 now = ktime_get_ns();
> +	struct tc_fq_qd_stats st = {
> +		.gc_flows		= q->stat_gc_flows,
> +		.highprio_packets	= q->stat_internal_packets,
> +		.tcp_retrans		= q->stat_tcp_retrans,
> +		.throttled		= q->stat_throttled,
> +		.flows_plimit		= q->stat_flows_plimit,
> +		.pkts_too_long		= q->stat_pkts_too_long,
> +		.allocation_errors	= q->stat_allocation_errors,
> +		.flows			= q->flows,
> +		.inactive_flows		= q->inactive_flows,
> +		.throttled_flows	= q->throttled_flows,
> +		.time_next_delayed_flow	= q->time_next_delayed_flow - now,
> +	};
>  
>  	return gnet_stats_copy_app(d, &st, sizeof(st));
>  }
> -- 
> 2.27.0
> 

Thanks, now applied.

greg k-h
