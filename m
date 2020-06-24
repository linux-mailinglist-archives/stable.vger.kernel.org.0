Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4697D2072F8
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 14:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390264AbgFXMMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 08:12:37 -0400
Received: from correo.us.es ([193.147.175.20]:46892 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389376AbgFXMMg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jun 2020 08:12:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0DA3818CDC5
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 14:12:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F23D1DA78D
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 14:12:34 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E76BFDA789; Wed, 24 Jun 2020 14:12:34 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B1ED0DA78F;
        Wed, 24 Jun 2020 14:12:32 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 24 Jun 2020 14:12:32 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 936FA42EF42B;
        Wed, 24 Jun 2020 14:12:32 +0200 (CEST)
Date:   Wed, 24 Jun 2020 14:12:32 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH v4.10] netfilter: nf_conntrack_h323: lost .data_len
 definition for Q.931/ipv6
Message-ID: <20200624121232.GA28150@salvia>
References: <c2385b5c-309c-cc64-2e10-a0ef62897502@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2385b5c-309c-cc64-2e10-a0ef62897502@virtuozzo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CC'ing stable@vger.kernel.org

On Tue, Jun 09, 2020 at 10:53:22AM +0300, Vasily Averin wrote:
> Could you please push this patch into stable@?
> it fixes memory corruption in kernels  v3.5 .. v4.10
> 
> Lost .data_len definition leads to write beyond end of
> struct nf_ct_h323_master. Usually it corrupts following
> struct nf_conn_nat, however if nat is not loaded it corrupts
> following slab object.
> 
> In mainline this problem went away in v4.11,
> after commit 9f0f3ebeda47 ("netfilter: helpers: remove data_len usage
> for inkernel helpers") however many stable kernels are still affected.

-stable maintainers of: 3.16, 4.4 and 4.9.

Please apply this patch, thanks.

> cc: stable@vger.kernel.org
> Fixes: 1afc56794e03 ("netfilter: nf_ct_helper: implement variable length helper private data") # v3.5
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> ---
>  net/netfilter/nf_conntrack_h323_main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
> index f65d93639d12..29fe1e7eac88 100644
> --- a/net/netfilter/nf_conntrack_h323_main.c
> +++ b/net/netfilter/nf_conntrack_h323_main.c
> @@ -1225,6 +1225,7 @@ static struct nf_conntrack_helper nf_conntrack_helper_q931[] __read_mostly = {
>  	{
>  		.name			= "Q.931",
>  		.me			= THIS_MODULE,
> +		.data_len		= sizeof(struct nf_ct_h323_master),
>  		.tuple.src.l3num	= AF_INET6,
>  		.tuple.src.u.tcp.port	= cpu_to_be16(Q931_PORT),
>  		.tuple.dst.protonum	= IPPROTO_TCP,
> -- 
> 2.17.1
> 
