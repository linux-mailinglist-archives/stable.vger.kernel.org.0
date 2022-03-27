Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD5B4E8728
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 11:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbiC0Jy5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 05:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbiC0Jy5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 05:54:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4CAF10FF3;
        Sun, 27 Mar 2022 02:53:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94AD4B80BEC;
        Sun, 27 Mar 2022 09:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08567C340ED;
        Sun, 27 Mar 2022 09:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648374796;
        bh=TiXLiP8osfZLBM1tROoLRqWuO2Nu9f4WDTma6rPEE/s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QBZpWgMvh5HKSy/hj4zSf9A5LV9AfAwN6c4UbP1HviO+BeShhz1EehVHWWFd11dMW
         ec9L9vLNcOj8a22u0qyJxiZTNjUjkX6vWAInHhePjdZ29gK4fEj0fpuJhsfxBMm9G6
         swZ9Bigb84TWJjTUuNDS4woR5gJmHzCQuLAOM/Ow=
Date:   Sun, 27 Mar 2022 11:51:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        =?utf-8?B?6LW15a2Q6L2p?= <beraphin@gmail.com>,
        Stoyan Manolov <smanolov@suse.de>
Subject: Re: [PATCH 5.10 09/38] llc: fix netdevice reference leaks in
 llc_ui_bind()
Message-ID: <YkAziXrW7/Fbqo/b@kroah.com>
References: <20220325150419.757836392@linuxfoundation.org>
 <20220325150420.029041400@linuxfoundation.org>
 <20220326200922.GA9262@duo.ucw.cz>
 <20220326131325.397bc0e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220326131325.397bc0e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 26, 2022 at 01:13:25PM -0700, Jakub Kicinski wrote:
> On Sat, 26 Mar 2022 21:09:22 +0100 Pavel Machek wrote:
> > Can someone check this? AFAICT this is buggy.
> > 
> > static int llc_ui_autobind(struct socket *sock, struct sockaddr_llc *addr)
> > {
> >         struct sock *sk = sock->sk;
> >         struct llc_sock *llc = llc_sk(sk);
> >         struct llc_sap *sap;
> >         int rc = -EINVAL;
> > 
> >         if (!sock_flag(sk, SOCK_ZAPPED))
> >                 goto out;
> > 
> > There are 'goto out's from both before dev_get() and after it,
> > dev_put() will be called with NULL pointer. dev_put() can't handle
> > NULL at least in the old kernels... this is simply confused.
> > 
> > Mainline has dev_put_track() there, but I see same confusion.
> > 
> > Best regards,
> 
> commit 2d327a79ee17 ("llc: only change llc->dev when bind() succeeds"),
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=2d327a79ee176930dc72c131a970c891d367c1dc
> 
> Should be in mainline on Thursday, LMK if we need to accelerate.
> IDK if anyone enables LLC2.

I'll queue this up now, thanks.

greg k-h
