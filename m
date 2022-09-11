Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8DC5B4C35
	for <lists+stable@lfdr.de>; Sun, 11 Sep 2022 07:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiIKFkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Sep 2022 01:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiIKFko (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Sep 2022 01:40:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B882E17599;
        Sat, 10 Sep 2022 22:40:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 744C1B80935;
        Sun, 11 Sep 2022 05:40:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA97BC433D6;
        Sun, 11 Sep 2022 05:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662874840;
        bh=Dr7c9iomyGRdSR43QbEQHNt1uFkVH+Wnkxpi3Fd7m4s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mJj4RPhz3S0fAdvaNkjlH8awbfZu1RXUdvb3ZA1InudpvXzPXhFT89h87Do7nqjnq
         uAdVLNlOvfSKVoba1dwfdAluAvSv1DmYHqP8m/lCCxMhs7b26lSr21xjiJ05wSzUXc
         Ye6DwOz9RfhseyFE+Tf1WImbfl/SJBFs1jIT8e0M=
Date:   Sun, 11 Sep 2022 07:41:02 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Eugeniu Rosca <erosca@de.adit-jv.com>
Cc:     Trond Myklebust <trondmy@hammerspace.com>,
        "neilb@suse.de" <neilb@suse.de>,
        "mrodin@de.adit-jv.com" <mrodin@de.adit-jv.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "roscaeugeniu@gmail.com" <roscaeugeniu@gmail.com>
Subject: Re: [PATCH 4.14 022/284] SUNRPC: avoid race between mod_timer() and
 del_timer_sync()
Message-ID: <Yx107owrRwmIc7pX@kroah.com>
References: <20220418121210.689577360@linuxfoundation.org>
 <20220418121211.327937970@linuxfoundation.org>
 <20220907142548.GA9975@lxhi-065>
 <166259870333.30452.4204968221881228505@noble.neil.brown.name>
 <f575eeb3000330d9194c6256ad6063bc58f996c7.camel@hammerspace.com>
 <20220908120931.GA3480@lxhi-065>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908120931.GA3480@lxhi-065>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 08, 2022 at 02:09:31PM +0200, Eugeniu Rosca wrote:
> Hello Neil,
> Hello Trond,
> 
> On Do, Sep 08, 2022 at 01:09:29 +0000, Trond Myklebust wrote:
> > On Thu, 2022-09-08 at 10:58 +1000, NeilBrown wrote:
> > > On Thu, 08 Sep 2022, Eugeniu Rosca wrote:
> > > > Hello all,
> > > > 
> > > > On Mo, Apr 18, 2022 at 02:10:03 +0200, Greg Kroah-Hartman wrote:
> > > > > From: NeilBrown <neilb@suse.de>
> > > > > 
> > > > > commit 3848e96edf4788f772d83990022fa7023a233d83 upstream.
> > > > > 
> > > > > xprt_destory() claims XPRT_LOCKED and then calls
> > > > > del_timer_sync().
> > > > > Both xprt_unlock_connect() and xprt_release() call
> > > > >  ->release_xprt()
> > > > > which drops XPRT_LOCKED and *then* xprt_schedule_autodisconnect()
> > > > > which calls mod_timer().
> > > > > 
> > > > > This may result in mod_timer() being called *after*
> > > > > del_timer_sync().
> > > > > When this happens, the timer may fire long after the xprt has
> > > > > been freed,
> > > > > and run_timer_softirq() will probably crash.
> > > > > 
> > > > > The pairing of ->release_xprt() and
> > > > > xprt_schedule_autodisconnect() is
> > > > > always called under ->transport_lock.  So if we take -
> > > > > >transport_lock to
> > > > > call del_timer_sync(), we can be sure that mod_timer() will run
> > > > > first
> > > > > (if it runs at all).
> > > > > 
> > > > > Cc: stable@vger.kernel.org
> > > > > Signed-off-by: NeilBrown <neilb@suse.de>
> > > > > Signed-off-by: Trond Myklebust <https://urldefense.proofpoint.com/v2/url?u=http-3A__trond.myklebust-40hammerspace.com&d=DwIGaQ&c=euGZstcaTDllvimEN8b7jXrwqOf-v5A_CdpgnVfiiMM&r=SAhjP5GOmrADp1v_EE5jWoSuMlYCIt9gKduw-DCBPLs&m=HrAc1Ouz3sNPrdBv5QBgh7SToNI8M0iGJyDPgOTT5AE&s=cNzW7c7t83SH27ck7hxvneR9awrt17JualiCD6TZtdI&e=>
> > > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > ---
> > > > >  net/sunrpc/xprt.c |    7 +++++++
> > > > >  1 file changed, 7 insertions(+)
> > > > > 
> > > > > --- a/net/sunrpc/xprt.c
> > > > > +++ b/net/sunrpc/xprt.c
> > > > > @@ -1520,7 +1520,14 @@ static void xprt_destroy(struct rpc_xprt
> > > > >          */
> > > > >         wait_on_bit_lock(&xprt->state, XPRT_LOCKED,
> > > > > TASK_UNINTERRUPTIBLE);
> > > > >  
> > > > > +       /*
> > > > > +        * xprt_schedule_autodisconnect() can run after
> > > > > XPRT_LOCKED
> > > > > +        * is cleared.  We use ->transport_lock to ensure the
> > > > > mod_timer()
> > > > > +        * can only run *before* del_time_sync(), never after.
> > > > > +        */
> > > > > +       spin_lock(&xprt->transport_lock);
> > > > >         del_timer_sync(&xprt->timer);
> > > > > +       spin_unlock(&xprt->transport_lock);
> > > 
> > > I think it is sufficient to change the to spin_{,un}lock_bh()
> > > in older kernels.  The spinlock call need to match other uses of the
> > > same lock.
> > 
> > Agreed. On older kernels, the xprt->transport_lock served the same
> > purpose, but it had to take a bh-safe spinlock in order to avoid
> > certain races with the socket callbacks. Since then, a number of
> > changes to both the socket layer and the SUNRPC code have made it
> > possible to eliminate bh-safe requirement.
> > 
> > > 
> > > Can you confirm doing that removes the problem?
> 
> Your proposal [*] seems to resolve the issue for me.
> 
> Any chance to get a stable patch, to which I will gladly provide
> the Reviewed-by/Tested-by signatures?
> 
> > > 
> > > NeilBrown
> > > 
> 
> [*] diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
> index e7d55d63d4f1..7f9b94acf597 100644
> --- a/net/sunrpc/xprt.c
> +++ b/net/sunrpc/xprt.c
> @@ -1525,9 +1525,9 @@ static void xprt_destroy(struct rpc_xprt *xprt)
>  	 * is cleared.  We use ->transport_lock to ensure the mod_timer()
>  	 * can only run *before* del_time_sync(), never after.
>  	 */
> -	spin_lock(&xprt->transport_lock);
> +	spin_lock_bh(&xprt->transport_lock);
>  	del_timer_sync(&xprt->timer);
> -	spin_unlock(&xprt->transport_lock);
> +	spin_unlock_bh(&xprt->transport_lock);
>  
>  	/*
>  	 * Destroy sockets etc from the system workqueue so they can
> 

Can you just turn this into a proper patch that we can apply to the
needed stable tree(s)?

thanks,

greg k-h
