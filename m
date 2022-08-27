Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57ABC5A3311
	for <lists+stable@lfdr.de>; Sat, 27 Aug 2022 02:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbiH0A1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Aug 2022 20:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbiH0A1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Aug 2022 20:27:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF49DE9AA4;
        Fri, 26 Aug 2022 17:27:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61C6C6188F;
        Sat, 27 Aug 2022 00:27:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A274C433B5;
        Sat, 27 Aug 2022 00:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661560023;
        bh=g6Fczq+e4vFz11SSps3NqjieFBOu+DQYPjNgDy5r3lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ImkjkNubGAUiWTVWzvfUdrzLtU2ouJrgeCmEeKKIawAKqALjnZVjuPGICQoLTKwYu
         Zn+yPUgXfE7VWwMLI2PVmEdBQWK71Lqrrlds08eiz5LsN6e7efwPxEcKEEGh3XiucX
         DX+YRkSRC4m3S7AIY6//ZoyYQ0b3M+CR9g8WCHSEYxLGgXwfA5Wuwp/ZzXJQynpenl
         pfod1mRgIt3S7e8q/d37DfNN8lmDfG69vznxec8M3iMt8CQa+v4//EK77YzO7phuQT
         eMqD4rzJNmMdZfdCNwosLNo+xFlxkxRXUCYMSDtrqnlo7erw+YKmaGAglRvCZ3477Q
         K6hrE2LwT3zEg==
From:   SeongJae Park <sj@kernel.org>
To:     SeongJae Park <sj@kernel.org>
Cc:     Maximilian Heyne <mheyne@amazon.de>, jgross@suse.com,
        roger.pau@citrix.com, marmarek@invisiblethingslab.com,
        xen-devel@lists.xenproject.org, axboe@kernel.dk,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] xen-blkfront: Advertise feature-persistent as user requested
Date:   Sat, 27 Aug 2022 00:27:00 +0000
Message-Id: <20220827002700.54181-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220826212039.50736-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 26 Aug 2022 21:20:39 +0000 SeongJae Park <sj@kernel.org> wrote:

