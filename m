Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE515B57FC
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 12:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiILKPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 06:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiILKPT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 06:15:19 -0400
Received: from hi1smtp01.de.adit-jv.com (smtp1.de.adit-jv.com [93.241.18.167])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C86C19C21;
        Mon, 12 Sep 2022 03:15:18 -0700 (PDT)
Received: from hi2exch02.adit-jv.com (hi2exch02.adit-jv.com [10.72.92.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hi1smtp01.de.adit-jv.com (Postfix) with ESMTPS id 9358C520594;
        Mon, 12 Sep 2022 12:15:16 +0200 (CEST)
Received: from lxhi-065 (10.72.94.21) by hi2exch02.adit-jv.com (10.72.92.28)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2308.27; Mon, 12 Sep
 2022 12:15:15 +0200
Date:   Mon, 12 Sep 2022 12:15:08 +0200
From:   Eugeniu Rosca <erosca@de.adit-jv.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Eugeniu Rosca <erosca@de.adit-jv.com>,
        Trond Myklebust <trondmy@hammerspace.com>,
        "neilb@suse.de" <neilb@suse.de>,
        "mrodin@de.adit-jv.com" <mrodin@de.adit-jv.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "roscaeugeniu@gmail.com" <roscaeugeniu@gmail.com>
Subject: Re: [PATCH 4.14 022/284] SUNRPC: avoid race between mod_timer() and
 del_timer_sync()
Message-ID: <20220912101508.GA5500@lxhi-065>
References: <20220418121210.689577360@linuxfoundation.org>
 <20220418121211.327937970@linuxfoundation.org>
 <20220907142548.GA9975@lxhi-065>
 <166259870333.30452.4204968221881228505@noble.neil.brown.name>
 <f575eeb3000330d9194c6256ad6063bc58f996c7.camel@hammerspace.com>
 <20220908120931.GA3480@lxhi-065>
 <Yx107owrRwmIc7pX@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Yx107owrRwmIc7pX@kroah.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Originating-IP: [10.72.94.21]
X-ClientProxiedBy: hi2exch02.adit-jv.com (10.72.92.28) To
 hi2exch02.adit-jv.com (10.72.92.28)
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

On So, Sep 11, 2022 at 07:41:02 +0200, gregkh@linuxfoundation.org wrote:
> On Thu, Sep 08, 2022 at 02:09:31PM +0200, Eugeniu Rosca wrote:

[..]

> > Your proposal [*] seems to resolve the issue for me.
> > 
> > Any chance to get a stable patch, to which I will gladly provide
> > the Reviewed-by/Tested-by signatures?
> > 
> > > > 
> > > > NeilBrown
> > > > 
> > 
> > [*] diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
> > index e7d55d63d4f1..7f9b94acf597 100644
> > --- a/net/sunrpc/xprt.c
> > +++ b/net/sunrpc/xprt.c
> > @@ -1525,9 +1525,9 @@ static void xprt_destroy(struct rpc_xprt *xprt)
> >  	 * is cleared.  We use ->transport_lock to ensure the mod_timer()
> >  	 * can only run *before* del_time_sync(), never after.
> >  	 */
> > -	spin_lock(&xprt->transport_lock);
> > +	spin_lock_bh(&xprt->transport_lock);
> >  	del_timer_sync(&xprt->timer);
> > -	spin_unlock(&xprt->transport_lock);
> > +	spin_unlock_bh(&xprt->transport_lock);
> >  
> >  	/*
> >  	 * Destroy sockets etc from the system workqueue so they can
> > 
> 
> Can you just turn this into a proper patch that we can apply to the
> needed stable tree(s)?

It has been kindly provided by Neil Brown in
https://lore.kernel.org/lkml/166293725263.30452.1720462103844620549@noble.neil.brown.name/

Best Regards,
Eugeniu Rosca
