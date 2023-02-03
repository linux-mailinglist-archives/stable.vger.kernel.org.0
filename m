Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 812C46892A1
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 09:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbjBCIsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 03:48:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjBCIsU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 03:48:20 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65EA9712D9;
        Fri,  3 Feb 2023 00:48:18 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pNrjw-0074w4-MK; Fri, 03 Feb 2023 16:48:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Feb 2023 16:48:12 +0800
Date:   Fri, 3 Feb 2023 16:48:12 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        stable@vger.kernel.org, Vladis Dronov <vdronov@redhat.com>,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: Re: [PATCH] crypto: qat - fix out-of-bounds read
Message-ID: <Y9zKTHFvYHrmfqdW@gondor.apana.org.au>
References: <20230201155944.23379-1-giovanni.cabiddu@intel.com>
 <Y9xduyjbaxFdaCUT@gondor.apana.org.au>
 <Y9yrZk9KnICxqkZp@gcabiddu-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9yrZk9KnICxqkZp@gcabiddu-mobl1.ger.corp.intel.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_SOFTFAIL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 03, 2023 at 06:36:22AM +0000, Giovanni Cabiddu wrote:
>
> The content descriptor structure (cd) is already initialized to zero
> before the function qat_alg_skcipher_init_com() is called.
> This is done in
>   (1) qat_alg_skcipher_newkey() implicitly by dma_alloc_coherent(),
>       the first time setkey() is called for a tfm or

Sorry but what zeroes the memory in this case? The only zeroing
I can find in newkey is when you free the memory.

>   (2) qat_alg_skcipher_rekey() explicitly, for subsequent calls to
>       sekey().

This looks fine.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
