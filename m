Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 655CB4C215C
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 02:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiBXBxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 20:53:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiBXBxk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 20:53:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5A712AA2;
        Wed, 23 Feb 2022 17:53:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C4EBB82355;
        Thu, 24 Feb 2022 01:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A69C340E7;
        Thu, 24 Feb 2022 01:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645667589;
        bh=tH1Ehp45yMhjnidPxO18cnLpeXBVJiCxuD6d1ITrvac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YRFvwf3j72bXGqxXHEAy6m81H+GhjpOP+s1vcWdIQew5U/ceiExBEm4Zs4H3qHndr
         BWUUCc3uqi/t5bKtZu7Tsviz+5IzEekZBkjnG+hCv+51HtbQ72YZi1pp6XGaz2iOfy
         NDKizmDZEC8mVe2S9YjgbCtGz91V5NQA6nJQfQUw0b9Sxp8p9/38wOfxIGgy0csNoH
         xMqAYWFs8qr1BWdYPBrU6mf2HX8sPUpdw6NYk64j9ezVPNv3niKKpBDSnMcVHd5heq
         mUBVCTvcFN4RY+9zLzyl1cJ8oXQc9/Tn0IlsA+RoEtMN1SUhYSYYRqpEWy3sl3P9ZN
         qUmyOYitmVSPA==
Date:   Wed, 23 Feb 2022 17:53:07 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: drbg: fix crypto api abuse
Message-ID: <YhblA1qQ9XLb2nmO@sol.localdomain>
References: <20220223080400.139367-1-gilad@benyossef.com>
 <Yhbjq3cVsMVUQLio@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yhbjq3cVsMVUQLio@sol.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 23, 2022 at 05:47:25PM -0800, Eric Biggers wrote:
> On Wed, Feb 23, 2022 at 10:04:00AM +0200, Gilad Ben-Yossef wrote:
> > the drbg code was binding the same buffer to two different
> > scatter gather lists and submitting those as source and
> > destination to a crypto api operation, thus potentially
> > causing HW crypto drivers to perform overlapping DMA
> > mappings which are not aware it is the same buffer.
> > 
> > This can have serious consequences of data corruption of
> > internal DRBG buffers and wrong RNG output.
> > 
> > Fix this by reusing the same scatter gatther list for both
> > src and dst.
> > 
> > Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> > Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > Tested-on: r8a7795-salvator-x
> > Tested-on: xilinx-zc706
> > Fixes: 43490e8046b5d ("crypto: drbg - in-place cipher operation for CTR")
> > Cc: stable@vger.kernel.org
> 
> Where is it documented and tested that the API doesn't allow this?
> I wasn't aware of this case; it sounds perfectly allowed to me.
> There might be a lot of other users who do this, not just drbg.c.
> 

Just quickly looking through the code I maintain, there is another place that
uses scatterlists like this: in fscrypt_crypt_block() in fs/crypto/crypto.c, the
source and destination can be the same.  That's just the code I maintain; I'm
sure if you looked through the whole kernel you'd find a lot more.

This sounds more like a driver bug, and a case we need to add self-tests for.

- Eric
