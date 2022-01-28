Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B8649F887
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 12:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237378AbiA1LoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 06:44:03 -0500
Received: from mail.netfilter.org ([217.70.188.207]:49304 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244357AbiA1LoD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 06:44:03 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4AAF760676;
        Fri, 28 Jan 2022 12:40:57 +0100 (CET)
Date:   Fri, 28 Jan 2022 12:43:57 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Steffen Weinreich <steve@weinreich.org>
Subject: Re: [PATCH 4.19.y] netfilter: nft_payload: do not update layer 4
 checksum when mangling fragments
Message-ID: <YfPW/Y+MjU79d7V7@salvia>
References: <20220128113821.7009-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220128113821.7009-1-fw@strlen.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 28, 2022 at 12:38:21PM +0100, Florian Westphal wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> commit 4e1860a3863707e8177329c006d10f9e37e097a8 upstream.
> 
> IP fragments do not come with the transport header, hence skip bogus
> layer 4 checksum updates.
> 
> Fixes: 1814096980bb ("netfilter: nft_payload: layer 4 checksum adjustment for pseudoheader fields")
> Reported-and-tested-by: Steffen Weinreich <steve@weinreich.org>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  This is already in the 5.y branches but 4.19 needs a minor
>  tweak as ->fragoff member resides in xt sub-struct.

Thanks for taking care of this -stable submission.

>  net/netfilter/nft_payload.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
> index b1a9f330a51f..fd87216bc0a9 100644
> --- a/net/netfilter/nft_payload.c
> +++ b/net/netfilter/nft_payload.c
> @@ -194,6 +194,9 @@ static int nft_payload_l4csum_offset(const struct nft_pktinfo *pkt,
>  				     struct sk_buff *skb,
>  				     unsigned int *l4csum_offset)
>  {
> +	if (pkt->xt.fragoff)
> +		return -1;
> +
>  	switch (pkt->tprot) {
>  	case IPPROTO_TCP:
>  		*l4csum_offset = offsetof(struct tcphdr, check);
> -- 
> 2.34.1
> 
