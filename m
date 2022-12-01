Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABBE63F7C6
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 19:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbiLASzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 13:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiLASzb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 13:55:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AE1A7A8A;
        Thu,  1 Dec 2022 10:55:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15266620D0;
        Thu,  1 Dec 2022 18:55:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C080C433D6;
        Thu,  1 Dec 2022 18:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669920929;
        bh=nF9nCEcoWvt/6aTJgg1HJ8sVTzrNCmcwxrN1MhU4RlM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RWfX7A6F0Wt1PL4eY7roR7x3RoDi5+pNFAL3tq5uFL6yMlbE9WFVA8iq89sfBufl7
         UaYuzca/lCdqE8AO6ctnkGclM10J6efnI11eLC2m9n0gTwRY8iSq23pIa3H5JCMn4M
         2MvLpTmH8m0PvLYGLcrUfkQUSilzyuiWbqpxThRMqqWyjV1v2oNK4tI0Abc5IrGw4e
         GAnjnQckkawsjuZOKDzBhTMUh4QX3YSA2Gye6ahy4E2FshMriz74P1DziNiH/XPvvk
         tsDglaz7eeVZByTHIT9EsAlacopk8XI1f1N8onoCDM9o3p9g2+pnN5dG+ewRC03frM
         wDg+PHTAZCGug==
Date:   Thu, 1 Dec 2022 10:55:27 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc:     zohar@linux.ibm.com, dmitry.kasatkin@gmail.com,
        paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ima: Alloc ima_max_digest_data in xattr_verify()
 if CONFIG_VMAP_STACK=y
Message-ID: <Y4j4n0sAfTAqFSNP@sol.localdomain>
References: <20221201100625.916781-1-roberto.sassu@huaweicloud.com>
 <20221201100625.916781-3-roberto.sassu@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201100625.916781-3-roberto.sassu@huaweicloud.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 01, 2022 at 11:06:25AM +0100, Roberto Sassu wrote:
> From: Roberto Sassu <roberto.sassu@huawei.com>
> 
> Similarly to evm_verify_hmac(), which allocates an evm_digest structure to
> satisfy the linear mapping requirement if CONFIG_VMAP_STACK is enabled, do
> the same in xattr_verify(). Allocate an ima_max_digest_data structure and
> use that instead of the in-stack counterpart.
> 
> Cc: stable@vger.kernel.org # 4.9.x
> Fixes: ba14a194a434 ("fork: Add generic vmalloced stack support")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

Likewise, what is the actual problem here?  Where specifically is a scatterlist
being used to represent an on-stack buffer?

- Eric
