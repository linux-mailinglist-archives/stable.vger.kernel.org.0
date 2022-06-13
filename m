Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574B8548309
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 11:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbiFMJPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 05:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240829AbiFMJNc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 05:13:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C93BE2
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 02:13:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5B97B80E46
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 09:13:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47467C34114;
        Mon, 13 Jun 2022 09:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655111608;
        bh=oFtjHZ21wjgG3oyZMkDZtOzU01N9bU2jQ/5yAeP6Nmk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vvt0dwkzVmsjuGLq8iRsbD0+VzzWHWPoWy+NwBCCsvn4QedHusbwg7IPvUU0WmZeH
         vKiojB+U+i5almx1Ne9eEeZHt7lBTCavX5NcNu0BLpRY7PS131pHB8ZVHsYuyWnlmI
         AGIS91qaXG49DCT8i82N3LZl/0JAlbhlb5qoeuQA=
Date:   Mon, 13 Jun 2022 11:13:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Snitzer <snitzer@kernel.org>
Cc:     Oleksandr Tymoshenko <ovt@google.com>, keescook@chromium.org,
        sarthakkukreti@google.com, stable@vger.kernel.org,
        regressions@lists.linux.dev, dm-devel@redhat.com
Subject: Re: [PATCH 5.4 26/34] dm verity: set DM_TARGET_IMMUTABLE feature flag
Message-ID: <Yqb/sT205Lrhl6Bv@kroah.com>
References: <20220603173816.944766454@linuxfoundation.org>
 <20220610042200.2561917-1-ovt@google.com>
 <YqLTV+5Q72/jBeOG@kroah.com>
 <YqNfBMOR9SE2TuCm@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqNfBMOR9SE2TuCm@redhat.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 10, 2022 at 11:11:00AM -0400, Mike Snitzer wrote:
> On Fri, Jun 10 2022 at  1:15P -0400,
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > On Fri, Jun 10, 2022 at 04:22:00AM +0000, Oleksandr Tymoshenko wrote:
> > > I believe this commit introduced a regression in dm verity on systems
> > > where data device is an NVME one. Loading table fails with the
> > > following diagnostics:
> > > 
> > > device-mapper: table: table load rejected: including non-request-stackable devices
> > > 
> > > The same kernel works with the same data drive on the SCSI interface.
> > > NVME-backed dm verity works with just this commit reverted.
> > > 
> > > I believe the presence of the immutable partition is used as an indicator
> > > of special case NVME configuration and if the data device's name starts
> > > with "nvme" the code tries to switch the target type to
> > > DM_TYPE_NVME_BIO_BASED (drivers/md/dm-table.c lines 1003-1010).
> > > 
> > > The special NVME optimization case was removed in
> > > 5.10 by commit 9c37de297f6590937f95a28bec1b7ac68a38618f, so only 5.4 is
> > > affected.
> > > 
> > 
> > Why wouldn't 4.9, 4.14, and 4.19 also be affected here?  Should I also
> > just queue up 9c37de297f65 ("dm: remove special-casing of bio-based
> > immutable singleton target on NVMe") to those older kernels?  If so,
> > have you tested this and verified that it worked?
> 
> Sorry for the unforeseen stable@ troubles here!
> 
> In general we'd be fine to apply commit 9c37de297f65 but to do it
> properly would require also making sure commits that remove
> "DM_TYPE_NVME_BIO_BASED", like 8d47e65948dd ("dm mpath: remove
> unnecessary NVMe branching in favor of scsi_dh checks") are applied --
> basically any lingering references to DM_TYPE_NVME_BIO_BASED need to
> be removed.
> 
> The commit header for 8d47e65948dd documents what
> DM_TYPE_NVME_BIO_BASED was used for.. it was dm-mpath specific and
> "nvme" mode really never got used by any userspace that I'm aware of.
> 
> Sadly I currently don't have the time to do this backport for all N
> stable kernels... :(
> 
> But if that backport gets out of control: A simpler, albeit stable@
> unicorn, way to resolve this is to simply revert 9c37de297f65 and make
> it so that DM-mpath and DM core just used bio-based if "nvme" is
> requested by dm-mpath, so also in drivers/md/dm-mpath.c e.g.:
> 
> @@ -1091,8 +1088,6 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
> 
>                         if (!strcasecmp(queue_mode_name, "bio"))
>                                 m->queue_mode = DM_TYPE_BIO_BASED;
> 			else if (!strcasecmp(queue_mode_name, "nvme"))
> -                               m->queue_mode = DM_TYPE_NVME_BIO_BASED;
> +                               m->queue_mode = DM_TYPE_BIO_BASED;
>                         else if (!strcasecmp(queue_mode_name, "rq"))
>                                 m->queue_mode = DM_TYPE_REQUEST_BASED;
>                         else if (!strcasecmp(queue_mode_name, "mq"))
> 
> Mike
> 

Ok, please submit a working patch for the kernels that need it so that
we can review and apply it to solve this regression.

thanks,

greg k-h
