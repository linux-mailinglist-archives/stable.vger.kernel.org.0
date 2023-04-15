Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C077F6E3209
	for <lists+stable@lfdr.de>; Sat, 15 Apr 2023 17:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjDOPHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 11:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjDOPHs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 11:07:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20AA340D6;
        Sat, 15 Apr 2023 08:07:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2F2160F91;
        Sat, 15 Apr 2023 15:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C094AC433D2;
        Sat, 15 Apr 2023 15:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681571266;
        bh=Fl/gTvlCoViEMPTAMS2nrZbrWPrbjIjS7GU06V6dev8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u9u+LEf76lHNymV/w4KL2lcwmfO18+8hx/35jXjq5vY+5OqkKYq7qQyQ7OK6kltOk
         OEwl6XVgEm58klJCMyABK+dUGW7ow1oXcuGHCDzx5aHkAuYphcQ4wtmKMnzWjPvnQU
         ysl3e5T/LBKNLMp5jSduI7KLdCBgVdh2prgkTRc8=
Date:   Sat, 15 Apr 2023 17:07:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     stable@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 5.10 1/4] crypto: api - Fix built-in testing dependency
 failures
Message-ID: <2023041513-sloppily-external-4c18@gregkh>
References: <20230415101158.1648486-1-cuigaosheng1@huawei.com>
 <20230415101158.1648486-2-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230415101158.1648486-2-cuigaosheng1@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 15, 2023 at 06:11:55PM +0800, Gaosheng Cui wrote:
> From: Herbert Xu <herbert@gondor.apana.org.au>
> 
> When complex algorithms that depend on other algorithms are built
> into the kernel, the order of registration must be done such that
> the underlying algorithms are ready before the ones on top are
> registered.  As otherwise they would fail during the self-test
> which is required during registration.
> 
> In the past we have used subsystem initialisation ordering to
> guarantee this.  The number of such precedence levels are limited
> and they may cause ripple effects in other subsystems.
> 
> This patch solves this problem by delaying all self-tests during
> boot-up for built-in algorithms.  They will be tested either when
> something else in the kernel requests for them, or when we have
> finished registering all built-in algorithms, whichever comes
> earlier.
> 
> Reported-by: Vladis Dronov <vdronov@redhat.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
> ---
>  crypto/algapi.c   | 73 +++++++++++++++++++++++++++++++++--------------
>  crypto/api.c      | 52 +++++++++++++++++++++++++++++----
>  crypto/internal.h | 10 +++++++
>  3 files changed, 108 insertions(+), 27 deletions(-)

What is the git commit id of this, and the other 3 patches, in Linus's
tree?  That is required to have here, as you know.

thanks,

greg k-h
