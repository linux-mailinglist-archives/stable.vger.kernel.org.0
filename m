Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2161112369
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 08:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfLDHOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 02:14:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:37462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726048AbfLDHOU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 02:14:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DD82206DF;
        Wed,  4 Dec 2019 07:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575443659;
        bh=Cwv1kql4NHvUwwQgzVHWaWKIlK5ISRIKAetwzq4MSnE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O2BvOavbnZnLGfNrzYPOt8r3wb3gV/o5U95NoWdokw+R3FiRIWnc84L75hC75OFpc
         fA/eBnwD4CeOj8d3qh0RhGcLOABAfSdqqjaO9V9v7TasyRqIFrr3reoKIRbSwdA8ie
         RJmlLjuRtCYFvw9RIE5rOPiwtP9/jT6F89Yez+KU=
Date:   Wed, 4 Dec 2019 08:14:16 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chuhong Yuan <hslester96@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 024/321] net: fec: add missed clk_disable_unprepare
 in remove
Message-ID: <20191204071416.GB3513626@kroah.com>
References: <20191203223427.103571230@linuxfoundation.org>
 <20191203223428.376628375@linuxfoundation.org>
 <20191204055738.nl5db2xtigoamtbk@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204055738.nl5db2xtigoamtbk@toshiba.co.jp>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 04, 2019 at 02:57:38PM +0900, Nobuhiro Iwamatsu wrote:
> Hi,
> 
> On Tue, Dec 03, 2019 at 11:31:30PM +0100, Greg Kroah-Hartman wrote:
> > From: Chuhong Yuan <hslester96@gmail.com>
> > 
> > [ Upstream commit c43eab3eddb4c6742ac20138659a9b701822b274 ]
> > 
> > This driver forgets to disable and unprepare clks when remove.
> > Add calls to clk_disable_unprepare to fix it.
> > 
> > Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> 
> This commit also requires the following commit:
> 
> commit a31eda65ba210741b598044d045480494d0ed52a
> Author: Chuhong Yuan <hslester96@gmail.com>
> Date:   Wed Nov 20 09:25:13 2019 +0800
> 
>     net: fec: fix clock count mis-match
> 
>     pm_runtime_put_autosuspend in probe will call runtime suspend to
>     disable clks automatically if CONFIG_PM is defined. (If CONFIG_PM
>     is not defined, its implementation will be empty, then runtime
>     suspend will not be called.)
> 
>     Therefore, we can call pm_runtime_get_sync to runtime resume it
>     first to enable clks, which matches the runtime suspend. (Only when
>     CONFIG_PM is defined, otherwise pm_runtime_get_sync will also be
>     empty, then runtime resume will not be called.)
> 
>     Then it is fine to disable clks without causing clock count mis-match.
> 
>     Fixes: c43eab3eddb4 ("net: fec: add missed clk_disable_unprepare in remove")
>     Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
>     Acked-by: Fugang Duan <fugang.duan@nxp.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> 
> And this should also apply to 5.3.

Thanks, now queued up.

greg k-h
