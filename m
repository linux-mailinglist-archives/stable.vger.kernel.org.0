Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1044E1E9EC8
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 09:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgFAHF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 03:05:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgFAHF2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 03:05:28 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB03D20678;
        Mon,  1 Jun 2020 07:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590995128;
        bh=of4R5hmBi9J/EzsQd0OEbsARZdgvjho4xeYJhJNt2Do=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=REe9iTIj0rvPdUZ0fAwCFBL25zQSliEg6NDZXCNWm+GxB7ChH+p6T4g9I3JrG/I29
         qQY6A4W6JGi89GzFHUrmUmzoBUmPFfUmnIC3GxnOv3Bb6SVKaZraCbH6JGOIVGVCQE
         JFlH21cNbzl/CZyF/zoYvoP15LkHIVOpCT2qAfTk=
Date:   Mon, 1 Jun 2020 00:05:26 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Daniel Rosenberg <drosen@google.com>,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: Re: [PATCH] ext4: avoid utf8_strncasecmp() with unstable name
Message-ID: <20200601070526.GD11054@sol.localdomain>
References: <20200530060216.221456-1-ebiggers@kernel.org>
 <20200530171814.GD19604@bombadil.infradead.org>
 <20200530173547.GA12299@sol.localdomain>
 <20200530204132.GE19604@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200530204132.GE19604@bombadil.infradead.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 30, 2020 at 01:41:32PM -0700, Matthew Wilcox wrote:
> On Sat, May 30, 2020 at 10:35:47AM -0700, Eric Biggers wrote:
> > On Sat, May 30, 2020 at 10:18:14AM -0700, Matthew Wilcox wrote:
> > > On Fri, May 29, 2020 at 11:02:16PM -0700, Eric Biggers wrote:
> > > > +	if (len <= DNAME_INLINE_LEN - 1) {
> > > > +		unsigned int i;
> > > > +
> > > > +		for (i = 0; i < len; i++)
> > > > +			strbuf[i] = READ_ONCE(str[i]);
> > > > +		strbuf[len] = 0;
> > > 
> > > This READ_ONCE is going to force the compiler to use byte accesses.
> > > What's wrong with using a plain memcpy()?
> > > 
> > 
> > It's undefined behavior when the source can be concurrently modified.
> > 
> > Compilers can assume that it's not, and remove the memcpy() (instead just using
> > the source data directly) if they can prove that the destination array is never
> > modified again before it goes out of scope.
> > 
> > Do you have any suggestions that don't involve undefined behavior?
> 
> void *memcpy_unsafe(void *dst, volatile void *src, __kernel_size_t);
> 
> It can just call memcpy() of course, but the compiler can't reason about
> this function because it's not a stdlib function.

The compiler can still reason about it if it's in the same file, if it's an
inline function, or if link-time-optimization is enabled.  (LTO isn't yet
supported by the mainline kernel, but people have been working on it.)

Also, as I mentioned to Al, it's necessary to cast away 'volatile' to call
memcpy().  So the 'volatile' serves no purpose.

How about using barrier(), which expands to  asm("" : : : "memory") to tell the
compiler that memory was clobbered?

        if (len <= DNAME_INLINE_LEN - 1) {
                memcpy(strbuf, str, len);
                strbuf[len] = 0;
                /* prevent compiler from optimizing out the temporary buffer */
                barrier();
        }

I think it's still technically undefined to call memcpy() on concurrently
modified memory at all, but I think the above would be okay in practice...

Using 'noinline' could be another option.

- Eric
