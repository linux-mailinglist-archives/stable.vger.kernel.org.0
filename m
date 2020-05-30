Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A371E92FC
	for <lists+stable@lfdr.de>; Sat, 30 May 2020 19:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729284AbgE3R7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 May 2020 13:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729006AbgE3R7N (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 May 2020 13:59:13 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D818C03E969;
        Sat, 30 May 2020 10:59:13 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jf5lD-000X31-I7; Sat, 30 May 2020 17:59:07 +0000
Date:   Sat, 30 May 2020 18:59:07 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org,
        Daniel Rosenberg <drosen@google.com>,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: Re: [PATCH] ext4: avoid utf8_strncasecmp() with unstable name
Message-ID: <20200530175907.GP23230@ZenIV.linux.org.uk>
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

Even memcpy(strbuf, (volatile void *)str, len)?  It's been a while since I've
looked at these parts of C99...
