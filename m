Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBAA569176D
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 04:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbjBJD4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 22:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjBJD4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 22:56:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD27B6F224;
        Thu,  9 Feb 2023 19:56:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78B6C61488;
        Fri, 10 Feb 2023 03:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B036C4339B;
        Fri, 10 Feb 2023 03:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676001393;
        bh=NZY1/v8Sk6GLpz/11I4nuyXPEbK3cemp/lGf/ubXeZ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AZuZJLFrbFS2b9ruw9wyTmroDDqdugku3LVd3lAzxtIxZYxFTAOgLYS4IAPPh260M
         +nRJULnBe//Su9Rhde6oHCb+n6ys2cUpoz3gnfW1+ZEF24W3FmnjysBF5ZqsQzWkgP
         SXzDJT/JWxIDLzR+o7n335pQFpU3sdP+vaYhRtMDbukcbfcuAMWbHbkIpp2YEEjN3D
         NK6IXAJMFd6w/YHCQdRQa5yrEfaSnZD7c+hAapVuvm+806OKBCB536iK+mU34gOioE
         ffmdnDtM4rzSoaWJRTXLia5OVXQuxzY9KgMNw37oSVvg0SwD/c5bgGcosmA9P4qtPT
         K+Uxn+6+fIdng==
Date:   Fri, 10 Feb 2023 05:56:31 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Paul Moore <paul@paul-moore.com>
Cc:     David Howells <dhowells@redhat.com>,
        Roberto Sassu <roberto.sassu@huaweicloud.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, jmorris@namei.org,
        serge@hallyn.com, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v5 2/2] KEYS: asymmetric: Copy sig and digest in
 public_key_verify_signature()
Message-ID: <Y+XAbz6YmazGNFQr@kernel.org>
References: <20221227142740.2807136-1-roberto.sassu@huaweicloud.com>
 <20221227142740.2807136-3-roberto.sassu@huaweicloud.com>
 <Y64XB0yi24yjeBDw@sol.localdomain>
 <d2a54ddec403cad12c003132542070bf781d5e26.camel@huaweicloud.com>
 <857eedc5ad18eddae7686dca63cf8c613a051be4.camel@huaweicloud.com>
 <Y+VBMQEwPTPGBIpP@gmail.com>
 <CAHC9VhTYeqCB8roaNvWUYJeKPwT35ixJ8MMXBe0v0+a9o8CXWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhTYeqCB8roaNvWUYJeKPwT35ixJ8MMXBe0v0+a9o8CXWw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 09, 2023 at 05:46:32PM -0500, Paul Moore wrote:
> On Thu, Feb 9, 2023 at 1:53 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > On Thu, Feb 09, 2023 at 11:49:19AM +0100, Roberto Sassu wrote:
> > > On Fri, 2023-01-27 at 09:27 +0100, Roberto Sassu wrote:
> > > > On Thu, 2022-12-29 at 14:39 -0800, Eric Biggers wrote:
> > > > > On Tue, Dec 27, 2022 at 03:27:40PM +0100, Roberto Sassu wrote:
> > > > > > From: Roberto Sassu <roberto.sassu@huawei.com>
> > > > > >
> > > > > > Commit ac4e97abce9b8 ("scatterlist: sg_set_buf() argument must be in linear
> > > > > > mapping") checks that both the signature and the digest reside in the
> > > > > > linear mapping area.
> > > > > >
> > > > > > However, more recently commit ba14a194a434c ("fork: Add generic vmalloced
> > > > > > stack support") made it possible to move the stack in the vmalloc area,
> > > > > > which is not contiguous, and thus not suitable for sg_set_buf() which needs
> > > > > > adjacent pages.
> > > > > >
> > > > > > Always make a copy of the signature and digest in the same buffer used to
> > > > > > store the key and its parameters, and pass them to sg_init_one(). Prefer it
> > > > > > to conditionally doing the copy if necessary, to keep the code simple. The
> > > > > > buffer allocated with kmalloc() is in the linear mapping area.
> > > > > >
> > > > > > Cc: stable@vger.kernel.org # 4.9.x
> > > > > > Fixes: ba14a194a434 ("fork: Add generic vmalloced stack support")
> > > > > > Link: https://lore.kernel.org/linux-integrity/Y4pIpxbjBdajymBJ@sol.localdomain/
> > > > > > Suggested-by: Eric Biggers <ebiggers@kernel.org>
> > > > > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > > > > > ---
> > > > > >  crypto/asymmetric_keys/public_key.c | 38 ++++++++++++++++-------------
> > > > > >  1 file changed, 21 insertions(+), 17 deletions(-)
> > > > >
> > > > > Reviewed-by: Eric Biggers <ebiggers@google.com>
> > > >
> > > > Hi David
> > > >
> > > > could you please take this patch in your repo, if it is ok?
> > >
> > > Kindly ask your support here. Has this patch been queued somewhere?
> > > Wasn't able to find it, also it is not in linux-next.
> > >
> >
> > The maintainer of asymmetric_keys (David Howells) is ignoring this patch, so
> > you'll need to find someone else to apply it.  Herbert Xu, the maintainer of the
> > crypto subsystem, might be willing to apply it.  Or maybe Jarkko Sakkinen, who
> > is a co-maintainer of the keyrings subsystem (but not asymmetric_keys, for some
> > reason; should that change?).
> 
> It is problematic that David isn't replying to this.  I have no idea
> if it will work, but I just reached out to him to see if I can draw
> his attention back to this ...

See my response to Eric.

BR, Jarkko
