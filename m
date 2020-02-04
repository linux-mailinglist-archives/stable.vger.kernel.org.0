Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBBCF151CE5
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 16:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbgBDPEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 10:04:33 -0500
Received: from dougal.metanate.com ([90.155.101.14]:34438 "EHLO metanate.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727282AbgBDPEc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Feb 2020 10:04:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/simple; d=metanate.com;
         s=stronger; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References
        :In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ieP8o0no7ny4dq1ZgQyoiOB7696+27Jc3q08Jbxmap0=; b=JCj3IuALSH3gV+mrcQLxCTI/wH
        5a4rDIpJDUQxNv1R0TsGTTmYZievYgAHheBaJT0jt+nDgnTu0nP5qNpMat62CGzT+wblKEdOdNcUo
        vgR+H2g4pOU7Lyc7eArRvvzYKNzDcbcDB2unGVa1Dx2yq102ABeLSshOtu6fJsoEWdPEH+sTRxlGt
        FUNWZ8HLwVirukMnqq6lH7ro8zx/wRjgtASneROg1tNh4FeYH3tqICaAqrIo4XubKccdSocYzg65M
        CSdrsAA3N/H3DCrnjUIB1yFL4yyOpKViraO/iTsEJTHpKD8Wbqb0UywsmRTPoZjvcNMyyQcZyAhY+
        loq8X/7Q==;
Received: from dougal.metanate.com ([192.168.88.1] helo=donbot)
        by email.metanate.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <john@metanate.com>)
        id 1iyzkY-0002aq-Lk; Tue, 04 Feb 2020 15:04:26 +0000
Date:   Tue, 4 Feb 2020 15:04:26 +0000
From:   John Keeping <john@metanate.com>
To:     Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc2: Fix SET/CLEAR_FEATURE and GET_STATUS flows
Message-ID: <20200204150426.6cd3f0b6.john@metanate.com>
In-Reply-To: <fd461c4e-331e-4941-061e-a02e7259aec2@synopsys.com>
References: <f8af9e4b892a8d005f0ae3d42401fee532f44a27.1574938826.git.hminas@synopsys.com>
        <8736dsl4u4.fsf@gmail.com>
        <e314d265-6d87-eb7a-997e-52d77ccdb725@synopsys.com>
        <d89dc76f-ab19-e7e7-1375-534cd2cfaa1c@synopsys.com>
        <20200204114538.12af5d84.john@metanate.com>
        <fd461c4e-331e-4941-061e-a02e7259aec2@synopsys.com>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Authenticated: YES
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 4 Feb 2020 11:50:12 +0000
Minas Harutyunyan <Minas.Harutyunyan@synopsys.com> wrote:

> On 2/4/2020 3:45 PM, John Keeping wrote:
> > On Fri, 13 Dec 2019 11:54:11 +0000
> > Minas Harutyunyan <Minas.Harutyunyan@synopsys.com> wrote:  
> >> On 12/10/2019 6:19 PM, Minas Harutyunyan wrote:  
> >>> On 12/10/2019 4:53 PM, Felipe Balbi wrote:  
> >>>> Minas Harutyunyan <Minas.Harutyunyan@synopsys.com> writes:
> >>>>     
> >>>>> SET/CLEAR_FEATURE for Remote Wakeup allowance not handled correctly.
> >>>>> GET_STATUS handling provided not correct data on DATA Stage.
> >>>>> Issue seen when gadget's dr_mode set to "otg" mode and connected
> >>>>> to MacOS.
> >>>>> Both are fixed and tested using USBCV Ch.9 tests.
> >>>>>
> >>>>> Signed-off-by: Minas Harutyunyan <hminas@synopsys.com>  
> >>>>
> >>>> do you want to add a Fixes tag here?  
> >>>
> >>> Fixes: fa389a6d7726 ("usb: dwc2: gadget: Add remote_wakeup_allowed flag")
> >>>      
> >> Got tested tag by issue reported.
> >>
> >> Tested-By: Jack Mitchell <ml@embed.me.uk>
> >>
> >> Should I resubmit patch as v2 with added "Fixes" and "Tested-by" tags.  
> > 
> > Was this patch ever picked up?  I don't see it in current next.
> >   
> Yes, it picked up by Felipe. It under testing/fixes
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git/commit/?h=testing/fixes&id=6de1e301b9cf8eb023357586ab8b02edda07320b

Thanks!  I'll try to remember to look there next time.


Sorry for the noise,
John
