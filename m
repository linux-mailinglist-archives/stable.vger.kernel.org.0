Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5E5F5B57CA
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 12:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiILKF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 06:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiILKF2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 06:05:28 -0400
Received: from hi1smtp01.de.adit-jv.com (smtp1.de.adit-jv.com [93.241.18.167])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2A2167F9;
        Mon, 12 Sep 2022 03:05:27 -0700 (PDT)
Received: from hi2exch02.adit-jv.com (hi2exch02.adit-jv.com [10.72.92.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hi1smtp01.de.adit-jv.com (Postfix) with ESMTPS id 87E5A520594;
        Mon, 12 Sep 2022 12:05:24 +0200 (CEST)
Received: from lxhi-065 (10.72.94.21) by hi2exch02.adit-jv.com (10.72.92.28)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2308.27; Mon, 12 Sep
 2022 12:05:23 +0200
Date:   Mon, 12 Sep 2022 12:05:15 +0200
From:   Eugeniu Rosca <erosca@de.adit-jv.com>
To:     NeilBrown <neilb@suse.de>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Trond Myklebust <trondmy@hammerspace.com>,
        "mrodin@de.adit-jv.com" <mrodin@de.adit-jv.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "roscaeugeniu@gmail.com" <roscaeugeniu@gmail.com>
Subject: Re: [PATCH - stable] SUNRPC: use _bh spinlocking on ->transport_lock
Message-ID: <20220912100515.GA5252@lxhi-065>
References: <20220418121210.689577360@linuxfoundation.org>
 <20220418121211.327937970@linuxfoundation.org>
 <20220907142548.GA9975@lxhi-065>
 <166259870333.30452.4204968221881228505@noble.neil.brown.name>
 <f575eeb3000330d9194c6256ad6063bc58f996c7.camel@hammerspace.com>
 <20220908120931.GA3480@lxhi-065>
 <Yx107owrRwmIc7pX@kroah.com>
 <166293725263.30452.1720462103844620549@noble.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <166293725263.30452.1720462103844620549@noble.neil.brown.name>
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

Hello Neil,

Many thanks for the solution. Much appreciated.

On Mo, Sep 12, 2022 at 09:00:52 +1000, NeilBrown wrote:
> 
> Prior to Linux 5.3, ->transport_lock in sunrpc required the _bh style
> spinlocks (when not called from a bottom-half handler).
> 
> When upstream 3848e96edf4788f772d83990022fa7023a233d83 was backported to
> stable kernels, the spin_lock/unlock calls should have been changed to
> the _bh version, but this wasn't noted in the patch and didn't happen.
> 
> So convert these lock/unlock calls to the _bh versions.
> 
> This patch is required for any stable kernel prior to 5.3 to which the
> above mentioned patch was backported.  Namely 4.9.y, 4.14.y, 4.19.y.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  net/sunrpc/xprt.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
> index d05fa7c36d00..b1abf4848bbc 100644
> --- a/net/sunrpc/xprt.c
> +++ b/net/sunrpc/xprt.c
> @@ -1550,9 +1550,9 @@ static void xprt_destroy(struct rpc_xprt *xprt)
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

Fixes: v4.19.238 commit 242a3e0c75b64b ("SUNRPC: avoid race between mod_timer() and del_timer_sync()")
Fixes: v4.14.276 commit dd7d3a609aac16 ("SUNRPC: avoid race between mod_timer() and del_timer_sync()")
Fixes: v4.9.311 commit 6180bbce52739e ("SUNRPC: avoid race between mod_timer() and del_timer_sync()")

Reported-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Reviewed-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Tested-by: Eugeniu Rosca <erosca@de.adit-jv.com>

Best Regards,
Eugeniu Rosca
