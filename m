Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43B95154C21
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 20:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgBFTYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 14:24:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:59674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727738AbgBFTYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Feb 2020 14:24:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B259520659;
        Thu,  6 Feb 2020 19:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581017078;
        bh=PP6R51yDCaaxvqfN3MLLQLCcK3TRuUTekb4oV0BJCVo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nuIO32KMhWnE4eakoTdOQLEQ8FLCooE9k9oYA/aL1+MWc2wyxrqU25EqtMS8h/m21
         VIvtV4NOJGtagpZXOiXbmS6tfttl5lVoSnjZH3wVGXJkLB/AS2fAfDnLo+ktOBw3mi
         mpyn2EQsHyNV4SdrlMPpkL9QCD5xpluYySf5Xu1Q=
Date:   Thu, 6 Feb 2020 20:05:02 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Florian Bezdeka <florian@bezdeka.de>
Cc:     stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4.19] crypto: geode-aes - convert to skcipher API and
 make thread-safe
Message-ID: <20200206190502.GA4096461@kroah.com>
References: <20200206171534.4051-1-florian@bezdeka.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206171534.4051-1-florian@bezdeka.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 06, 2020 at 06:15:34PM +0100, Florian Bezdeka wrote:
> commit 4549f7e5aa27ffc2cba63b5db8842a3b486f5688 upstream.
> 
> The geode AES driver is heavily broken because it stores per-request
> state in the transform context.  So it will crash or produce the wrong
> result if used by any of the many places in the kernel that issue
> concurrent requests for the same transform object.
> 
> This driver is also implemented using the deprecated blkcipher API,
> which makes it difficult to fix, and puts it among the drivers
> preventing that API from being removed.
> 
> Convert this driver to use the skcipher API, and change it to not store
> per-request state in the transform context.
> 
> Fixes: 9fe757b ("[PATCH] crypto: Add support for the Geode LX AES hardware")
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Florian Bezdeka <florian@bezdeka.de>
> ---
>  drivers/crypto/geode-aes.c | 442 ++++++++++++-------------------------
>  drivers/crypto/geode-aes.h |  15 +-
>  2 files changed, 149 insertions(+), 308 deletions(-)

Thanks for the backport, now applied.

greg k-h
