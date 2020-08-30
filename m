Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027092570D7
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 00:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgH3W0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Aug 2020 18:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgH3W0P (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Aug 2020 18:26:15 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B7BC061573;
        Sun, 30 Aug 2020 15:26:14 -0700 (PDT)
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 02F819E6;
        Mon, 31 Aug 2020 00:26:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1598826370;
        bh=Mhfgf3DBnamtwmS/lZnkwRcZ5fDIWm1pmtGC2Ip9qaA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vU3NJY1JELtDJ6xGLfpFe87O7gs1WYZzDFQtkw/NTJuZ8duEKXjVJRosnvegaJpPl
         sEf+nLm0lieySOXOz3J1HkueYD8RU7rSDMOIi4YYqFK5jF7o9eSk4RgFNlzegVnjha
         3VdYFAN57MApazjO+RgVnwgWU2YgGrXkEo5gMktY=
Date:   Mon, 31 Aug 2020 01:25:49 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
Cc:     Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 08/38] media: pci: ttpci: av7110: fix
 possible buffer overflow caused by bad DMA value in debiirq()
Message-ID: <20200830222549.GD6043@pendragon.ideasonboard.com>
References: <20200821161807.348600-1-sashal@kernel.org>
 <20200821161807.348600-8-sashal@kernel.org>
 <20200829121020.GA20944@duo.ucw.cz>
 <20200829171600.GA7465@pendragon.ideasonboard.com>
 <9e797c3a-033b-3473-ac03-1566d40e90d2@tsinghua.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9e797c3a-033b-3473-ac03-1566d40e90d2@tsinghua.edu.cn>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jia-Ju,

On Sun, Aug 30, 2020 at 03:33:11PM +0800, Jia-Ju Bai wrote:
> On 2020/8/30 1:16, Laurent Pinchart wrote:
> > On Sat, Aug 29, 2020 at 02:10:20PM +0200, Pavel Machek wrote:
> >> Hi!
> >>
> >>> The value av7110->debi_virt is stored in DMA memory, and it is assigned
> >>> to data, and thus data[0] can be modified at any time by malicious
> >>> hardware. In this case, "if (data[0] < 2)" can be passed, but then
> >>> data[0] can be changed into a large number, which may cause buffer
> >>> overflow when the code "av7110->ci_slot[data[0]]" is used.
> >>>
> >>> To fix this possible bug, data[0] is assigned to a local variable, which
> >>> replaces the use of data[0].
> >> I'm pretty sure hardware capable of manipulating memory can work
> >> around any such checks, but...
> >>
> >>> +++ b/drivers/media/pci/ttpci/av7110.c
> >>> @@ -424,14 +424,15 @@ static void debiirq(unsigned long cookie)
> >>>   	case DATA_CI_GET:
> >>>   	{
> >>>   		u8 *data = av7110->debi_virt;
> >>> +		u8 data_0 = data[0];
> >>>   
> >>> -		if ((data[0] < 2) && data[2] == 0xff) {
> >>> +		if (data_0 < 2 && data[2] == 0xff) {
> >>>   			int flags = 0;
> >>>   			if (data[5] > 0)
> >>>   				flags |= CA_CI_MODULE_PRESENT;
> >>>   			if (data[5] > 5)
> >>>   				flags |= CA_CI_MODULE_READY;
> >>> -			av7110->ci_slot[data[0]].flags = flags;
> >>> +			av7110->ci_slot[data_0].flags = flags;
> >>
> >> This does not even do what it says. Compiler is still free to access
> >> data[0] multiple times. It needs READ_ONCE() to be effective.
> >
> > Yes, it seems quite dubious to me. If we *really* want to guard against
> > rogue hardware here, the whole DMA buffer should be copied. I don't
> > think it's worth it, a rogue PCI device can do much more harm.
> 
> From the original driver code, data[0] is considered to be bad and thus 
> it should be checked, because the content of the DMA buffer may be 
> problematic.
>
> Based on this consideration, data[0] can be also modified to bypass the 
> check, and thus its value should be copied to a local variable for the 
> check and use.

What makes you think the hardware would do that ?

> I agree with Pavel that the compiler optimization may drop the copying 
> operation, and thus READ_ONCE() should be used here.
> I will submit a v2 patch soon.

-- 
Regards,

Laurent Pinchart
