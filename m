Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0965C4E8413
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 21:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbiCZUPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 16:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbiCZUPG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 16:15:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528A81CFD3;
        Sat, 26 Mar 2022 13:13:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05634B802C4;
        Sat, 26 Mar 2022 20:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74328C340E8;
        Sat, 26 Mar 2022 20:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648325606;
        bh=67mC5+UyTHPDAPHu8NFPVWifvnSC7jO5bu6RDCWYbe4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F6gQAzLe+8aCsaLzFlgGhKjw2w4bnYdBwjFyN/S1gX7uw1LBEQy0PrJzLEUYq01Xh
         zJzmgBLaj/L4Iq7gIWgHG6fKo82T/hT+0iLzBOWISkFHgNEDWSWJUZ640073wvB3x7
         chwqWY909RPy+cvL3CAiDZLGibKRIXuHsM7Hi15jQwEh+fDvKdajfGPSAxSoRL97Kh
         peaV7U2FljtK7A8vq0yo8JNXTBSWaD3Cn9gxr0NvdWeBahaBl8ufpJuwYNfeBl1qmb
         ryDmB19575LmDgM9Hg5o6a2Sc63wd7YJBQdHKZtx1YLA0gHD+wrQaqkB25TO+ODruf
         hjqY/wi/uWeDw==
Date:   Sat, 26 Mar 2022 13:13:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        =?UTF-8?B?6LW15a2Q6L2p?= <beraphin@gmail.com>,
        Stoyan Manolov <smanolov@suse.de>
Subject: Re: [PATCH 5.10 09/38] llc: fix netdevice reference leaks in
 llc_ui_bind()
Message-ID: <20220326131325.397bc0e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220326200922.GA9262@duo.ucw.cz>
References: <20220325150419.757836392@linuxfoundation.org>
        <20220325150420.029041400@linuxfoundation.org>
        <20220326200922.GA9262@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 26 Mar 2022 21:09:22 +0100 Pavel Machek wrote:
> Can someone check this? AFAICT this is buggy.
> 
> static int llc_ui_autobind(struct socket *sock, struct sockaddr_llc *addr)
> {
>         struct sock *sk = sock->sk;
>         struct llc_sock *llc = llc_sk(sk);
>         struct llc_sap *sap;
>         int rc = -EINVAL;
> 
>         if (!sock_flag(sk, SOCK_ZAPPED))
>                 goto out;
> 
> There are 'goto out's from both before dev_get() and after it,
> dev_put() will be called with NULL pointer. dev_put() can't handle
> NULL at least in the old kernels... this is simply confused.
> 
> Mainline has dev_put_track() there, but I see same confusion.
> 
> Best regards,

commit 2d327a79ee17 ("llc: only change llc->dev when bind() succeeds"),
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=2d327a79ee176930dc72c131a970c891d367c1dc

Should be in mainline on Thursday, LMK if we need to accelerate.
IDK if anyone enables LLC2.
