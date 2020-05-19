Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493101D989B
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 15:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbgESNxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 09:53:22 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51234 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727086AbgESNxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 09:53:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589896401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z3JDC7hHAG3qt8ihx4nUX9Oy4XZ2I9b3feKVYfmOZwY=;
        b=V+ApZdPmMPK9DxGtzP8YEtIfkwUnqRUyPZynoLfyXlPHBFDf9GRp6YOQwRIG4YQ7qynaRx
        RH/ltig7lf8tNr1yf0RcC1qV0e0NQRxNF6Z/KHNsBoDe+06USznbkb3cjMvpDrv0s7SOrk
        teKKr60fNYld5I0QBoRJTaQLD9vu6nU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-BIX5Nvf_MP2OJJmsKvkikA-1; Tue, 19 May 2020 09:53:17 -0400
X-MC-Unique: BIX5Nvf_MP2OJJmsKvkikA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F9AF107ACF8;
        Tue, 19 May 2020 13:53:15 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.31])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 57FC71001B07;
        Tue, 19 May 2020 13:53:10 +0000 (UTC)
Date:   Tue, 19 May 2020 15:53:00 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH 4.19 41/80] netfilter: nft_set_rbtree: Introduce and use
 nft_rbtree_interval_start()
Message-ID: <20200519155300.3560394f@elisabeth>
In-Reply-To: <20200519125113.GA376546@kroah.com>
References: <20200518173450.097837707@linuxfoundation.org>
        <20200518173458.612903024@linuxfoundation.org>
        <20200519120625.GA8342@amd>
        <20200519121356.GA354164@kroah.com>
        <20200519121907.GA9158@amd>
        <20200519125113.GA376546@kroah.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 19 May 2020 14:51:13 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Tue, May 19, 2020 at 02:19:07PM +0200, Pavel Machek wrote:
> > On Tue 2020-05-19 14:13:56, Greg Kroah-Hartman wrote: =20
> > > On Tue, May 19, 2020 at 02:06:25PM +0200, Pavel Machek wrote: =20
> > > > Hi!
> > > >  =20
> > > > > [ Upstream commit 6f7c9caf017be8ab0fe3b99509580d0793bf0833 ]
> > > > >=20
> > > > > Replace negations of nft_rbtree_interval_end() with a new helper,
> > > > > nft_rbtree_interval_start(), wherever this helps to visualise the
> > > > > problem at hand, that is, for all the occurrences except for the
> > > > > comparison against given flags in __nft_rbtree_get().
> > > > >=20
> > > > > This gets especially useful in the next patch. =20
> > > >=20
> > > > This looks like cleanup in preparation for the next patch. Next pat=
ch
> > > > is there for some series, but not for 4.19.124. Should this be in
> > > > 4.19, then? =20
> > >=20
> > > What is the "next patch" in this situation? =20
> >=20
> > In 5.4 you have:
> >=20
> > 9956 O   Greg Kroah =E2=94=9C=E2=94=80>[PATCH 5.4 082/147] netfilter: n=
ft_set_rbtree: Introduce and use nft
> > 9957     Greg Kroah =E2=94=9C=E2=94=80>[PATCH 5.4 083/147] netfilter: n=
ft_set_rbtree: Add missing expired c
> >=20
> > In 4.19 you have:
> >=20
> > 10373 r   Greg Kroah =E2=94=9C=E2=94=80>[PATCH 4.19 41/80] netfilter: n=
ft_set_rbtree: Introduce and use nft
> > 10376 O   Greg Kroah =E2=94=9C=E2=94=80>[PATCH 4.19 42/80] IB/mlx4: Tes=
t return value of calls to ib_get_ca
> >=20
> > I believe 41/80 can be dropped from 4.19 series, as it is just a
> > preparation for 083/147... which is not queued for 4.19. =20
>=20
> I've queued it up for 4.19 now, thanks.

Wait, wait, sorry. I thought you were queuing this up as a missing
dependency or something, but I see it's not the case. That patch is
*not* the preparation for:

  340eaff65116 netfilter: nft_set_rbtree: Add missing expired checks

...but rather preparation for:

  7c84d41416d8 netfilter: nft_set_rbtree: Detect partial overlaps on insert=
ion

whose fix-up:

  72239f2795fa netfilter: nft_set_rbtree: Drop spurious condition for overl=
ap detection on insertion

was queued for 5.6.x (see <20200421131431.GA793882@kroah.com>).

Now, if you want to backport "Add missing expired checks", it *might* be
more convenient to also backport:

  6f7c9caf017b netfilter: nft_set_rbtree: Introduce and use nft_rbtree_inte=
rval_start()

and, perhaps (I haven't tried to actually cherry-pick) also:

  7c84d41416d8 netfilter: nft_set_rbtree: Detect partial overlaps on insert=
ion
  72239f2795fa netfilter: nft_set_rbtree: Drop spurious condition for overl=
ap detection on insertion

and it's safe to either:

- backport only 6f7c9caf017b
- backport the three of them

but other than avoiding conflicts, there should be no reason to do that.
Sasha had already queued them up for 4.19 and 5.4, then dropped them as
they weren't needed, see <20200413163900.GO27528@sasha-vm>.

--=20
Stefano

