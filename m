Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04EE61E92EB
	for <lists+stable@lfdr.de>; Sat, 30 May 2020 19:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgE3Rft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 May 2020 13:35:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgE3Rft (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 May 2020 13:35:49 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71A3C20774;
        Sat, 30 May 2020 17:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590860148;
        bh=Km+qsBMMCDWbNMm6RhJqYLEma5l3VL5pC1iVxzc9Ljc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ONHZOgZx3Q3+kUxk28asW/VTjbkXr6fmbkaCLfRocfasre//eQ8N+H8ow5bFn2xpc
         uzOcmb+LeGzNgVi+kWs1F9TLCQo0V1V/Cx5r4MEnnaZoz/2+E51ez9VyjQ8BaL47rD
         3JZWi+c4WkS0ahXTI7RyIR2JEJ4iTPJZ2z9GX+tM=
Date:   Sat, 30 May 2020 10:35:47 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Daniel Rosenberg <drosen@google.com>,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: Re: [PATCH] ext4: avoid utf8_strncasecmp() with unstable name
Message-ID: <20200530173547.GA12299@sol.localdomain>
References: <20200530060216.221456-1-ebiggers@kernel.org>
 <20200530171814.GD19604@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200530171814.GD19604@bombadil.infradead.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 30, 2020 at 10:18:14AM -0700, Matthew Wilcox wrote:
> On Fri, May 29, 2020 at 11:02:16PM -0700, Eric Biggers wrote:
> > +	if (len <= DNAME_INLINE_LEN - 1) {
> > +		unsigned int i;
> > +
> > +		for (i = 0; i < len; i++)
> > +			strbuf[i] = READ_ONCE(str[i]);
> > +		strbuf[len] = 0;
> 
> This READ_ONCE is going to force the compiler to use byte accesses.
> What's wrong with using a plain memcpy()?
> 

It's undefined behavior when the source can be concurrently modified.

Compilers can assume that it's not, and remove the memcpy() (instead just using
the source data directly) if they can prove that the destination array is never
modified again before it goes out of scope.

Do you have any suggestions that don't involve undefined behavior?

- Eric
