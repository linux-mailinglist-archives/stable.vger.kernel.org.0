Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC322A87B6
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 21:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgKEUIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 15:08:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:58118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbgKEUIK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Nov 2020 15:08:10 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F8DA20729;
        Thu,  5 Nov 2020 20:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604606889;
        bh=UbXVjeOJkuP8+CC9HnOjLWKGZfWfCv/qYw/apchOvu0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LI06uVl2qSHOowOvTc/LExLLKr74j/LoNMga+IIQHSYugCgTZ/qz6FfhsHAdRUUT/
         nbteaX4CUK9eK1EerhGvZBzlQx1Q+olQZYcX2TWiAc0diPGo6v919ZmZNcM6Rf6Dtq
         7vA3wAgIVyvl9rDcsPHgGi8pxnMA1/wAjfG530Ds=
Date:   Thu, 5 Nov 2020 21:08:57 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joe Perches <joe@perches.com>
Cc:     Dwaipayan Ray <dwaipayanray1@gmail.com>, stable@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, lukas.bulwahn@gmail.com,
        yashsri421@gmail.com
Subject: Re: [PATCH v3] checkpatch: improve email parsing
Message-ID: <20201105200857.GC1333458@kroah.com>
References: <20201105115949.39474-1-dwaipayanray1@gmail.com>
 <f83c2eeafdebc6307ee6e515e4d6652b2606a068.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f83c2eeafdebc6307ee6e515e4d6652b2606a068.camel@perches.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 05, 2020 at 09:41:15AM -0800, Joe Perches wrote:
> (adding stable and Greg KH for additional review)
> On Thu, 2020-11-05 at 17:29 +0530, Dwaipayan Ray wrote:
> > checkpatch doesn't report warnings for many common mistakes
> > in emails. Some of which are trailing commas and incorrect
> > use of email comments.
> 
> I presume you've tested this against the git tree.
> 
> Can you send me a file with the BAD_SIGN_OFF messages generated
> and if possible the git SHA-1s of the commits?
> 
> > At the same time several false positives are reported due to
> > incorrect handling of mail comments. The most common of which
> > is due to the pattern:
> > 
> > <stable@vger.kernel.org> # X.X
> > 
> > Improve email parsing in checkpatch.
> > 
> > Some general comment rules are defined:
> > 
> > - Multiple name comments should not be allowed.
> > - Comments inside address should not be allowed.
> > - In general comments should be enclosed within parentheses.
> >   Exception for stable@vger.kernel.org # X.X
> 
> not just vger.kernel.org, but this should also allow stable@kernel.org
> and only allow cc: and not any other -by: type for that email address.
> 
> A process preference question for Greg and the stable team:
> 
> The most common stable forms are
> 
> 	stable@vger.kernel.org # version info

That is what is documented it should be, yes.

> then
> 	stable@vger.kernel.org [ version info ]

Really?  Ick, no wonder my email parsing scripts choke on that :)

> with some other relatively infrequently used outlier styles, some
> that use parentheses, but this is not frequent.

The one with '#' should be preferred.  If not, we need to change our
documentation.

thanks,

greg k-h
