Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B33B165D133
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 12:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbjADLIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 06:08:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbjADLIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 06:08:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3ED1583E;
        Wed,  4 Jan 2023 03:08:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A985BB815EB;
        Wed,  4 Jan 2023 11:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE0AC433EF;
        Wed,  4 Jan 2023 11:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672830522;
        bh=gU2PIy9PmMrmzGK3B2fUwGgTdHeKJCWcIu9vIJLjimg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gbF+tC6RKG2t+F8kRs17Z3xXPg/AW++tKBrgK+e+TsUAyjKe14CN2TI6My+jbR1fC
         O6OCfT97NOtmN7run0682kpKaGfi7wX9oUzycrrkGCZzYHsqlKpvCQdvGtfQGPl7XU
         hTIrNWdWJfmqEUvJ3p/7I7SzuGEKIPjJNzZkPvNk=
Date:   Wed, 4 Jan 2023 12:08:39 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 00/74] 6.0.17-rc1 review
Message-ID: <Y7VeN+WpVKqivRGL@kroah.com>
References: <20230102110552.061937047@linuxfoundation.org>
 <Y7QFW7O0xqSYTzyl@debian>
 <CADVatmPJrRsKTNyzWYeU10k+3eycd1bXTnwAaF7KKOR+h6mwYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmPJrRsKTNyzWYeU10k+3eycd1bXTnwAaF7KKOR+h6mwYw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 03, 2023 at 10:59:58PM +0000, Sudip Mukherjee wrote:
> On Tue, 3 Jan 2023 at 10:37, Sudip Mukherjee (Codethink)
> <sudipm.mukherjee@gmail.com> wrote:
> >
> > Hi Greg,
> >
> > On Mon, Jan 02, 2023 at 12:21:33PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.0.17 release.
> > > There are 74 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> > > Anything received after that time might be too late.
> >
> 
> <snip>
> 
> >
> > mips: Booted on ci20 board. VNC server did not start, will try a bisect
> > later tonight.
> 
> bisect pointed to 2575eebf1bd2 ("net: Return errno in
> sk->sk_prot->get_port().") introduced in v6.0.16
> Reverting it on top of v6.0.16 and 6.0.17-rc1 fixed the problem.
> 
> This is also in v6.1.y but the issue is not seen there, and I am
> trying to figure out why.

As there's probably only going to be one more 6.0.y release before it is
end-of-life, if you can't figure it out, not that big of a deal :)

thanks,

greg k-h
