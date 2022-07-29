Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8215855DD
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 22:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbiG2UEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 16:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiG2UEY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 16:04:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7016D3B965;
        Fri, 29 Jul 2022 13:04:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18751B827B5;
        Fri, 29 Jul 2022 20:04:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8D3C433C1;
        Fri, 29 Jul 2022 20:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659125060;
        bh=CZrmFQE485FNk30AR4rcGGChtR1M+6GsIccKAXdh1RU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Q+EvfT+GvfujAEihhqTDOIGmmeFDYI/o/7meOjZC7KoCQSYwJ59g2M/ZR7Iw0b//i
         49fnyF+o6Q4uo04Pn1rVWNAAB7yZVAuQ+IEbqjp8It+Fpx/60kaY6UNlc9lajOOURM
         fGRAKPPMRqJbJMd4skXipSWbEx/Dv6bicojjoC+u/DaG9u/wZmbKNavzesLwcAdtmK
         n7ACqljgDZ3t9LZITmtJoCaULO6QqWMBZhcFpvfBvN/RX57q9UV1U0kmWQmGGValpV
         NJyLwn5x+1QpjSQh/JgURU+tnTPnpjPZmfBbkMuMdqZZXGfDNrOHRTHKREGpzBMny+
         ljAvQc0yKEEnw==
Message-ID: <4a6ca0b71a7de10718820b4d00d37829dbeecbdd.camel@kernel.org>
Subject: Re: [PATCH v2] nfsd: eliminate the NFSD_FILE_BREAK_* flags
From:   Jeff Layton <jlayton@kernel.org>
To:     chuck.lever@oracle.com
Cc:     linux-nfs@vger.kernel.org, Olga Kornieskaia <kolga@netapp.com>,
        stable@vger.kernel.org
