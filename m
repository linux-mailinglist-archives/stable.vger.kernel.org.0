Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6AE691BD2
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 10:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbjBJJqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 04:46:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbjBJJqf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 04:46:35 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8297167A;
        Fri, 10 Feb 2023 01:46:34 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pQPzB-009c22-29; Fri, 10 Feb 2023 17:46:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 Feb 2023 17:46:29 +0800
Date:   Fri, 10 Feb 2023 17:46:29 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        stable@vger.kernel.org, Vladis Dronov <vdronov@redhat.com>,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: Re: [PATCH] crypto: qat - fix out-of-bounds read
Message-ID: <Y+YSdcuBAU/AfvgC@gondor.apana.org.au>
References: <20230201155944.23379-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201155944.23379-1-giovanni.cabiddu@intel.com>
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,PDS_RDNS_DYNAMIC_FP,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 01, 2023 at 03:59:44PM +0000, Giovanni Cabiddu wrote:
> When preparing an AER-CTR request, the driver copies the key provided by
> the user into a data structure that is accessible by the firmware.
> If the target device is QAT GEN4, the key size is rounded up by 16 since
> a rounded up size is expected by the device.
> If the key size is rounded up before the copy, the size used for copying
> the key might be bigger than the size of the region containing the key,
> causing an out-of-bounds read.
> 
> Fix by doing the copy first and then update the keylen.
> 
> This is to fix the following warning reported by KASAN:
> 
> 	[  138.150574] BUG: KASAN: global-out-of-bounds in qat_alg_skcipher_init_com.isra.0+0x197/0x250 [intel_qat]
> 	[  138.150641] Read of size 32 at addr ffffffff88c402c0 by task cryptomgr_test/2340
> 
> 	[  138.150651] CPU: 15 PID: 2340 Comm: cryptomgr_test Not tainted 6.2.0-rc1+ #45
> 	[  138.150659] Hardware name: Intel Corporation ArcherCity/ArcherCity, BIOS EGSDCRB1.86B.0087.D13.2208261706 08/26/2022
> 	[  138.150663] Call Trace:
> 	[  138.150668]  <TASK>
> 	[  138.150922]  kasan_check_range+0x13a/0x1c0
> 	[  138.150931]  memcpy+0x1f/0x60
> 	[  138.150940]  qat_alg_skcipher_init_com.isra.0+0x197/0x250 [intel_qat]
> 	[  138.151006]  qat_alg_skcipher_init_sessions+0xc1/0x240 [intel_qat]
> 	[  138.151073]  crypto_skcipher_setkey+0x82/0x160
> 	[  138.151085]  ? prepare_keybuf+0xa2/0xd0
> 	[  138.151095]  test_skcipher_vec_cfg+0x2b8/0x800
> 
> Fixes: 67916c951689 ("crypto: qat - add AES-CTR support for QAT GEN4 devices")
> Cc: <stable@vger.kernel.org>
> Reported-by: Vladis Dronov <vdronov@redhat.com>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
> ---
>  drivers/crypto/qat/qat_common/qat_algs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
