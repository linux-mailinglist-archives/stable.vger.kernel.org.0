Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3510B5517AC
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 13:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235342AbiFTLpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 07:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241998AbiFTLoy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 07:44:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD111704B
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 04:44:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07EED612E3
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 11:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04141C3411B;
        Mon, 20 Jun 2022 11:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655725492;
        bh=xhMdFyuY9abX5LxO5cJnIDjmqdDZ9TJ2fUXwuwOB0mI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qYGfRyXm8a59j7k427hr0loL1HihSj1Y/qLH7f50E8miqStJNCvCEw5CqRs9XCYG2
         cxsArSeEtTf4e9LNyhomA7EXflVWn7oYrgk2GnRGKHPQdncMd32i8689na2/EzG5Gi
         KCTBsLpcwmZ9BD5g0N8I5EnIpGLwbSqp0zuIWDvQ=
Date:   Mon, 20 Jun 2022 13:44:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Mike Snitzer <snitzer@kernel.org>, keescook@chromium.org,
        sarthakkukreti@google.com, stable@vger.kernel.org,
        Oleksandr Tymoshenko <ovt@google.com>, dm-devel@redhat.com,
        regressions@lists.linux.dev
Subject: Re: [PATCH 5.4 26/34] dm verity: set DM_TARGET_IMMUTABLE feature flag
Message-ID: <YrBdsTDrreF3H82o@kroah.com>
References: <20220603173816.944766454@linuxfoundation.org>
 <20220610042200.2561917-1-ovt@google.com>
 <YqLTV+5Q72/jBeOG@kroah.com>
 <YqNfBMOR9SE2TuCm@redhat.com>
 <Yqb/sT205Lrhl6Bv@kroah.com>
 <20220615143642.GA2386944@roeck-us.net>
 <Yqn64AMwoIzQXwXM@redhat.com>
 <50eeff2e-45c5-5eb2-c41d-3e0092a84483@roeck-us.net>
 <Yqo63CvFpTDFnH3x@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yqo63CvFpTDFnH3x@redhat.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 15, 2022 at 04:02:36PM -0400, Mike Snitzer wrote:
