Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2CD64FC38C
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 19:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348935AbiDKRjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 13:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245622AbiDKRjm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 13:39:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2312E080;
        Mon, 11 Apr 2022 10:37:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CFAEB817F4;
        Mon, 11 Apr 2022 17:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F007C385A3;
        Mon, 11 Apr 2022 17:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649698645;
        bh=d11mO3LX2P3Rkje8lctEcN2DxY/GwNb0EftCmy3y2A8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gVQ6tC1UOcpoExzTBT2QIf5RCrpmKiltJrefElAQL7hOSnhMRzQzjHDBe7eL7sdxc
         6B24ncMgQs10tbXz7S2VEJp90RdSbmBGjLrgbNtnyf/U+wPNZAbVeLnQneXhCpXW1Z
         Yenl5ORmVZ3JOvf4EcrJOYQ9ouqu8FaAwTFe5ZPYW8m0U0GSMDUShaCk6xf7A8PTBX
         d2X3baNLiOQSl8H6hZetYc9e/0N6xgxyHVfnUgIj+EYQD1gFkX4Eb21yNbI47nTtJu
         cgy3yApNWCHWcmwaTEw+nDdb7qgu289ymAHMpYDL9nlgxTiN8WrBA0qLFaeArLm+Nh
         gRI6F7Vr5dVfQ==
Date:   Mon, 11 Apr 2022 17:37:24 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: Re: [PATCH v3 1/3] crypto: qat - use pre-allocated buffers in
 datapath
Message-ID: <YlRnVBYl1eJ+zvM5@gmail.com>
References: <20220410194707.9746-1-giovanni.cabiddu@intel.com>
 <20220410194707.9746-2-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220410194707.9746-2-giovanni.cabiddu@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 10, 2022 at 08:47:05PM +0100, Giovanni Cabiddu wrote:
> If requests exceed 4 entries buffers, memory is allocated dynamically.
> 
> In addition, remove the CRYPTO_ALG_ALLOCATES_MEMORY flag from both aead
> and skcipher alg structures.
> 

There is nothing that says that algorithms can ignore
!CRYPTO_ALG_ALLOCATES_MEMORY if there are too many scatterlist entries.  See the
comment above the definition of CRYPTO_ALG_ALLOCATES_MEMORY.

If you need to introduce this constraint, then you will need to audit the users
of !CRYPTO_ALG_ALLOCATES_MEMORY to verify that none of them are issuing requests
that violate this constraint, then add this to the documentation comment for
CRYPTO_ALG_ALLOCATES_MEMORY.

- Eric
