Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C66E4621020
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 13:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233844AbiKHMRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 07:17:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233703AbiKHMRx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 07:17:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB2132048
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 04:17:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDBCE61522
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 12:17:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878E4C433D7;
        Tue,  8 Nov 2022 12:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667909872;
        bh=z54yTYflR93m+cRsgK19fjszSlK0JGKQ3Efk8EO8LQw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zCwu9oCfGAXfTnK6SoXMEKKNglPXROOWgUFRTFpUwH39RnuOXNXaAQvrUn4VegN9y
         Cbx9kl21ZGpEGRc8jGJHI+jAmYFQZfTnxj6B25EA1CBJ++fca3P63IGVH8jIb5mfeW
         Qyy7K3ebVc7esSfoKrzsLociw8XuJgjmZETwwRBg=
Date:   Tue, 8 Nov 2022 13:17:49 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     stable@vger.kernel.org, jens.wiklander@linaro.org,
        jerome.forissier@linaro.org,
        Sahil Malhotra <sahil.malhotra@nxp.com>
Subject: Re: [PATCH] tee: Fix tee_shm_register() for kernel TEE drivers
Message-ID: <Y2pI7ZI1OXlO0uLh@kroah.com>
References: <20221108105301.1925751-1-sumit.garg@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108105301.1925751-1-sumit.garg@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 08, 2022 at 04:23:01PM +0530, Sumit Garg wrote:
> Commit 056d3fed3d1f ("tee: add tee_shm_register_{user,kernel}_buf()")
> refactored tee_shm_register() into corresponding user and kernel space
> functions named tee_shm_register_{user,kernel}_buf(). The upstream fix
> commit 573ae4f13f63 ("tee: add overflow check in register_shm_helper()")
> only applied to tee_shm_register_user_buf().
> 
> But the stable kernel 4.19, 5.4, 5.10 and 5.15 don't have the above
> mentioned tee_shm_register() refactoring commit. Hence a direct backport
> wasn't possible and the fix has to be rather applied to
> tee_ioctl_shm_register().
> 
> Somehow the fix was correctly backported to 4.19 and 5.4 stable kernels
> but the backports for 5.10 and 5.15 stable kernels were broken as fix
> was applied to common tee_shm_register() function which broke its kernel
> space users such as trusted keys driver.
> 
> Fortunately the backport for 5.10 stable kernel was incidently fixed by:
> commit 606fe84a4185 ("tee: fix memory leak in tee_shm_register()"). So
> fix the backport for 5.15 stable kernel as well.
> 
> Fixes: 578c349570d2 ("tee: add overflow check in register_shm_helper()")
> Cc: stable@vger.kernel.org # 5.15
> Reported-by: Sahil Malhotra <sahil.malhotra@nxp.com>
> Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> ---
>  drivers/tee/tee_core.c | 3 +++
>  drivers/tee/tee_shm.c  | 3 ---
>  2 files changed, 3 insertions(+), 3 deletions(-)

Now queued up, thanks.

greg k-h
