Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14676811F3
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237492AbjA3ORc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237493AbjA3ORC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:17:02 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B8DFA3C2AE
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:16:54 -0800 (PST)
Date:   Mon, 30 Jan 2023 15:16:51 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Florian Westphal <fw@strlen.de>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 274/313] netfilter: conntrack: fix bug in
 for_each_sctp_chunk
Message-ID: <Y9fRU/vV0oCYv7+u@salvia>
References: <20230130134336.532886729@linuxfoundation.org>
 <20230130134349.500119625@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230130134349.500119625@linuxfoundation.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Jan 30, 2023 at 02:51:49PM +0100, Greg Kroah-Hartman wrote:
> From: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
> 
> [ Upstream commit 98ee0077452527f971567db01386de3c3d97ce13 ]
> 
> skb_header_pointer() will return NULL if offset + sizeof(_sch) exceeds
> skb->len, so this offset < skb->len test is redundant.
> 
> if sch->length == 0, this will end up in an infinite loop, add a check
> for sch->length > 0

Please, keep back this patch. for_each_sctp_chunk() is fine because
do_basic_checks() already make sure what sch->length is sane.

A revert is scheduled for the net.git tree, the revert should show up
in the next 6.2-rc release.

Sorry for the inconvenience.

> Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
> Suggested-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  net/netfilter/nf_conntrack_proto_sctp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
> index 3704d1c7d3c2..ee317f9a22e5 100644
> --- a/net/netfilter/nf_conntrack_proto_sctp.c
> +++ b/net/netfilter/nf_conntrack_proto_sctp.c
> @@ -155,8 +155,8 @@ static void sctp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
>  
>  #define for_each_sctp_chunk(skb, sch, _sch, offset, dataoff, count)	\
>  for ((offset) = (dataoff) + sizeof(struct sctphdr), (count) = 0;	\
> -	(offset) < (skb)->len &&					\
> -	((sch) = skb_header_pointer((skb), (offset), sizeof(_sch), &(_sch)));	\
> +	((sch) = skb_header_pointer((skb), (offset), sizeof(_sch), &(_sch))) &&	\
> +	(sch)->length;	\
>  	(offset) += (ntohs((sch)->length) + 3) & ~3, (count)++)
>  
>  /* Some validity checks to make sure the chunks are fine */
> -- 
> 2.39.0
> 
> 
> 
