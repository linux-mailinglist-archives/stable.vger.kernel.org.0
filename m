Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE8E1EAC8C
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729553AbgFASiI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728939AbgFAShm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 14:37:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA58C008636
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 11:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/djMMu0fZWsClBzd1XLdgM75MIiDvkdIBpG+OCvNkYk=; b=kgBd/F+VVufnGihfAC9h4tY+b
        vAO1MyDOpF24hniVTVQtfGL8hJ5Yxrwxzrxn0CTUrghxUeGMb3i5nGWTCCUmg/kZwSr6a36c3voRY
        ObyZEmvDcqRL4aj+8xIjMe4dBQA5gagww+0erT5mfHVwsymNuxZ09Tq8KDweDx0hoFC4VQlP7wI7W
        qnDuj227VPPMr1RJXlStuCs70+sU14b1z90eFnFEZRe5TjZ0Rx3m8KKAfSO54oivR02xHE5XvuKFC
        2/LVgY1T9eCrXv+kkxN0DEVZ3q9Ms1BgFE6wp1FtlW6CWq+hHLkN04tkXlkkO9ZHtpcM75lOuk7bG
        NNySLg0/A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:40058)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jfpBb-00011X-Ah; Mon, 01 Jun 2020 19:29:23 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jfpBa-0003Xa-MS; Mon, 01 Jun 2020 19:29:22 +0100
Date:   Mon, 1 Jun 2020 19:29:22 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Subject: Re: stable-rc 4.9: arm: arch/arm/vfp/vfphw.S:158: Error: bad
 instruction `ldcleq p11,cr0,[r10],#32*4'
Message-ID: <20200601182922.GQ1551@shell.armlinux.org.uk>
References: <CA+G9fYuwMbm2NUmSLohbUs+KzKcyY9rC0dc4kh9AD9hJi6+ePw@mail.gmail.com>
 <20200601170248.GA1105493@kroah.com>
 <20200601170751.GO1551@shell.armlinux.org.uk>
 <CA+G9fYsHPjXW5BWbAgURhxnrSHamGPMAGtpjikbkUd79_ojFbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsHPjXW5BWbAgURhxnrSHamGPMAGtpjikbkUd79_ojFbw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 01, 2020 at 11:01:19PM +0530, Naresh Kamboju wrote:
> On Mon, 1 Jun 2020 at 22:37, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> > It looks like Naresh's toolchain doesn't like the new format
> > instructions.  Which toolchain (and versions of the individual
> > tools) are you (Naresh) using?
> 
>   toolchain version is gcc-9

gcc 9 is just one part of the toolchain - that's the compiler, and
actually irrelevent for the errors being reported.

It's binutils, specifically the assembler that is choking, so that's
the version we really need.  Something like:

  arm-linux-gnueabihf-as --version

should get it for you.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
