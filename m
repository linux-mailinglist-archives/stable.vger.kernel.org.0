Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C824597E05
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 07:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237948AbiHRFXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 01:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233628AbiHRFXe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 01:23:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463D325CF
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 22:23:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB15261620
        for <stable@vger.kernel.org>; Thu, 18 Aug 2022 05:23:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFE1C433D6;
        Thu, 18 Aug 2022 05:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660800208;
        bh=mjtcjX2qFRVgUFcU+6PpRSuKfBritOdurMaF1gpCas4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nGc0Wx2etCZtgB27Y2dffx9JQT6noFC5yQMqrhRjmppHYHpYt2Sj2fGwT76XBEMEj
         d/JxFsgRqmB4RpQT6+qWdl2NvFh28QXS+ZH85QrMBHZlDBlZyvjmkj30RUMxbJ3q8I
         rc+sDOPNhwTYDL6Ce1y+WrUCTOJIEYa0OwjPh8rk=
Date:   Thu, 18 Aug 2022 07:23:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Arun Easi <aeasi@marvell.com>
Cc:     himanshu.madhani@oracle.com, martin.petersen@oracle.com,
        njavali@marvell.com, stable@vger.kernel.org
Subject: Re: [EXT] Re: WTF: patch "[PATCH] scsi: qla2xxx: Fix response queue
 handler reading stale" was seriously submitted to be applied to the
 5.19-stable tree?
Message-ID: <Yv3MzRU+MSRDuzs+@kroah.com>
References: <166039743723771@kroah.com>
 <YverHtqNRmMLXmqb@kroah.com>
 <e43fa407-31bd-8e7c-c847-87f13bdd2b73@marvell.com>
 <YvtjocfDhhPuo5Ua@kroah.com>
 <4ed36d0a-2f82-4fe6-1f8f-25870b9e05c6@marvell.com>
 <YvyIn61N7g1tB4S6@kroah.com>
 <b973894e-d88e-41dc-27fd-9544e193a64b@marvell.com>
 <6f93047c-5059-125c-8636-a99081f32f11@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f93047c-5059-125c-8636-a99081f32f11@marvell.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 17, 2022 at 05:44:48PM -0700, Arun Easi wrote:
