Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7713459D1C7
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 09:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237040AbiHWHOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 03:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiHWHOd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 03:14:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4AEE5926F
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 00:14:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F0306CE1AEC
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 07:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFD1C433D6;
        Tue, 23 Aug 2022 07:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661238868;
        bh=unjE1vc68y6gFzqWEvbFLMBCgHWntYhMyj+Gy0d8q8M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ftyLLsnbmTOB/W2ql6U6UJRNVifVJQbBem66gU1nDRfbNQEyo3IpHof4nsyjRfd66
         EjJuAr9k/JbrY2KafbXHe1DVYAzjFQVu624o19lsKYRLjSfILSOZsKsRj0rPRNU3YK
         fmHiD4YY6Fbux4S8/deKLDWIlWw1jzNvOrEc8dQI=
Date:   Tue, 23 Aug 2022 09:14:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Wiklander <jens.wiklander@linaro.org>
Cc:     stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Jerome Forissier <jerome.forissier@linaro.org>,
        Nimish Mishra <neelam.nimish@gmail.com>,
        Anirban Chakraborty <ch.anirban00727@gmail.com>,
        Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@denx.de>
Subject: Re: [PATCH] tee: add overflow check in tee_ioctl_shm_register()
Message-ID: <YwR+UTRq5stmn0jC@kroah.com>
References: <20220822131227.3865684-1-jens.wiklander@linaro.org>
 <YwOFX8eXYmZrsl/n@kroah.com>
 <CAHUa44Ein2WMDtBeBHU+MQULFBonQ1LYXCuQTCO+rrmfxunbNw@mail.gmail.com>
 <YwOZYRYSke8N1Tpr@kroah.com>
 <CAHUa44GdJQDmAtSyM5uYSoc4JX_EfrG9zSHCJgx4Jf+qU6LS_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHUa44GdJQDmAtSyM5uYSoc4JX_EfrG9zSHCJgx4Jf+qU6LS_g@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 23, 2022 at 09:00:43AM +0200, Jens Wiklander wrote:
> On Mon, Aug 22, 2022 at 4:57 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Aug 22, 2022 at 04:29:05PM +0200, Jens Wiklander wrote:
> > > On Mon, Aug 22, 2022 at 3:32 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Mon, Aug 22, 2022 at 03:12:27PM +0200, Jens Wiklander wrote:
> > > > > commit 573ae4f13f630d6660008f1974c0a8a29c30e18a upstream.
> > > > >
> > > > > With special lengths supplied by user space, tee_shm_register() has
> > > > > an integer overflow when calculating the number of pages covered by a
> > > > > supplied user space memory region.
> > > > >
> > > > > This may cause pin_user_pages_fast() to do a NULL pointer dereference.
> > > > >
> > > > > Fix this by adding an an explicit call to access_ok() in
> > > > > tee_ioctl_shm_register() to catch an invalid user space address early.
> > > > >
> > > > > Fixes: 033ddf12bcf5 ("tee: add register user memory")
> > > > > Cc: stable@vger.kernel.org # 5.4
> > > > > Cc: stable@vger.kernel.org # 5.10
> > > > > Reported-by: Nimish Mishra <neelam.nimish@gmail.com>
> > > > > Reported-by: Anirban Chakraborty <ch.anirban00727@gmail.com>
> > > > > Reported-by: Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>
> > > > > Suggested-by: Jerome Forissier <jerome.forissier@linaro.org>
> > > > > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > > > [JW: backport to stable 5.4 and 5.10 + update commit message]
> > > >
> > > > You already sent me a 5.4 version here:
> > > >         https://lore.kernel.org/r/20220822092621.3691771-1-jens.wiklander@linaro.org
> > > >
> > > > And I applied that.
> > > >
> > > > And for 5.10, it's already in the tree as commit 578c349570d2 ("tee: add
> > > > overflow check in register_shm_helper()") and was in the 5.10.137
> > > > release.
> > > >
> > > > > Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
> > > > > ---
> > > > >  drivers/tee/tee_core.c | 3 +++
> > > > >  1 file changed, 3 insertions(+)
> > > > >
> > > > > diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
> > > > > index a7ccd4d2bd10..2db144d2d26f 100644
> > > > > --- a/drivers/tee/tee_core.c
> > > > > +++ b/drivers/tee/tee_core.c
> > > > > @@ -182,6 +182,9 @@ tee_ioctl_shm_register(struct tee_context *ctx,
> > > > >       if (data.flags)
> > > > >               return -EINVAL;
> > > > >
> > > > > +     if (!access_ok((void __user *)(unsigned long)data.addr, data.length))
> > > > > +             return -EFAULT;
> > > >
> > > > What I took in 5.10.137 was:
> > > >
> > > > +       if (!access_ok((void __user *)addr, length))
> > > > +               return ERR_PTR(-EFAULT);
> > > >
> > > > Should I fix it up to look like what you sent here instead?
> > >
> > > Yes, please.
> >
> > Ok, no, that does not work on 5.10.y at all, it blows up with the
> > obvious issue that there is no data pointer in this function.  It's also
> > in a different file, drivers/tee/tee_shm.c
> >
> > So I'm going to leave 5.10.y alone for now, I think it's fixed.
> 
> It works somewhat, but there's the potential memory leak that Pavel
> Machek pointed out,
> https://lore.kernel.org/lkml/20220822111546.GA7795@duo.ucw.cz/ .
> 
> The 5.4 patch has a better approach since it verifies the supplied
> address range early before we do anything that must be undone on
> error.
> The 5.4 patch changes  tee_ioctl_shm_register() instead, which is the
> function one step up in the call chain. This approach should be taken
> for all kernels before 53e16519c2ec ("tee: replace
> tee_shm_register()"), that is, before v5.18 if I'm reading the git log
> correctly.
> 
> access_ok() went from taking three arguments to two sometime after
> v4.19, why that patch is slightly different.

Ok, can you send me a new fix-up patch, on top of the latest 5.10.y
release, to resolve the 5.10 issue?

thanks,

greg k-h
