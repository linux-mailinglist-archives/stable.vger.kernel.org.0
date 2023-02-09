Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 851FE6910C9
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 19:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjBISxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 13:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbjBISxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 13:53:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4655860D79;
        Thu,  9 Feb 2023 10:53:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B52261B9F;
        Thu,  9 Feb 2023 18:53:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C76C4339B;
        Thu,  9 Feb 2023 18:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675968819;
        bh=/EJIsbHlXYqxqRDnynhzcObanhAGUH6x/EXbOvBSPik=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nwn2gcag7jq/vB794G8EMIyOYd6GFKDmOrPKUYpi1Ma2ao0645MDlyMG9B0BPd9bj
         x5g0gxl5qNvq4ROdQhl3wlU+VCl6SFuuZR4hC9kNKIpJkFWxnpQyQH6fR54uatpA2Q
         MdKgfOJKlNEPHiZSDlwCu1FJTCLJz10Nmm5+C3KYNdcH7V1M1XCqpwjymCay2UbIWK
         Tmg5Xsfn9BppBIF67pg8TBhlu51atrshG/gng8ysA7iKAOULKTrYY9F1sdV5rX6eHu
         f8fjbSDrVGGxNc+121Yzw5NR4KnE+w1BVHDDxlq4mVVLEGf/EbEV+Bv4Raqiv9V2YL
         oxWX0UAtc1mSg==
Date:   Thu, 9 Feb 2023 18:53:37 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     davem@davemloft.net, zohar@linux.ibm.com,
        dmitry.kasatkin@gmail.com, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>
Subject: Re: [PATCH v5 2/2] KEYS: asymmetric: Copy sig and digest in
 public_key_verify_signature()
Message-ID: <Y+VBMQEwPTPGBIpP@gmail.com>
References: <20221227142740.2807136-1-roberto.sassu@huaweicloud.com>
 <20221227142740.2807136-3-roberto.sassu@huaweicloud.com>
 <Y64XB0yi24yjeBDw@sol.localdomain>
 <d2a54ddec403cad12c003132542070bf781d5e26.camel@huaweicloud.com>
 <857eedc5ad18eddae7686dca63cf8c613a051be4.camel@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <857eedc5ad18eddae7686dca63cf8c613a051be4.camel@huaweicloud.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 09, 2023 at 11:49:19AM +0100, Roberto Sassu wrote:
> On Fri, 2023-01-27 at 09:27 +0100, Roberto Sassu wrote:
> > On Thu, 2022-12-29 at 14:39 -0800, Eric Biggers wrote:
> > > On Tue, Dec 27, 2022 at 03:27:40PM +0100, Roberto Sassu wrote:
> > > > From: Roberto Sassu <roberto.sassu@huawei.com>
> > > > 
> > > > Commit ac4e97abce9b8 ("scatterlist: sg_set_buf() argument must be in linear
> > > > mapping") checks that both the signature and the digest reside in the
> > > > linear mapping area.
> > > > 
> > > > However, more recently commit ba14a194a434c ("fork: Add generic vmalloced
> > > > stack support") made it possible to move the stack in the vmalloc area,
> > > > which is not contiguous, and thus not suitable for sg_set_buf() which needs
> > > > adjacent pages.
> > > > 
> > > > Always make a copy of the signature and digest in the same buffer used to
> > > > store the key and its parameters, and pass them to sg_init_one(). Prefer it
> > > > to conditionally doing the copy if necessary, to keep the code simple. The
> > > > buffer allocated with kmalloc() is in the linear mapping area.
> > > > 
> > > > Cc: stable@vger.kernel.org # 4.9.x
> > > > Fixes: ba14a194a434 ("fork: Add generic vmalloced stack support")
> > > > Link: https://lore.kernel.org/linux-integrity/Y4pIpxbjBdajymBJ@sol.localdomain/
> > > > Suggested-by: Eric Biggers <ebiggers@kernel.org>
> > > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > > > ---
> > > >  crypto/asymmetric_keys/public_key.c | 38 ++++++++++++++++-------------
> > > >  1 file changed, 21 insertions(+), 17 deletions(-)
> > > 
> > > Reviewed-by: Eric Biggers <ebiggers@google.com>
> > 
> > Hi David
> > 
> > could you please take this patch in your repo, if it is ok?
> 
> Kindly ask your support here. Has this patch been queued somewhere?
> Wasn't able to find it, also it is not in linux-next.
> 

The maintainer of asymmetric_keys (David Howells) is ignoring this patch, so
you'll need to find someone else to apply it.  Herbert Xu, the maintainer of the
crypto subsystem, might be willing to apply it.  Or maybe Jarkko Sakkinen, who
is a co-maintainer of the keyrings subsystem (but not asymmetric_keys, for some
reason; should that change?).

- Eric
