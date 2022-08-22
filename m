Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D76E959BD3F
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 11:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbiHVJ7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 05:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbiHVJ7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 05:59:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B85731ED4
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 02:59:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A46B3CE1056
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 09:59:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E3DC433D6;
        Mon, 22 Aug 2022 09:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661162359;
        bh=Spezi85mLXcE4lx8TIKRiZUPlk9y83CDJuFzuml/FgU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cp/yPBRFGyOVhQthyVtLfgFELyhky5UxLW8kgHdQJW6G/oz7tJtYwpa79De+KhLYc
         KjMhMQWNO+6j6vgEXws5aSG0EWHVpbCHupyYVzkLkwOh/4aB9onDgAYMojRvJeFGmu
         16yHgnt+qmBgnRBM8OZmIUJ/+bsnPfVKOfCZV4Pc=
Date:   Mon, 22 Aug 2022 11:59:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Wiklander <jens.wiklander@linaro.org>
Cc:     stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Jerome Forissier <jerome.forissier@linaro.org>,
        Nimish Mishra <neelam.nimish@gmail.com>,
        Anirban Chakraborty <ch.anirban00727@gmail.com>,
        Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] tee: add overflow check in tee_ioctl_shm_register()
Message-ID: <YwNTdQTj8SC/wnYD@kroah.com>
References: <20220822092621.3691771-1-jens.wiklander@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822092621.3691771-1-jens.wiklander@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 22, 2022 at 11:26:21AM +0200, Jens Wiklander wrote:
> commit 573ae4f13f630d6660008f1974c0a8a29c30e18a upstream.
> 
> With special lengths supplied by user space, tee_shm_register() has
> an integer overflow when calculating the number of pages covered by a
> supplied user space memory region.
> 
> This may cause pin_user_pages_fast() to do a NULL pointer dereference.
> 
> Fix this by adding an an explicit call to access_ok() in
> tee_ioctl_shm_register() to catch an invalid user space address early.
> 
> Fixes: 033ddf12bcf5 ("tee: add register user memory")
> Cc: stable@vger.kernel.org # 5.4
> Reported-by: Nimish Mishra <neelam.nimish@gmail.com>
> Reported-by: Anirban Chakraborty <ch.anirban00727@gmail.com>
> Reported-by: Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>
> Suggested-by: Jerome Forissier <jerome.forissier@linaro.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> [JW: backport to stable-5.4 + update commit message]

Will this also work for 4.19?

thanks,

greg k-h
