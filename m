Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C489E43FEFD
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 17:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhJ2PH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 11:07:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229712AbhJ2PH2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Oct 2021 11:07:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83CC761166;
        Fri, 29 Oct 2021 15:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635519900;
        bh=MUYeiAaozhKHUbA+9acaxgzevRgCsoyWy0L9+v730e8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FVxnP24lmTk7GUjVwiXovLHeEWC8ZzMMn4bWo7WPQJM2N1RrYFETzL7ytQkOX6xtD
         0fv0DIt1/4ReeAEuis7w6qLNvlv5DKmMpY0qCLTiUzS4z+GlDcLhXKt9FWavzm/ZtJ
         cBg/kkrmDWAS/UmMbdjb1HIjl++ZcMlJR0Lg1mUg=
Date:   Fri, 29 Oct 2021 17:04:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.19 0/3] ipv4/ipv6: backport fixes for CVE-2021-20322
Message-ID: <YXwNmcIcmOYTRhG2@kroah.com>
References: <20211028190901.1839515-1-ovidiu.panait@windriver.com>
 <YXulOpILxpS+ljKY@kroah.com>
 <cdf08090-1f48-4a90-4c68-139b706fdd88@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdf08090-1f48-4a90-4c68-139b706fdd88@windriver.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 29, 2021 at 11:17:16AM +0300, Ovidiu Panait wrote:
> Hi Greg,
> 
> On 29.10.2021 10:39, Greg KH wrote:
> > [Please note: This e-mail is from an EXTERNAL e-mail address]
> > 
> > On Thu, Oct 28, 2021 at 10:08:58PM +0300, Ovidiu Panait wrote:
> > > The following commits are needed to fix CVE-2021-20322:
> > > ipv4:
> > > [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6457378fe796815c973f631a1904e147d6ee33b1
> > > [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=67d6d681e15b578c1725bad8ad079e05d1c48a8e
> > > 
> > > ipv6:
> > > [3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4785305c05b25a242e5314cc821f54ade4c18810
> > > [4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a00df2caffed3883c341d5685f830434312e4a43
> > > 
> > > Commit [2] is already present in 4.19 stable, so backport the
> > > remaining three fixes with minor context adjustments.
> > > 
> > > Eric Dumazet (3):
> > >    ipv4: use siphash instead of Jenkins in fnhe_hashfun()
> > >    ipv6: use siphash in rt6_exception_hash()
> > >    ipv6: make exception cache less predictible
> > > 
> > >   net/ipv4/route.c | 12 ++++++------
> > >   net/ipv6/route.c | 25 ++++++++++++++++++-------
> > >   2 files changed, 24 insertions(+), 13 deletions(-)
> > > 
> > > --
> > > 2.25.1
> > > 
> > You sent 0/3 but only 2 patches showed up?
> > 
> > Can you please resend all 3?
> 
> I tried resending the full patchset, but the last patch is still not showing
> up.
> 
> git send-email doesn't report any errors:
> 
> OK. Log says:
> MAIL FROM:<ovidiu.panait@windriver.com>
> RCPT TO:<stable@vger.kernel.org>
> RCPT TO:<gregkh@linuxfoundation.org>
> From: Ovidiu Panait <ovidiu.panait@windriver.com>
> To: stable@vger.kernel.org
> Cc: gregkh@linuxfoundation.org
> Subject: [PATCH 4.19 3/3] ipv6: make exception cache less predictible
> Date: Fri, 29 Oct 2021 10:50:27 +0300
> Message-Id: <20211029075027.1910142-4-ovidiu.panait@windriver.com>
> X-Mailer: git-send-email 2.25.1
> In-Reply-To: <20211029075027.1910142-1-ovidiu.panait@windriver.com>
> References: <20211029075027.1910142-1-ovidiu.panait@windriver.com>
> MIME-Version: 1.0
> Content-Transfer-Encoding: 8bit
> 
> Result: 250
> 
> 
> I have attached the 4.19 backport of a00df2caffed ("ipv6: make exception
> cache less predictible").

Odd, it did not come to me either.  I've taken the attached file, thanks.

greg k-h
