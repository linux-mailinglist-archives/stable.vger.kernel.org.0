Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6124E91A0
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 11:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236481AbiC1Jo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 05:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236203AbiC1Jo2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 05:44:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4AF213D70;
        Mon, 28 Mar 2022 02:42:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7094E60EFB;
        Mon, 28 Mar 2022 09:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6EBC340ED;
        Mon, 28 Mar 2022 09:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648460566;
        bh=K37a3LN3h3JA5FWXkkFDjUnaU63eyav4SZXBMRkzCsg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RmAqKzkT8fkHxf4xi4joHqW1Cub9p4b0/XG8WjVyhC6lhTfR73AzAGV8DoJxqdi5m
         EzlNeUIkocEM2Ens1d08qwNK5GPmgyt50dMqRgFPeTKtjJrroT8MaCc0bBDUBpmWIi
         Z09n2aIdVo+DenWgnqsb1dlYhanVXNSwX4msbycA=
Date:   Mon, 28 Mar 2022 11:42:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        =?utf-8?B?6LW15a2Q6L2p?= <beraphin@gmail.com>,
        Stoyan Manolov <smanolov@suse.de>
Subject: Re: [PATCH 5.10 09/38] llc: fix netdevice reference leaks in
 llc_ui_bind()
Message-ID: <YkGDEzS7bWHNIoP3@kroah.com>
References: <20220325150419.757836392@linuxfoundation.org>
 <20220325150420.029041400@linuxfoundation.org>
 <20220326200922.GA9262@duo.ucw.cz>
 <20220326131325.397bc0e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YkAziXrW7/Fbqo/b@kroah.com>
 <20220328090830.GA24435@amd>
 <YkF8HQ7Ih3IUJ3jT@kroah.com>
 <20220328093115.GB26815@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328093115.GB26815@amd>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 28, 2022 at 11:31:16AM +0200, Pavel Machek wrote:
> Hi!
> 
> > > > > Should be in mainline on Thursday, LMK if we need to accelerate.
> > > > > IDK if anyone enables LLC2.
> > > > 
> > > > I'll queue this up now, thanks.
> > > 
> > > As the changelog says, this needs b37a46683739, otherwise there will
> > > be oops-es in even more cases.
> > 
> > If you look at the change, I think I already handled that issue.  If
> > not, please let me know.
> 
> I did not notice you making changes there, but no, it is not correct
> AFAICT.
> 
> # commit 163960a7de1333514c9352deb7c80c6b9fd9abf2
> # Author: Eric Dumazet <edumazet@google.com>
> # Date:   Thu Mar 24 20:58:27 2022 -0700
> 
> #    llc: only change llc->dev when bind() succeeds
> ...    
> #     Make sure commit b37a46683739 ("netdevice: add the case if dev is NULL")
> #     is already present in your trees.
> 
> Before b37a46683739, dev_put can't handle NULL.
>     
> +++ b/net/llc/af_llc.c
> @@ -287,14 +288,14 @@ static int llc_ui_autobind(struct socket *sock, struct sockaddr_llc *addr)
> ...
> 
> -		llc->dev = dev_getfirstbyhwtype(&init_net, addr->sllc_arphrd);
> -	if (!llc->dev)
> +		dev = dev_getfirstbyhwtype(&init_net, addr->sllc_arphrd);
> +	if (!dev)
>  		goto out;
>  	rc = -EUSERS;
>  	llc->laddr.lsap = llc_ui_autoport();
> 
> One of several paths where we goto out with dev==NULL.
> 
> @@ -311,10 +317,7 @@ static int llc_ui_autobind(struct socket *sock, struct sockaddr_llc *addr)
>  	sock_reset_flag(sk, SOCK_ZAPPED);
>  	rc = 0;
>  out:
> -	if (rc) {
> -		dev_put(llc->dev);
> -		llc->dev = NULL;
> -	}
> +	dev_put(dev);
>  	return rc;
>  }
> 
> 
> But dev_put can't handle NULL.

Ah, missed that one.  I'll go queue up b37a46683739 now.

thanks,

greg k-h
