Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C60F5B1C61
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 14:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiIHMKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 08:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiIHMKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 08:10:09 -0400
Received: from hi1smtp01.de.adit-jv.com (smtp1.de.adit-jv.com [93.241.18.167])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4FC18B15;
        Thu,  8 Sep 2022 05:09:39 -0700 (PDT)
Received: from hi2exch02.adit-jv.com (hi2exch02.adit-jv.com [10.72.92.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hi1smtp01.de.adit-jv.com (Postfix) with ESMTPS id 23E985202E7;
        Thu,  8 Sep 2022 14:09:37 +0200 (CEST)
Received: from lxhi-065 (10.72.94.31) by hi2exch02.adit-jv.com (10.72.92.28)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2308.27; Thu, 8 Sep
 2022 14:09:36 +0200
Date:   Thu, 8 Sep 2022 14:09:31 +0200
From:   Eugeniu Rosca <erosca@de.adit-jv.com>
To:     Trond Myklebust <trondmy@hammerspace.com>,
        "neilb@suse.de" <neilb@suse.de>
CC:     "erosca@de.adit-jv.com" <erosca@de.adit-jv.com>,
        "mrodin@de.adit-jv.com" <mrodin@de.adit-jv.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "roscaeugeniu@gmail.com" <roscaeugeniu@gmail.com>
Subject: Re: [PATCH 4.14 022/284] SUNRPC: avoid race between mod_timer() and
 del_timer_sync()
Message-ID: <20220908120931.GA3480@lxhi-065>
References: <20220418121210.689577360@linuxfoundation.org>
 <20220418121211.327937970@linuxfoundation.org>
 <20220907142548.GA9975@lxhi-065>
 <166259870333.30452.4204968221881228505@noble.neil.brown.name>
 <f575eeb3000330d9194c6256ad6063bc58f996c7.camel@hammerspace.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f575eeb3000330d9194c6256ad6063bc58f996c7.camel@hammerspace.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Originating-IP: [10.72.94.31]
X-ClientProxiedBy: hi2exch02.adit-jv.com (10.72.92.28) To
 hi2exch02.adit-jv.com (10.72.92.28)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Neil,
Hello Trond,

On Do, Sep 08, 2022 at 01:09:29 +0000, Trond Myklebust wrote:
> On Thu, 2022-09-08 at 10:58 +1000, NeilBrown wrote:
> > On Thu, 08 Sep 2022, Eugeniu Rosca wrote:
> > > Hello all,
> > > 
> > > On Mo, Apr 18, 2022 at 02:10:03 +0200, Greg Kroah-Hartman wrote:
> > > > From: NeilBrown <neilb@suse.de>
> > > > 
> > > > commit 3848e96edf4788f772d83990022fa7023a233d83 upstream.
> > > > 
> > > > xprt_destory() claims XPRT_LOCKED and then calls
> > > > del_timer_sync().
> > > > Both xprt_unlock_connect() and xprt_release() call
> > > >  ->release_xprt()
> > > > which drops XPRT_LOCKED and *then* xprt_schedule_autodisconnect()
> > > > which calls mod_timer().
> > > > 
> > > > This may result in mod_timer() being called *after*
> > > > del_timer_sync().
> > > > When this happens, the timer may fire long after the xprt has
> > > > been freed,
> > > > and run_timer_softirq() will probably crash.
> > > > 
> > > > The pairing of ->release_xprt() and
> > > > xprt_schedule_autodisconnect() is
> > > > always called under ->transport_lock.  So if we take -
> > > > >transport_lock to
> > > > call del_timer_sync(), we can be sure that mod_timer() will run
> > > > first
> > > > (if it runs at all).
> > > > 
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: NeilBrown <neilb@suse.de>
> > > > Signed-off-by: Trond Myklebust <https://urldefense.proofpoint.com/v2/url?u=http-3A__trond.myklebust-40hammerspace.com&d=DwIGaQ&c=euGZstcaTDllvimEN8b7jXrwqOf-v5A_CdpgnVfiiMM&r=SAhjP5GOmrADp1v_EE5jWoSuMlYCIt9gKduw-DCBPLs&m=HrAc1Ouz3sNPrdBv5QBgh7SToNI8M0iGJyDPgOTT5AE&s=cNzW7c7t83SH27ck7hxvneR9awrt17JualiCD6TZtdI&e=>
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > ---
> > > >  net/sunrpc/xprt.c |    7 +++++++
> > > >  1 file changed, 7 insertions(+)
> > > > 
> > > > --- a/net/sunrpc/xprt.c
> > > > +++ b/net/sunrpc/xprt.c
> > > > @@ -1520,7 +1520,14 @@ static void xprt_destroy(struct rpc_xprt
> > > >          */
> > > >         wait_on_bit_lock(&xprt->state, XPRT_LOCKED,
> > > > TASK_UNINTERRUPTIBLE);
> > > >  
> > > > +       /*
> > > > +        * xprt_schedule_autodisconnect() can run after
> > > > XPRT_LOCKED
> > > > +        * is cleared.  We use ->transport_lock to ensure the
> > > > mod_timer()
> > > > +        * can only run *before* del_time_sync(), never after.
> > > > +        */
> > > > +       spin_lock(&xprt->transport_lock);
> > > >         del_timer_sync(&xprt->timer);
> > > > +       spin_unlock(&xprt->transport_lock);
> > 
> > I think it is sufficient to change the to spin_{,un}lock_bh()
> > in older kernels.  The spinlock call need to match other uses of the
> > same lock.
> 
> Agreed. On older kernels, the xprt->transport_lock served the same
> purpose, but it had to take a bh-safe spinlock in order to avoid
> certain races with the socket callbacks. Since then, a number of
> changes to both the socket layer and the SUNRPC code have made it
> possible to eliminate bh-safe requirement.
> 
> > 
> > Can you confirm doing that removes the problem?

Your proposal [*] seems to resolve the issue for me.

Any chance to get a stable patch, to which I will gladly provide
the Reviewed-by/Tested-by signatures?

> > 
> > NeilBrown
> > 

[*] diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index e7d55d63d4f1..7f9b94acf597 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1525,9 +1525,9 @@ static void xprt_destroy(struct rpc_xprt *xprt)
 	 * is cleared.  We use ->transport_lock to ensure the mod_timer()
 	 * can only run *before* del_time_sync(), never after.
 	 */
-	spin_lock(&xprt->transport_lock);
+	spin_lock_bh(&xprt->transport_lock);
 	del_timer_sync(&xprt->timer);
-	spin_unlock(&xprt->transport_lock);
+	spin_unlock_bh(&xprt->transport_lock);
 
 	/*
 	 * Destroy sockets etc from the system workqueue so they can

Best Regards,
Eugeniu Rosca
