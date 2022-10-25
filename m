Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A08460CECF
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 16:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbiJYOVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 10:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbiJYOVO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 10:21:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47DA872FE2
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 07:21:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03F2AB81D4D
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 14:21:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6124BC433C1;
        Tue, 25 Oct 2022 14:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666707670;
        bh=DrBtBT1YwkPRhGh4yStdeRbRv12U7agiY0u8AUBEnNQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xx0Iq2eB80GNuLD4zohIrDU7Alb4u079NFrCosSIZC67KlwTebEImud0Z1Caryb8C
         jytzFpjCJmxKcwTdpQdAuBjnp7LsDGRzAkpHPQG3vDbGY/0poOVxmhzp01Pxckpz0d
         nNXUaj/X2VxUI1ovq+qSE+z91SAw4kz/WqAG2kLE=
Date:   Tue, 25 Oct 2022 16:21:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        Diederik de Haas <didi.debian@cknow.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 1/2] Revert "drm/amdgpu: move nbio sdma_doorbell_range()
 into sdma code for vega"
Message-ID: <Y1fw1IQhsBWnJbiQ@kroah.com>
References: <20221020153857.565160-1-alexander.deucher@amd.com>
 <2651645.mvXUDI8C0e@bagend>
 <Y1I4rC37gwl367rt@eldamar.lan>
 <Y1Z5Km83Rcc3W0PY@kroah.com>
 <BL1PR12MB51443BFF32835644A72F7A38F72E9@BL1PR12MB5144.namprd12.prod.outlook.com>
 <Y1ana7eNFN/CMNOg@kroah.com>
 <BL1PR12MB5144F3CC640A18DF0C36E414F72E9@BL1PR12MB5144.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB5144F3CC640A18DF0C36E414F72E9@BL1PR12MB5144.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 24, 2022 at 05:31:53PM +0000, Deucher, Alexander wrote:
