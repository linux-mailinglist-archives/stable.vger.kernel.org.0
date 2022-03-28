Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF994E90D4
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 11:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbiC1JOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 05:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234016AbiC1JOo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 05:14:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08797338A1;
        Mon, 28 Mar 2022 02:13:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9295260ECF;
        Mon, 28 Mar 2022 09:13:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5FAC004DD;
        Mon, 28 Mar 2022 09:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648458783;
        bh=xlgUvlrc9AqQXNkKJA9r8fmQgBBJGNDElqvjL2e27Mk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1p9+BBDKpfOjgMTmbQm3GuboZDswNM95lBLwGVsZOU9vJ26Y94Giy60+CTzfCPHDE
         NiQoIk8iWy7ue8DwIv7T1Uk3QEBDz2mEyRs/5oxkMcCS/SNQuM/asuW098XR/Qx9ap
         0+/HNvf4BUhIMUSUtdkZd0nZ5vmwTfQ1RfTyvrsk=
Date:   Mon, 28 Mar 2022 11:13:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        =?utf-8?B?6LW15a2Q6L2p?= <beraphin@gmail.com>,
        Stoyan Manolov <smanolov@suse.de>
Subject: Re: [PATCH 5.10 09/38] llc: fix netdevice reference leaks in
 llc_ui_bind()
Message-ID: <YkF8HQ7Ih3IUJ3jT@kroah.com>
References: <20220325150419.757836392@linuxfoundation.org>
 <20220325150420.029041400@linuxfoundation.org>
 <20220326200922.GA9262@duo.ucw.cz>
 <20220326131325.397bc0e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YkAziXrW7/Fbqo/b@kroah.com>
 <20220328090830.GA24435@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328090830.GA24435@amd>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 28, 2022 at 11:08:30AM +0200, Pavel Machek wrote:
> Hi!
> 
> > > > Can someone check this? AFAICT this is buggy.
> > > > 
> > > > static int llc_ui_autobind(struct socket *sock, struct sockaddr_llc *addr)
> > > > {
> > > >         struct sock *sk = sock->sk;
> > > >         struct llc_sock *llc = llc_sk(sk);
> > > >         struct llc_sap *sap;
> > > >         int rc = -EINVAL;
> > > > 
> > > >         if (!sock_flag(sk, SOCK_ZAPPED))
> > > >                 goto out;
> > > > 
> > > > There are 'goto out's from both before dev_get() and after it,
> > > > dev_put() will be called with NULL pointer. dev_put() can't handle
> > > > NULL at least in the old kernels... this is simply confused.
> > > > 
> > > > Mainline has dev_put_track() there, but I see same confusion.
> > > > 
> > > > Best regards,
> > > 
> > > commit 2d327a79ee17 ("llc: only change llc->dev when bind() succeeds"),
> > > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=2d327a79ee176930dc72c131a970c891d367c1dc
> > > 
> > > Should be in mainline on Thursday, LMK if we need to accelerate.
> > > IDK if anyone enables LLC2.
> > 
> > I'll queue this up now, thanks.
> 
> As the changelog says, this needs b37a46683739, otherwise there will
> be oops-es in even more cases.

If you look at the change, I think I already handled that issue.  If
not, please let me know.

thanks,

greg k-h
