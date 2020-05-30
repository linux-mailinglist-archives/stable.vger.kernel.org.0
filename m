Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E171E93A0
	for <lists+stable@lfdr.de>; Sat, 30 May 2020 22:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729345AbgE3Ulh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 May 2020 16:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgE3Ulh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 May 2020 16:41:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF5BC03E969;
        Sat, 30 May 2020 13:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4OdrZK2pGyMVHZP9dBAVdzAWc40dh9XQscP29VyVrvM=; b=HZvQiU2YlUtBkyi6j0X0sBvcK6
        YZbb6RElwJlDvQSoI8EnGgMdqBHoihEOfco2ouCjUP4Lrt9K1yHxN8OR5Caaio7SnY2tGtjpu2vng
        jr1IQnGoevyNcal8I/kgEqEGTu3l+Zwlh5LVZwcZgiHGb4WD6ut/ABzyv8M2MhE68B0QNvidpnC3Q
        2Lj81yDjMRBVamW438WZSQXqIyI6NJY97hDAeLt7m7VQQfHf4EELlTmQSzzKspRVXWPOK0cCOwljZ
        sJ9Nep2Dn0XzCi79koJwJFZzSkEGkTSq4HO0sQ6syXZ7aNRGYBeUxnVBXkgbEbKIIudGg/NB/2i+7
        XqHaEaWg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jf8IO-0000XW-Qx; Sat, 30 May 2020 20:41:32 +0000
Date:   Sat, 30 May 2020 13:41:32 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Daniel Rosenberg <drosen@google.com>,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: Re: [PATCH] ext4: avoid utf8_strncasecmp() with unstable name
Message-ID: <20200530204132.GE19604@bombadil.infradead.org>
References: <20200530060216.221456-1-ebiggers@kernel.org>
 <20200530171814.GD19604@bombadil.infradead.org>
 <20200530173547.GA12299@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200530173547.GA12299@sol.localdomain>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 30, 2020 at 10:35:47AM -0700, Eric Biggers wrote:
> On Sat, May 30, 2020 at 10:18:14AM -0700, Matthew Wilcox wrote:
> > On Fri, May 29, 2020 at 11:02:16PM -0700, Eric Biggers wrote:
> > > +	if (len <= DNAME_INLINE_LEN - 1) {
> > > +		unsigned int i;
> > > +
> > > +		for (i = 0; i < len; i++)
> > > +			strbuf[i] = READ_ONCE(str[i]);
> > > +		strbuf[len] = 0;
> > 
> > This READ_ONCE is going to force the compiler to use byte accesses.
> > What's wrong with using a plain memcpy()?
> > 
> 
> It's undefined behavior when the source can be concurrently modified.
> 
> Compilers can assume that it's not, and remove the memcpy() (instead just using
> the source data directly) if they can prove that the destination array is never
> modified again before it goes out of scope.
> 
> Do you have any suggestions that don't involve undefined behavior?

void *memcpy_unsafe(void *dst, volatile void *src, __kernel_size_t);

It can just call memcpy() of course, but the compiler can't reason about
this function because it's not a stdlib function.
