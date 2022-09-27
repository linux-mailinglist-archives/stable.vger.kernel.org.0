Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 441045EC9CA
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 18:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbiI0QnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 12:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbiI0Qmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 12:42:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7681C00C2;
        Tue, 27 Sep 2022 09:42:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C741760FBB;
        Tue, 27 Sep 2022 16:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8ADDC433C1;
        Tue, 27 Sep 2022 16:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664296971;
        bh=ViNq6LYgdEbfo2489j+uRo51d1QTLEOg+E/Vq2a5SVY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gba3xc+YUCTWcb9XfurPU3KT+OOyhGv9uLAhDVcK7TAP3+0NeB5jcTOpmUOmKitbz
         Gdksj3p7HOcJBI15S7Qeg8PHVPkjpX2eVZnfVpAWKjTWLcEjFNx+I3fWyfvBj8bwk8
         1S69zK2NsYEFLW8cFHTMSfBhE4fKzkEBN3Ogio5s=
Date:   Tue, 27 Sep 2022 18:42:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dan Vacura <w36195@motorola.com>
Cc:     linux-usb@vger.kernel.org,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: uvc: fix sg handling in error case
Message-ID: <YzMoCMIh85XxWcdh@kroah.com>
References: <20220926195307.110121-1-w36195@motorola.com>
 <20220926195307.110121-2-w36195@motorola.com>
 <YzK1Xry5KIrMr18F@kroah.com>
 <YzMbK0ZZ08WD8ql+@p1g3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzMbK0ZZ08WD8ql+@p1g3>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 27, 2022 at 10:47:55AM -0500, Dan Vacura wrote:
> Hi Greg,
> 
> On Tue, Sep 27, 2022 at 10:33:34AM +0200, Greg Kroah-Hartman wrote:
> > On Mon, Sep 26, 2022 at 02:53:07PM -0500, Dan Vacura wrote:
> > > If there is a transmission error the buffer will be returned too early,
> > > causing a memory fault as subsequent requests for that buffer are still
> > > queued up to be sent. Refactor the error handling to wait for the final
> > > request to come in before reporting back the buffer to userspace for all
> > > transfer types (bulk/isoc/isoc_sg) to ensure userspace knows if the
> > > frame was successfully sent.
> > > 
> > > Fixes: e81e7f9a0eb9 ("usb: gadget: uvc: add scatter gather support")
> > > Cc: <stable@vger.kernel.org> # 859c675d84d4: usb: gadget: uvc: consistently use define for headerlen
> > > Cc: <stable@vger.kernel.org> # f262ce66d40c: usb: gadget: uvc: use on returned header len in video_encode_isoc_sg
> > > Cc: <stable@vger.kernel.org> # 61aa709ca58a: usb: gadget: uvc: rework uvcg_queue_next_buffer to uvcg_complete_buffer
> > > Cc: <stable@vger.kernel.org> # 9b969f93bcef: usb: gadget: uvc: giveback vb2 buffer on req complete
> > > Cc: <stable@vger.kernel.org> # aef11279888c: usb: gadget: uvc: improve sg exit condition
> > 
> > I don't understand, why we backport all of these commits to 5.15.y if
> > the original problem isn't in 5.15.y?
> > 
> > Or is it?
> > 
> > I'm confused,
> 
> It seems we have a regression in 5.15 with some recent, still in
> development, features for the uvc gadget driver. Compared to the last
> kernel I worked with, 5.10, I'm seeing stability and functional issues
> in 5.15, explained in my summary here:
> https://lore.kernel.org/all/20220926195307.110121-1-w36195@motorola.com/
> 
> I think we have few approaches.
> 1) Work through these issues and get the fixes into mainline and stable
> versions, this patch starts that effort, but there's still more work to
> be done.
> 2) Revert the changes that are causing regressions in 5.15 (two changes
> from what I can see).
> 3) Add a configfs ability to allow sg isoc transfers and couple the
> quarter interrupt logic to only sg xfers.
> 
> Approach 2 is my preference, as there are issues still present that need
> to be figured out. However, I don't know how we can revert to just a
> stable line. I'm basically looking for feedback and input for the next
> steps, and if it's just me with these issues on 5.15.

Worry about the latest kernel release first.  Once we get things fixed
there, we can backport any needed changes to older stable/LTS kernels as
needed.

We can't go back in time and do new development on older kernels.

For Android devices, you can always use the `android-mainline` AOSP
kernel branch as it is up to date with Linus's tree at all times and is
known to successfully boot and run at least one real device.


> > >  #define UVC_QUEUE_DISCONNECTED		(1 << 0)
> > > -#define UVC_QUEUE_DROP_INCOMPLETE	(1 << 1)
> > > +#define UVC_QUEUE_MISSED_XFER 		(1 << 1)
> > 
> > Why change the name of the error?
> 
> I thought MISSED_XFER was a more explicit name to what is going on,
> instead of an action. I can change it back.

That's fine, but you didn't document why you were doing this.

Perhaps this needs to be a patch series, remember, each patch only
should do 1 thing.

> > > +	case -EXDEV:
> > > +		uvcg_info(&video->uvc->func, "VS request missed xfer.\n");
> > 
> > Why are you spamming the kernel logs at the info level for a USB
> > transmission problem?   That could get very noisy, please change this to
> > be at the debug level.
> 
> Previously this would printout as a dev_warn in a725d0f6dfc5 ("usb:
> gadget: uvc: call uvc uvcg_warn on completed status instead of
> uvcg_info"), which I think might be too noisy. Info is helpful to
> see what's going on if there is video corruption, but I can change to a
> dbg as well.

info is never a valid level for an error.  dbg is best if a user can not
actually do something about the error.

thanks,

greg k-h