> On Wed, Jun 15 2022 at  1:50P -0400,
> Guenter Roeck <linux@roeck-us.net> wrote:
> 
> > On 6/15/22 08:29, Mike Snitzer wrote:
> > > On Wed, Jun 15 2022 at 10:36P -0400,
> > > Guenter Roeck <linux@roeck-us.net> wrote:
> > > 
> > > > On Mon, Jun 13, 2022 at 11:13:21AM +0200, Greg KH wrote:
> > > > > On Fri, Jun 10, 2022 at 11:11:00AM -0400, Mike Snitzer wrote:
> > > > > > On Fri, Jun 10 2022 at  1:15P -0400,
> > > > > > Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > > > 
> > > > > > > On Fri, Jun 10, 2022 at 04:22:00AM +0000, Oleksandr Tymoshenko wrote:
> > > > > > > > I believe this commit introduced a regression in dm verity on systems
> > > > > > > > where data device is an NVME one. Loading table fails with the
> > > > > > > > following diagnostics:
> > > > > > > > 
> > > > > > > > device-mapper: table: table load rejected: including non-request-stackable devices
> > > > > > > > 
> > > > > > > > The same kernel works with the same data drive on the SCSI interface.
> > > > > > > > NVME-backed dm verity works with just this commit reverted.
> > > > > > > > 
> > > > > > > > I believe the presence of the immutable partition is used as an indicator
> > > > > > > > of special case NVME configuration and if the data device's name starts
> > > > > > > > with "nvme" the code tries to switch the target type to
> > > > > > > > DM_TYPE_NVME_BIO_BASED (drivers/md/dm-table.c lines 1003-1010).
> > > > > > > > 
> > > > > > > > The special NVME optimization case was removed in
> > > > > > > > 5.10 by commit 9c37de297f6590937f95a28bec1b7ac68a38618f, so only 5.4 is
> > > > > > > > affected.
> > > > > > > > 
> > > > > > > 
> > > > > > > Why wouldn't 4.9, 4.14, and 4.19 also be affected here?  Should I also
> > > > > > > just queue up 9c37de297f65 ("dm: remove special-casing of bio-based
> > > > > > > immutable singleton target on NVMe") to those older kernels?  If so,
> > > > > > > have you tested this and verified that it worked?
> > > > > > 
> > > > > > Sorry for the unforeseen stable@ troubles here!
> > > > > > 
> > > > > > In general we'd be fine to apply commit 9c37de297f65 but to do it
> > > > > > properly would require also making sure commits that remove
> > > > > > "DM_TYPE_NVME_BIO_BASED", like 8d47e65948dd ("dm mpath: remove
> > > > > > unnecessary NVMe branching in favor of scsi_dh checks") are applied --
> > > > > > basically any lingering references to DM_TYPE_NVME_BIO_BASED need to
> > > > > > be removed.
> > > > > > 
> > > > > > The commit header for 8d47e65948dd documents what
> > > > > > DM_TYPE_NVME_BIO_BASED was used for.. it was dm-mpath specific and
> > > > > > "nvme" mode really never got used by any userspace that I'm aware of.
> > > > > > 
> > > > > > Sadly I currently don't have the time to do this backport for all N
> > > > > > stable kernels... :(
> > > > > > 
> > > > > > But if that backport gets out of control: A simpler, albeit stable@
> > > > > > unicorn, way to resolve this is to simply revert 9c37de297f65 and make
> > > > 
> > > > 9c37de297f65 can not be reverted in 5.4 and older because it isn't there,
> > > > and trying to apply it results in conflicts which at least I can not
> > > > resolve.
> > > > 
> > > > > > it so that DM-mpath and DM core just used bio-based if "nvme" is
> > > > > > requested by dm-mpath, so also in drivers/md/dm-mpath.c e.g.:
> > > > > > 
> > > > > > @@ -1091,8 +1088,6 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
> > > > > > 
> > > > > >                          if (!strcasecmp(queue_mode_name, "bio"))
> > > > > >                                  m->queue_mode = DM_TYPE_BIO_BASED;
> > > > > > 			else if (!strcasecmp(queue_mode_name, "nvme"))
> > > > > > -                               m->queue_mode = DM_TYPE_NVME_BIO_BASED;
> > > > > > +                               m->queue_mode = DM_TYPE_BIO_BASED;
> > > > > >                          else if (!strcasecmp(queue_mode_name, "rq"))
> > > > > >                                  m->queue_mode = DM_TYPE_REQUEST_BASED;
> > > > > >                          else if (!strcasecmp(queue_mode_name, "mq"))
> > > > > > 
> > > > > > Mike
> > > > > > 
> > > > > 
> > > > > Ok, please submit a working patch for the kernels that need it so that
> > > > > we can review and apply it to solve this regression.
> > > > > 
> > > > 
> > > > So, effectively, v5.4.y and older are broken right now for use cases
> > > > with dm on NVME drives.
> > > > 
> > > > Given that the regression does affect older branches, and given that we
> > > > have to revert this patch to avoid regressions in ChromeOS, would it be
> > > > possible to revert it from v5.4.y and older until a fix is found ?
> > > 
> > > I obviously would prefer to not have this false-start.
> > > 
> > The false start has already happened since we had to revert the patch
> > from chromeos-5.4 and older branches.
> 
> OK, well this is pretty easy to fix in general.  If there are slight
> differences across older trees they are easily resolved.  Fact that
> stable@ couldn't cope with backporting 9c37de297f65 is.. what it is.
> 
> But this will fix the issue on 5.4.y:
> 
> From: Mike Snitzer <snitzer@kernel.org>
> Date: Wed, 15 Jun 2022 14:07:09 -0400
> Subject: [5.4.y PATCH] dm: remove special-casing of bio-based immutable singleton target on NVMe
> 
> Commit 9c37de297f6590937f95a28bec1b7ac68a38618f upstream.
> 
> There is no benefit to DM special-casing NVMe. Remove all code used to
> establish DM_TYPE_NVME_BIO_BASED.
> 
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> ---
>  drivers/md/dm-table.c         | 32 ++----------------
>  drivers/md/dm.c               | 64 +++--------------------------------
>  include/linux/device-mapper.h |  1 -
>  3 files changed, 7 insertions(+), 90 deletions(-)

Can someone resend this in the proper format (and fixed up), with
Guenter's tested-by so that I can queue it up?

thanks,

greg k-h
