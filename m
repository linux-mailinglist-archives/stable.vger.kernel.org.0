Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 243AA91BBE
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 06:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbfHSEOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 00:14:48 -0400
Received: from m12-17.163.com ([220.181.12.17]:48714 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbfHSEOs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Aug 2019 00:14:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:Message-ID:MIME-Version; bh=x0nxG
        PuZl6OzRvhI9JteYOTIS9V5/De0DOoCRwbKaa0=; b=diS2vgq1plYI9D/2d5FjR
        jHQknkIjEfCb3tBQF62KjBe3nVG5AMpilVTllP5NLmZsa5OxOglJBUSsp3h3kqUu
        w6MP/qJRK+f9wmaK5E4i5c84ZjGyjs341lAaX4LAC+UY5TL9Kf13r3seh0ETg0r4
        98mfjQiCtJ5NswDaIo6Xyo=
Received: from sise (unknown [202.112.113.212])
        by smtp13 (Coremail) with SMTP id EcCowADHzAkvIlpdvAaPIg--.63341S2;
        Mon, 19 Aug 2019 12:14:40 +0800 (CST)
Date:   Mon, 19 Aug 2019 12:14:39 +0800
From:   PanBian <bianpan2016@163.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH V2] block/bio-integrity: fix mismatched alloc free
Message-ID: <20190819041439.GA23459@sise>
Reply-To: PanBian <bianpan2016@163.com>
References: <1566176353-20157-1-git-send-email-bianpan2016@163.com>
 <20190819035613.GC3086@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819035613.GC3086@ming.t460p>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-CM-TRANSID: EcCowADHzAkvIlpdvAaPIg--.63341S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZFykCFWfGr4rAF1fAFyfCrg_yoW8Gr4Dpw
        4kKayYkF4jgFyIkF4DA3W3ZF10g34xurWUWr13A34Fy347C3WSgr1q9ryFgry09rWYkrWI
        yFWYgryqk3s8A3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jVc_fUUUUU=
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/1tbiQBAWclSIcBkc9QAAso
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 19, 2019 at 11:56:14AM +0800, Ming Lei wrote:
> On Mon, Aug 19, 2019 at 08:59:13AM +0800, Pan Bian wrote:
> > The function kmalloc rather than mempool_alloc is called to allocate
> > memory when the memory pool is unavailable. However, mempool_alloc is
> > used to release the memory chunck in both cases when error occurs. This
> > patch fixes the bug.
> > 
> > Fixes: 9f060e2231c ("block: Convert integrity to bvec_alloc_bs()")
> > Signed-off-by: Pan Bian <bianpan2016@163.com>
> > Cc: stable@vger.kernel.org
> > ---
> > V2: add Fixes and CC tags
> > ---
> >  block/bio-integrity.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/block/bio-integrity.c b/block/bio-integrity.c
> > index fb95dbb..011dfc8 100644
> > --- a/block/bio-integrity.c
> > +++ b/block/bio-integrity.c
> > @@ -75,7 +75,10 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
> >  
> >  	return bip;
> >  err:
> > -	mempool_free(bip, &bs->bio_integrity_pool);
> > +	if (!bs || !mempool_initialized(&bs->bio_integrity_pool))
> > +		kfree(bip);
> > +	else
> > +		mempool_free(bip, &bs->bio_integrity_pool);
> >  	return ERR_PTR(-ENOMEM);
> >  }
> >  EXPORT_SYMBOL(bio_integrity_alloc);
> 
> 'err' is still reached in case that 'bs' is valid, so fix nothing.

You are right! It's my fault.

Thanks,
Pan

> 
> 
> Thanks,
> Ming

