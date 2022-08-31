Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E81055A82E1
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 18:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbiHaQRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 12:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbiHaQRu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 12:17:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3D4D4F72;
        Wed, 31 Aug 2022 09:17:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E0B261958;
        Wed, 31 Aug 2022 16:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6D7C433C1;
        Wed, 31 Aug 2022 16:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661962665;
        bh=2d72f6ZKuMN8oZ4S4xSp9+IUsC77vGcpoLIrln4q3HU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E/zoiqW0CXelaAIpNPabokQCPHML9pmxsjeAaHpoc9tiVZd3jKRKxr3yRVOv3bryn
         hNfAGxDcQNLx8hEjr6PAQ4zNzsm3c/5cQzfFC4uA11MqzX1+0NVaiXDOr9w1Gs9/mL
         9qBI+Gr6m5KH69e0y4pZO4t45IGF5h60K2INVzu8tKEhmmU/s6hqXjscz0RIkbmWjU
         Up8lUA3GpjduwLZq0rpelh2qn2byGkKceUj2HxerzNgQZ/h/mvBF6LgoAGF2tZVcDd
         KTMiaTHLWBorZxCuRnJc0tVviqiDEEsgwZZUNTuAx6m3GdYcpp9fKnKKoWu02gihcr
         ANFoxeRDrjaWw==
From:   SeongJae Park <sj@kernel.org>
To:     Pratyush Yadav <ptyadav@amazon.de>
Cc:     SeongJae Park <sj@kernel.org>, jgross@suse.com,
        roger.pau@citrix.com, marmarek@invisiblethingslab.com,
        mheyne@amazon.de, xen-devel@lists.xenproject.org, axboe@kernel.dk,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] xen-blkback: Advertise feature-persistent as user requested
Date:   Wed, 31 Aug 2022 16:17:43 +0000
Message-Id: <20220831161743.93872-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220831153259.fzdkgbi76hmxa67a@yadavpratyush.com>
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

On Wed, 31 Aug 2022 15:47:50 +0000 Pratyush Yadav <ptyadav@amazon.de> wrote:

> Hi,
> 
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
> > This commit fixes the issue by making the blkback advertises its support
> > of the feature as user requested via 'feature_persistent' parameter
> > regardless of the otherend's support of the feature.
> > 
> > [1] https://lore.kernel.org/xen-devel/bd818aba-4857-bc07-dc8a-e9b2f8c5f7cd@suse.com/
> > 
> > Fixes: e94c6101e151 ("xen-blkback: Apply 'feature_persistent' parameter when connect")
> > Cc: <stable@vger.kernel.org> # 5.10.x
> > Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
> > Suggested-by: Juergen Gross <jgross@suse.com>
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > ---
> >  drivers/block/xen-blkback/common.h | 3 +++
> >  drivers/block/xen-blkback/xenbus.c | 6 ++++--
> >  2 files changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
> > index bda5c815e441..a28473470e66 100644
> > --- a/drivers/block/xen-blkback/common.h
> > +++ b/drivers/block/xen-blkback/common.h
> > @@ -226,6 +226,9 @@ struct xen_vbd {
> >  	sector_t		size;
> >  	unsigned int		flush_support:1;
> >  	unsigned int		discard_secure:1;
> > +	/* Connect-time cached feature_persistent parameter value */
> > +	unsigned int		feature_gnt_persistent_parm:1;
> > +	/* Persistent grants feature negotiation result */
> >  	unsigned int		feature_gnt_persistent:1;
> >  	unsigned int		overflow_max_grants:1;
> >  };
> > diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
> > index ee7ad2fb432d..c0227dfa4688 100644
> > --- a/drivers/block/xen-blkback/xenbus.c
> > +++ b/drivers/block/xen-blkback/xenbus.c
> > @@ -907,7 +907,7 @@ static void connect(struct backend_info *be)
> >  	xen_blkbk_barrier(xbt, be, be->blkif->vbd.flush_support);
> >  
> >  	err = xenbus_printf(xbt, dev->nodename, "feature-persistent", "%u",
> > -			be->blkif->vbd.feature_gnt_persistent);
> > +			be->blkif->vbd.feature_gnt_persistent_parm);
> >  	if (err) {
> >  		xenbus_dev_fatal(dev, err, "writing %s/feature-persistent",
> >  				 dev->nodename);
> > @@ -1085,7 +1085,9 @@ static int connect_ring(struct backend_info *be)
> >  		return -ENOSYS;
> >  	}
> >  
> > -	blkif->vbd.feature_gnt_persistent = feature_persistent &&
> > +	blkif->vbd.feature_gnt_persistent_parm = feature_persistent;
> 
> If feature_gnt_persistent_parm is always going to be equal to 
> feature_persistent, then why introduce it at all? Why not just use 
> feature_persistent directly? This way you avoid adding an extra flag 
> whose purpose is not immediately clear, and you also avoid all the mess 
> with setting this flag at the right time.

Mainly because the parameter should read twice (once for advertisement, and
once later just before the negotitation, for checking if we advertised or not),
and the user might change the parameter value between the two reads.

For the detailed available sequence of the race, you could refer to the prior
conversation[1].

[1] https://lore.kernel.org/linux-block/20200922111259.GJ19254@Air-de-Roger/


Thanks,
SJ

> 
> > +	blkif->vbd.feature_gnt_persistent =
> > +		blkif->vbd.feature_gnt_persistent_parm &&
> >  		xenbus_read_unsigned(dev->otherend, "feature-persistent", 0);
> >  
> >  	blkif->vbd.overflow_max_grants = 0;
> > -- 
> > 2.25.1
> > 
> > 
> 
