Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCDF6E5D51
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 11:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbjDRJ2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 05:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbjDRJ2M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 05:28:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1683E170E;
        Tue, 18 Apr 2023 02:28:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4B98623D5;
        Tue, 18 Apr 2023 09:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B476EC433EF;
        Tue, 18 Apr 2023 09:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681810090;
        bh=LplBaAfiQN63yKSqWMsQVi8bs1BiaFM52dC7sMKWPZ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SHbE3VNR/WwjzDYQNg2o/1AmILBYDwf4FE0A0zBuEzDtaU/vG43snOtOnptRO7hKv
         3jKr4VxEDAaltjV1qkHWmgtva3kkxtGsofA14eMM9OolRbtm6saofpjHuHx02NvbKy
         aSV29vf9iGR2aS8bJ/Wyje+U1N0RAuOjdcP2AD5c=
Date:   Tue, 18 Apr 2023 11:28:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     cuigaosheng <cuigaosheng1@huawei.com>
Cc:     stable@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 5.10 1/4] crypto: api - Fix built-in testing dependency
 failures
Message-ID: <2023041809-silicon-backspace-327d@gregkh>
References: <20230415101158.1648486-1-cuigaosheng1@huawei.com>
 <20230415101158.1648486-2-cuigaosheng1@huawei.com>
 <2023041513-sloppily-external-4c18@gregkh>
 <3f6315cc-4684-2121-3556-0ace47c29b35@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f6315cc-4684-2121-3556-0ace47c29b35@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 16, 2023 at 03:22:18PM +0800, cuigaosheng wrote:
> On 2023/4/15 23:07, Greg KH wrote:
> > On Sat, Apr 15, 2023 at 06:11:55PM +0800, Gaosheng Cui wrote:
> > > From: Herbert Xu <herbert@gondor.apana.org.au>
> > > 
> > > When complex algorithms that depend on other algorithms are built
> > > into the kernel, the order of registration must be done such that
> > > the underlying algorithms are ready before the ones on top are
> > > registered.  As otherwise they would fail during the self-test
> > > which is required during registration.
> > > 
> > > In the past we have used subsystem initialisation ordering to
> > > guarantee this.  The number of such precedence levels are limited
> > > and they may cause ripple effects in other subsystems.
> > > 
> > > This patch solves this problem by delaying all self-tests during
> > > boot-up for built-in algorithms.  They will be tested either when
> > > something else in the kernel requests for them, or when we have
> > > finished registering all built-in algorithms, whichever comes
> > > earlier.
> > > 
> > > Reported-by: Vladis Dronov <vdronov@redhat.com>
> > > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> > > Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
> > > ---
> > >   crypto/algapi.c   | 73 +++++++++++++++++++++++++++++++++--------------
> > >   crypto/api.c      | 52 +++++++++++++++++++++++++++++----
> > >   crypto/internal.h | 10 +++++++
> > >   3 files changed, 108 insertions(+), 27 deletions(-)
> > What is the git commit id of this, and the other 3 patches, in Linus's
> > tree?  That is required to have here, as you know.
> > 
> > thanks,
> > 
> > greg k-h
> > .
> 
> Thanks for taking time to review these patch.
> 
> These patches are in Linus's tree, reference as follows:
>   Reference 1: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=adad556efcdd42a1d9e060cbe5f6161cccf1fa28
>   Reference 2: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=cad439fc040efe5f4381e3a7d583c5c200dbc186
>   Reference 3: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e42dff467ee688fe6b5a083f1837d06e3b27d8c0
>   Reference 4: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=beaaaa37c664e9afdf2913aee19185d8e3793b50

Please resend the patches with the git commit id in the changelog
somewhere, as is normally done (there are thousands of examples on the
mailing list.)

Also be sure that you are also backporting the patches to newer kernel
releases so that someone does not upgrade and have a regression (i.e. if
a patch is also needed in 5.15.y send a backport for that too.)

Thanks,

greg k-h
