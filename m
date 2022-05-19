Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4188852D302
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 14:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238189AbiESMvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 08:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238175AbiESMu5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 08:50:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D61CAE4C
        for <stable@vger.kernel.org>; Thu, 19 May 2022 05:50:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87E6661152
        for <stable@vger.kernel.org>; Thu, 19 May 2022 12:50:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960BBC385AA;
        Thu, 19 May 2022 12:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652964650;
        bh=YRDuIn1dPkbI8KkCNe+bzbPFzQBXGEARGRMaoznDiZk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mDr5Si/Z6kexDbqM+UOLVyRnT4QpYb1GgNSOYaUk/rmcclm2HvBtC9/sc2w1EELeb
         IfUMXaCmZUpi8f4r1+7GrYOOxSl/i2lFTX68R8qFv8VEsIAs2gbVxSCkpSsd/xxUeB
         5iiTzkYnW5d281ZlJzO33vyULDV88vM5rNz8irfY=
Date:   Thu, 19 May 2022 14:50:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: MMIO support for I2C-PIIX4 and SP5100-TCO
Message-ID: <YoY9J6Xls0l6LPp2@kroah.com>
References: <MN0PR12MB610150AC5F1E15D6A67AC352E2D19@MN0PR12MB6101.namprd12.prod.outlook.com>
 <YoVIJB/d8Ei3iJiE@kroah.com>
 <MN0PR12MB6101658686E4C29D64920E3FE2D19@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB6101658686E4C29D64920E3FE2D19@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 18, 2022 at 07:35:41PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> 
> 
> > -----Original Message-----
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Sent: Wednesday, May 18, 2022 14:25
> > To: Limonciello, Mario <Mario.Limonciello@amd.com>
> > Cc: stable@vger.kernel.org
> > Subject: Re: MMIO support for I2C-PIIX4 and SP5100-TCO
> > 
> > On Wed, May 18, 2022 at 06:49:59PM +0000, Limonciello, Mario wrote:
> > > [Public]
> > >
> > > Hi,
> > >
> > > Some users have complained that i2c the controller doesn't work on newer
> > designs.  This is because the system can be configured by an OEM to not
> > allow access to the I2C controller registers via legacy methods and instead
> > requires MMIO.
> > >
> > > Some bug reports collecting this problem (which have had duplicates
> > brought in)
> > >
> > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgitla
> > b.com%2FCalcProgrammer1%2FOpenRGB%2F-
> > %2Fissues%2F1984&amp;data=05%7C01%7CMario.Limonciello%40amd.com
> > %7C5c8827b7f53e479d364108da39042a91%7C3dd8961fe4884e608e11a82d994
> > e183d%7C0%7C0%7C637884987298944924%7CUnknown%7CTWFpbGZsb3d8
> > eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3
> > D%7C3000%7C%7C%7C&amp;sdata=JQrvW5I0iSF14zm64ijMegqFSX6YTF1p6Y
> > c8mub7DgI%3D&amp;reserved=0
> > >
> > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugs
> > .launchpad.net%2Famd%2F%2Bbug%2F1950062&amp;data=05%7C01%7CMa
> > rio.Limonciello%40amd.com%7C5c8827b7f53e479d364108da39042a91%7C3dd
> > 8961fe4884e608e11a82d994e183d%7C0%7C0%7C637884987298944924%7CUn
> > known%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6
> > Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=z3Ba6AfJE41z
> > cZfpTd1Fkp5jg1sKPEMHy%2BWDIgCv6tE%3D&amp;reserved=0
> > >
> > > These commits that have landed into 5.18 fix this issue both for i2c-piix4
> > and for sp5100-tco (which suffers the same fate).
> > >
> > > Would you take them back to stable 5.15.y and 5.17.y?  The series comes
> > back cleanly to both.
> > >
> > > 27c196c7b73c kernel/resource: Introduce request_mem_region_muxed()
> > > 93102cb44978 i2c: piix4: Replace hardcoded memory map size with a
> > #define
> > > a3325d225b00 i2c: piix4: Move port I/O region request/release code into
> > functions
> > > 0a59a24e14e9 i2c: piix4: Move SMBus controller base address detect into
> > function
> > > fbafbd51bff5 i2c: piix4: Move SMBus port selection into function
> > > 7c148722d074 i2c: piix4: Add EFCH MMIO support to region request and
> > release
> > > 46967bc1ee93 i2c: piix4: Add EFCH MMIO support to SMBus base address
> > detect
> > > 381a3083c674 i2c: piix4: Add EFCH MMIO support for SMBus port select
> > > 6cf72f41808a i2c: piix4: Enable EFCH MMIO for Family 17h+
> > > abd71a948f7a Watchdog: sp5100_tco: Move timer initialization into
> > function
> > > 1f182aca2300 Watchdog: sp5100_tco: Refactor MMIO base address
> > initialization
> > > 0578fff4aae5 Watchdog: sp5100_tco: Add initialization using EFCH MMIO
> > > 826270373f17 Watchdog: sp5100_tco: Enable Family 17h+ CPUs
> > 
> > What is the overall diffstat of all of these commits applied?  
> 
> $ git diff --stat linux-5.15.y HEAD^
>  drivers/i2c/busses/i2c-piix4.c | 213 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------
>  drivers/watchdog/sp5100_tco.c  | 318 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------
>  drivers/watchdog/sp5100_tco.h  |   6 +++
>  include/linux/ioport.h         |   2 +
>  4 files changed, 390 insertions(+), 149 deletions(-)
> 
> > And why
> > can't people with newer hardware just use 5.18 and newer releases like
> > they do for other more complex hardware additions?
> > 
> 
> I think that argument is fine for not taking it to 5.17.y as 5.18 is right around the
> corner.  I do think there is a strong case for 5.15.y though for a few reasons:
> 
> 1) The same problem happens on client (Ryzen) and server (EPYC).  Most people
> will otherwise stick to the LTS kernel for the stability purposes.
> 
> 2) The affected hardware here isn't new hardware, it's just a solution to an old
> problem.  For client chips I2C not working means common things like the I2C
> trackpads won't work if they are on such a system.   Also rarer things like RGB
> lighting (which was the OpenRGB bug I linked) don't work.

Ah, RGB lighting, I missed that link, sorry about that.

I'll gladly fix up a kernel for stuff like this anyday over boring old
"enterprise" features, as this is what makes computers fun.

> Not having the watchdog timer hardware working is probably more important for
> the server chips though.

Ah, bonus then, the enterprise people will not feel left out.

all queued up, thanks.

greg k-h
