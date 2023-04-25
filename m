Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46836EE75A
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 20:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234094AbjDYSJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 14:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232927AbjDYSJA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 14:09:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C55916188
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 11:08:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAA2C60AE2
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 18:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD6DC433EF;
        Tue, 25 Apr 2023 18:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682446138;
        bh=m+OWbxfUWsNr8e9sj0LRl8SZr/zteujplUfx8lhHQoM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0gPjBep60VuVyMBT7TtQpnofDEBIiybu3opXaG1qbxL/BjLf4Jaw+Mj5b+/4kRoK6
         kso9eVre4XUCGaVunPi3beTZyrvzPkkMN7SbMwqbzmozMMTYyexGaMReyf1ZlEA6kJ
         sbq9S3G1hyZr3ZSYYXNeYCpndrd3YbfvnVrcRZVU=
Date:   Tue, 25 Apr 2023 20:08:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kristof Havasi <havasiefr@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: Does v5.4 need CVE-2022-3566 and CVE-2022-3567 patches
Message-ID: <2023042519-powdery-passerby-213a@gregkh>
References: <CADBnMvgH1H_+WNSdQ=hJp15v4jh0nwFZVkggeiCSWaFHtzORJQ@mail.gmail.com>
 <ZEfoC9UDzniw6mo_@kroah.com>
 <CADBnMviZ4Q3LpUUfnGYrM6aiPQFLD6ohC1qjetJp0RcDGTTYsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADBnMviZ4Q3LpUUfnGYrM6aiPQFLD6ohC1qjetJp0RcDGTTYsg@mail.gmail.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 25, 2023 at 06:27:24PM +0200, Kristof Havasi wrote:
> On Tue, 25 Apr 2023 at 16:47, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Apr 25, 2023 at 04:08:30PM +0200, Kristof Havasi wrote:
> > > Hi there,
> > >
> > > I was evaluating CVE-2022-3567 and CVE-2022-3566 which both
> > > revolt around load tearing and reference an ancient Kernel commit:
> > > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > >
> > > I am not sure whether they are applicable to the v5.4.y branch as well.
> >
> > I do not know, what specific commits are you referring to?  CVEs mean
> > nothing, they are not valid identifiers, sorry.
> >
> > And have you tried applying them to the older kernels and testing to see
> > if they solve any specific issue?
> >
> > Or better yet, why use the older kernels, why not stick to the most
> > recent one?  What is preventing you from switching?
> 
> Thank you for the quick response!
> 
> I meant the following commits:
> f49cd2f4d6170d27a2c61f1fecb03d8a70c91f57 and
> 364f997b5cfe1db0d63a390fe7c801fa2b3115f6
> 
> The v5.4 kernel is used in an embedded device where due to certification
> processes a quick upgrade of the Kernel isn't realistic until at least
> another year.

You do realize that stable kernel updates can radically change the whole
system (look at the changes needed for retbleed), so any update needs to
always be properly tested.  Version numbers mean nothing, so even if we
do take these patches, you still need to do proper testing, the same
amount of testing you would have done for moving to a new kernel
version.

> The patches are quite small, I could cherry-pick them on the latest v5.4 tag,
> and the kernel builds... only for
> f49cd2f4d6170d27a2c61f1fecb03d8a70c91f57 USER_SOCKPTR
> isn't available in 5.4, so I sticked to `char __user *`.

Note that you also need to provide backports for 5.15.y and 5.10.y as
you do not want to upgrade to a new version and have a regression,
right?

> I will get a device tomorrow and try whether I can netcat between them
> via IPv4 and v6.
> Any other tests, which would be needed?

Why does the existance of a random CVE number mean anything?  You do
know that MITRE (the entity that deals out CVEs), refuses to give the
kernel team new CVE numbers for bug reports, right?  So that means that
any kernel-related CVE that you see are created by vendors who are using
them to facilitate their internal engineering processes, not necessarily
anything else.

I gave a whole long talk about this a few years ago if you are
interested:
	https://kernel-recipes.org/en/2019/talks/cves-are-dead-long-live-the-cve/

So maybe work to see if this is a real problem or not first, before
worrying about backporting it?

thanks,

greg k-h
