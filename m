Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66D11EB995
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 12:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgFBK0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 06:26:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727785AbgFBKYt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jun 2020 06:24:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 612E8206C3;
        Tue,  2 Jun 2020 10:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591093488;
        bh=TrGhn5EbApP0rTldnGBC/61hiEOwWaKzZ7RQMycm4gI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c22P/nX3NTr76YgD8tg54gr/BppeXI9M3ugHuwhRB7tKQ0gqipPrtJ7nxeM4lQUzM
         K9zTOafCvzLgxGZRTwK23OWGivNdPced+F1nBgejRA/Jt7dXkGcHaAHSwdWCkxW04H
         lS64x7DaRYab3G8yNR4x5pxNltn4JXhUUrsFyvAg=
Date:   Tue, 2 Jun 2020 12:24:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chris Paterson <Chris.Paterson2@renesas.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "ben.hutchings@codethink.co.uk" <ben.hutchings@codethink.co.uk>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/48] 4.4.226-rc1 review
Message-ID: <20200602102447.GA2987707@kroah.com>
References: <20200601173952.175939894@linuxfoundation.org>
 <OSAPR01MB23858265B59669B78394A94CB78A0@OSAPR01MB2385.jpnprd01.prod.outlook.com>
 <20200602020651.GM1407771@sasha-vm>
 <OSAPR01MB2385A58EDAF34A14A3756230B78B0@OSAPR01MB2385.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSAPR01MB2385A58EDAF34A14A3756230B78B0@OSAPR01MB2385.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 02, 2020 at 09:07:15AM +0000, Chris Paterson wrote:
> Hello Sasha,
> 
> > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> > Behalf Of Sasha Levin
> > Sent: 02 June 2020 03:07
> > 
> > On Mon, Jun 01, 2020 at 10:14:20PM +0000, Chris Paterson wrote:
> > >Hi Greg,
> > >
> > >> From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> > >> Behalf Of Greg Kroah-Hartman
> > >> Sent: 01 June 2020 18:53
> > >>
> > >> This is the start of the stable review cycle for the 4.4.226 release.
> > >> There are 48 patches in this series, all will be posted as a response
> > >> to this one.  If anyone has any issues with these being applied, please
> > >> let me know.
> > >
> > >I'm seeing some issues with Linux 4.4.226-rc1 (dc230329b026).
> > >
> > >We have 4 configurations that fail, 2x Armv7 and 2x x86, whilst building the
> > modules.
> > >
> > >Error message:
> > >  ERROR: "pptp_msg_name" [net/netfilter/nf_conntrack_pptp.ko] undefined!
> > >  ERROR: "pptp_msg_name" [net/ipv4/netfilter/nf_nat_pptp.ko] undefined!
> > >
> > >Relevant patches are:
> > >  69969e0f7e37 ("netfilter: nf_conntrack_pptp: prevent buffer overflows in
> > debug code")
> > >  3441cc75e4d1 ("netfilter: nf_conntrack_pptp: fix compilation warning with
> > W=1 build")
> > >
> > >I haven't had a chance to dig deeper yet but will do in the morning.
> > >
> > >Build/test pipeline/logs: https://gitlab.com/cip-project/cip-testing/linux-stable-
> > rc-ci/pipelines/151700917
> > >GitLab CI pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-
> > pipelines/-/blob/master/trees/linux-4.4.y.yml
> > >Relevant LAVA jobs:
> > https://lava.ciplatform.org/scheduler/alljobs?length=25&search=dc2303#table
> > 
> > Thats and interesting one... I've queued fe22cd9b7c98 ("printk: help
> > pr_debug and pr_devel to optimize out arguments") for 4.4 to address
> > this.
> 
> This patch resolves the issue for me.
> 
> Test pipeline: https://gitlab.com/cip-project/cip-kernel/linux-cip/pipelines/151885545

Thanks for testing -rc2 is out with this fixed.

greg k-h
