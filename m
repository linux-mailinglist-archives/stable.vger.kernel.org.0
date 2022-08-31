Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856BD5A822A
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 17:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiHaPtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 11:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbiHaPsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 11:48:15 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E76140D4;
        Wed, 31 Aug 2022 08:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1661960891; x=1693496891;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=y+fkgIc9fvNBrkNoyidj8kDyZUg8P/MCawXruROBWFs=;
  b=BvnX8v7tP5wOrwXpnipTpmMbz+dabx6j71fKwAT3wIfsmkHoQRveJtqw
   XFKyXYuGgDadZL6Y/Kh02Fi6I06/7j6KJSumASFjOQ1UqmB32zeWzalqj
   yyHLtKLN09IMtfxpjoIht8DnYTBSz3liyFTBxH0YpB2qIwjY/5mJugAx0
   s=;
X-IronPort-AV: E=Sophos;i="5.93,278,1654560000"; 
   d="scan'208";a="1049979248"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-5bed4ba5.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 15:47:53 +0000
Received: from EX13D08EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-5bed4ba5.us-west-2.amazon.com (Postfix) with ESMTPS id CC52E8E23E;
        Wed, 31 Aug 2022 15:47:52 +0000 (UTC)
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08EUC001.ant.amazon.com (10.43.164.184) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Wed, 31 Aug 2022 15:47:51 +0000
Received: from dev-dsk-ptyadav-1c-613f0921.eu-west-1.amazon.com (10.15.8.155)
 by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.38 via Frontend Transport; Wed, 31 Aug 2022 15:47:50 +0000
Received: by dev-dsk-ptyadav-1c-613f0921.eu-west-1.amazon.com (Postfix, from userid 23027615)
        id 8E5ED25976; Wed, 31 Aug 2022 15:47:50 +0000 (UTC)
Date:   Wed, 31 Aug 2022 15:47:50 +0000
From:   Pratyush Yadav <ptyadav@amazon.de>
To:     SeongJae Park <sj@kernel.org>
CC:     <jgross@suse.com>, <roger.pau@citrix.com>,
        <marmarek@invisiblethingslab.com>, <mheyne@amazon.de>,
        <xen-devel@lists.xenproject.org>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] xen-blkback: Advertise feature-persistent as user
 requested
Message-ID: <20220831153259.fzdkgbi76hmxa67a@yadavpratyush.com>
References: <20220825161511.94922-1-sj@kernel.org>
 <20220825161511.94922-2-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220825161511.94922-2-sj@kernel.org>
X-Spam-Status: No, score=-11.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 25/08/22 04:15PM, SeongJae Park wrote:
> Commit e94c6101e151 ("xen-blkback: Apply 'feature_persistent' parameter
> when connect") made blkback to advertise its support of the persistent
> grants feature only if the user sets the 'feature_persistent' parameter
> of the driver and the frontend advertised its support of the feature.
> However, following commit 402c43ea6b34 ("xen-blkfront: Apply
> 'feature_persistent' parameter when connect") made the blkfront to work
> in the same way.  That is, blkfront also advertises its support of the
> persistent grants feature only if the user sets the 'feature_persistent'
> parameter of the driver and the backend advertised its support of the
> feature.
> 
> Hence blkback and blkfront will never advertise their support of the
> feature but wait until the other advertises the support, even though
> users set the 'feature_persistent' parameters of the drivers.  As a
> result, the persistent grants feature is disabled always regardless of
> the 'feature_persistent' values[1].
> 
> The problem comes from the misuse of the semantic of the advertisement
> of the feature.  The advertisement of the feature should means only
> availability of the feature not the decision for using the feature.
> However, current behavior is working in the wrong way.
> 
> This commit fixes the issue by making the blkback advertises its support
> of the feature as user requested via 'feature_persistent' parameter
> regardless of the otherend's support of the feature.
> 
> [1] https://lore.kernel.org/xen-devel/bd818aba-4857-bc07-dc8a-e9b2f8c5f7cd@suse.com/
> 
> Fixes: e94c6101e151 ("xen-blkback: Apply 'feature_persistent' parameter when connect")
> Cc: <stable@vger.kernel.org> # 5.10.x
> Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
> Suggested-by: Juergen Gross <jgross@suse.com>
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  drivers/block/xen-blkback/common.h | 3 +++
>  drivers/block/xen-blkback/xenbus.c | 6 ++++--
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
> index bda5c815e441..a28473470e66 100644
> --- a/drivers/block/xen-blkback/common.h
> +++ b/drivers/block/xen-blkback/common.h
> @@ -226,6 +226,9 @@ struct xen_vbd {
>  	sector_t		size;
>  	unsigned int		flush_support:1;
>  	unsigned int		discard_secure:1;
> +	/* Connect-time cached feature_persistent parameter value */
> +	unsigned int		feature_gnt_persistent_parm:1;
> +	/* Persistent grants feature negotiation result */
>  	unsigned int		feature_gnt_persistent:1;
>  	unsigned int		overflow_max_grants:1;
>  };
> diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
> index ee7ad2fb432d..c0227dfa4688 100644
> --- a/drivers/block/xen-blkback/xenbus.c
> +++ b/drivers/block/xen-blkback/xenbus.c
> @@ -907,7 +907,7 @@ static void connect(struct backend_info *be)
>  	xen_blkbk_barrier(xbt, be, be->blkif->vbd.flush_support);
>  
>  	err = xenbus_printf(xbt, dev->nodename, "feature-persistent", "%u",
> -			be->blkif->vbd.feature_gnt_persistent);
> +			be->blkif->vbd.feature_gnt_persistent_parm);
>  	if (err) {
>  		xenbus_dev_fatal(dev, err, "writing %s/feature-persistent",
>  				 dev->nodename);
> @@ -1085,7 +1085,9 @@ static int connect_ring(struct backend_info *be)
>  		return -ENOSYS;
>  	}
>  
> -	blkif->vbd.feature_gnt_persistent = feature_persistent &&
> +	blkif->vbd.feature_gnt_persistent_parm = feature_persistent;

If feature_gnt_persistent_parm is always going to be equal to 
feature_persistent, then why introduce it at all? Why not just use 
feature_persistent directly? This way you avoid adding an extra flag 
whose purpose is not immediately clear, and you also avoid all the mess 
with setting this flag at the right time.

> +	blkif->vbd.feature_gnt_persistent =
> +		blkif->vbd.feature_gnt_persistent_parm &&
>  		xenbus_read_unsigned(dev->otherend, "feature-persistent", 0);
>  
>  	blkif->vbd.overflow_max_grants = 0;
> -- 
> 2.25.1
> 
> 
