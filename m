Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4543AC744
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 11:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbhFRJVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 05:21:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230175AbhFRJVN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Jun 2021 05:21:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41658613BA;
        Fri, 18 Jun 2021 09:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624007943;
        bh=d6L8De6SYFaetstLiE1nJCBZWihJ29jUVk5AQi+slLM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ii3BvH+zyZ2xJDaPeqND8gbRYSFndrh2PVsgtJDBc2/i8pDJOdR/0zMDyxiMX2LOI
         RdgUVyreprCstrRPerKKjUrDMVC68Nu8vQG4rOBnLoV0U91DjdkajAwTotrMjA16JX
         d+uv1e0KVbK77iNH1snIewQGkVuzOeCpH3vmtxCw=
Date:   Fri, 18 Jun 2021 11:19:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Krzysztof Kozlowski' <krzysztof.kozlowski@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>, Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH 5.4 031/184] modules: inherit TAINT_PROPRIETARY_MODULE
Message-ID: <YMxlBCzztbWGvi/l@kroah.com>
References: <20210510101950.200777181@linuxfoundation.org>
 <20210510101951.249384110@linuxfoundation.org>
 <8edc6f45-6c42-19c7-6f40-6f1a49cc685b@canonical.com>
 <5ac70bdf2c5b440c83f12e75ca42a107@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ac70bdf2c5b440c83f12e75ca42a107@AcuMS.aculab.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 18, 2021 at 09:07:53AM +0000, David Laight wrote:
> From: Krzysztof Kozlowski
> > Sent: 18 June 2021 09:57
> > 
> > On 10/05/2021 12:18, Greg Kroah-Hartman wrote:
> > > From: Christoph Hellwig <hch@lst.de>
> > >
> > > commit 262e6ae7081df304fc625cf368d5c2cbba2bb991 upstream.
> > >
> > > If a TAINT_PROPRIETARY_MODULE exports symbol, inherit the taint flag
> > > for all modules importing these symbols, and don't allow loading
> > > symbols from TAINT_PROPRIETARY_MODULE modules if the module previously
> > > imported gplonly symbols.  Add a anti-circumvention devices so people
> > > don't accidentally get themselves into trouble this way.
> > >
> > > Comment from Greg:
> > >   "Ah, the proven-to-be-illegal "GPL Condom" defense :)"
> > 
> > Patch got in to stable, so my comments are quite late, but can someone
> > explain me - how this is a stable material? What specific, real bug that
> > bothers people, is being fixed here? Or maybe it fixes serious issue
> > reported by a user of distribution kernel? IOW, how does this match
> > stable kernel rules at all?
> > 
> > For sure it breaks some out-of-tree modules already present and used by
> > customers of downstream stable kernels. Therefore I wonder what is the
> > bug fixed here, so the breakage and annoyance of stable users is justified.
> 
> It also doesn't stop non-gpl out-of-tree modules doing anything.
> They just have to be reorganized with a 'base' GPL module that
> includes wrappers for all the gplonly symbols and then all
> the rest of the modules can be non-gpl.

Ah, the "gpl condom defense".  Love it that you somehow think that is
acceptable (hint, it is not.)

That's what this patch series is supposed to be addressing and fixing,
but someone has shown me a way around this.   I'll work on fixing that
up in a future patch series next week.

thanks,

greg k-h
