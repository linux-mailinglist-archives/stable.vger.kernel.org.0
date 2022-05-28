Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBAE1536DEC
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 19:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238984AbiE1RTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 May 2022 13:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238811AbiE1RTl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 May 2022 13:19:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D65396;
        Sat, 28 May 2022 10:19:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DFBCB8013C;
        Sat, 28 May 2022 17:19:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E70C34100;
        Sat, 28 May 2022 17:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653758378;
        bh=G7tf9YJZazhJ3zj5XmFBFb8oMtPMYs1ILDRcunfXUOw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MP6gqjJmOFpiYtR3HghPFwUhJrMNT0RmD8A+6eDYU8B1VGfcdBY1O3KDKETkvziu7
         3eiXllmFK7KgLQr+WfEVA8nkjLGleKFyF5bAguuFNDo2hGVtYjN5izZ2MWBXPGU9MD
         qCe9ccojxK/hG5lnmw++VzHHYa7gX1b0ZUJszymADCHhxKPu013WxCf1wuPOuzc0q9
         H60xgPVGjlERTEUil+BvTb4FnuqqKFW0tlh5twnHiSvCKzlvzK5YP4japU4P4iHEZc
         4rT/mo37jaerJwjwGhHRbKcBWCtI1llWueCSBpiw980ZnYjv9gEATsq9lU5PAySFXv
         s6Kst1tf92l8w==
Date:   Sat, 28 May 2022 10:19:36 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, gaochao <gaochao49@huawei.com>,
        Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH crypto v2] crypto: blake2s - remove shash module
Message-ID: <YpJZqJd9j1gEOdTe@sol.localdomain>
References: <YpCGQvpirQWaAiRF@zx2c4.com>
 <20220527081106.63227-1-Jason@zx2c4.com>
 <YpGeIT1KHv9QwF4X@sol.localdomain>
 <YpHx7arH4lLaZuhm@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YpHx7arH4lLaZuhm@zx2c4.com>
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 28, 2022 at 11:57:01AM +0200, Jason A. Donenfeld wrote:
> > Also, the wrong value is being passed for the 'inc' argument.
> 
> Are you sure? Not sure I'm seeing what you are on first glance.

Yes, 'inc' is the increment amount per block.  It needs to always be
BLAKE2S_BLOCK_SIZE unless a partial block is being processed.

- Eric
