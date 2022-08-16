Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5053595999
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 13:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbiHPLMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 07:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235378AbiHPLM0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 07:12:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F786CCE13
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 02:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88579B81661
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 09:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B8DC433C1;
        Tue, 16 Aug 2022 09:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660642212;
        bh=B/g5pswH/gWZIt6453nMEqjheUNk12EZQXH9d1tOm1g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U+LP6hysrBrAyw4T0/go5oxX6lbLjvk5uVN2HFYN/9O/ejr9+kbtWK0dHFu+Ahc4F
         xZIUsQl/ipYLbPN16d4RP0m/mMQjeWJFi6jFXT7BN2jHQ+BvGAmLwzSEUeL5JdVuex
         RRDr5EMIlkX8vT9zJnAp8Km8Apr3gARVBpFbCDj4=
Date:   Tue, 16 Aug 2022 11:30:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Arun Easi <aeasi@marvell.com>
Cc:     himanshu.madhani@oracle.com, martin.petersen@oracle.com,
        njavali@marvell.com, stable@vger.kernel.org
Subject: Re: [EXT] Re: WTF: patch "[PATCH] scsi: qla2xxx: Fix response queue
 handler reading stale" was seriously submitted to be applied to the
 5.19-stable tree?
Message-ID: <YvtjocfDhhPuo5Ua@kroah.com>
References: <166039743723771@kroah.com>
 <YverHtqNRmMLXmqb@kroah.com>
 <e43fa407-31bd-8e7c-c847-87f13bdd2b73@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e43fa407-31bd-8e7c-c847-87f13bdd2b73@marvell.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 15, 2022 at 03:35:09PM -0700, Arun Easi wrote:
> Hi Greg,
> 
> On Sat, 13 Aug 2022, 6:46am, Greg KH wrote:
> 
> > 
> > ----------------------------------------------------------------------
> > On Sat, Aug 13, 2022 at 03:30:37PM +0200, gregkh@linuxfoundation.org wrote:
> > > The patch below was submitted to be applied to the 5.19-stable tree.
> > > 
> > > I fail to see how this patch meets the stable kernel rules as found at
> > > Documentation/process/stable-kernel-rules.rst.
> > > 
> > > I could be totally wrong, and if so, please respond to 
> > > <stable@vger.kernel.org> and let me know why this patch should be
> > > applied.  Otherwise, it is now dropped from my patch queues, never to be
> > > seen again.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > > ------------------ original commit in Linus's tree ------------------
> > > 
> > > >From b1f707146923335849fb70237eec27d4d1ae7d62 Mon Sep 17 00:00:00 2001
> > > From: Arun Easi <aeasi@marvell.com>
> > > Date: Tue, 12 Jul 2022 22:20:39 -0700
> > > Subject: [PATCH] scsi: qla2xxx: Fix response queue handler reading stale
> > >  packets
> > > 
> > > On some platforms, the current logic of relying on finding new packet
> > > solely based on signature pattern can lead to driver reading stale
> > > packets. Though this is a bug in those platforms, reduce such exposures by
> > > limiting reading packets until the IN pointer.
> > > 
> > > Two module parameters are introduced:
> > > 
> > >   ql2xrspq_follow_inptr:
> > > 
> > >     When set, on newer adapters that has queue pointer shadowing, look for
> > >     response packets only until response queue in pointer.
> > > 
> > >     When reset, response packets are read based on a signature pattern
> > >     logic (old way).
> > > 
> > >   ql2xrspq_follow_inptr_legacy:
> > > 
> > >     Like ql2xrspq_follow_inptr, but for those adapters where there is no
> > >     queue pointer shadowing.
> > 
> > On a meta-note, this patch seems VERY wrong.  You are adding a
> > driver-wide module option for a device-specific action.  That should be
> > a device-specific functionality, not a module.
> > 
> > Again, as I say many times, this isn't the 1990's, please never add new
> > module parameters.  Use the other interfaces we have in the kernel to
> > configure individual devices properly, module parameters are not to be
> > used for that at all for anything new.
> > 
> > So, can you revert this commit and do it properly please?
> > 
> 
> The reason I chose module parameter way was because of these primarily:
> 
> 1 As this is a platform specific issue, this behavior does not require a 
>   device granular level tuning. Either all the said adapters turns the 
>   behavior on or off.

What is going to allow a user to know to do this or not?  Why is this
needed at all, and why doesn't the driver automatically know what to do
either based on the device id, or the platform, or the workload?

Forcing a user to pick something for "tuning" like this is horrible and
messy and almost impossible to support properly over time.  Just do it
in the driver automatically and then there's no need for any options at
all.

> 2 Module parameters allowed persistence without complexity: Since this 
>   adapter is also used in booting on some environments, module parameter 
>   allowed the configurability as well as simplicity.

Just because it is easy does not mean it is correct.  It is a
device-specific option being applied to ALL devices in the system, which
feels wrong.  If it is correct, then just do it automatically in the
driver based on platform information.

> If the above approach is discouraged, the alternatives that comes to my 
> mind are:
> 
> 1 Add a sysfs node 

Sure!

> 2 Add a debugfs node

Only if this really is only for debugging as that's what debugfs is for.
You can never rely on debugfs to be present or accessable for anything
that the system relies on for functionality.

> 3 /proc/sys/kernel ? (but that is not per adapter specific)

Ick, no.

> 4 Add a udev script to watch for PCI adapter addition and set/reset 1, 2 
>   or 3

Your udev script will tie into the sysfs node.

> If udev route is taken, I'd have to come up with a configuration file to 
> save tunable state, which could be a bit cumbersome and needs 
> documentation and be different (in terms of script location/submitting) 
> distro to distro.

How is a module parameter saving any state anywhere?  Your sysfs rule
should be identical to the rule that causes you to write the module
parameter file out to the device.

And then that logic, again, really should just be in the driver itself
with no option needed at all.

Again, resist the option to force a user to do anything, that's messy
and painful and not what a kernel should do if at all possible.

thanks,

greg k-h