> [Public]
> 
> > -----Original Message-----
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Sent: Monday, October 24, 2022 10:56 AM
> > To: Deucher, Alexander <Alexander.Deucher@amd.com>
> > Cc: Salvatore Bonaccorso <carnil@debian.org>; Diederik de Haas
> > <didi.debian@cknow.org>; stable@vger.kernel.org; Shuah Khan
> > <skhan@linuxfoundation.org>; Sasha Levin <sashal@kernel.org>
> > Subject: Re: [PATCH 1/2] Revert "drm/amdgpu: move nbio
> > sdma_doorbell_range() into sdma code for vega"
> > 
> > On Mon, Oct 24, 2022 at 02:39:41PM +0000, Deucher, Alexander wrote:
> > > [Public]
> > 
> > Of course it is!
> > 
> > > > -----Original Message-----
> > > > From: Greg KH <gregkh@linuxfoundation.org>
> > > > Sent: Monday, October 24, 2022 7:38 AM
> > > > To: Salvatore Bonaccorso <carnil@debian.org>
> > > > Cc: Diederik de Haas <didi.debian@cknow.org>;
> > > > stable@vger.kernel.org; Deucher, Alexander
> > > > <Alexander.Deucher@amd.com>; Shuah Khan
> > <skhan@linuxfoundation.org>;
> > > > Sasha Levin <sashal@kernel.org>
> > > > Subject: Re: [PATCH 1/2] Revert "drm/amdgpu: move nbio
> > > > sdma_doorbell_range() into sdma code for vega"
> > 
> > This is horrid, please fix up your email system.
> > 
> > > > On Fri, Oct 21, 2022 at 08:14:04AM +0200, Salvatore Bonaccorso wrote:
> > > > > Hi,
> > > > >
> > > > > On Fri, Oct 21, 2022 at 02:29:22AM +0200, Diederik de Haas wrote:
> > > > > > On Thursday, 20 October 2022 17:38:56 CEST Alex Deucher wrote:
> > > > > > > This reverts commit 9f55f36f749a7608eeef57d7d72991a9bd557341.
> > > > > > >
> > > > > > > This patch was backported incorrectly when Sasha backported it
> > > > > > > and the patch that caused the regression that this patch set
> > > > > > > fixed was reverted in commit 412b844143e3 ("Revert
> > > > > > > "PCI/portdrv: Don't disable AER reporting in
> > > > > > > get_port_device_capability()""). This isn't necessary and causes a
> > regression so drop it.
> > > > > > >
> > > > > > > Bug:
> > > > > > >
> > > > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2F
> > > > > > > gitlab.freedesktop.org%2Fdrm%2Famd%2F-
> > > > %2Fissues%2F2216&amp;data=05
> > > > > > >
> > > >
> > %7C01%7Calexander.deucher%40amd.com%7C5f932b93d7154b20994a08dab
> > > > 5bf
> > > > > > >
> > > >
> > 354e%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C6380221300859
> > > > 453
> > > > > > >
> > > >
> > 54%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luM
> > > > zIiLCJ
> > > > > > >
> > > >
> > BTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=D9Gkpt0
> > > > zCN5q
> > > > > > > BWoSngMY%2FiJyHWiaAC34eWr2UfYRIjE%3D&amp;reserved=0
> > > > > > > Cc: Shuah Khan <skhan@linuxfoundation.org>
> > > > > > > Cc: Sasha Levin <sashal@kernel.org>
> > > > > > > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > > > > > > Cc: <stable@vger.kernel.org>    # 5.10
> > > > > > > ---
> > > > > >
> > > > > > I build a kernel with these 2 patches reverted and can confirm
> > > > > > that that fixes the issue on my machine with a Radeon RX Vega 64
> > GPU.
> > > > > > # lspci -nn | grep VGA
> > > > > > 0b:00.0 VGA compatible controller [0300]: Advanced Micro
> > > > > > Devices, Inc. [AMD/ ATI] Vega 10 XL/XT [Radeon RX Vega 56/64]
> > > > > > [1002:687f] (rev c1)
> > > > > >
> > > > > > So feel free to add
> > > > > >
> > > > > > Tested-By: Diederik de Haas <didi.debian@cknow.org>
> > > > >
> > > > > Note additionally (probably only relevant for Greg while
> > > > > reviewing), that the first of the commits which need to be
> > > > > reverted is already queued as revert in queue-5.10.
> > > >
> > > > Argh, that caused me to drop both of these from the review queue.
> > > >
> > > > Can someone verify that this really still is needed on the latest
> > > > 5.10-rc that was just sent out?  And if so, please send me whatever is
> > really needed?
> > > >
> > > > this got way too confusing...
> > >
> > > These two patches need to be reverted from 5.10:
> > > 9f55f36f749a7608eeef57d7d72991a9bd557341
> > > 7b0db849ea030a70b8fb9c9afec67c81f955482e
> > >
> > > I did not see either of the reverts in linux-5.10.y in the stable tree when I
> > generated these 2 revert patches.  Where should I be looking to see
> > proposed stable patches other than being possibly being cc'ed on a patch?
> > Shuah had proposed a patch to revert
> > 9f55f36f749a7608eeef57d7d72991a9bd557341, but I didn't see it in linux-
> > 5.10.y and I added some additional details to the commit message to provide
> > more background on why it was being reverted so I wasn't sure if it had been
> > applied or not.
> > 
> > /me hands you some '\n' characters....
> > 
> > Look in the stable-queue git tree for what is queued up next.
> > 
> > Now you can see all the emails for the 5.10-rc release on the list as well in the
> > linux-stable-rc git tree if you want to look there instead.
> > 
> > Can you check and make sure it's all correct now?
> 
> Please also revert 7b0db849ea030a70b8fb9c9afec67c81f955482e or apply patch 2/2 of this series of if you'd
> prefer, I can resend just patch 2/2 by itself.

Now queued up.
