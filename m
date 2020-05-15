Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC591D59CB
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 21:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgEOTRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 15:17:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgEOTRG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 May 2020 15:17:06 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9E7E20727;
        Fri, 15 May 2020 19:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589570226;
        bh=XBx66mGVJ7Tbb+phuQ5uMEEIItH+a9pVZe/h/WYga1s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1UWKkNNKCuIzrl5u6+/k8AYmsz01h1u+HcEBJ/L4lKNuC3iBVSz/ZOmmaLj2uBfL7
         ccDTssausF1EHjwGCk5y0XHUwHVwYRWaSsoGGmaIz2XUhlgAYJXiRdhDUn4GSKxFP9
         4VHfJV9HpwUW4vcJPE890Gi8KFTgoAPCFWyG//Xw=
Date:   Fri, 15 May 2020 12:17:04 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        Richard Weinberger <richard@nod.at>
Cc:     linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ubifs: fix wrong use of crypto_shash_descsize()
Message-ID: <20200515191704.GE1009@sol.localdomain>
References: <20200502055945.1008194-1-ebiggers@kernel.org>
 <20200504071644.GS5877@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504071644.GS5877@pengutronix.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 04, 2020 at 09:16:44AM +0200, Sascha Hauer wrote:
> On Fri, May 01, 2020 at 10:59:45PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > crypto_shash_descsize() returns the size of the shash_desc context
> > needed to compute the hash, not the size of the hash itself.
> > 
> > crypto_shash_digestsize() would be correct, or alternatively using
> > c->hash_len and c->hmac_desc_len which already store the correct values.
> > But actually it's simpler to just use stack arrays, so do that instead.
> > 
> > Fixes: 49525e5eecca ("ubifs: Add helper functions for authentication support")
> > Fixes: da8ef65f9573 ("ubifs: Authenticate replayed journal")
> > Cc: <stable@vger.kernel.org> # v4.20+
> > Cc: Sascha Hauer <s.hauer@pengutronix.de>
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Looks better that way, thanks.
> 
> Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
> 

Richard, could you take this through the ubifs tree for 5.8?

- Eric
