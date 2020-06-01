Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7F11E9E6D
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 08:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgFAGpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 02:45:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726076AbgFAGpP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 02:45:15 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72D46206C3;
        Mon,  1 Jun 2020 06:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590993915;
        bh=zfYAnnOMkuQXZpA+G/MMKrf7YexWrDaV0EqmTcf7Kaw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FFKfplnDcJ3+nxndceXPwzR2M/jR5K/qxfXBsvkZAJzdDCb74SueskNAYqAs33Vk3
         aepTFVKI0QPR+J5wWfSJQF5/tsz99wlBYoa9QC69vAvtmGepUojbFvMA5EA8HXV/l+
         7Z1fKoGzdAEknCR10jfE8XtiTzQs3f6/WMt4QQEE=
Date:   Sun, 31 May 2020 23:45:14 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org,
        Daniel Rosenberg <drosen@google.com>,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: Re: [PATCH] ext4: avoid utf8_strncasecmp() with unstable name
Message-ID: <20200601064514.GC11054@sol.localdomain>
References: <20200530060216.221456-1-ebiggers@kernel.org>
 <20200530171814.GD19604@bombadil.infradead.org>
 <20200530173547.GA12299@sol.localdomain>
 <20200530175907.GP23230@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200530175907.GP23230@ZenIV.linux.org.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 30, 2020 at 06:59:07PM +0100, Al Viro wrote:
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
> Even memcpy(strbuf, (volatile void *)str, len)?  It's been a while since I've
> looked at these parts of C99...

That doesn't make sense.  memcpy() takes a non-volatile pointer, so the pointer
just gets implicitly cast back to (void *), and you get a compiler warning.

- Eric