> Hi Max,
> 
> On Fri, 26 Aug 2022 14:26:58 +0000 Maximilian Heyne <mheyne@amazon.de> wrote:
> 
> > On Thu, Aug 25, 2022 at 04:15:11PM +0000, SeongJae Park wrote:
> > > 
> > > Commit e94c6101e151 ("xen-blkback: Apply 'feature_persistent' parameter
> > > when connect") made blkback to advertise its support of the persistent
> > > grants feature only if the user sets the 'feature_persistent' parameter
> > > of the driver and the frontend advertised its support of the feature.
> > > However, following commit 402c43ea6b34 ("xen-blkfront: Apply
> > > 'feature_persistent' parameter when connect") made the blkfront to work
> > > in the same way.  That is, blkfront also advertises its support of the
> > > persistent grants feature only if the user sets the 'feature_persistent'
> > > parameter of the driver and the backend advertised its support of the
> > > feature.
> > > 
> > > Hence blkback and blkfront will never advertise their support of the
> > > feature but wait until the other advertises the support, even though
> > > users set the 'feature_persistent' parameters of the drivers.  As a
> > > result, the persistent grants feature is disabled always regardless of
> > > the 'feature_persistent' values[1].
> > > 
> > > The problem comes from the misuse of the semantic of the advertisement
> > > of the feature.  The advertisement of the feature should means only
> > > availability of the feature not the decision for using the feature.
> > > However, current behavior is working in the wrong way.
> > > 
> > > This commit fixes the issue by making the blkfront advertises its
> > > support of the feature as user requested via 'feature_persistent'
> > > parameter regardless of the otherend's support of the feature.
> > > 
> > > [1] https://lore.kernel.org/xen-devel/bd818aba-4857-bc07-dc8a-e9b2f8c5f7cd@suse.com/
> > > 
> > > Fixes: 402c43ea6b34 ("xen-blkfront: Apply 'feature_persistent' parameter when connect")
> > > Cc: <stable@vger.kernel.org> # 5.10.x
> > > Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
> > > Suggested-by: Juergen Gross <jgross@suse.com>
> > > Signed-off-by: SeongJae Park <sj@kernel.org>
> > > ---
> > >  drivers/block/xen-blkfront.c | 8 ++++++--
> > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> > > index 8e56e69fb4c4..dfae08115450 100644
> > > --- a/drivers/block/xen-blkfront.c
> > > +++ b/drivers/block/xen-blkfront.c
> > > @@ -213,6 +213,9 @@ struct blkfront_info
> > >         unsigned int feature_fua:1;
> > >         unsigned int feature_discard:1;
> > >         unsigned int feature_secdiscard:1;
> > > +       /* Connect-time cached feature_persistent parameter */
> > > +       unsigned int feature_persistent_parm:1;
> > > +       /* Persistent grants feature negotiation result */
> > >         unsigned int feature_persistent:1;
> > >         unsigned int bounce:1;
> > >         unsigned int discard_granularity;
> > > @@ -1848,7 +1851,7 @@ static int talk_to_blkback(struct xenbus_device *dev,
> > >                 goto abort_transaction;
> > >         }
> > >         err = xenbus_printf(xbt, dev->nodename, "feature-persistent", "%u",
> > > -                       info->feature_persistent);
> > > +                       info->feature_persistent_parm);
> > >         if (err)
> > >                 dev_warn(&dev->dev,
> > >                          "writing persistent grants feature to xenbus");
> > > @@ -2281,7 +2284,8 @@ static void blkfront_gather_backend_features(struct blkfront_info *info)
> > >         if (xenbus_read_unsigned(info->xbdev->otherend, "feature-discard", 0))
> > >                 blkfront_setup_discard(info);
> > > 
> > > -       if (feature_persistent)
> > > +       info->feature_persistent_parm = feature_persistent;
> > 
> > I think setting this here is too late because "feature-persistent" was already
> > written to xenstore via talk_to_blkback but with default 0. So during the
> > connect blkback will not see that the guest supports the feature and falls back
> > to no persistent grants.
> > 
> > Tested only this patch with some hacky dom0 kernel that doesn't have the patch
> > from your series yet. Will do more testing next week.
> 
> Appreciate for your test!  And you're right, this patch is not fixing the issue
> completely.  That is, commit 402c43ea6b34 ("xen-blkfront: Apply
> 'feature_persistent' parameter when connect") introduced two bugs.  One is the
> misuse of the semantic of the advertisement.  It's fixed by this patch.  The
> second bug, which you found here, is caching the parameter in a wrong place.
> 
> In detail, blkfront does the advertisement before connect (for init and resume)
> and then negotiation after connected.  And the blkback does the negotiation
> first, and then the advertisement during the establishing the connection.
> Hence, blkback should cache the parameter just before the negotiation logic
> while blkfront should do that just before the advertisement logic.
> 
> The blkback behavior change commit (e94c6101e151) did the work in the right
> place, but the blkfront behavior change commit didn't.
> 
> So, I guess below change would fix the issue entirely when applied together
> with this patch.  Any opinion, please?
> 
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index dfae08115450..7d3bde271e69 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -1850,6 +1850,7 @@ static int talk_to_blkback(struct xenbus_device *dev,
>                 message = "writing protocol";
>                 goto abort_transaction;
>         }
> +       info->feature_persistent_parm = feature_persistent;
>         err = xenbus_printf(xbt, dev->nodename, "feature-persistent", "%u",
>                         info->feature_persistent_parm);
>         if (err)
> @@ -2284,7 +2285,6 @@ static void blkfront_gather_backend_features(struct blkfront_info *info)
>         if (xenbus_read_unsigned(info->xbdev->otherend, "feature-discard", 0))
>                 blkfront_setup_discard(info);
> 
> -       info->feature_persistent_parm = feature_persistent;
>         if (info->feature_persistent_parm)
>                 info->feature_persistent =
>                         !!xenbus_read_unsigned(info->xbdev->otherend,

FWIW, 'feature_persistent' variable definition should be moved to above of
'talk_to_blkback()'.  Otherwise, build would fail.


Thanks,
SJ

> 
> 
> Thanks,
> SJ
> 
> 
> > 
> > > +       if (info->feature_persistent_parm)
> > >                 info->feature_persistent =
> > >                         !!xenbus_read_unsigned(info->xbdev->otherend,
> > >                                                "feature-persistent", 0);
> > > --
> > > 2.25.1
> > > 
> > 
