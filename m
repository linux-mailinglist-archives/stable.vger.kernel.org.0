Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA3C54613C
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 11:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348669AbiFJJPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 05:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347505AbiFJJOv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 05:14:51 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED6D1E7BCD;
        Fri, 10 Jun 2022 02:13:58 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nzaiF-005MT4-NF; Fri, 10 Jun 2022 19:13:53 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 Jun 2022 17:13:52 +0800
Date:   Fri, 10 Jun 2022 17:13:52 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     John Allen <john.allen@amd.com>
Cc:     linux-crypto@vger.kernel.org, seanjc@google.com,
        Thomas.Lendacky@amd.com, Ashish.Kalra@amd.com,
        linux-kernel@vger.kernel.org, theflow@google.com,
        rientjes@google.com, pgonda@google.com, stable@vger.kernel.org
Subject: Re: [PATCH v4] crypto: ccp - Use kzalloc for sev ioctl interfaces to
 prevent kernel memory leak
Message-ID: <YqMLUOQtcsNwU6xw@gondor.apana.org.au>
References: <20220518153126.265074-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518153126.265074-1-john.allen@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 18, 2022 at 03:31:26PM +0000, John Allen wrote:
> For some sev ioctl interfaces, input may be passed that is less than or
> equal to SEV_FW_BLOB_MAX_SIZE, but larger than the data that PSP
> firmware returns. In this case, kmalloc will allocate memory that is the
> size of the input rather than the size of the data. Since PSP firmware
> doesn't fully overwrite the buffer, the sev ioctl interfaces with the
> issue may return uninitialized slab memory.
> 
> Currently, all of the ioctl interfaces in the ccp driver are safe, but
> to prevent future problems, change all ioctl interfaces that allocate
> memory with kmalloc to use kzalloc and memset the data buffer to zero
> in sev_ioctl_do_platform_status.
> 
> Fixes: 38103671aad3 ("crypto: ccp: Use the stack and common buffer for status commands")
> Fixes: e799035609e15 ("crypto: ccp: Implement SEV_PEK_CSR ioctl command")
> Fixes: 76a2b524a4b1d ("crypto: ccp: Implement SEV_PDH_CERT_EXPORT ioctl command")
> Fixes: d6112ea0cb344 ("crypto: ccp - introduce SEV_GET_ID2 command")
> Cc: stable@vger.kernel.org
> Reported-by: Andy Nguyen <theflow@google.com>
> Suggested-by: David Rientjes <rientjes@google.com>
> Suggested-by: Peter Gonda <pgonda@google.com>
> Signed-off-by: John Allen <john.allen@amd.com>
> ---
> v2:
>   - Add fixes tags and CC stable@vger.kernel.org
> v3:
>   - memset data buffer to zero in sev_ioctl_do_platform_status
> v4:
>   - Add fixes tag for sev_ioctl_do_platform_status change
> ---
>  drivers/crypto/ccp/sev-dev.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
