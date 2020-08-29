Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0AD025694B
	for <lists+stable@lfdr.de>; Sat, 29 Aug 2020 19:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgH2RQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Aug 2020 13:16:24 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:34236 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728105AbgH2RQY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Aug 2020 13:16:24 -0400
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 4A007303;
        Sat, 29 Aug 2020 19:16:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1598721381;
        bh=CU4taoOmDFFhxm8biPJdqxmXviSj+cJCy+kfWTx+v4Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eatXXiu/xs1ZWxxSvsVMx/+vF87ygwNUAh44oawI9uMl10KFjsicMvZRFIGTwAhpz
         YtnW5N1YBXXWHfgFMfAiZH6wzmhQlxq0PpN6JMNVNJ4y155f9ed/IzRIXkI8Vebdmt
         fcRB512voAIbAh6wmXQ1uz6O7a98B/QtmMS0hpcM=
Date:   Sat, 29 Aug 2020 20:16:00 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju@tsinghua.edu.cn>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 08/38] media: pci: ttpci: av7110: fix
 possible buffer overflow caused by bad DMA value in debiirq()
Message-ID: <20200829171600.GA7465@pendragon.ideasonboard.com>
References: <20200821161807.348600-1-sashal@kernel.org>
 <20200821161807.348600-8-sashal@kernel.org>
 <20200829121020.GA20944@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200829121020.GA20944@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 29, 2020 at 02:10:20PM +0200, Pavel Machek wrote:
> Hi!
> 
> > The value av7110->debi_virt is stored in DMA memory, and it is assigned
> > to data, and thus data[0] can be modified at any time by malicious
> > hardware. In this case, "if (data[0] < 2)" can be passed, but then
> > data[0] can be changed into a large number, which may cause buffer
> > overflow when the code "av7110->ci_slot[data[0]]" is used.
> > 
> > To fix this possible bug, data[0] is assigned to a local variable, which
> > replaces the use of data[0].
> 
> I'm pretty sure hardware capable of manipulating memory can work
> around any such checks, but...
> 
> > +++ b/drivers/media/pci/ttpci/av7110.c
> > @@ -424,14 +424,15 @@ static void debiirq(unsigned long cookie)
> >  	case DATA_CI_GET:
> >  	{
> >  		u8 *data = av7110->debi_virt;
> > +		u8 data_0 = data[0];
> >  
> > -		if ((data[0] < 2) && data[2] == 0xff) {
> > +		if (data_0 < 2 && data[2] == 0xff) {
> >  			int flags = 0;
> >  			if (data[5] > 0)
> >  				flags |= CA_CI_MODULE_PRESENT;
> >  			if (data[5] > 5)
> >  				flags |= CA_CI_MODULE_READY;
> > -			av7110->ci_slot[data[0]].flags = flags;
> > +			av7110->ci_slot[data_0].flags = flags;
> 
> This does not even do what it says. Compiler is still free to access
> data[0] multiple times. It needs READ_ONCE() to be effective.

Yes, it seems quite dubious to me. If we *really* want to guard against
rogue hardware here, the whole DMA buffer should be copied. I don't
think it's worth it, a rogue PCI device can do much more harm.

-- 
Regards,

Laurent Pinchart
