Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D35C4A97A8
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 11:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbiBDKYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 05:24:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36801 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343827AbiBDKYL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 05:24:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643970251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IMhpcKff10NK4E5NidIBF+4PwEYoDyPrVi1KRq92OTA=;
        b=YrRyoxgeN/7aGccIibidkAR4ONAV6itAydno2cCrtKPYKt0qpc9cYr/jNivGs+Xoz8rVOp
        5Y0T98Wo4b6vFtmvWHh66FSHaJKccGB0R48A3HLsKw6NDAXMMjLBd8BWMODHYtvnAoNDh1
        QUyW886XL65QXw5r9uYSHOz1JejAhEo=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-170-O4wRUn9RMompkmMMXo9zAg-1; Fri, 04 Feb 2022 05:24:10 -0500
X-MC-Unique: O4wRUn9RMompkmMMXo9zAg-1
Received: by mail-qk1-f197.google.com with SMTP id q5-20020ae9dc05000000b00507225deac5so3303172qkf.5
        for <stable@vger.kernel.org>; Fri, 04 Feb 2022 02:24:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=IMhpcKff10NK4E5NidIBF+4PwEYoDyPrVi1KRq92OTA=;
        b=z2P6l1YbTniFgxLEhyNsrUXbgVNPf4LNFOUsV7Nwkf95LpD+P5MIcm5Ln8Y6O/HU16
         kPTEZIQEtvw8B5iV874/p8+KygUzrQ8Sw/rvr1kx2Dw+7JSpF3QrpzcYfwZaaNlUXdMA
         Z6MzNH++0NP5T2FNWG00kCYCsWN6/07HbxQglWldZLLkHeJX+2GqTv6x1wF5/QfEOf2U
         X08LALhxxQNmo8ERenf7gV1TNNnpKA+K3fxIvrUL2V84ZK9RNlWaPyaGNu4cno0wbc4G
         xFW/4Z+kryXrebgWT3UjR+K/L85XV6wxRHQ9RwaAj6lTvd9tVVEhsnngNIdLTE3NKMlR
         cXTQ==
X-Gm-Message-State: AOAM531jTejWEu57e4FxRsc6+xWi6ymeIliF+VtikXXiilQlXc4lmGgs
        fGBcQeo24A7KTL0lgLjHU8doe54SCxyxmoejtPrUL88cfavyQIdu3CTlwvkwV9CtNHwyQduEtDX
        AevA4o7bzn/B8viWZ
X-Received: by 2002:a05:6214:27e9:: with SMTP id jt9mr1306674qvb.65.1643970249787;
        Fri, 04 Feb 2022 02:24:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyAtqMoIn6fBallR9B6BRc1B8yeT12HilgKV1BAD8ZmWpqaoX83jiwejQU6dcd2yFa0LUvO8A==
X-Received: by 2002:a05:6214:27e9:: with SMTP id jt9mr1306670qvb.65.1643970249596;
        Fri, 04 Feb 2022 02:24:09 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-96-254.dyn.eolo.it. [146.241.96.254])
        by smtp.gmail.com with ESMTPSA id i20sm915610qtx.44.2022.02.04.02.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 02:24:09 -0800 (PST)
Message-ID: <8303978268b465905ebfeac114577d96a26b6156.camel@redhat.com>
Subject: Re: [PATCH mptcp-stable] mptcp: fix msk traversal in
 mptcp_nl_cmd_set_flags()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        mptcp@lists.linux.dev