Date:   Fri, 29 Jul 2022 16:04:18 -0400
In-Reply-To: <20220729195218.284339-1-jlayton@kernel.org>
References: <20220729195218.284339-1-jlayton@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2022-07-29 at 15:52 -0400, Jeff Layton wrote:
> We had a report from the spring Bake-a-thon of data corruption in some
> nfstest_interop tests. Looking at the traces showed the NFS server
> allowing a v3 WRITE to proceed while a read delegation was still
> outstanding.
>=20
> Currently, we only set NFSD_FILE_BREAK_* flags if
> NFSD_MAY_NOT_BREAK_LEASE was set when we call nfsd_file_alloc.
> NFSD_MAY_NOT_BREAK_LEASE was intended to be set when finding files for
> COMMIT ops, where we need a writeable filehandle but don't need to
> break read leases.
>=20
> It doesn't make any sense to consult that flag when allocating a file
> since the file may be used on subsequent calls where we do want to break
> the lease (and the usage of it here seems to be reverse from what it
> should be anyway).
>=20
> Also, after calling nfsd_open_break_lease, we don't want to clear the
> BREAK_* bits. A lease could end up being set on it later (more than
> once) and we need to be able to break those leases as well.
>=20
> This means that the NFSD_FILE_BREAK_* flags now just mirror
> NFSD_MAY_{READ,WRITE} flags, so there's no need for them at all. Just
> drop those flags and unconditionally call nfsd_open_break_lease every
> time.
>=20
> Reported-by: Olga Kornieskaia <kolga@netapp.com>
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=3D2107360
> Fixes: 65294c1f2c5e (nfsd: add a new struct file caching facility to nfsd=
)
> Cc: <stable@vger.kernel.org> # 5.4.x : bb283ca18d1e NFSD: Clean up the sh=
ow_nf_flags() macro
> Cc: <stable@vger.kernel.org> # 5.4.x
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/nfsd/filecache.c | 24 +++---------------------
>  fs/nfsd/filecache.h |  4 +---
>  fs/nfsd/trace.h     |  2 --
>  3 files changed, 4 insertions(+), 26 deletions(-)
>=20
> This patch should apply cleanly on top of v5.19-rc8, and fixes the issue
> I was seeing with missing CB_RECALLS. It also applies and works on top of
> v5.18.15, but that requires a prerequisite patch. Hopefully I've got the
> stable prereq tags right here.
>=20
> I'll resend the tracepoint patches separately.
>=20
> diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
> index 9cb2d590c036..8f3c0c567d70 100644
> --- a/fs/nfsd/filecache.c
> +++ b/fs/nfsd/filecache.c
> @@ -184,12 +184,8 @@ nfsd_file_alloc(struct inode *inode, unsigned int ma=
y, unsigned int hashval,
>  		nf->nf_hashval =3D hashval;
>  		refcount_set(&nf->nf_ref, 1);
>  		nf->nf_may =3D may & NFSD_FILE_MAY_MASK;
> -		if (may & NFSD_MAY_NOT_BREAK_LEASE) {
> -			if (may & NFSD_MAY_WRITE)
> -				__set_bit(NFSD_FILE_BREAK_WRITE, &nf->nf_flags);
> -			if (may & NFSD_MAY_READ)
> -				__set_bit(NFSD_FILE_BREAK_READ, &nf->nf_flags);
> -		}
> +		__set_bit(NFSD_FILE_HASHED, &nf->nf_flags);
> +		__set_bit(NFSD_FILE_PENDING, &nf->nf_flags);

Oof, this bit crept in during the backport. I'll send a v3.

>  		nf->nf_mark =3D NULL;
>  		trace_nfsd_file_alloc(nf);
>  	}
> @@ -958,21 +954,7 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct =
svc_fh *fhp,
> =20
>  	this_cpu_inc(nfsd_file_cache_hits);
> =20
> -	if (!(may_flags & NFSD_MAY_NOT_BREAK_LEASE)) {
> -		bool write =3D (may_flags & NFSD_MAY_WRITE);
> -
> -		if (test_bit(NFSD_FILE_BREAK_READ, &nf->nf_flags) ||
> -		    (test_bit(NFSD_FILE_BREAK_WRITE, &nf->nf_flags) && write)) {
> -			status =3D nfserrno(nfsd_open_break_lease(
> -					file_inode(nf->nf_file), may_flags));
> -			if (status =3D=3D nfs_ok) {
> -				clear_bit(NFSD_FILE_BREAK_READ, &nf->nf_flags);
> -				if (write)
> -					clear_bit(NFSD_FILE_BREAK_WRITE,
> -						  &nf->nf_flags);
> -			}
> -		}
> -	}
> +	status =3D nfserrno(nfsd_open_break_lease(file_inode(nf->nf_file), may_=
flags));
>  out:
>  	if (status =3D=3D nfs_ok) {
>  		*pnf =3D nf;
> diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
> index 1da0c79a5580..c9e3c6eb4776 100644
> --- a/fs/nfsd/filecache.h
> +++ b/fs/nfsd/filecache.h
> @@ -37,9 +37,7 @@ struct nfsd_file {
>  	struct net		*nf_net;
>  #define NFSD_FILE_HASHED	(0)
>  #define NFSD_FILE_PENDING	(1)
> -#define NFSD_FILE_BREAK_READ	(2)
> -#define NFSD_FILE_BREAK_WRITE	(3)
> -#define NFSD_FILE_REFERENCED	(4)
> +#define NFSD_FILE_REFERENCED	(2)
>  	unsigned long		nf_flags;
>  	struct inode		*nf_inode;
>  	unsigned int		nf_hashval;
> diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
> index a60ead3b227a..081179fb17e8 100644
> --- a/fs/nfsd/trace.h
> +++ b/fs/nfsd/trace.h
> @@ -696,8 +696,6 @@ DEFINE_CLID_EVENT(confirmed_r);
>  	__print_flags(val, "|",						\
>  		{ 1 << NFSD_FILE_HASHED,	"HASHED" },		\
>  		{ 1 << NFSD_FILE_PENDING,	"PENDING" },		\
> -		{ 1 << NFSD_FILE_BREAK_READ,	"BREAK_READ" },		\
> -		{ 1 << NFSD_FILE_BREAK_WRITE,	"BREAK_WRITE" },	\
>  		{ 1 << NFSD_FILE_REFERENCED,	"REFERENCED"})
> =20
>  DECLARE_EVENT_CLASS(nfsd_file_class,

--=20
Jeff Layton <jlayton@kernel.org>
