Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384C25068CE
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 12:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbiDSKez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 06:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbiDSKey (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 06:34:54 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA81A29CB7;
        Tue, 19 Apr 2022 03:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650364332; x=1681900332;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bu0Y9ouPwjYA3ueaFAYSJGV2wPbGFzFrBYeLS/0C5HI=;
  b=DIFJWe1Ay+/piZfRPTiaCrhRomGnTILD5Q/27c9LkcDFOmTvtW8bsijr
   T2WyHkxjxk3GRm9h5qa79p3gcWI9RhA2sARWHFNyi2DrFw8cvRFxkWPpT
   aFT5RxHXBRr6Pi8nrpeXPGt489x+CqaQEbZFLZ4lNVBCEgsdTrWd3++WM
   XzG+1z7Qlr8XIQjYBx382ntKjBVNf9CTtRJpcOMJ3RP1Ot9btLr+dcif0
   wtcyqzyhW7ATz5iL95VF9DLbR/OV0U9ff59ppk8u/2kk5YjWoZwrnUxuP
   eOYs8JhsxBPsPijmm2ey7+bkeCEJR6pEDSYiSO51071WbAMvPkDQMRHK2
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10321"; a="288829308"
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; 
   d="scan'208";a="288829308"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 03:32:00 -0700
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; 
   d="scan'208";a="529259623"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.76])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 03:31:58 -0700
Date:   Tue, 19 Apr 2022 11:31:50 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        dm-devel@redhat.com
Subject: Re: [PATCH v3 1/3] crypto: qat - use pre-allocated buffers in
 datapath
Message-ID: <Yl6PlqyucVLCzwF5@silpixa00400314>
References: <20220410194707.9746-1-giovanni.cabiddu@intel.com>
 <20220410194707.9746-2-giovanni.cabiddu@intel.com>
 <YlRnVBYl1eJ+zvM5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlRnVBYl1eJ+zvM5@gmail.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Belated response on this - I was out last week.

On Mon, Apr 11, 2022 at 05:37:24PM +0000, Eric Biggers wrote:
> On Sun, Apr 10, 2022 at 08:47:05PM +0100, Giovanni Cabiddu wrote:
> > If requests exceed 4 entries buffers, memory is allocated dynamically.
> > 
> > In addition, remove the CRYPTO_ALG_ALLOCATES_MEMORY flag from both aead
> > and skcipher alg structures.
> > 
> 
> There is nothing that says that algorithms can ignore
> !CRYPTO_ALG_ALLOCATES_MEMORY if there are too many scatterlist entries.  See the
> comment above the definition of CRYPTO_ALG_ALLOCATES_MEMORY.
From the conversation in [1], I assumed that a cap on the number of
pre-allocated entries in the scatterlists was already agreed.

> If you need to introduce this constraint, then you will need to audit the users
> of !CRYPTO_ALG_ALLOCATES_MEMORY to verify that none of them are issuing requests
> that violate this constraint, then add this to the documentation comment for
> CRYPTO_ALG_ALLOCATES_MEMORY.
Makes sense. I see that the only users of !CRYPTO_ALG_ALLOCATES_MEMORY
are dm-crypt and dm-integrity but I haven't done an audit on those yet
to understand if they use more than 4 entries.

Regards,

[1] https://lore.kernel.org/linux-crypto/20200722072932.GA27544@gondor.apana.org.au/

-- 
Giovanni
