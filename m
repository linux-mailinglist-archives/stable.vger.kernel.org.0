Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3461C6D105B
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 22:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjC3U4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 16:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjC3U4L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 16:56:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07ACFCA39;
        Thu, 30 Mar 2023 13:56:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97A67621AF;
        Thu, 30 Mar 2023 20:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79419C433EF;
        Thu, 30 Mar 2023 20:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680209765;
        bh=0djKXzg5S9iieMQ+tqm7uwpizSVx6AIzaRoioVm/uUA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h9suXRmM0KtxtECkOEwilpDhN6528XVIj0jE6on13fOsyvBVdR0+N8nJwkgjxd4M7
         ZJSetTh4LettQtbTgvXjLLr3cMuv3AgeFmwiYlXBqjJ99uW0VJ+aAv5Vc/j+7UkCBT
         Z6EanJfXLrbadglUINO6aH7UkLLhX8ecRyzYnKPU=
Date:   Thu, 30 Mar 2023 22:56:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     "quic_jhugo@quicinc.com" <quic_jhugo@quicinc.com>,
        "quic_carlv@quicinc.com" <quic_carlv@quicinc.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "robh@kernel.org" <robh@kernel.org>, "kw@linux.com" <kw@linux.com>,
        "helgaas@kernel.org" <helgaas@kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH v2] PCI: hv: Fix the definition of vector in
 hv_compose_msi_msg()
Message-ID: <ZCX3Ys8BCRODV0jD@kroah.com>
References: <20221027205256.17678-1-decui@microsoft.com>
 <ZCTsPFb7dBj2IZmo@boqun-archlinux>
 <ZCT6JEK/yGpKHVLn@boqun-archlinux>
 <SA1PR21MB13354973735A5E727F94A169BF8E9@SA1PR21MB1335.namprd21.prod.outlook.com>
 <ZCUk_9YQGSfedCOR@kroah.com>
 <SA1PR21MB13350093800BC2C387EE0648BF8E9@SA1PR21MB1335.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR21MB13350093800BC2C387EE0648BF8E9@SA1PR21MB1335.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 30, 2023 at 07:50:11PM +0000, Dexuan Cui wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ...
> > > e70af8d040d2 has a Fixes tag. Not sure why it's not automatically
> > backported.
> > 
> > Because "Fixes:" is not the flag that we are sure to trigger off of.
> > Please read:
> > https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> > for how to do this properly.
> 
> Thanks, I just read this again to refresh my memory :-)
> I remember Sasha has an AI algorithm to pick up patches into the stable
> tree and a "Fixes" tag should be a strong indicator. 

Yes, we have to rely on "hints" like that due to maintainers not wanting
to put any cc: stable tags for many subsystems so we have to dig them
out somehow.

> If I add the cc: stable line in a patch and use git-send-email to post
> the patch, git-send-email also posts the patch to the stable list -- is
> this acceptable?

Totally acceptable.

> Sometimes a patch may have to undergo multiple
> revisions, meaning all the discussion emails go to the stable list
> unnecessarily, and I guess this is not good?

It's not a problem at all, happens all the time and in fact I like it as
it gives us a heads-up that a patch is going to be eventually merged for
us to handle.

> It looks like there is no git-send-email option to exclude an email.

No need to, don't worry about that at all.

thanks,

greg k-h
