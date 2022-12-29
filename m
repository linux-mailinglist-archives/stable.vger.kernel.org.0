Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500DF659284
	for <lists+stable@lfdr.de>; Thu, 29 Dec 2022 23:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbiL2WjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Dec 2022 17:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbiL2WjJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Dec 2022 17:39:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7289B14024;
        Thu, 29 Dec 2022 14:39:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12944B819CD;
        Thu, 29 Dec 2022 22:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AF5C433EF;
        Thu, 29 Dec 2022 22:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672353545;
        bh=Vl16ZrQ6FIVlc0MsbXC4FP4xe8sX0FhBJ0Zr7gy0p3k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RDiEvnsJ7m+xWx1JB3ZXOqwxK6gfQ7FhGem0LZdefcr//JxgTkvMhIyjggykSOjPg
         G43lW/GXie2JOFvIxuNZlN+IYJJnFvjb3nI5NOuCMwUo/ED57wAR+Aa6lwrshtNexq
         Kye9wmMjHimuhiRfKWJsta2EFquKEHR7lCLLZBPFY0vYzXVFyD/ZBN182WMYZA/6BX
         51utRGlceQI7eHvg0dJV0lb03uVjcgOnI/9+udBgzRmAOfZOyzzmrnCWiCfJb6TwFM
         m7jp72RYb6mVoOV4hM5DaWmX8O2ljVwfmbA8uuYoi7KSa3CLFlbzpyVsx0I1Wrz1wN
         IFMjGZyxi8r1Q==
Date:   Thu, 29 Dec 2022 14:39:03 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc:     dhowells@redhat.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, zohar@linux.ibm.com,
        dmitry.kasatkin@gmail.com, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>
Subject: Re: [PATCH v5 2/2] KEYS: asymmetric: Copy sig and digest in
 public_key_verify_signature()
Message-ID: <Y64XB0yi24yjeBDw@sol.localdomain>
References: <20221227142740.2807136-1-roberto.sassu@huaweicloud.com>
 <20221227142740.2807136-3-roberto.sassu@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221227142740.2807136-3-roberto.sassu@huaweicloud.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 27, 2022 at 03:27:40PM +0100, Roberto Sassu wrote:
> From: Roberto Sassu <roberto.sassu@huawei.com>
> 
> Commit ac4e97abce9b8 ("scatterlist: sg_set_buf() argument must be in linear
> mapping") checks that both the signature and the digest reside in the
> linear mapping area.
> 
> However, more recently commit ba14a194a434c ("fork: Add generic vmalloced
> stack support") made it possible to move the stack in the vmalloc area,
> which is not contiguous, and thus not suitable for sg_set_buf() which needs
> adjacent pages.
> 
> Always make a copy of the signature and digest in the same buffer used to
> store the key and its parameters, and pass them to sg_init_one(). Prefer it
> to conditionally doing the copy if necessary, to keep the code simple. The
> buffer allocated with kmalloc() is in the linear mapping area.
> 
> Cc: stable@vger.kernel.org # 4.9.x
> Fixes: ba14a194a434 ("fork: Add generic vmalloced stack support")
> Link: https://lore.kernel.org/linux-integrity/Y4pIpxbjBdajymBJ@sol.localdomain/
> Suggested-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  crypto/asymmetric_keys/public_key.c | 38 ++++++++++++++++-------------
>  1 file changed, 21 insertions(+), 17 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
