Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCF5199343
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 12:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730235AbgCaKQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 06:16:08 -0400
Received: from correo.us.es ([193.147.175.20]:33632 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730053AbgCaKQI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 06:16:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 08D29DA3DE
        for <stable@vger.kernel.org>; Tue, 31 Mar 2020 12:16:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EF989100A60
        for <stable@vger.kernel.org>; Tue, 31 Mar 2020 12:16:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E4892100A45; Tue, 31 Mar 2020 12:16:05 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E261C100A47;
        Tue, 31 Mar 2020 12:16:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 31 Mar 2020 12:16:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id BE18342EF4E0;
        Tue, 31 Mar 2020 12:16:03 +0200 (CEST)
Date:   Tue, 31 Mar 2020 12:16:03 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 5.5 138/170] netfilter: nft_fwd_netdev: allow to redirect
 to ifb via ingress
Message-ID: <20200331101603.wmsbhgmjc6vf4esk@salvia>
References: <20200331085423.990189598@linuxfoundation.org>
 <20200331085438.148415210@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200331085438.148415210@linuxfoundation.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 31, 2020 at 10:59:12AM +0200, Greg Kroah-Hartman wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> commit bcfabee1afd99484b6ba067361b8678e28bbc065 upstream.
> 
> Set skb->tc_redirected to 1, otherwise the ifb driver drops the packet.
> Set skb->tc_from_ingress to 1 to reinject the packet back to the ingress
> path after leaving the ifb egress path.
> 
> This patch inconditionally sets on these two skb fields that are
> meaningful to the ifb driver. The existing forward action is guaranteed
> to run from ingress path.
> 
> Fixes: 39e6dea28adc ("netfilter: nf_tables: add forward expression to the netdev family")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  net/netfilter/nft_fwd_netdev.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> --- a/net/netfilter/nft_fwd_netdev.c
> +++ b/net/netfilter/nft_fwd_netdev.c
> @@ -28,6 +28,10 @@ static void nft_fwd_netdev_eval(const st
>  	struct nft_fwd_netdev *priv = nft_expr_priv(expr);
>  	int oif = regs->data[priv->sreg_dev];
>  
> +	/* These are used by ifb only. */
> +	pkt->skb->tc_redirected = 1;
> +	pkt->skb->tc_from_ingress = 1;

This patch also requires:

2c64605b590e net: Fix CONFIG_NET_CLS_ACT=n and CONFIG_NFT_FWD_NETDEV={y, m} build

Otherwise build breaks with CONFIG_NET_CLS_ACT=n.

Thanks.
