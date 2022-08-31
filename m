Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE6D5A8300
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 18:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbiHaQUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 12:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbiHaQUr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 12:20:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3AB6F567;
        Wed, 31 Aug 2022 09:20:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 019B2B821EC;
        Wed, 31 Aug 2022 16:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB391C433D7;
        Wed, 31 Aug 2022 16:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661962841;
        bh=mP7bY6kuZc9xANg6iW41oQkce9SwkX/s/4sydwbPcjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mKAxncKKgrqPf9z1NEdnLQx6+7HIVT5B0iodsnbqAMy7uSqLjxRVvUlHuv2+g/tgA
         vNAFgnSnFnD7Or+FIfXuNZjhTAfdcyrkLZqH3tHat5GOE0Lf0UZiD/Cb8u7YgxHTyb
         r964TWGMQIQOc1E45665y19axjm+NpDqURdotluc+O26NNGLYsjneXBMo6688Hu3hm
         2BcnxJov8rKlO1LGghjrCnbJCFVdT6zgeQ5N8sQ79esQwraE7gCBWkM2h3GGundUAP
         vQV9BSsGD9xn+0VnudTKDVEeZ823m+c5eBEuXtefj5A4OmUxpeHZKrR7lgU4RbwpM9
         7IS1mhda/JgaA==
From:   SeongJae Park <sj@kernel.org>
To:     Pratyush Yadav <ptyadav@amazon.de>
Cc:     SeongJae Park <sj@kernel.org>, jgross@suse.com,
        roger.pau@citrix.com, marmarek@invisiblethingslab.com,
        mheyne@amazon.de, xen-devel@lists.xenproject.org, axboe@kernel.dk,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] xen-blkfront: Advertise feature-persistent as user requested
Date:   Wed, 31 Aug 2022 16:20:36 +0000
Message-Id: <20220831162036.93966-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220831155045.kxopdchlc67fmi5n@yadavpratyush.com>
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

Hi Pratyush,

On Wed, 31 Aug 2022 15:50:45 +0000 Pratyush Yadav <ptyadav@amazon.de> wrote:

> On 25/08/22 04:15PM, SeongJae Park wrote:
> > Commit e94c6101e151 ("xen-blkback: Apply 'feature_persistent' parameter
> > when connect") made blkback to advertise its support of the persistent
> > grants feature only if the user sets the 'feature_persistent' parameter
> > of the driver and the frontend advertised its support of the feature.
> > However, following commit 402c43ea6b34 ("xen-blkfront: Apply
> > 'feature_persistent' parameter when connect") made the blkfront to work
> > in the same way.  That is, blkfront also advertises its support of the
> > persistent grants feature only if the user sets the 'feature_persistent'
> > parameter of the driver and the backend advertised its support of the
> > feature.
> > 
> > Hence blkback and blkfront will never advertise their support of the
> > feature but wait until the other advertises the support, even though
> > users set the 'feature_persistent' parameters of the drivers.  As a
> > result, the persistent grants feature is disabled always regardless of
> > the 'feature_persistent' values[1].
> > 
> > The problem comes from the misuse of the semantic of the advertisement
> > of the feature.  The advertisement of the feature should means only
> > availability of the feature not the decision for using the feature.
> > However, current behavior is working in the wrong way.
> > 
> > This commit fixes the issue by making the blkfront advertises its
> > support of the feature as user requested via 'feature_persistent'
> > parameter regardless of the otherend's support of the feature.
> > 
> > [1] https://lore.kernel.org/xen-devel/bd818aba-4857-bc07-dc8a-e9b2f8c5f7cd@suse.com/
> > 
> > Fixes: 402c43ea6b34 ("xen-blkfront: Apply 'feature_persistent' parameter when connect")
> > Cc: <stable@vger.kernel.org> # 5.10.x
> > Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
> > Suggested-by: Juergen Gross <jgross@suse.com>
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > ---
> >  drivers/block/xen-blkfront.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> > index 8e56e69fb4c4..dfae08115450 100644
> > --- a/drivers/block/xen-blkfront.c
> > +++ b/drivers/block/xen-blkfront.c
> > @@ -213,6 +213,9 @@ struct blkfront_info
> >  	unsigned int feature_fua:1;
> >  	unsigned int feature_discard:1;
> >  	unsigned int feature_secdiscard:1;
> > +	/* Connect-time cached feature_persistent parameter */
> > +	unsigned int feature_persistent_parm:1;
> > +	/* Persistent grants feature negotiation result */
> >  	unsigned int feature_persistent:1;
> >  	unsigned int bounce:1;
> >  	unsigned int discard_granularity;
> > @@ -1848,7 +1851,7 @@ static int talk_to_blkback(struct xenbus_device *dev,
> >  		goto abort_transaction;
> >  	}
> >  	err = xenbus_printf(xbt, dev->nodename, "feature-persistent", "%u",
> > -			info->feature_persistent);
> > +			info->feature_persistent_parm);
> >  	if (err)
> >  		dev_warn(&dev->dev,
> >  			 "writing persistent grants feature to xenbus");
> > @@ -2281,7 +2284,8 @@ static void blkfront_gather_backend_features(struct blkfront_info *info)
> >  	if (xenbus_read_unsigned(info->xbdev->otherend, "feature-discard", 0))
> >  		blkfront_setup_discard(info);
> >  
> > -	if (feature_persistent)
> > +	info->feature_persistent_parm = feature_persistent;
> 
> Same question as before. Why not just use feature_persistent directly?

Same answer as before, due to the possible race[1].

[1] https://lore.kernel.org/linux-block/20200922111259.GJ19254@Air-de-Roger/

> 
> > +	if (info->feature_persistent_parm)
> >  		info->feature_persistent =
> >  			!!xenbus_read_unsigned(info->xbdev->otherend,
> >  					       "feature-persistent", 0);
> 
> Aside: IMO this would look nicer as below:
> 
> 	info->feature_persistent = feature_persistent && !!xenbus_read_unsigned();

Agreed, that would also make the code more consistent with the blkback side
code.

I would make the change in the next version of this patchset.


Thanks,
SJ
