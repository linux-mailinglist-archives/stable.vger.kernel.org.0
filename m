Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 737B35AABE6
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 11:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235788AbiIBJx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 05:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235901AbiIBJxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 05:53:44 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C17E82D19;
        Fri,  2 Sep 2022 02:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1662112422; x=1693648422;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RYkyDTlCTvMrlOLx7kj+NLb70k5rmvCjtCTCfEk9Kmg=;
  b=Rs4DN1ao4A5zAJOp4/ga33eur9LYSt/+aOu7rSU/FVEltgPXLZgmZHJ2
   sqFSwUmvy9fohozDpV3lbNSvFUBD5X5Frlp92xiWzRHhyD7+qPRUESJVY
   HqrnWwH2KlPS0FDNfMei320H6+E9xk8+9pIiTxiUaN6bG9TN7AV3dAnYA
   I=;
X-IronPort-AV: E=Sophos;i="5.93,283,1654560000"; 
   d="scan'208";a="255514482"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-1f9d5b26.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 09:53:26 +0000
Received: from EX13D08EUB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-1f9d5b26.us-west-2.amazon.com (Postfix) with ESMTPS id E124945026;
        Fri,  2 Sep 2022 09:53:25 +0000 (UTC)
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D08EUB002.ant.amazon.com (10.43.166.232) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 2 Sep 2022 09:53:25 +0000
Received: from dev-dsk-ptyadav-1c-613f0921.eu-west-1.amazon.com (10.15.8.155)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.38 via Frontend Transport; Fri, 2 Sep 2022 09:53:23 +0000
Received: by dev-dsk-ptyadav-1c-613f0921.eu-west-1.amazon.com (Postfix, from userid 23027615)
        id 65C212599D; Fri,  2 Sep 2022 09:53:22 +0000 (UTC)
Date:   Fri, 2 Sep 2022 09:53:22 +0000
From:   Pratyush Yadav <ptyadav@amazon.de>
To:     SeongJae Park <sj@kernel.org>
CC:     <jgross@suse.com>, <roger.pau@citrix.com>,
        <marmarek@invisiblethingslab.com>, <mheyne@amazon.de>,
        <xen-devel@lists.xenproject.org>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] xen-blkback: Advertise feature-persistent as user
 requested
Message-ID: <20220902095207.y3whbc5mw4hyqphg@yadavpratyush.com>
References: <20220831165824.94815-1-sj@kernel.org>
 <20220831165824.94815-2-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220831165824.94815-2-sj@kernel.org>
X-Spam-Status: No, score=-14.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 31/08/22 04:58PM, SeongJae Park wrote:
> The advertisement of the persistent grants feature (writing
> 'feature-persistent' to xenbus) should mean not the decision for using
> the feature but only the availability of the feature.  However, commit
> aac8a70db24b ("xen-blkback: add a parameter for disabling of persistent
> grants") made a field of blkback, which was a place for saving only the
> negotiation result, to be used for yet another purpose: caching of the
> 'feature_persistent' parameter value.  As a result, the advertisement,
> which should follow only the parameter value, becomes inconsistent.
> 
> This commit fixes the misuse of the semantic by making blkback saves the
> parameter value in a separate place and advertises the support based on
> only the saved value.
> 
> Fixes: aac8a70db24b ("xen-blkback: add a parameter for disabling of persistent grants")
> Cc: <stable@vger.kernel.org> # 5.10.x
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
>         sector_t                size;
>         unsigned int            flush_support:1;
>         unsigned int            discard_secure:1;
> +       /* Connect-time cached feature_persistent parameter value */
> +       unsigned int            feature_gnt_persistent_parm:1;

Continuing over from the previous version:

> > If feature_gnt_persistent_parm is always going to be equal to 
> > feature_persistent, then why introduce it at all? Why not just use 
> > feature_persistent directly? This way you avoid adding an extra flag 
> > whose purpose is not immediately clear, and you also avoid all the 
> > mess with setting this flag at the right time.
>
> Mainly because the parameter should read twice (once for 
> advertisement, and once later just before the negotitation, for 
> checking if we advertised or not), and the user might change the 
> parameter value between the two reads.
>
> For the detailed available sequence of the race, you could refer to the 
> prior conversation[1].
>
> [1] https://lore.kernel.org/linux-block/20200922111259.GJ19254@Air-de-Roger/

Okay, I see. Thanks for the pointer. But still, I think it would be 
better to not maintain two copies of the value. How about doing:

	blkif->vbd.feature_gnt_persistent =
		xenbus_read_unsigned(dev->nodename, "feature-persistent", 0) &&
		xenbus_read_unsigned(dev->otherend, "feature-persistent", 0);

This makes it quite clear that we only enable persistent grants if 
_both_ ends support it. We can do the same for blkfront.

> +       /* Persistent grants feature negotiation result */
>         unsigned int            feature_gnt_persistent:1;
>         unsigned int            overflow_max_grants:1;
>  };
> diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
> index ee7ad2fb432d..c0227dfa4688 100644
> --- a/drivers/block/xen-blkback/xenbus.c
> +++ b/drivers/block/xen-blkback/xenbus.c
> @@ -907,7 +907,7 @@ static void connect(struct backend_info *be)
>         xen_blkbk_barrier(xbt, be, be->blkif->vbd.flush_support);
> 
>         err = xenbus_printf(xbt, dev->nodename, "feature-persistent", "%u",
> -                       be->blkif->vbd.feature_gnt_persistent);
> +                       be->blkif->vbd.feature_gnt_persistent_parm);
>         if (err) {
>                 xenbus_dev_fatal(dev, err, "writing %s/feature-persistent",
>                                  dev->nodename);
> @@ -1085,7 +1085,9 @@ static int connect_ring(struct backend_info *be)
>                 return -ENOSYS;
>         }
> 
> -       blkif->vbd.feature_gnt_persistent = feature_persistent &&
> +       blkif->vbd.feature_gnt_persistent_parm = feature_persistent;
> +       blkif->vbd.feature_gnt_persistent =
> +               blkif->vbd.feature_gnt_persistent_parm &&
>                 xenbus_read_unsigned(dev->otherend, "feature-persistent", 0);
> 
>         blkif->vbd.overflow_max_grants = 0;
> --
> 2.25.1
> 

-- 
Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879
