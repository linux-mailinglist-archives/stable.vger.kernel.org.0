Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEA65663CAB
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 10:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbjAJJVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 04:21:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbjAJJV0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 04:21:26 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDDBBC9C;
        Tue, 10 Jan 2023 01:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=44Pxq/Gu6cSIMFTEHWOH2WtfVltGkpXc5b5mvZ6YnMI=; b=DOriKYHiGPkpmgYw+wHIx8e2IT
        3urzCMP8j8Yo0EQmssHJSHLFHA5Snvs9o3amcHseYUKMNPcpOdgqv7Kjxt9HXaLtQwcO6agEcZfZa
        vWwvRntt52smuMbHpKb4IOfBYDxHmekMmJfH50cOaUd6GBE4onPxA+2WgQrzEJWpIwnSl1fYddL73
        qhMPEyz9u0snEdIYZJpVu2AvhQr45MtPLxCycgPP78q+4N082A8aOQ83sCpCfzW7Sata2NW6KlFbt
        I4wxrNGoUQxPLaZ4WvsrKMKyWgpLgMvAo9Anrjwvst9WyhCsG/d7HLpdh9hjN0+5VrzNxY2Qc7Fff
        luCbA1BA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFAou-00647I-MK; Tue, 10 Jan 2023 09:21:24 +0000
Date:   Tue, 10 Jan 2023 01:21:24 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, mikelley@microsoft.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] block: don't allow splitting of a REQ_NOWAIT bio
Message-ID: <Y70uFA3s1d0pSz5H@infradead.org>
References: <20230104160938.62636-1-axboe@kernel.dk>
 <20230104160938.62636-3-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104160938.62636-3-axboe@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 04, 2023 at 09:09:38AM -0700, Jens Axboe wrote:
>  split:
> +	/*
> +	 * We can't sanely support splitting for a REQ_NOWAIT bio. End it
> +	 * with EAGAIN if splitting is required and return an error pointer.
> +	 */
> +	if (bio->bi_opf & REQ_NOWAIT) {
> +		bio->bi_status = BLK_STS_AGAIN;
> +		bio_endio(bio);
> +		return ERR_PTR(-EAGAIN);
> +	}

Hmm.  Just completing the bio here seems a little dangerous in terms
of ownership.  What speaks against letting the caller do it?
