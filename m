Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D6C1F14F0
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 11:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgFHJFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 05:05:21 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38445 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726038AbgFHJFU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jun 2020 05:05:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591607119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u02Yb6/7niV6uEp6j0FmqS3e9RiH0EM/My+7XTcVsNo=;
        b=Qh3hlB1zJXgEnlmbClElcRt8r4EnenFqiwe8U+bB2gMd78MmTQc4vSnOZs8d/G2LPt0t6P
        Jc0SMCoSXTbao7w0CyPNUZ4Q4eBKHw9WCGR8w37uOhZZ6RT9GITn/rXrQdMIMZ1KMH8buJ
        3Z6RXXJL+C5wLKh7uIF9ONkSbibBHBc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-KeJOM71xMIOKjFu64-jyxA-1; Mon, 08 Jun 2020 05:05:07 -0400
X-MC-Unique: KeJOM71xMIOKjFu64-jyxA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E489107ACCD;
        Mon,  8 Jun 2020 09:05:06 +0000 (UTC)
Received: from localhost (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A746F10013C1;
        Mon,  8 Jun 2020 09:05:04 +0000 (UTC)
Date:   Mon, 8 Jun 2020 11:05:00 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        kernel test robot <lkp@intel.com>, stable@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] nft_set_pipapo: Disable preemption before getting
 per-CPU pointer
Message-ID: <20200608110500.3cb1edc6@redhat.com>
In-Reply-To: <20200608085652.GP28263@breakpoint.cc>
References: <45861d795de2db1494b40bb2cc13bb36b4dacf72.1591606165.git.sbrivio@redhat.com>
        <20200608085652.GP28263@breakpoint.cc>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 8 Jun 2020 10:56:52 +0200
Florian Westphal <fw@strlen.de> wrote:

> Stefano Brivio <sbrivio@redhat.com> wrote:
> > The lkp kernel test robot reports, with CONFIG_DEBUG_PREEMPT enabled:  
> [..]
> 
> > diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> > index 8b5acc6910fd..8c04388296b0 100644
> > --- a/net/netfilter/nft_set_pipapo.c
> > +++ b/net/netfilter/nft_set_pipapo.c
> > @@ -1242,7 +1242,9 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
> >  		end += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
> >  	}
> >  
> > -	if (!*this_cpu_ptr(m->scratch) || bsize_max > m->bsize_max) {
> > +	if (!*get_cpu_ptr(m->scratch) || bsize_max > m->bsize_max) {
> > +		put_cpu_ptr(m->scratch);
> > +
> >  		err = pipapo_realloc_scratch(m, bsize_max);
> >  		if (err)
> >  			return err;
> > @@ -1250,6 +1252,8 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
> >  		this_cpu_write(nft_pipapo_scratch_index, false);  
> 
> Won't that mean that this_cpu_write() can occur on a different CPU than
> the get_cpu_ptr() ptr check was done on?

Yes, but that's okay, because get_cpu_ptr(m->scratch) can be done on
any CPU: it's just used as a flag to detect that scratch maps were
never allocated for this matching data.

The write to nft_pipapo_scratch_index is not needed: in this path we
always call pipapo_realloc_scratch() so we're supplying two fresh
scratch maps, we can start from either one for the next lookup
operation. But dropping it doesn't fix anything, so I'd do that in a
separate patch for nf-next.

-- 
Stefano

