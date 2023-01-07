Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B1C660D40
	for <lists+stable@lfdr.de>; Sat,  7 Jan 2023 10:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjAGJZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Jan 2023 04:25:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjAGJZT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Jan 2023 04:25:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E086219B;
        Sat,  7 Jan 2023 01:25:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC765B81F75;
        Sat,  7 Jan 2023 09:25:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9B1C433D2;
        Sat,  7 Jan 2023 09:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673083515;
        bh=J8ZNRfAC90E4l+KnllRu6fKnEjow7qjFHPiiHVWOTbM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xL+5S9lJf5Dwdx69WhnVrfy+yB//SSk/Yltfl3Ta3qLmoHVKQK1vkvxoQyrGy66e6
         YXDygiRLMkMLIzDbVY9PsCCFE7qWTnHaqmv7byIwOzjFgA9HkDMmsj1jtG5B/+nJTP
         D244filmbiwFl2jvUPdm/SfJGxhsdy85Ez8INAVM=
Date:   Sat, 7 Jan 2023 10:25:12 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Georg =?iso-8859-1?Q?M=FCller?= <georgmueller@gmx.net>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/177] 6.0.18-rc1 review
Message-ID: <Y7k6eIjw0bNUmA95@kroah.com>
References: <20230104160507.635888536@linuxfoundation.org>
 <53f19c0a-412d-ba8e-57bb-b626ba5b7672@gmx.net>
 <Y7gxZ201DOi7nyZZ@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y7gxZ201DOi7nyZZ@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 06, 2023 at 03:34:15PM +0100, Greg Kroah-Hartman wrote:
> On Fri, Jan 06, 2023 at 03:27:58PM +0100, Georg Müller wrote:
> > Hi Greg,
> > 
> > Am 04.01.23 um 17:04 schrieb Greg Kroah-Hartman:
> > > This is the start of the stable review cycle for the 6.0.18 release.
> > > There are 177 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Fri, 06 Jan 2023 16:04:29 +0000.
> > > Anything received after that time might be too late.
> > 
> > There is an easy-to-trigger kernel panic in cifs which was introduced in 6.0.16 and could be fixed by backporting the following commit:
> > 
> >    9ee2afe5207b ("cifs: prevent copying past input buffer boundaries")
> > 
> > Please see https://bugzilla.kernel.org/show_bug.cgi?id=216895 for the details
> > 
> > Could this commit be added as well to 6.0.18?
> 
> It is too late for this release, we can add it to the next one.  Or you
> can move to 6.1.y which you should be doing anyway as 6.0.y is about to
> go end-of-life in a few days.

Ah, it seems simple enough, I've queued it up now all the way back to
5.4.y, is that correct?

And any specific reason why this commit was NOT marked as a fix or for a
stable release?

thanks,

greg k-h
