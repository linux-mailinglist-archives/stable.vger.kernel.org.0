Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17F827BD95
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 11:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727613AbfGaJol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 05:44:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfGaJol (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 05:44:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 950EC20665;
        Wed, 31 Jul 2019 09:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564566280;
        bh=9CQh+fppQvTOStqKiDukaYM+WtmIth11V+qgBeMjt+A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sb9wX3khpHjNdMDeSXgabrCnsVy1VQdsirBRGsSkZefxPDFxwgFvayNvYQ7LDrlc8
         VGzqK1UvFOOC+oQsLd80o1+z7HDCc22ryiDnx9I5biBBtaob69W2fz0tIGMHrYIDYn
         HkIfyE4+xpuCgC6CsveV9sbGGQSfxxLWZUR/lnPc=
Date:   Wed, 31 Jul 2019 11:44:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Amit Pundir <amit.pundir@linaro.org>
Cc:     Stable <stable@vger.kernel.org>, Wen Yang <wen.yang99@zte.com.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Armijn Hemel <armijn@tjaldur.nl>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH for-4.14.y 3/3] crypto: crypto4xx - fix a potential
 double free in ppc4xx_trng_probe
Message-ID: <20190731094437.GF18269@kroah.com>
References: <1564517913-17164-1-git-send-email-amit.pundir@linaro.org>
 <1564517913-17164-3-git-send-email-amit.pundir@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564517913-17164-3-git-send-email-amit.pundir@linaro.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 31, 2019 at 01:48:33AM +0530, Amit Pundir wrote:
> From: Wen Yang <wen.yang99@zte.com.cn>
> 
> commit 95566aa75cd6b3b404502c06f66956b5481194b3 upstream.
> 
> There is a possible double free issue in ppc4xx_trng_probe():
> 
> 85:	dev->trng_base = of_iomap(trng, 0);
> 86:	of_node_put(trng);          ---> released here
> 87:	if (!dev->trng_base)
> 88:		goto err_out;
> ...
> 110:	ierr_out:
> 111:		of_node_put(trng);  ---> double released here
> ...
> 
> This issue was detected by using the Coccinelle software.
> We fix it by removing the unnecessary of_node_put().
> 
> Fixes: 5343e674f32f ("crypto4xx: integrate ppc4xx-rng into crypto4xx")
> Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
> Cc: <stable@vger.kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Allison Randal <allison@lohutok.net>
> Cc: Armijn Hemel <armijn@tjaldur.nl>
> Cc: Julia Lawall <Julia.Lawall@lip6.fr>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
> ---
> Cleanly apply on 4.9.y as well.

This is already in the 4.14.135 kernel release.  Are you sure we need it
there again?

thanks,

greg k-h
