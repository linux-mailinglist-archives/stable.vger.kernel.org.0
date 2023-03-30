Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9526CFB0F
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 07:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjC3F6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 01:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjC3F63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 01:58:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB09E4;
        Wed, 29 Mar 2023 22:58:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E93DB825DA;
        Thu, 30 Mar 2023 05:58:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CAA0C433D2;
        Thu, 30 Mar 2023 05:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680155906;
        bh=vx/Rnvlz/DgN2zpFUitn4sJ61icshhEzaPkBFQHilaA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hqMaP3HREd0etYbIDJDe3wFNh2yBBggwgWJnYQhMaiWD9UbeD5IyvNh5E230ustkC
         bVdvPiwvs8fFeb4lYFWXiXkZv85cYyiSLP35vyyxGrSCzoeTG9+tn39sVOg0d9xnCb
         zlyfb7MK3rmCnayaKeoL51E3hJpm0po69Y7dh9fY=
Date:   Thu, 30 Mar 2023 07:58:23 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     Boqun Feng <boqun.feng@gmail.com>,
        "quic_jhugo@quicinc.com" <quic_jhugo@quicinc.com>,
        "quic_carlv@quicinc.com" <quic_carlv@quicinc.com>,
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
Message-ID: <ZCUk_9YQGSfedCOR@kroah.com>
References: <20221027205256.17678-1-decui@microsoft.com>
 <ZCTsPFb7dBj2IZmo@boqun-archlinux>
 <ZCT6JEK/yGpKHVLn@boqun-archlinux>
 <SA1PR21MB13354973735A5E727F94A169BF8E9@SA1PR21MB1335.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR21MB13354973735A5E727F94A169BF8E9@SA1PR21MB1335.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 30, 2023 at 03:23:45AM +0000, Dexuan Cui wrote:
> > From: Boqun Feng <boqun.feng@gmail.com>
> > Sent: Wednesday, March 29, 2023 7:56 PM
> > To: Dexuan Cui <decui@microsoft.com>
> >  ...
> > On Wed, Mar 29, 2023 at 06:56:12PM -0700, Boqun Feng wrote:
> > > [Cc stable]
> > >
> > > On Thu, Oct 27, 2022 at 01:52:56PM -0700, Dexuan Cui wrote:
> > > > The local variable 'vector' must be u32 rather than u8: see the
> > > > struct hv_msi_desc3.
> > > >
> > > > 'vector_count' should be u16 rather than u8: see struct hv_msi_desc,
> > > > hv_msi_desc2 and hv_msi_desc3.
> > > >
> > >
> > > Dexuan, I think this patch should only be in 5.15, because...
> > >
> > 
> > Sorry, I meant:
> > 
> > "this patch should also be backported in 5.15"
> > 
> > Regards,
> > Boqun
> > 
> > > > Fixes: a2bad844a67b ("PCI: hv: Fix interrupt mapping for multi-MSI")
> > >
> > > ^^^ this commit is already in 5.15.y (commit id 92dcb50f7f09).
> > >
> > > Upstream id e70af8d040d2b7904dca93d942ba23fb722e21b1
> > > Cc: <stable@vger.kernel.org> # 5.15.x
> 
> The faulty commit a2bad844a67b ("PCI: hv: Fix interrupt mapping for multi-MSI")
> is in all the stable branches, even including 4.14.y, so yes, the commit
> e70af8d040d2 ("PCI: hv: Fix the definition of vector in hv_compose_msi_msg()")
> should be backported to all the stable branches as well, including
> v5.15.y, v5.10.y, v5.4.y, v4.19.y, v4.14.y.
> 
> e70af8d040d2 has a Fixes tag. Not sure why it's not automatically backported.

Because "Fixes:" is not the flag that we are sure to trigger off of.
Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

That being said, because some subsystem maintainers do NOT put cc:
stable in their patches, we do sometimes sweep the tree and try to pick
up things with only "Fixes:" but we don't always catch everything.

So if you want to be sure a patch is applied, please always add a cc:
stable in the patch.

thanks,

greg k-h
