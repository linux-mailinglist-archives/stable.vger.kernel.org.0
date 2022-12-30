Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7784659648
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 09:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbiL3IY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 03:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234427AbiL3IY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 03:24:57 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C931D101DA;
        Fri, 30 Dec 2022 00:24:55 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pBAh4-00CHKd-2Z; Fri, 30 Dec 2022 16:24:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Dec 2022 16:24:46 +0800
Date:   Fri, 30 Dec 2022 16:24:46 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Rijo Thomas <Rijo-john.Thomas@amd.com>
Cc:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org,
        Mythri PK <Mythri.Pandeshwarakrishna@amd.com>,
        Jeshwanth <JESHWANTHKUMAR.NK@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        stable@vger.kernel.org, Jens Wiklander <jens.wiklander@linaro.org>
Subject: Re: [PATCH v2] crypto: ccp - Allocate TEE ring and cmd buffer using
 DMA APIs
Message-ID: <Y66gTtjZf5ZT0lP0@gondor.apana.org.au>
References: <651349f55060767a9a51316c966c1e5daa57a644.1670919979.git.Rijo-john.Thomas@amd.com>
 <20221215132917.GA11061@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <5771ea99-eef7-7321-dd67-4c42c0cbb721@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5771ea99-eef7-7321-dd67-4c42c0cbb721@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 23, 2022 at 05:45:24PM +0530, Rijo Thomas wrote:
>
> > dma_alloc_coherent memory is just as contiguous as __get_free_pages, and
> > calling dma_alloc_coherent from a guest does not guarantee that the memory is
> > contiguous in host memory either. The memory would look contiguous from the
> > device point of view thanks to the IOMMU though (in both cases). So this is not
> > about being contiguous but other properties that you might rely on (dma mask
> > most likely, or coherent if you're not running this on x86?).
> > 
> > Can you confirm why this fixes things and update the comment to reflect that.
> 
> I see what you are saying.
> 
> We verified this in Xen Dom0 PV guest, where dma_alloc_coherent() returned a memory
> that is contiguous in machine address space, and the machine address was returned
> in the dma handle (buf->dma).

So is this even relevant to the mainstream kernel or is this patch
only needed for Xen Dom0?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
