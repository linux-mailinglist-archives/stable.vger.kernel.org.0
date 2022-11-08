Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E81C62098E
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 07:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbiKHGXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 01:23:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233213AbiKHGXj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 01:23:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7392167EA
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 22:23:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 203A161377
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E8BC433C1;
        Tue,  8 Nov 2022 06:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667888616;
        bh=NTtqock9rImK/a7AsgD/Jk1vM3LB+SgXknrHJ5ENsa0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ocplBJKDvkjEGPPnwGUTr5Utwz2WIVeKkiS2GANWXFl6gb0LfS0ZcL3CT+QsHidRO
         EnbBAVfOSz5UF0u57pXnlrf1l4So6sN6LjPYqIwumCtbBswInOQx8UOLbm20BiNTCi
         dxq8RnHZarHretWR566a3r7KOSPl50+Bqlu2M8rg=
Date:   Tue, 8 Nov 2022 07:23:33 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     stable@vger.kernel.org, Jens Wiklander <jens.wiklander@linaro.org>,
        Jerome Forissier <jerome.forissier@linaro.org>,
        Nimish Mishra <neelam.nimish@gmail.com>,
        Anirban Chakraborty <ch.anirban00727@gmail.com>,
        Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        sahil.malhotra@nxp.com
Subject: Re: [PATCH] tee: add overflow check in tee_ioctl_shm_register()
Message-ID: <Y2n15Tv+EX9qb/F/@kroah.com>
References: <20220822131227.3865684-1-jens.wiklander@linaro.org>
 <CAFA6WYNwk+dT_Kb3xsUQ1u5KvX+RpLwXtom6fruBbTe9W56s8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFA6WYNwk+dT_Kb3xsUQ1u5KvX+RpLwXtom6fruBbTe9W56s8Q@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 08, 2022 at 11:42:01AM +0530, Sumit Garg wrote:
> Hi Greg,
> 
> On Mon, 22 Aug 2022 at 18:42, Jens Wiklander <jens.wiklander@linaro.org> wrote:
> >
> > commit 573ae4f13f630d6660008f1974c0a8a29c30e18a upstream.
> >
> > With special lengths supplied by user space, tee_shm_register() has
> > an integer overflow when calculating the number of pages covered by a
> > supplied user space memory region.
> >
> > This may cause pin_user_pages_fast() to do a NULL pointer dereference.
> >
> > Fix this by adding an an explicit call to access_ok() in
> > tee_ioctl_shm_register() to catch an invalid user space address early.
> >
> > Fixes: 033ddf12bcf5 ("tee: add register user memory")
> > Cc: stable@vger.kernel.org # 5.4
> > Cc: stable@vger.kernel.org # 5.10
> > Reported-by: Nimish Mishra <neelam.nimish@gmail.com>
> > Reported-by: Anirban Chakraborty <ch.anirban00727@gmail.com>
> > Reported-by: Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>
> > Suggested-by: Jerome Forissier <jerome.forissier@linaro.org>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > [JW: backport to stable 5.4 and 5.10 + update commit message]
> > Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
> > ---
> >  drivers/tee/tee_core.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> 
> The v5.15 backport [1] for this fix has broken the kernel consumers
> for tee_shm_register(), the trusted keys driver is one of them
> reported here [2]. We need to fix that up with the following change
> [3]. Would you like to revert the backport and apply the correct one
> or should I prepare a fix patch for the following [3]?

A fixup patch is fine if needed, along with the description of why the
backport was broken.  Note, this commit went much further back than
5.15, so be sure to check older kernels too.

thanks,

greg k-h
