Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A7120B26B
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 15:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgFZNX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 09:23:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725864AbgFZNXZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jun 2020 09:23:25 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E68BC2078D;
        Fri, 26 Jun 2020 13:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593177805;
        bh=eLUtMNXs0fYMI6cz6qlvIpFMySMSeTOQYK+CTrq5IHc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ViFJdl33+SQO0HSremYUDH6RB/AlDLXkbLcptQ6dttFIB0MRREVlGkxng12H89P3h
         Ykk/jY4yd2dA1NXQsM/YnKERkJsvCcxWtK2/4YEjYSs+quabNSiSvWRubAJqBsKbfF
         LRb+KiIF8A/Fuqx2vr9LCDRaoIXX/T25PwGM/4kA=
Received: by pali.im (Postfix)
        id 065AD890; Fri, 26 Jun 2020 15:23:22 +0200 (CEST)
Date:   Fri, 26 Jun 2020 15:23:22 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomasz Maciej Nowak <tmn505@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 023/206] PCI: aardvark: Dont blindly enable ASPM L0s
 and dont write to read-only register
Message-ID: <20200626132322.j5wwyps7rj3c3eeg@pali>
References: <20200623195316.864547658@linuxfoundation.org>
 <20200623195318.115434987@linuxfoundation.org>
 <20200626125350.GA29985@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626125350.GA29985@duo.ucw.cz>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On Friday 26 June 2020 14:53:50 Pavel Machek wrote:
> Hi!
> 
> > [ Upstream commit 90c6cb4a355e7befcb557d217d1d8b8bd5875a05 ]
> > 
> > Trying to change Link Status register does not have any effect as this
> > is a read-only register. Trying to overwrite bits for Negotiated Link
> > Width does not make sense.
> 
> I don't quite get it. This says register is read only...
> 
> > In future proper change of link width can be done via Lane Count Select
> > bits in PCIe Control 0 register.
> > 
> > Trying to unconditionally enable ASPM L0s via ASPM Control bits in Link
> > Control register is wrong. There should be at least some detection if
> > endpoint supports L0s as isn't mandatory.
> 
> ....and this says it is wrong to set the bits as ASPM L0 is not
> mandatory.

Negotiated Link Width is in read-only 16bit Link Status register.

ASPM Control bits are in read-write 16bit Link Control register.

> > +++ b/drivers/pci/controller/pci-aardvark.c
> > @@ -321,10 +321,6 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
> >  
> >  	advk_pcie_wait_for_link(pcie);
> >  
> > -	reg = PCIE_CORE_LINK_L0S_ENTRY |
> > -		(1 << PCIE_CORE_LINK_WIDTH_SHIFT);
> > -	advk_writel(pcie, reg, PCIE_CORE_LINK_CTRL_STAT_REG);
> > -
> >  	reg = advk_readl(pcie, PCIE_CORE_CMD_STATUS_REG);
> >  	reg |= PCIE_CORE_CMD_MEM_ACCESS_EN |
> >  		PCIE_CORE_CMD_IO_ACCESS_EN |
> 
> ...but we only do single write.
> 
> So which is it?

That single write was via 32bit memory access which tried to overwrite
both registers (Link Status and Link Control) at the same time.

> Best regards,
> 									Pavel
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html


