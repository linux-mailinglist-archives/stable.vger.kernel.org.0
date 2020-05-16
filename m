Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0901D5DAB
	for <lists+stable@lfdr.de>; Sat, 16 May 2020 03:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgEPBfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 21:35:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbgEPBfL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 May 2020 21:35:11 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DC8520671;
        Sat, 16 May 2020 01:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589592910;
        bh=A/YvaDksaFu99ghPmbMTUGhjLsi3EZ2qYC3LCwM1LwA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FCMPtDYJZcw2/loDgsY3buAEdq4MaFDRI7UZDPxP5gepuaSB8WfcULS3g2o24Y1TS
         9mdJZvt0luVlxpROTQO7XI0TaX07kifa9ZQhWc3EaWqTS08KEjCd1DFoj1uEOcRoUA
         yhKwDQLo3fV9GeVMpsSciRYU3i9zSMLQQDvVPm+0=
Date:   Fri, 15 May 2020 18:35:09 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.14 39/39] crypto: xts - simplify error handling
 in ->create()
Message-ID: <20200516013509.GA118329@gmail.com>
References: <20200514185456.21060-1-sashal@kernel.org>
 <20200514185456.21060-39-sashal@kernel.org>
 <20200514190843.GA187179@gmail.com>
 <20200515005530.GD29995@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515005530.GD29995@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 14, 2020 at 08:55:30PM -0400, Sasha Levin wrote:
> On Thu, May 14, 2020 at 12:08:43PM -0700, Eric Biggers wrote:
> > On Thu, May 14, 2020 at 02:54:56PM -0400, Sasha Levin wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > [ Upstream commit 732e540953477083082e999ff553622c59cffd5f ]
> > > 
> > > Simplify the error handling in the XTS template's ->create() function by
> > > taking advantage of crypto_drop_skcipher() now accepting (as a no-op) a
> > > spawn that hasn't been grabbed yet.
> > > 
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > 
> > Please don't backport this patch.  It's a cleanup (not a fix) that depends on
> > patches in 5.6, which you don't seem to be backporting.
> 
> For 5.6-4.19 I grabbed these to take:
> 
> 	1a263ae60b04 ("gcc-10: avoid shadowing standard library 'free()' in crypto")
> 
> cleanly. I'll drop it as it's mostly to avoid silly gcc10 warnings, but
> I just wanted to let you know the reason they ended up here.
> 

If the gcc 10 warning fix is needed, then you should just backport it on its
own.  It just renames a function, so it seems it's trivial to fix the conflict?

- Eric
