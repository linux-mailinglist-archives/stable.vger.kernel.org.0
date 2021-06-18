Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9CF3AC768
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 11:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbhFRJbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 05:31:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229466AbhFRJbN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Jun 2021 05:31:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21155613D6;
        Fri, 18 Jun 2021 09:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624008543;
        bh=cajhCmV65XLZcXw4300MqDf324q9WNWkNa8RXQ2brms=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lbvpjpn4hIWsl1+D/mog0YkoJor8jYcZP7RDlUOTStK07crJvqHirvfWBKxF14Qr3
         KI77qCHjc6+hlVk0ywMEaVXZc5kMIahZMMp/Qj/qvsl2ecnCOzDNi1Bbl+2KMECrz7
         G/VEsiGcaRWPtIrfJeu2GBjK7KR2P59KakCIfbIQ=
Date:   Fri, 18 Jun 2021 11:29:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>, Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH 5.4 031/184] modules: inherit TAINT_PROPRIETARY_MODULE
Message-ID: <YMxnXQzcP0g1F9Iw@kroah.com>
References: <20210510101950.200777181@linuxfoundation.org>
 <20210510101951.249384110@linuxfoundation.org>
 <8edc6f45-6c42-19c7-6f40-6f1a49cc685b@canonical.com>
 <YMxlP2EMTaG9+2y6@kroah.com>
 <e56625df-dda3-01f3-0f9d-f4dffdbd6690@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e56625df-dda3-01f3-0f9d-f4dffdbd6690@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 18, 2021 at 11:22:37AM +0200, Krzysztof Kozlowski wrote:
> On 18/06/2021 11:19, Greg Kroah-Hartman wrote:
> > On Fri, Jun 18, 2021 at 10:57:23AM +0200, Krzysztof Kozlowski wrote:
> >> On 10/05/2021 12:18, Greg Kroah-Hartman wrote:
> >>> From: Christoph Hellwig <hch@lst.de>
> >>>
> >>> commit 262e6ae7081df304fc625cf368d5c2cbba2bb991 upstream.
> >>>
> >>> If a TAINT_PROPRIETARY_MODULE exports symbol, inherit the taint flag
> >>> for all modules importing these symbols, and don't allow loading
> >>> symbols from TAINT_PROPRIETARY_MODULE modules if the module previously
> >>> imported gplonly symbols.  Add a anti-circumvention devices so people
> >>> don't accidentally get themselves into trouble this way.
> >>>
> >>> Comment from Greg:
> >>>   "Ah, the proven-to-be-illegal "GPL Condom" defense :)"
> >>
> >> Patch got in to stable, so my comments are quite late, but can someone
> >> explain me - how this is a stable material? What specific, real bug that
> >> bothers people, is being fixed here? Or maybe it fixes serious issue
> >> reported by a user of distribution kernel? IOW, how does this match
> >> stable kernel rules at all?
> >>
> >> For sure it breaks some out-of-tree modules already present and used by
> >> customers of downstream stable kernels. Therefore I wonder what is the
> >> bug fixed here, so the breakage and annoyance of stable users is justified.
> > 
> > It fixes a reported bug in that somehow symbols are being exported to
> > modules that should not have been.  This has been in mainline and newer
> > stable releases for quite some time, it should not be a suprise that
> > this was backported further as well.
> 
> This is vague. What exactly is the bug? How exporting symbols which
> should not be exported, causes it? Is there OOPs? Some feature does not
> work?

The bug/issue is that symbols were being incorrectly exported in ways
that they should not have been and were available to users that should
not have been able to use them.  That is what this patch series
resolves.  I can go into details but they are boring and deal with
closed source monstrosities that feel they are allowed to muck around in
kernel internals at will, which causes a support burden on the kernel
community.

If you object to this, that's fine, you are free to revert them in your
local distro kernel after discussing it with your lawyers to get their
approval to do so.

thanks,

greg k-h