Cc:     stable@vger.kernel.org
Date:   Fri, 04 Feb 2022 11:24:06 +0100
In-Reply-To: <20220202004032.208848-1-mathew.j.martineau@linux.intel.com>
References: <20220202004032.208848-1-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2022-02-01 at 16:40 -0800, Mat Martineau wrote:
> commit 8e9eacad7ec7a9cbf262649ebf1fa6e6f6cc7d82 upstream.
> 
> The upstream commit had to handle a lookup_by_id variable that is only
> present in 5.17. This version of the patch removes that variable, so the
> __lookup_addr() function only handles the lookup as it is implemented in
> 5.15 and 5.16. It also removes one 'const' keyword to prevent a warning
> due to differing const-ness in the 5.17 version of addresses_equal().
> 
> The MPTCP endpoint list is under RCU protection, guarded by the
> pernet spinlock. mptcp_nl_cmd_set_flags() traverses the list
> without acquiring the spin-lock nor under the RCU critical section.
> 
> This change addresses the issue performing the lookup and the endpoint
> update under the pernet spinlock.
> 
> Fixes: 0f9f696a502e ("mptcp: add set_flags command in PM netlink")
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---
> 
> Paolo, can I add an ack or signoff tag from you?
> 
> The upstream commit (8e9eacad7ec7) was queued for the 5.16 and 5.15
> stable trees, which brought along a few extra patches that didn't belong
> in stable. I asked Greg to drop those patches from his queue, and this
> particular commit required manual changes as described above (related to
> the lookup_by_id variable that's new in 5.16).


The patches LGTM. Since you did all the good work, I think is better if
you preserve your SoB and just add:

Acked-by: Paolo Abeni <pabeni@redhat.com>

> 
> This patch will not apply to the export branch. I confirmed that it
> applies, builds, and runs on both the 5.16.5 and 5.15.19 branches. Self
> tests succeed too.
> 
> When I send to the stable list, I'll also include these tags:
> Cc: <stable@vger.kernel.org> # 5.15.x
> Cc: <stable@vger.kernel.org> # 5.16.x
> 
> 
> ---
>  net/mptcp/pm_netlink.c | 34 +++++++++++++++++++++++++---------
>  1 file changed, 25 insertions(+), 9 deletions(-)
> 
> diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
> index 65764c8171b3..5d305fafd0e9 100644
> --- a/net/mptcp/pm_netlink.c
> +++ b/net/mptcp/pm_netlink.c
> @@ -459,6 +459,18 @@ static unsigned int fill_remote_addresses_vec(struct mptcp_sock *msk, bool fullm
>  	return i;
>  }
>  
> +static struct mptcp_pm_addr_entry *
> +__lookup_addr(struct pm_nl_pernet *pernet, struct mptcp_addr_info *info)
> +{
> +	struct mptcp_pm_addr_entry *entry;
> +
> +	list_for_each_entry(entry, &pernet->local_addr_list, list) {
> +		if (addresses_equal(&entry->addr, info, true))
> +			return entry;
> +	}
> +	return NULL;
> +}
> +
>  static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
>  {
>  	struct sock *sk = (struct sock *)msk;
> @@ -1725,17 +1737,21 @@ static int mptcp_nl_cmd_set_flags(struct sk_buff *skb, struct genl_info *info)
>  	if (addr.flags & MPTCP_PM_ADDR_FLAG_BACKUP)
>  		bkup = 1;
>  
> -	list_for_each_entry(entry, &pernet->local_addr_list, list) {
> -		if (addresses_equal(&entry->addr, &addr.addr, true)) {
> -			mptcp_nl_addr_backup(net, &entry->addr, bkup);
> -
> -			if (bkup)
> -				entry->flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
> -			else
> -				entry->flags &= ~MPTCP_PM_ADDR_FLAG_BACKUP;
> -		}
> +	spin_lock_bh(&pernet->lock);
> +	entry = __lookup_addr(pernet, &addr.addr);
> +	if (!entry) {
> +		spin_unlock_bh(&pernet->lock);
> +		return -EINVAL;
>  	}
>  
> +	if (bkup)
> +		entry->flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
> +	else
> +		entry->flags &= ~MPTCP_PM_ADDR_FLAG_BACKUP;
> +	addr = *entry;
> +	spin_unlock_bh(&pernet->lock);
> +
> +	mptcp_nl_addr_backup(net, &addr.addr, bkup);
>  	return 0;
>  }
>  

