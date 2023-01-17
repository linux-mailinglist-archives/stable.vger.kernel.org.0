Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B932866D5D0
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 07:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235582AbjAQGCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 01:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235659AbjAQGCM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 01:02:12 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05873298FE;
        Mon, 16 Jan 2023 22:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0iFYPwB56z2uVqPM1Af+NzvPAa6MzVC/MYfjI6yAY5A=; b=rS1nepsu+NNaRwhTSKHr/33vYx
        bjUv9LNzKIkBn89U8opnUY7DIiAPFUGjY722xAQcby/87TIIhiVm+z+s3/b9gNWJj1c43eMpLeywx
        ZQvtHjhTVeZUrBqR0/QH0QecNBbos1UCmPqH30grNUJ+MhkyVktt7QpDeJWXOD/+6HrAEZ4I1Mi95
        RpUn2/IwYRmmTotr9oPihqnujOKWlAvGR8MfyDbhjlv7vevktuHpL5ibiX2QPQ9njNhQ59bJ0HC2K
        l0nMbLKwaf/CTNTEBIfvCNHSL7Y9zYQrBVPc6K0nGiTRJsK0SY8DvXHROgB2Fx3mNbCyiYlJWdegk
        cHuTYbIA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pHf2J-00D1Xj-14; Tue, 17 Jan 2023 06:01:31 +0000
Date:   Mon, 16 Jan 2023 22:01:31 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, mikelley@microsoft.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] block: don't allow splitting of a REQ_NOWAIT bio
Message-ID: <Y8Y5u0yB69gcORXq@infradead.org>
References: <20230104160938.62636-1-axboe@kernel.dk>
 <20230104160938.62636-3-axboe@kernel.dk>
 <Y70uFA3s1d0pSz5H@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y70uFA3s1d0pSz5H@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

And this is the other comment.

On Tue, Jan 10, 2023 at 01:21:24AM -0800, Christoph Hellwig wrote:
> On Wed, Jan 04, 2023 at 09:09:38AM -0700, Jens Axboe wrote:
> >  split:
> > +	/*
> > +	 * We can't sanely support splitting for a REQ_NOWAIT bio. End it
> > +	 * with EAGAIN if splitting is required and return an error pointer.
> > +	 */
> > +	if (bio->bi_opf & REQ_NOWAIT) {
> > +		bio->bi_status = BLK_STS_AGAIN;
> > +		bio_endio(bio);
> > +		return ERR_PTR(-EAGAIN);
> > +	}
> 
> Hmm.  Just completing the bio here seems a little dangerous in terms
> of ownership.  What speaks against letting the caller do it?
---end quoted text---
