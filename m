Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F0A464A59
	for <lists+stable@lfdr.de>; Wed,  1 Dec 2021 10:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348145AbhLAJMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 04:12:30 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:56546 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348144AbhLAJM3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 04:12:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F3253CE1D7B
        for <stable@vger.kernel.org>; Wed,  1 Dec 2021 09:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02A5C53FCC;
        Wed,  1 Dec 2021 09:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638349746;
        bh=eHUGuCO30oLWhVMylcxVgfDfonDMnkjRpYXSmDMMWOc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BBSxiZ8hfssi6VtmgZ3xBg9dLEmcWvvOE5O9gj69LyZN/H9oIddgb6ISvSsg39pxe
         Bs0D1wLC6Kt7ro902b/lYJippikajhR/qcoyKst1cmZMo2p2kfu2C2uCCNqswEq7vz
         OwzTZyZVxAN5tZKbi7IYJGAH1E9Vz2AY/7cJqU9U=
Date:   Wed, 1 Dec 2021 10:09:03 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Manfred Spraul <manfred@colorfullife.com>
Cc:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Vasily Averin <vvs@virtuozzo.com>
Subject: Re: [PATCH] ipc: WARN if trying to remove ipc object which is absent
Message-ID: <Yac7rzJu4hVN2es3@kroah.com>
References: <16375837111940@kroah.com>
 <20211129194811.827410-1-alexander.mikhalitsyn@virtuozzo.com>
 <cb05fe18-f83c-7c84-eaca-3c3e69968b19@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cb05fe18-f83c-7c84-eaca-3c3e69968b19@colorfullife.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 30, 2021 at 10:00:07AM +0100, Manfred Spraul wrote:
> Hi,
> 
> On 11/29/21 20:48, Alexander Mikhalitsyn wrote:
> > For 4.14.y:
> > 
> > Upstream commit 126e8bee943e ("ipc: WARN if trying to remove ipc object which is absent")
> > 
> > Patch series "shm: shm_rmid_forced feature fixes".
> [...]
> > ---
> >   ipc/util.c | 6 +++---
> >   1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/ipc/util.c b/ipc/util.c
> > index 5a65b0cbae7d..198b4c1c3ad3 100644
> > --- a/ipc/util.c
> > +++ b/ipc/util.c
> > @@ -409,8 +409,8 @@ static int ipcget_public(struct ipc_namespace *ns, struct ipc_ids *ids,
> >   static void ipc_kht_remove(struct ipc_ids *ids, struct kern_ipc_perm *ipcp)
> >   {
> >   	if (ipcp->key != IPC_PRIVATE)
> > -		rhashtable_remove_fast(&ids->key_ht, &ipcp->khtnode,
> > -				       ipc_kht_params);
> > +		WARN_ON_ONCE(rhashtable_remove_fast(&ids->key_ht, &ipcp->khtnode,
> > +				       ipc_kht_params));
> >   }
> >   /**
> > @@ -425,7 +425,7 @@ void ipc_rmid(struct ipc_ids *ids, struct kern_ipc_perm *ipcp)
> >   {
> >   	int lid = ipcid_to_idx(ipcp->id);
> > -	idr_remove(&ids->ipcs_idr, lid);
> > +	WARN_ON_ONCE(idr_remove(&ids->ipcs_idr, lid) != ipcp);
> >   	ipc_kht_remove(ids, ipcp);
> >   	ids->in_use--;
> >   	ipcp->deleted = true;
> 
> Tested: With the patch applied, the warning is printed.
> 
> 
> --
> 
>     manfred
> 

Now queued up, thanks.

greg k-h
