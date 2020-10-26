Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2650E299AD9
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 00:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407443AbgJZXkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:40:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407433AbgJZXkM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:40:12 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C14C206FB;
        Mon, 26 Oct 2020 23:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603755611;
        bh=ZgbflWpbtTfBxG7usPJTb2WZqEYqd438hFIgnDyXuZk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s4jrG+TkxPz3M1yPMrS2r30WcawYO1jYf1AyyGHiEtn1vMdQ1ui0K8jDexcGCGsR4
         qgptXFeRExv0dD6gh+fJm5OBVo/+BvYnP2/KSs6/f7rLeJY31E+VlYDOdJudJL6N96
         sKfCkkyZpbO6hx2jpem2/n1ODJmzZYKLLznl6ih8=
Date:   Mon, 26 Oct 2020 16:40:10 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        syzkaller-bugs@googlegroups.com, linux-hardening@vger.kernel.org,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Elena Petrova <lenaptr@google.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        stable@vger.kernel.org,
        syzbot+92ead4eb8e26a26d465e@syzkaller.appspotmail.com
Subject: Re: [PATCH] crypto: af_alg - avoid undefined behavior accessing
 salg_name
Message-ID: <20201026234010.GD1947033@gmail.com>
References: <CACT4Y+beaHrWisaSsV90xQn+t2Xn-bxvVgmx8ih_h=yJYPjs4A@mail.gmail.com>
 <20201026200715.170261-1-ebiggers@kernel.org>
 <20201026212148.GA26823@embeddedor>
 <20201026231059.GB26823@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026231059.GB26823@embeddedor>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 26, 2020 at 06:10:59PM -0500, Gustavo A. R. Silva wrote:
> On Mon, Oct 26, 2020 at 04:21:48PM -0500, Gustavo A. R. Silva wrote:
> > > +/*
> > > + * Linux v4.12 and later removed the 64-byte limit on salg_name[]; it's now an
> > > + * arbitrary-length field.  We had to keep the original struct above for source
> > > + * compatibility with existing userspace programs, though.  Use the new struct
> > > + * below if support for very long algorithm names is needed.  To do this,
> > > + * allocate 'sizeof(struct sockaddr_alg_new) + strlen(algname) + 1' bytes, and
> > > + * copy algname (including the null terminator) into salg_name.
> > > + */
> > > +struct sockaddr_alg_new {
> > > +	__u16	salg_family;
> > > +	__u8	salg_type[14];
> > > +	__u32	salg_feat;
> > > +	__u32	salg_mask;
> > > +	__u8	salg_name[];
> > > +};
> > > +
> > 
> > How something like this, instead:
> > 
> >  struct sockaddr_alg {
> > -	__u16	salg_family;
> > -	__u8	salg_type[14];
> > -	__u32	salg_feat;
> > -	__u32	salg_mask;
> > -	__u8	salg_name[64];
> > +	union {
> > +		struct {
> > +			__u16	salg_v1_family;
> > +			__u8	salg_v1_type[14];
> > +			__u32	salg_v1_feat;
> > +			__u32	salg_v1_mask;
> > +			__u8	salg_name[64];
> > +		};
> > +		struct {
> > +			__u16	salg_family;
> > +			__u8	salg_type[14];
> > +			__u32	salg_feat;
> > +			__u32	salg_mask;
> > +			__u8	salg_name_new[];
> > +		};
> > +	};
> >  };
> > 
> 
> Something similar to the following approach might work:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/gustavoars/linux.git/commit/?h=testing/uapi/gntalloc&id=db46c8aba41c436edb0b4ef2941bd7390b0e5d61
> 

I suppose so.  It's very confusing to see a union like that at first glance,
though.  It definitely needs an explanatory comment...

- Eric
