Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF5C3AC74E
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 11:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhFRJXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 05:23:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231841AbhFRJXP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Jun 2021 05:23:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A3B3613BA;
        Fri, 18 Jun 2021 09:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624008066;
        bh=2u8yVPlOkYeJNV+u1aRDZxR+tkmp6yjiZlW6piuN2E4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uVCOwqtKbl5no5WQYecnzyvH+SVo3t0/UhXe9HRF6XBpqFFUYJ0WBgKcNU49kA/53
         eE5Ep4PUrCHHvGGEyNHuOeKDeuO/rYvmuW3uHPYbwyJHoSakOxseejz170im+ptFOK
         FYfnWtJHyLmQxToDCBsZls62cQMWL8CndKSDQleU=
Date:   Fri, 18 Jun 2021 11:21:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>, Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH 5.4 031/184] modules: inherit TAINT_PROPRIETARY_MODULE
Message-ID: <YMxlgKNV/m/fz8Qs@kroah.com>
References: <20210510101950.200777181@linuxfoundation.org>
 <20210510101951.249384110@linuxfoundation.org>
 <8edc6f45-6c42-19c7-6f40-6f1a49cc685b@canonical.com>
 <08a2e600-74cf-dbf8-1ecc-777ff65e06b0@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08a2e600-74cf-dbf8-1ecc-777ff65e06b0@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 18, 2021 at 10:59:50AM +0200, Krzysztof Kozlowski wrote:
> On 18/06/2021 10:57, Krzysztof Kozlowski wrote:
> > On 10/05/2021 12:18, Greg Kroah-Hartman wrote:
> >> From: Christoph Hellwig <hch@lst.de>
> >>
> >> commit 262e6ae7081df304fc625cf368d5c2cbba2bb991 upstream.
> >>
> >> If a TAINT_PROPRIETARY_MODULE exports symbol, inherit the taint flag
> >> for all modules importing these symbols, and don't allow loading
> >> symbols from TAINT_PROPRIETARY_MODULE modules if the module previously
> >> imported gplonly symbols.  Add a anti-circumvention devices so people
> >> don't accidentally get themselves into trouble this way.
> >>
> >> Comment from Greg:
> >>   "Ah, the proven-to-be-illegal "GPL Condom" defense :)"
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
> And for the record I am not talking about this patch only. I am asking
> also what serious or real bug is being fixed by:
> "modules: mark find_symbol static
> find_symbol is only used in module.c."

That was part of the patch series, I needed pretty much the whole thing
to be able to apply them cleanly.  We always try to match what is in
Linus's tree exactly so we can correctly track things, one-off backports
are almost always broken and wrong.

And no one should be ever using find_symbol(), that's just a given.

thanks,

greg k-h
