Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58D334C2141
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 02:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiBXBsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 20:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiBXBr5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 20:47:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301851A3A9;
        Wed, 23 Feb 2022 17:47:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDAD2B82355;
        Thu, 24 Feb 2022 01:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC8BC340E7;
        Thu, 24 Feb 2022 01:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645667245;
        bh=sCX7LzdLIdSqvaigD4FToB9/z+1YgqNv/qwnaTVAbHI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ur7EyzAH9ZcNYgRVcmNTzBDaXF5XSMZ0PuMiWeSmdccrs2mrnd/enBEJLSDLaq+zB
         6ZpJxBIWbnsRADPgWRUR5snmpdCNpCbR4avXXvIqd4GNWTxqLEDH0AmK/Gzn8fmsXP
         /gCfMavgBiJ45ajtxHpJrPNQrthzejKzSE4YhEsPDpvw8LmbMX+rkMuuV0P86tZmvc
         qMG+w0LFVuIkHVvEUqB7bTIfUf+G5O0UXw+rvkGY4YThRdstdRlWsLaHLOrtxVwoQh
         JZMg1xolqUI74KINDObCAmqOBlDZmKazxkkWZaORpwK1UfmisPEqX0Ner9dIcf3elh
         pxXH+wSLIqmfg==
Date:   Wed, 23 Feb 2022 17:47:23 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: drbg: fix crypto api abuse
Message-ID: <Yhbjq3cVsMVUQLio@sol.localdomain>
References: <20220223080400.139367-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223080400.139367-1-gilad@benyossef.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 23, 2022 at 10:04:00AM +0200, Gilad Ben-Yossef wrote:
> the drbg code was binding the same buffer to two different
> scatter gather lists and submitting those as source and
> destination to a crypto api operation, thus potentially
> causing HW crypto drivers to perform overlapping DMA
> mappings which are not aware it is the same buffer.
> 
> This can have serious consequences of data corruption of
> internal DRBG buffers and wrong RNG output.
> 
> Fix this by reusing the same scatter gatther list for both
> src and dst.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> Tested-on: r8a7795-salvator-x
> Tested-on: xilinx-zc706
> Fixes: 43490e8046b5d ("crypto: drbg - in-place cipher operation for CTR")
> Cc: stable@vger.kernel.org

Where is it documented and tested that the API doesn't allow this?
I wasn't aware of this case; it sounds perfectly allowed to me.
There might be a lot of other users who do this, not just drbg.c.

- Eric
