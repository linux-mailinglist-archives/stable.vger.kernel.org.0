Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30A335A2967
	for <lists+stable@lfdr.de>; Fri, 26 Aug 2022 16:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237347AbiHZO1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Aug 2022 10:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344425AbiHZO1T (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Aug 2022 10:27:19 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34537B7BA;
        Fri, 26 Aug 2022 07:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1661524035; x=1693060035;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:content-transfer-encoding:subject;
  bh=3KHfG9pE5vUtzEuAuE175SucQTfUj+3os4tgSI5rGug=;
  b=BRujo0VQI/jE021v/Pr+D8b+4umEbqrJymmEKBT5I+QeBZKawQPKG46g
   fNF/Ga7YIcFCRT2sV7x4XRdSoiquhGdkSgW3i5PJBn9hMKeDkGwYpWts3
   Iw1X8lIYOY4udkNRmzaxvyBqpc8YKwZNeGBIUHUC3mdX7sA2Y9nFjGscg
   w=;
X-IronPort-AV: E=Sophos;i="5.93,265,1654560000"; 
   d="scan'208";a="237815397"
Subject: Re: [PATCH 2/2] xen-blkfront: Advertise feature-persistent as user requested
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-b09ea7fa.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 14:27:00 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-b09ea7fa.us-west-2.amazon.com (Postfix) with ESMTPS id A73F044E7B;
        Fri, 26 Aug 2022 14:26:59 +0000 (UTC)
Received: from EX19D048UWA004.ant.amazon.com (10.13.139.40) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 26 Aug 2022 14:26:59 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX19D048UWA004.ant.amazon.com (10.13.139.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Fri, 26 Aug 2022 14:26:58 +0000
Received: from dev-dsk-mheyne-1b-c1362c4d.eu-west-1.amazon.com (10.15.57.183)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.38 via Frontend Transport; Fri, 26 Aug 2022 14:26:58 +0000
Received: by dev-dsk-mheyne-1b-c1362c4d.eu-west-1.amazon.com (Postfix, from userid 5466572)
        id 4069E26EF; Fri, 26 Aug 2022 14:26:58 +0000 (UTC)
Date:   Fri, 26 Aug 2022 14:26:58 +0000
From:   Maximilian Heyne <mheyne@amazon.de>
To:     SeongJae Park <sj@kernel.org>
CC:     <jgross@suse.com>, <roger.pau@citrix.com>,
        <marmarek@invisiblethingslab.com>,
        <xen-devel@lists.xenproject.org>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Message-ID: <20220826142658.GA77627@dev-dsk-mheyne-1b-c1362c4d.eu-west-1.amazon.com>
References: <20220825161511.94922-1-sj@kernel.org>
 <20220825161511.94922-3-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20220825161511.94922-3-sj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 25, 2022 at 04:15:11PM +0000, SeongJae Park wrote:
> CAUTION: This email originated from outside of the organization. Do not c=
lick links or open attachments unless you can confirm the sender and know t=
he content is safe.
> =

> =

> =

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
> =

> Hence blkback and blkfront will never advertise their support of the
> feature but wait until the other advertises the support, even though
> users set the 'feature_persistent' parameters of the drivers.  As a
> result, the persistent grants feature is disabled always regardless of
> the 'feature_persistent' values[1].
> =

> The problem comes from the misuse of the semantic of the advertisement
> of the feature.  The advertisement of the feature should means only
> availability of the feature not the decision for using the feature.
> However, current behavior is working in the wrong way.
> =

> This commit fixes the issue by making the blkfront advertises its
> support of the feature as user requested via 'feature_persistent'
> parameter regardless of the otherend's support of the feature.
> =

> [1] https://lore.kernel.org/xen-devel/bd818aba-4857-bc07-dc8a-e9b2f8c5f7c=
d@suse.com/
> =

> Fixes: 402c43ea6b34 ("xen-blkfront: Apply 'feature_persistent' parameter =
when connect")
> Cc: <stable@vger.kernel.org> # 5.10.x
> Reported-by: Marek Marczykowski-G=F3recki <marmarek@invisiblethingslab.co=
m>
> Suggested-by: Juergen Gross <jgross@suse.com>
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  drivers/block/xen-blkfront.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> =

> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 8e56e69fb4c4..dfae08115450 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -213,6 +213,9 @@ struct blkfront_info
>         unsigned int feature_fua:1;
>         unsigned int feature_discard:1;
>         unsigned int feature_secdiscard:1;
> +       /* Connect-time cached feature_persistent parameter */
> +       unsigned int feature_persistent_parm:1;
> +       /* Persistent grants feature negotiation result */
>         unsigned int feature_persistent:1;
>         unsigned int bounce:1;
>         unsigned int discard_granularity;
> @@ -1848,7 +1851,7 @@ static int talk_to_blkback(struct xenbus_device *de=
v,
>                 goto abort_transaction;
>         }
>         err =3D xenbus_printf(xbt, dev->nodename, "feature-persistent", "=
%u",
> -                       info->feature_persistent);
> +                       info->feature_persistent_parm);
>         if (err)
>                 dev_warn(&dev->dev,
>                          "writing persistent grants feature to xenbus");
> @@ -2281,7 +2284,8 @@ static void blkfront_gather_backend_features(struct=
 blkfront_info *info)
>         if (xenbus_read_unsigned(info->xbdev->otherend, "feature-discard"=
, 0))
>                 blkfront_setup_discard(info);
> =

> -       if (feature_persistent)
> +       info->feature_persistent_parm =3D feature_persistent;

I think setting this here is too late because "feature-persistent" was alre=
ady
written to xenstore via talk_to_blkback but with default 0. So during the
connect blkback will not see that the guest supports the feature and falls =
back
to no persistent grants.

Tested only this patch with some hacky dom0 kernel that doesn't have the pa=
tch
from your series yet. Will do more testing next week.

> +       if (info->feature_persistent_parm)
>                 info->feature_persistent =3D
>                         !!xenbus_read_unsigned(info->xbdev->otherend,
>                                                "feature-persistent", 0);
> --
> 2.25.1
> =




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



