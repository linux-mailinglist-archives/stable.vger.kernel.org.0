Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DADD657056D
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 16:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbiGKOWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 10:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbiGKOVv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 10:21:51 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B508C67169;
        Mon, 11 Jul 2022 07:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657549309; x=1689085309;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=A/xwrdAxYXsA63RbLzyW7L2rIbPha0EngocXXdoox2M=;
  b=C+Z0UlAu+ySencYq6s1jm5PNfEu7hgjIc4OQkdfKQFWf6G5quDMskYTQ
   OEJQlWrSQLOhmn8MhG+5RsWPVrf21THsVu8jD9FFcS40D7dBWWTYe3WW4
   SgFcUEoP1UlwqA8w+At/nxVyBy93m2njP3pChSoliobgKwJUERy1EjRsg
   ANVjaC62JOgr5rtEJ5uyq+++wz1x6Xybmu/shc9nsrnXkMqTxjOA0y1Cr
   deCzpLpoe1A5U2dtaLVamR7XU3ziozkRix7Mv/YE1F7UjVN5FcYOL/MWT
   XyC7T4Fl/tar2lxL2goJrYYP6dRSwLMqGU4YoorB5g8PxDVQ5ISbhOgrP
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="348652380"
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="348652380"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 07:21:49 -0700
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="662564681"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.76])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 07:21:46 -0700
Date:   Mon, 11 Jul 2022 15:21:39 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Subject: Re: [PATCH v3 1/3] crypto: qat - use pre-allocated buffers in
 datapath
Message-ID: <Yswx1myaFwJR22FQ@silpixa00400314>
References: <20220410194707.9746-1-giovanni.cabiddu@intel.com>
 <20220410194707.9746-2-giovanni.cabiddu@intel.com>
 <YlRnVBYl1eJ+zvM5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlRnVBYl1eJ+zvM5@gmail.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
> 
> If you need to introduce this constraint, then you will need to audit the users
> of !CRYPTO_ALG_ALLOCATES_MEMORY to verify that none of them are issuing requests
> that violate this constraint, then add this to the documentation comment for
> CRYPTO_ALG_ALLOCATES_MEMORY.
Belatedly...

Adding to this thread my colleague Lucas who did an audit of the users
of !CRYPTO_ALG_ALLOCATES_MEMORY to understand if we can add a constraint
to the definition of CRYPTO_ALG_ALLOCATES_MEMORY.

Regards,

-- 
Giovanni
