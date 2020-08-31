Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5FED257AEB
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 15:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgHaNzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 09:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbgHaNzt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 09:55:49 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EEBC061573;
        Mon, 31 Aug 2020 06:55:48 -0700 (PDT)
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 852DE277;
        Mon, 31 Aug 2020 15:55:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1598882142;
        bh=YjANQfU2PJKUK7bbJGGRHgkqFKMb/cIwpm/y1CxpPFo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TgaNE0U6odJlc+9i7YVK1k2SQkBoNtxo4hGNQlMmNAzKd4fUS5IuO3uR+9h5oDh3w
         MnDSjQLm9AOe+luMB6ZBC9OciWwGpHUoydsPN04ThTSr6u5leAnX1QYC5y0hQwA+1H
         Yye2SAgS6kd3fLDVPFXwlQFhtyDCagxbFLC+19k4=
Date:   Mon, 31 Aug 2020 16:55:21 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
Cc:     Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 08/38] media: pci: ttpci: av7110: fix
 possible buffer overflow caused by bad DMA value in debiirq()
Message-ID: <20200831135521.GB16155@pendragon.ideasonboard.com>
References: <20200821161807.348600-1-sashal@kernel.org>
 <20200821161807.348600-8-sashal@kernel.org>
 <20200829121020.GA20944@duo.ucw.cz>
 <20200829171600.GA7465@pendragon.ideasonboard.com>
 <9e797c3a-033b-3473-ac03-1566d40e90d2@tsinghua.edu.cn>
 <20200830222549.GD6043@pendragon.ideasonboard.com>
 <665f2e2d-b133-05be-17d5-49b860474ce5@tsinghua.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <665f2e2d-b133-05be-17d5-49b860474ce5@tsinghua.edu.cn>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jia-Ju,

On Mon, Aug 31, 2020 at 09:45:14PM +0800, Jia-Ju Bai wrote:
> On 2020/8/31 6:25, Laurent Pinchart wrote:
> > On Sun, Aug 30, 2020 at 03:33:11PM +0800, Jia-Ju Bai wrote:
> >> On 2020/8/30 1:16, Laurent Pinchart wrote:
> >>> On Sat, Aug 29, 2020 at 02:10:20PM +0200, Pavel Machek wrote:
> >>>> Hi!
> >>>>
> >>>>> The value av7110->debi_virt is stored in DMA memory, and it is assigned
> >>>>> to data, and thus data[0] can be modified at any time by malicious
> >>>>> hardware. In this case, "if (data[0] < 2)" can be passed, but then
> >>>>> data[0] can be changed into a large number, which may cause buffer
> >>>>> overflow when the code "av7110->ci_slot[data[0]]" is used.
> >>>>>
> >>>>> To fix this possible bug, data[0] is assigned to a local variable, which
> >>>>> replaces the use of data[0].
> >>>>
> >>>> I'm pretty sure hardware capable of manipulating memory can work
> >>>> around any such checks, but...
> >>>>
> >>>>> +++ b/drivers/media/pci/ttpci/av7110.c
> >>>>> @@ -424,14 +424,15 @@ static void debiirq(unsigned long cookie)
> >>>>>    	case DATA_CI_GET:
> >>>>>    	{
> >>>>>    		u8 *data = av7110->debi_virt;
> >>>>> +		u8 data_0 = data[0];
> >>>>>    
> >>>>> -		if ((data[0] < 2) && data[2] == 0xff) {
> >>>>> +		if (data_0 < 2 && data[2] == 0xff) {
> >>>>>    			int flags = 0;
> >>>>>    			if (data[5] > 0)
> >>>>>    				flags |= CA_CI_MODULE_PRESENT;
> >>>>>    			if (data[5] > 5)
> >>>>>    				flags |= CA_CI_MODULE_READY;
> >>>>> -			av7110->ci_slot[data[0]].flags = flags;
> >>>>> +			av7110->ci_slot[data_0].flags = flags;
> >>>>
> >>>> This does not even do what it says. Compiler is still free to access
> >>>> data[0] multiple times. It needs READ_ONCE() to be effective.
> >>>
> >>> Yes, it seems quite dubious to me. If we *really* want to guard against
> >>> rogue hardware here, the whole DMA buffer should be copied. I don't
> >>> think it's worth it, a rogue PCI device can do much more harm.
> >>
> >>  From the original driver code, data[0] is considered to be bad and thus
> >> it should be checked, because the content of the DMA buffer may be
> >> problematic.
> >>
> >> Based on this consideration, data[0] can be also modified to bypass the
> >> check, and thus its value should be copied to a local variable for the
> >> check and use.
> >
> > What makes you think the hardware would do that ?
> 
> Several recent papers show that the bad values from malicious or 
> problematic hardware can cause security problems:
> [NDSS'19] PeriScope: An Effective Probing and Fuzzing Framework for the 
> Hardware-OS Boundary
> [NDSS'19] Thunderclap: Exploring Vulnerabilities in Operating System 
> IOMMU Protection via DMA from Untrustworthy Peripherals
> [USENIX Security'20] USBFuzz: A Framework for Fuzzing USB Drivers by 
> Device Emulation
> 
> In this case, the values from DMA can be bad, and the driver should 
> carefully check these values to avoid security problems.
> IOMMU is an effective method to prevent the hardware from accessing 
> arbitrary memory address via DMA, but it does not check whether the 
> values from DMA are safe.
> 
> I find that some drivers (including the av7110 driver) check (or try to 
> check) the values from DMA, and thus I think these drivers have 
> considered such security problems.
> However, some of these checks are not rigorous, so that they can be 
> bypassed in some cases. The problem that I reported is such an example.

The AV7110 is an old chip, I'm not even sure if it can be used with a
modern system that supports IOMMUs for PCI devices. Without that, it's
game over anyway. Before trying to address the issue of a malicious
AV7110 playing with DMA and CPU races, I would ensure that it's worth
it.

-- 
Regards,

Laurent Pinchart
