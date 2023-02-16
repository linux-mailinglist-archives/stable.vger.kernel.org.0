Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD53698D79
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 07:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjBPG6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 01:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjBPG6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 01:58:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4342911165;
        Wed, 15 Feb 2023 22:58:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D390DB825BC;
        Thu, 16 Feb 2023 06:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E06AC433D2;
        Thu, 16 Feb 2023 06:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676530718;
        bh=2FqkwkZjiBPavFp1l2RKoVJVfxS4Y70fRW3GIwt8mFQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N+7mz4VFp532ugW2m0Vzn0nQcLmlcW8gUWBN/P9xeIvLzkoI+ysmtlfu7GlKRYwFb
         tNCJzL28MOHGAkSaQULBmpxdq9uizMkZsM6u797NC4DQt8kKwD/XlWL6B+J/WdTNVf
         cubS79kYC5swxO7uZ2YihEDpvHi7XydZZOP4+Y1U=
Date:   Thu, 16 Feb 2023 07:58:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc:     "# v4 . 16+" <stable@vger.kernel.org>,
        Xiu Jianfeng <xiujianfeng@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dan Williams <dan.j.williams@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH stable v5.15.y 1/1] crypto: add __init/__exit annotations
 to init/exit funcs
Message-ID: <Y+3UGwHNMbTQq7bF@kroah.com>
References: <20230214195300.2432989-1-saeed.mirzamohammadi@oracle.com>
 <20230214195300.2432989-2-saeed.mirzamohammadi@oracle.com>
 <Y+yBxXNjBLuonPKP@kroah.com>
 <281CF1A3-C16D-4598-B741-B1128DA97B5B@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <281CF1A3-C16D-4598-B741-B1128DA97B5B@oracle.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 15, 2023 at 11:10:14PM +0000, Saeed Mirzamohammadi wrote:
> Hi,
> 
> > On Feb 14, 2023, at 10:55 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > 
> > On Tue, Feb 14, 2023 at 11:53:00AM -0800, Saeed Mirzamohammadi wrote:
> >> From: Xiu Jianfeng <xiujianfeng@huawei.com>
> >> 
> >> Add missing __init/__exit annotations to init/exit funcs.
> >> 
> >> Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
> >> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> >> (cherry picked from commit 33837be33367172d66d1f2bd6964cc41448e6e7c)
> >> Cc: stable@vger.kernel.org # 5.15+
> >> Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
> >> ---
> >> crypto/async_tx/raid6test.c | 4 ++--
> >> crypto/curve25519-generic.c | 4 ++--
> >> crypto/dh.c                 | 4 ++--
> >> crypto/ecdh.c               | 4 ++--
> >> crypto/ecdsa.c              | 4 ++--
> >> crypto/rsa.c                | 4 ++--
> >> crypto/sm2.c                | 4 ++--
> >> 7 files changed, 14 insertions(+), 14 deletions(-)
> > 
> > What bug/problem does this resolve?  Why is this needed in stable
> > kernels?
> 
> I don’t have any specific bug to discuss for this fix. It would help freeing up some memory after initialization for these crypto modules since the init function is only called once but not addressing any major issue. Feel free to disregard if this is trivial for stable.

Exactly how much memory is actually freed here and why is that required
for a stable kernel?

Please read the kernel documentation for what is considered a valid
stable kernel change:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

thanks,

greg k-h
