Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC6154CCEF
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 17:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355042AbiFOPaI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 11:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353786AbiFOP3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 11:29:44 -0400
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F017E1759F
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 08:29:38 -0700 (PDT)
Received: by mail-qv1-f47.google.com with SMTP id q104so9043361qvq.8
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 08:29:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oOUOcgst0LKLvdZ4y1qA+jD7xbPureSESBaUterAPeQ=;
        b=bWbSyr90fdsQAFJfJwekDfS/9R1GXHwAjYqxBG4rf/SC6M0VWjku/NEeAjd4CW6BLw
         GvBsRVRoF4PQ7uARlI75g9GuW1XaHkeN887f5fQhq1HMZwdXef6HlAgdm8lIG7rMkhZe
         2ZlHV12Mk2xwizb7ntEldcr0cfw8iWUeYHd23OHudGvepazzLWYPTFeK+wS2kEpfts6W
         KpV5wVbSLxjxVv6gLrLpLDXVjM2Gb5RmKKP031o8RZTpQ7repNCmLFN2Wl1ei/56gHXW
         p82nmudcpyyxhd04h4GbT8Uz/S38yCiA6rkVNv9mw1Y2ReRdRQNzqlZCSZiGoztLmBFz
         Wbzw==
X-Gm-Message-State: AJIora/eiCU9A/oToXWhawn19N7+dHXTGFypTu87VNa/kOyUl4YbcPW7
        xwuTpgWK0h2rOrox43qhGGWd
X-Google-Smtp-Source: AGRyM1udyvePyABL3hVV3lkzQhfydZn0wmJrxJ9zo1e7WcUiTeQdcq2H4C9hLV+9rcwDXfakoleMEg==
X-Received: by 2002:a05:6214:5199:b0:464:58c0:3926 with SMTP id kl25-20020a056214519900b0046458c03926mr282092qvb.48.1655306977430;
        Wed, 15 Jun 2022 08:29:37 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id bk12-20020a05620a1a0c00b006a70f581243sm12307395qkb.93.2022.06.15.08.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 08:29:36 -0700 (PDT)
Date:   Wed, 15 Jun 2022 11:29:36 -0400
From:   Mike Snitzer <snitzer@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg KH <gregkh@linuxfoundation.org>, keescook@chromium.org,
        sarthakkukreti@google.com, Mike Snitzer <snitzer@kernel.org>,
        stable@vger.kernel.org, Oleksandr Tymoshenko <ovt@google.com>,
        dm-devel@redhat.com, regressions@lists.linux.dev
Subject: Re: [PATCH 5.4 26/34] dm verity: set DM_TARGET_IMMUTABLE feature flag
Message-ID: <Yqn64AMwoIzQXwXM@redhat.com>
References: <20220603173816.944766454@linuxfoundation.org>
 <20220610042200.2561917-1-ovt@google.com>
 <YqLTV+5Q72/jBeOG@kroah.com>
 <YqNfBMOR9SE2TuCm@redhat.com>
 <Yqb/sT205Lrhl6Bv@kroah.com>
 <20220615143642.GA2386944@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615143642.GA2386944@roeck-us.net>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 15 2022 at 10:36P -0400,
Guenter Roeck <linux@roeck-us.net> wrote:

> On Mon, Jun 13, 2022 at 11:13:21AM +0200, Greg KH wrote:
> > On Fri, Jun 10, 2022 at 11:11:00AM -0400, Mike Snitzer wrote:
> > > On Fri, Jun 10 2022 at  1:15P -0400,
> > > Greg KH <gregkh@linuxfoundation.org> wrote:
> > > 
> > > > On Fri, Jun 10, 2022 at 04:22:00AM +0000, Oleksandr Tymoshenko wrote:
> > > > > I believe this commit introduced a regression in dm verity on systems
> > > > > where data device is an NVME one. Loading table fails with the
> > > > > following diagnostics:
> > > > > 
> > > > > device-mapper: table: table load rejected: including non-request-stackable devices
> > > > > 
> > > > > The same kernel works with the same data drive on the SCSI interface.
> > > > > NVME-backed dm verity works with just this commit reverted.
> > > > > 
> > > > > I believe the presence of the immutable partition is used as an indicator
> > > > > of special case NVME configuration and if the data device's name starts
> > > > > with "nvme" the code tries to switch the target type to
> > > > > DM_TYPE_NVME_BIO_BASED (drivers/md/dm-table.c lines 1003-1010).
> > > > > 
> > > > > The special NVME optimization case was removed in
> > > > > 5.10 by commit 9c37de297f6590937f95a28bec1b7ac68a38618f, so only 5.4 is
> > > > > affected.
> > > > > 
> > > > 
> > > > Why wouldn't 4.9, 4.14, and 4.19 also be affected here?  Should I also
> > > > just queue up 9c37de297f65 ("dm: remove special-casing of bio-based
> > > > immutable singleton target on NVMe") to those older kernels?  If so,
> > > > have you tested this and verified that it worked?
> > > 
> > > Sorry for the unforeseen stable@ troubles here!
> > > 
> > > In general we'd be fine to apply commit 9c37de297f65 but to do it
> > > properly would require also making sure commits that remove
> > > "DM_TYPE_NVME_BIO_BASED", like 8d47e65948dd ("dm mpath: remove
> > > unnecessary NVMe branching in favor of scsi_dh checks") are applied --
> > > basically any lingering references to DM_TYPE_NVME_BIO_BASED need to
> > > be removed.
> > > 
> > > The commit header for 8d47e65948dd documents what
> > > DM_TYPE_NVME_BIO_BASED was used for.. it was dm-mpath specific and
> > > "nvme" mode really never got used by any userspace that I'm aware of.
> > > 
> > > Sadly I currently don't have the time to do this backport for all N
> > > stable kernels... :(
> > > 
> > > But if that backport gets out of control: A simpler, albeit stable@
> > > unicorn, way to resolve this is to simply revert 9c37de297f65 and make
> 
> 9c37de297f65 can not be reverted in 5.4 and older because it isn't there,
> and trying to apply it results in conflicts which at least I can not
> resolve.
> 
> > > it so that DM-mpath and DM core just used bio-based if "nvme" is
> > > requested by dm-mpath, so also in drivers/md/dm-mpath.c e.g.:
> > > 
> > > @@ -1091,8 +1088,6 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
> > > 
> > >                         if (!strcasecmp(queue_mode_name, "bio"))
> > >                                 m->queue_mode = DM_TYPE_BIO_BASED;
> > > 			else if (!strcasecmp(queue_mode_name, "nvme"))
> > > -                               m->queue_mode = DM_TYPE_NVME_BIO_BASED;
> > > +                               m->queue_mode = DM_TYPE_BIO_BASED;
> > >                         else if (!strcasecmp(queue_mode_name, "rq"))
> > >                                 m->queue_mode = DM_TYPE_REQUEST_BASED;
> > >                         else if (!strcasecmp(queue_mode_name, "mq"))
> > > 
> > > Mike
> > > 
> > 
> > Ok, please submit a working patch for the kernels that need it so that
> > we can review and apply it to solve this regression.
> > 
> 
> So, effectively, v5.4.y and older are broken right now for use cases
> with dm on NVME drives.
> 
> Given that the regression does affect older branches, and given that we
> have to revert this patch to avoid regressions in ChromeOS, would it be
> possible to revert it from v5.4.y and older until a fix is found ?

I obviously would prefer to not have this false-start.

I'll look at latest 5.4.y _now_ and see what can be done.

Should hopefully be pretty straight-forward.

Mike