> On Wed, 17 Aug 2022, 5:35pm, Arun Easi wrote:
> 
> > On Tue, 16 Aug 2022, 11:20pm, Greg KH wrote:
> > 
> > > On Tue, Aug 16, 2022 at 11:17:39AM -0700, Arun Easi wrote:
> > > > On Tue, 16 Aug 2022, 2:30am, Greg KH wrote:
> > > > 
> > > > > On Mon, Aug 15, 2022 at 03:35:09PM -0700, Arun Easi wrote:
> > > > > > Hi Greg,
> > > > > > 
> > > > > > On Sat, 13 Aug 2022, 6:46am, Greg KH wrote:
> > > > > > 
> > > > > > > 
> > > > > > > ----------------------------------------------------------------------
> > > > > > > On Sat, Aug 13, 2022 at 03:30:37PM +0200, gregkh@linuxfoundation.org wrote:
> > > > > > > > The patch below was submitted to be applied to the 5.19-stable tree.
> > > > > > > > 
> > > > > > > > I fail to see how this patch meets the stable kernel rules as found at
> > > > > > > > Documentation/process/stable-kernel-rules.rst.
> > > > > > > > 
> > > > > > > > I could be totally wrong, and if so, please respond to 
> > > > > > > > <stable@vger.kernel.org> and let me know why this patch should be
> > > > > > > > applied.  Otherwise, it is now dropped from my patch queues, never to be
> > > > > > > > seen again.
> > > > > > > > 
> > > > > > > > thanks,
> > > > > > > > 
> > > > > > > > greg k-h
> > > > > > > > 
> > > > > > > > ------------------ original commit in Linus's tree ------------------
> > > > > > > > 
> > > > > > > > >From b1f707146923335849fb70237eec27d4d1ae7d62 Mon Sep 17 00:00:00 2001
> > > > > > > > From: Arun Easi <aeasi@marvell.com>
> > > > > > > > Date: Tue, 12 Jul 2022 22:20:39 -0700
> > > > > > > > Subject: [PATCH] scsi: qla2xxx: Fix response queue handler reading stale
> > > > > > > >  packets
> > > > > > > > 
> > > > > > > > On some platforms, the current logic of relying on finding new packet
> > > > > > > > solely based on signature pattern can lead to driver reading stale
> > > > > > > > packets. Though this is a bug in those platforms, reduce such exposures by
> > > > > > > > limiting reading packets until the IN pointer.
> > > > > > > > 
> > > > > > > > Two module parameters are introduced:
> > > > > > > > 
> > > > > > > >   ql2xrspq_follow_inptr:
> > > > > > > > 
> > > > > > > >     When set, on newer adapters that has queue pointer shadowing, look for
> > > > > > > >     response packets only until response queue in pointer.
> > > > > > > > 
> > > > > > > >     When reset, response packets are read based on a signature pattern
> > > > > > > >     logic (old way).
> > > > > > > > 
> > > > > > > >   ql2xrspq_follow_inptr_legacy:
> > > > > > > > 
> > > > > > > >     Like ql2xrspq_follow_inptr, but for those adapters where there is no
> > > > > > > >     queue pointer shadowing.
> > > > > > > 
> > > > > > > On a meta-note, this patch seems VERY wrong.  You are adding a
> > > > > > > driver-wide module option for a device-specific action.  That should be
> > > > > > > a device-specific functionality, not a module.
> > > > > > > 
> > > > > > > Again, as I say many times, this isn't the 1990's, please never add new
> > > > > > > module parameters.  Use the other interfaces we have in the kernel to
> > > > > > > configure individual devices properly, module parameters are not to be
> > > > > > > used for that at all for anything new.
> > > > > > > 
> > > > > > > So, can you revert this commit and do it properly please?
> > > > > > > 
> > > > > > 
> > > > > > The reason I chose module parameter way was because of these primarily:
> > > > > > 
> > > > > > 1 As this is a platform specific issue, this behavior does not require a 
> > > > > >   device granular level tuning. Either all the said adapters turns the 
> > > > > >   behavior on or off.
> > > > > 
> > > > > What is going to allow a user to know to do this or not?  Why is this
> > > > > needed at all, and why doesn't the driver automatically know what to do
> > > > > either based on the device id, or the platform, or the workload?
> > > > 
> > > > The change is to err on the side of caution and make the logic 
> > > > a bit conservative at the same time providing an option for those 
> > > > platforms or architectures where the issue is not applicable, but the 
> > > > logic is causing a reduction in performance.
> > > 
> > > So this is a "enable the driver to work in a broken way" option?
> > > 
> > > > > Forcing a user to pick something for "tuning" like this is horrible and
> > > > > messy and almost impossible to support properly over time.
> > > > 
> > > > The option is intended for slightly advanced users, platform or os 
> > > > vendors etc. When it comes to an end user, I agree it is challenging to 
> > > > know if a change from default is needed or not.
> > > 
> > > That's not ok, as a driver writer you need to make it "always work",
> > > don't force the user to choose "safe vs. unsafe" options, that's passing
> > > the blame.
> > > 
> > > > > Just do it in the driver automatically and then there's no need for any 
> > > > > options at all.
> > > > 
> > > > The platform bug exhibited as driver accessing stale memory, so it is 
> > > > tough to automatically tune the value automatically.
> > > 
> > > That sounds like a real bug that you need to fix.
> > 
> > Actually, this is a platform bug that got exposed with the driver 
> > behavior.

What are you meaning by "platform"?  The kernel?  Or your hardware
device?

> > > Please revert this change and just fix the issue to always work 
> > > properly.  To have an option that allows a driver to work in a broken 
> > > way is not acceptable.
> > > 
> > > > > > If udev route is taken, I'd have to come up with a configuration file to 
> > > > > > save tunable state, which could be a bit cumbersome and needs 
> > > > > > documentation and be different (in terms of script location/submitting) 
> > > > > > distro to distro.
> > > > > 
> > > > > How is a module parameter saving any state anywhere?
> > > > 
> > > > Since module parameter could be configured via modprobe.conf/equivalent, a 
> > > > user could set the value of his choice in that file and have the value 
> > > > persisted.
> > > 
> > > Same for a udev rule, so this is not an issue.
> > > 
> > > Do you want me to send a patch that reverts this, or will you?
> > > 
> > 
> > Ok, hint taken, will send a revert followed by the patch with modparam 
> > removed.
> > 
> 
> Greg, would you be alright if the module parameter be converted into a 
> #define? That way, an advanced user, who knows what he is doing, still has 
> the option, and the chances of a regular user accidentally turning on the 
> module parameter incorrectly on the buggy platform avoided as well.

No one will ever turn on such a thing if it is a #define, as no
"enterprise" customer will ever build a custom kernel (it voids their
warranty) and for the rest of the world that uses stock kernel.org
kernels, they would never want to change the code to "enable an option
that is known to break things."

Just fix the driver to work properly, don't try to paper over it with
"change this line of code to go faster but it might break!" options.

thanks,

greg k-h
