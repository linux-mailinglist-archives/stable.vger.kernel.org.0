Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F605A9573
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 13:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbiIALI4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 07:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbiIALIz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 07:08:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9261321E8;
        Thu,  1 Sep 2022 04:08:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2995161D76;
        Thu,  1 Sep 2022 11:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E29C433C1;
        Thu,  1 Sep 2022 11:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662030533;
        bh=GO5OWJyxvsNjXdz5eXwP4/4lg3DYoGMjM+O2CwFsH7M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hf1MkGxfopSkLoYKyPfD0bOwVW4DvkvgULW5uBZRxcNaH5CfrxD6u95w3YyUfUOPx
         cjqA1lU+cYsX2olFRE+jHT8gkYOVG1BTcRgp4ei6pxztB32L115JGtsZ8BSkhhgtAN
         d8i6yXyIQ9/n195E+ExTOUkKFqCAcKPK0aHQM6HU=
Date:   Thu, 1 Sep 2022 13:08:50 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Stefan Roese <sr@denx.de>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Ben Greear <greearb@candelatech.com>, bjorn@helgaas.com,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bharat Kumar Gogada <bharat.kumar.gogada@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Yao Hongbo <yaohongbo@linux.alibaba.com>,
        Naveen Naidu <naveennaidu479@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5.4 182/389] PCI/portdrv: Dont disable AER reporting in
 get_port_device_capability()
Message-ID: <YxCSwtfrEcuJKBoS@kroah.com>
References: <20220830221159.GA132418@bhelgaas>
 <cdcf3377-c3fe-f22b-6f43-8ae8cb889da3@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdcf3377-c3fe-f22b-6f43-8ae8cb889da3@denx.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 31, 2022 at 07:52:00AM +0200, Stefan Roese wrote:
> On 31.08.22 00:11, Bjorn Helgaas wrote:
> > [+cc Gregory, linux-wireless for iwlwifi issue]
> > 
> > On Tue, Aug 30, 2022 at 01:47:48PM -0700, Ben Greear wrote:
> > > On 8/23/22 11:41 PM, Greg Kroah-Hartman wrote:
> > > > On Tue, Aug 23, 2022 at 07:20:14AM -0500, Bjorn Helgaas wrote:
> > > > > On Tue, Aug 23, 2022, 6:35 AM Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > wrote:
> > > > > 
> > > > > > From: Stefan Roese <sr@denx.de>
> > > > > > 
> > > > > > [ Upstream commit 8795e182b02dc87e343c79e73af6b8b7f9c5e635 ]
> > > > > > 
> > > > > 
> > > > > There's an open regression related to this commit:
> > > > > 
> > > > > https://bugzilla.kernel.org/show_bug.cgi?id=216373
> > > > 
> > > > This is already in the following released stable kernels:
> > > > 	5.10.137 5.15.61 5.18.18 5.19.2
> > > > 
> > > > I'll go drop it from the 4.19 and 5.4 queues, but when this gets
> > > > resolved in Linus's tree, make sure there's a cc: stable on the fix so
> > > > that we know to backport it to the above branches as well.  Or at the
> > > > least, a "Fixes:" tag.
> > > 
> > > This is still in 5.19.5.  We saw some funny iwlwifi crashes in 5.19.3+
> > > that we did not see in 5.19.0+.  I just bisected the scary looking
> > > AER errors to this patch, though I do not know for certain if it
> > > causes the iwlwifi related crashes yet.
> > > 
> > > In general, from reading the commit msg, this patch doesn't seem to
> > > be a great candidate for stable in general.  Does it fix some
> > > important problem?
> > 
> > I agree, I don't think this is a good candidate for stable.  It has
> > already exposed latent amdgpu issues and we'll likely find more.  It's
> > good to find and fix these things, but I'd rather do it in -rc than in
> > stable kernels.
> 
> I also agree. It was not my intention to have this patch added to
> the stable branches. Frankly I missed intervening when seeing the
> mails about the integration into stable a few weeks ago.

It was maked with a Fixes: tag, which makes it ripe for backporting,
especially as it is written as "this fixes this problem".

Anyway, I've now reverted it from the stable trees. Hopefully you all
get this figured out so that 6.0 doesn't have the same issue.

thanks,

greg k-h
