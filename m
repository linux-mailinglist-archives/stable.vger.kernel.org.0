Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A781EC118
	for <lists+stable@lfdr.de>; Fri,  1 Nov 2019 11:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729606AbfKAKJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Nov 2019 06:09:40 -0400
Received: from smtp1.de.adit-jv.com ([93.241.18.167]:35982 "EHLO
        smtp1.de.adit-jv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729346AbfKAKJk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Nov 2019 06:09:40 -0400
Received: from localhost (smtp1.de.adit-jv.com [127.0.0.1])
        by smtp1.de.adit-jv.com (Postfix) with ESMTP id EE3073C0585;
        Fri,  1 Nov 2019 11:09:36 +0100 (CET)
Received: from smtp1.de.adit-jv.com ([127.0.0.1])
        by localhost (smtp1.de.adit-jv.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MhaYGHxy-4I0; Fri,  1 Nov 2019 11:09:31 +0100 (CET)
Received: from HI2EXCH01.adit-jv.com (hi2exch01.adit-jv.com [10.72.92.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp1.de.adit-jv.com (Postfix) with ESMTPS id A6A4A3C004C;
        Fri,  1 Nov 2019 11:09:31 +0100 (CET)
Received: from vmlxhi-102.adit-jv.com (10.72.93.184) by HI2EXCH01.adit-jv.com
 (10.72.92.24) with Microsoft SMTP Server (TLS) id 14.3.468.0; Fri, 1 Nov 2019
 11:09:31 +0100
Date:   Fri, 1 Nov 2019 11:09:28 +0100
From:   Eugeniu Rosca <erosca@de.adit-jv.com>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
CC:     "REE erosca@DE.ADIT-JV.COM" <erosca@DE.ADIT-JV.COM>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Asano Yasushi <yasano@jp.adit-jv.com>,
        Yohhei Fukui <yohhei.fukui@denso-ten.com>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>
Subject: Re: [PATCH 2/2] PCI: rcar: Fix missing MACCTLR register setting in
 initialize sequence
Message-ID: <20191101100928.GA20839@vmlxhi-102.adit-jv.com>
References: <1572434824-1850-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <1572434824-1850-3-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <20191030163431.GA882@vmlxhi-102.adit-jv.com>
 <TYAPR01MB45442B94AAFF1F7E8FFB0CE6D8620@TYAPR01MB4544.jpnprd01.prod.outlook.com>
 <TYAPR01MB4544C58FAB805796583B428AD8620@TYAPR01MB4544.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <TYAPR01MB4544C58FAB805796583B428AD8620@TYAPR01MB4544.jpnprd01.prod.outlook.com>
User-Agent: Mutt/1.12.1+40 (7f8642d4ee82) (2019-06-28)
X-Originating-IP: [10.72.93.184]
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Shimoda-san,

On Fri, Nov 01, 2019 at 06:39:03AM +0000, Yoshihiro Shimoda wrote:
> Hello again,
> 
> > From: Yoshihiro Shimoda, Sent: Friday, November 1, 2019 2:08 PM
> <snip>
> > Hello Eugeniu-san,
> > 
> > > From: Eugeniu Rosca, Sent: Thursday, October 31, 2019 1:35 AM
> > <snip>
> > > > diff --git a/drivers/pci/controller/pcie-rcar.c b/drivers/pci/controller/pcie-rcar.c
> > > > index 40d8c54..d470ab8 100644
> > > > --- a/drivers/pci/controller/pcie-rcar.c
> > > > +++ b/drivers/pci/controller/pcie-rcar.c
> > > > @@ -91,6 +91,7 @@
> > > >  #define  LINK_SPEED_2_5GTS	(1 << 16)
> > > >  #define  LINK_SPEED_5_0GTS	(2 << 16)
> > > >  #define MACCTLR			0x011058
> > > > +#define  MACCTLR_INIT_VAL	0x80ff0000
> > >
> > > Actually, I do believe there is an inconsistency in the manual,
> > > since the following statements pretty much contradict one another:
> > >
> > > 1. (as quoted by Shimoda-san from "Initial Setting of PCI Express")
> > >    > Be sure to write the initial value (= H'80FF 0000) to MACCTLR
> > >    > before enabling PCIETCTLR.CFINIT.
> > > 2. Description of SPCHG bit in "54.2.98 MAC Control Register (MACCTLR)"
> > >    > Only writing 1 is valid and writing 0 is invalid.
> > >
> > > The last "invalid" sounds like "bad things can happen" aka "expect
> > > undefined behaviors" when SPCHG is written "0".
> > 
> > I asked the hardware team about the "invalid" in the SPCHG bit and then
> > this "invalid" means "ignored", not "prohibited". So, even if we write
> > the SPCHG to 0, no bad things/undefined behaviors happen.
> > 
> > > While leaving the decision on the patch inclusion to the maintainers, I
> > > hope, in the long run, Renesas can resolve the documentation conflict
> > > with the HW team and the tech writers.
> > 
> > So, I don't think the documentation conflict exists about the MACCTLR register.
> > But, what do you think?
> 
> JFYI, I have submitted v2 patch series which was described about the SPCHG:
> https://patchwork.kernel.org/project/linux-renesas-soc/list/?series=196557

Thanks for clarifying the exact meaning of the "invalid" wording in the
description of the SPCHG bit so promptly and for stressing that in v2.
Greatly appreciated from our side.

-- 
Best Regards,
Eugeniu
