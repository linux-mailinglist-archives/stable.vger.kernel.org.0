Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 997265AAD2C
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 13:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236057AbiIBLMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 07:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235830AbiIBLLd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 07:11:33 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D491EC7B90;
        Fri,  2 Sep 2022 04:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1662117089; x=1693653089;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6syYNqYADgJ/uyZ9pJBWRfO0mouP2N6IJMJoILo4HW0=;
  b=P+/xjhKqYpWc9umHw7ARMbJ163HgF9/nytW7tYnuWORlFdrRcPuaOe+z
   z9HFreuszZZ9tx9PJcL9+EHkk6kaqS6r68NhGYUJlF744EnCcwb9ersNt
   7f8q+r7UTG2J1P8uy5xe2BBzW3fkCyNgN17q0iEw4CfaUDskpuj1aW+XL
   g=;
X-IronPort-AV: E=Sophos;i="5.93,283,1654560000"; 
   d="scan'208";a="236927472"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-92ba9394.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 11:11:15 +0000
Received: from EX13D05EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-92ba9394.us-west-2.amazon.com (Postfix) with ESMTPS id 9051B4558C;
        Fri,  2 Sep 2022 11:11:12 +0000 (UTC)
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D05EUC001.ant.amazon.com (10.43.164.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 2 Sep 2022 11:11:11 +0000
Received: from dev-dsk-mheyne-1b-c1362c4d.eu-west-1.amazon.com (10.15.57.183)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.38 via Frontend Transport; Fri, 2 Sep 2022 11:11:09 +0000
Received: by dev-dsk-mheyne-1b-c1362c4d.eu-west-1.amazon.com (Postfix, from userid 5466572)
        id 58D8226F6; Fri,  2 Sep 2022 11:11:08 +0000 (UTC)
Date:   Fri, 2 Sep 2022 11:11:08 +0000
From:   Maximilian Heyne <mheyne@amazon.de>
To:     Pratyush Yadav <ptyadav@amazon.de>
CC:     SeongJae Park <sj@kernel.org>, <jgross@suse.com>,
        <roger.pau@citrix.com>, <marmarek@invisiblethingslab.com>,
        <xen-devel@lists.xenproject.org>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] xen-blkback: Advertise feature-persistent as user
 requested
Message-ID: <20220902111108.GA27172@dev-dsk-mheyne-1b-c1362c4d.eu-west-1.amazon.com>
References: <20220831165824.94815-1-sj@kernel.org>
 <20220831165824.94815-2-sj@kernel.org>
 <20220902095207.y3whbc5mw4hyqphg@yadavpratyush.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220902095207.y3whbc5mw4hyqphg@yadavpratyush.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 02, 2022 at 09:53:22AM +0000, Pratyush Yadav wrote:
> On 31/08/22 04:58PM, SeongJae Park wrote:
> > The advertisement of the persistent grants feature (writing
> > 'feature-persistent' to xenbus) should mean not the decision for using
> > the feature but only the availability of the feature.  However, commit
> > aac8a70db24b ("xen-blkback: add a parameter for disabling of persistent
> > grants") made a field of blkback, which was a place for saving only the
> > negotiation result, to be used for yet another purpose: caching of the
> > 'feature_persistent' parameter value.  As a result, the advertisement,
> > which should follow only the parameter value, becomes inconsistent.
> > 
> > This commit fixes the misuse of the semantic by making blkback saves the
> > parameter value in a separate place and advertises the support based on
> > only the saved value.
> > 
> > Fixes: aac8a70db24b ("xen-blkback: add a parameter for disabling of persistent grants")
> > Cc: <stable@vger.kernel.org> # 5.10.x
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
> >         sector_t                size;
> >         unsigned int            flush_support:1;
> >         unsigned int            discard_secure:1;
> > +       /* Connect-time cached feature_persistent parameter value */
> > +       unsigned int            feature_gnt_persistent_parm:1;
> 
> Continuing over from the previous version:
> 
> > > If feature_gnt_persistent_parm is always going to be equal to 
> > > feature_persistent, then why introduce it at all? Why not just use 
> > > feature_persistent directly? This way you avoid adding an extra flag 
> > > whose purpose is not immediately clear, and you also avoid all the 
> > > mess with setting this flag at the right time.
> >
> > Mainly because the parameter should read twice (once for 
> > advertisement, and once later just before the negotitation, for 
> > checking if we advertised or not), and the user might change the 
> > parameter value between the two reads.
> >
> > For the detailed available sequence of the race, you could refer to the 
> > prior conversation[1].
> >
> > [1] https://lore.kernel.org/linux-block/20200922111259.GJ19254@Air-de-Roger/
> 
> Okay, I see. Thanks for the pointer. But still, I think it would be 
> better to not maintain two copies of the value. How about doing:
> 
> 	blkif->vbd.feature_gnt_persistent =
> 		xenbus_read_unsigned(dev->nodename, "feature-persistent", 0) &&
> 		xenbus_read_unsigned(dev->otherend, "feature-persistent", 0);
> 
> This makes it quite clear that we only enable persistent grants if 
> _both_ ends support it. We can do the same for blkfront.

Currently, the feature-persistent xenstore entry is written to from connect()
which is called after connect_ring(). So it's not available like this.  Perhaps
it's possible to delay the decision whether to use persistent grants until
connect().

> 
> > +       /* Persistent grants feature negotiation result */
> >         unsigned int            feature_gnt_persistent:1;
> >         unsigned int            overflow_max_grants:1;
> >  };
> > diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
> > index ee7ad2fb432d..c0227dfa4688 100644
> > --- a/drivers/block/xen-blkback/xenbus.c
> > +++ b/drivers/block/xen-blkback/xenbus.c
> > @@ -907,7 +907,7 @@ static void connect(struct backend_info *be)
> >         xen_blkbk_barrier(xbt, be, be->blkif->vbd.flush_support);
> > 
> >         err = xenbus_printf(xbt, dev->nodename, "feature-persistent", "%u",
> > -                       be->blkif->vbd.feature_gnt_persistent);
> > +                       be->blkif->vbd.feature_gnt_persistent_parm);
> >         if (err) {
> >                 xenbus_dev_fatal(dev, err, "writing %s/feature-persistent",
> >                                  dev->nodename);
> > @@ -1085,7 +1085,9 @@ static int connect_ring(struct backend_info *be)
> >                 return -ENOSYS;
> >         }
> > 
> > -       blkif->vbd.feature_gnt_persistent = feature_persistent &&
> > +       blkif->vbd.feature_gnt_persistent_parm = feature_persistent;
> > +       blkif->vbd.feature_gnt_persistent =
> > +               blkif->vbd.feature_gnt_persistent_parm &&
> >                 xenbus_read_unsigned(dev->otherend, "feature-persistent", 0);
> > 
> >         blkif->vbd.overflow_max_grants = 0;
> > --
> > 2.25.1
> > 
> 
> -- 
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



