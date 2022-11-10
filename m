Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A710E623B29
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 06:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiKJFRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 00:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiKJFRl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 00:17:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E802098F;
        Wed,  9 Nov 2022 21:17:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA35BB8204F;
        Thu, 10 Nov 2022 05:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF9EC433D6;
        Thu, 10 Nov 2022 05:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668057457;
        bh=U7Ij5rr5CuBSj0KhRp8f5GgpbSuZW4Sm6iJWVpUw4pA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gcoh40LFPAc6tVx3NzisbmxoaRi1SpDqFGBSoT1xD8fLzrMMdF0MsK4n4PePkaxjQ
         Xc4Jn2yx3I39PltG7smnKHuZytIclyT0Xt3t0OhNrhxT5+8fRBMPF7wIK6FVyKkcjF
         p0Fu66v6zh0yNr+gxZT/AIDPHMLPF5hYpSanrZE1IQJe/F+d/o5XNIFm5WNleR30a9
         gc2Et23gQqUEUNe5+rXkZTZq55rS99Zuc0zPllsOiRvrueZxjnLr5VQJPd4eiHNEjX
         d1KQvD0GrCZU98frnIXyJEEd65EF7q9DGzghaYk1rDDTZp8jZ0vj6iBZa5p78a53Qo
         6eLdaijY541bA==
Date:   Wed, 9 Nov 2022 21:17:35 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] crypto: avoid unnecessary work when self-tests are
 disabled
Message-ID: <Y2yJbxnin1MMpA9r@sol.localdomain>
References: <20221110023738.147128-1-ebiggers@kernel.org>
 <MW5PR84MB18426B2DDE014FBE9F91C016AB019@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW5PR84MB18426B2DDE014FBE9F91C016AB019@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 10, 2022 at 04:36:17AM +0000, Elliott, Robert (Servers) wrote:
> 
> > -----Original Message-----
> > From: Eric Biggers <ebiggers@kernel.org>
> > Sent: Wednesday, November 9, 2022 8:38 PM
> > Subject: [PATCH] crypto: avoid unnecessary work when self-tests are
> > disabled
> > 
> > Currently, registering an algorithm with the crypto API always causes a
> > notification to be posted to the "cryptomgr", which then creates a
> > kthread to self-test the algorithm.  However, if self-tests are disabled
> > in the kconfig (as is the default option), then this kthread just
> > notifies waiters that the algorithm has been tested, then exits.
> > 
> > This causes a significant amount of overhead, especially in the kthread
> > creation and destruction, which is not necessary at all.  For example,
> > in a quick test I found that booting a "minimum" x86_64 kernel with all
> > the crypto options enabled (except for the self-tests) takes about 400ms
> > until PID 1 can start.  Of that, a full 13ms is spent just doing this
> > pointless dance, involving a kthread being created, run, and destroyed
> > over 200 times.  That's over 3% of the entire kernel start time.
> > 
> > Fix this by just skipping the creation of the test larval and the
> > posting of the registration notification entirely, when self-tests are
> > disabled.  Also compile out the unnecessary code in algboss.c.
> > 
> ...
> > +#ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
> > +static int cryptomgr_schedule_test(struct crypto_alg *alg)
> > +{
> > +	return 0;
> > +}
> > +#else
> 
> The crypto/kdf_sp800108.c init function currently ignores both 
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS and the cryptomgr module's
> notests module parameter and always runs its self-test, as described in
> https://lore.kernel.org/lkml/MW5PR84MB1842811C4EECC0F4B35B5FB3AB709@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM/T/#t
> 
> Paul reported that taking 262 ms on his system; I measured 1.4 s on
> my system.
> 
> It'd be nice if a patch series improving how DISABLE_TESTS is honored
> would tackle that module too.

That should be a separate patch, but yes, it should only run the test if
!IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS), like what everywhere else
does.

- Eric
