Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6895835612
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 06:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfFEE6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 00:58:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbfFEE6u (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Jun 2019 00:58:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EC602083E;
        Wed,  5 Jun 2019 04:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559710729;
        bh=DEf0Y+bhQL478Uky0AAR8FzgVDMCNOv8h9CVgUfkA2k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q2gD34iPnsroQVtI3ep7Kp1IB2RIVemKkGlksaJ8CwIFffKNJJrcDJv1XxCjjzsm9
         UyMmf3AVftsNzK5xwXyJJPsdq5LdJFK6EodMpMcWtsCbPYJMF8/tpLs1wBxamavn4S
         ITJQs9/VPmEfj5n1r6VjGdgTcln2yaJHpBg18FyA=
Date:   Wed, 5 Jun 2019 06:58:46 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Venkata Narendra Kumar Gutta <vnkgutta@codeaurora.org>
Subject: Re: [PATCH AUTOSEL 5.1 06/60] driver core: platform: Fix the usage
 of platform device name(pdev->name)
Message-ID: <20190605045846.GA21363@kroah.com>
References: <20190604232212.6753-1-sashal@kernel.org>
 <20190604232212.6753-6-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604232212.6753-6-sashal@kernel.org>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 04, 2019 at 07:21:16PM -0400, Sasha Levin wrote:
> From: Venkata Narendra Kumar Gutta <vnkgutta@codeaurora.org>
> 
> [ Upstream commit edb16da34b084c66763f29bee42b4e6bb33c3d66 ]
> 
> Platform core is using pdev->name as the platform device name to do
> the binding of the devices with the drivers. But, when the platform
> driver overrides the platform device name with dev_set_name(),
> the pdev->name is pointing to a location which is freed and becomes
> an invalid parameter to do the binding match.
> 
> use-after-free instance:
> 
> [   33.325013] BUG: KASAN: use-after-free in strcmp+0x8c/0xb0
> [   33.330646] Read of size 1 at addr ffffffc10beae600 by task modprobe
> [   33.339068] CPU: 5 PID: 518 Comm: modprobe Tainted:
> 			G S      W  O      4.19.30+ #3
> [   33.346835] Hardware name: MTP (DT)
> [   33.350419] Call trace:
> [   33.352941]  dump_backtrace+0x0/0x3b8
> [   33.356713]  show_stack+0x24/0x30
> [   33.360119]  dump_stack+0x160/0x1d8
> [   33.363709]  print_address_description+0x84/0x2e0
> [   33.368549]  kasan_report+0x26c/0x2d0
> [   33.372322]  __asan_report_load1_noabort+0x2c/0x38
> [   33.377248]  strcmp+0x8c/0xb0
> [   33.380306]  platform_match+0x70/0x1f8
> [   33.384168]  __driver_attach+0x78/0x3a0
> [   33.388111]  bus_for_each_dev+0x13c/0x1b8
> [   33.392237]  driver_attach+0x4c/0x58
> [   33.395910]  bus_add_driver+0x350/0x560
> [   33.399854]  driver_register+0x23c/0x328
> [   33.403886]  __platform_driver_register+0xd0/0xe0
> 
> So, use dev_name(&pdev->dev), which fetches the platform device name from
> the kobject(dev->kobj->name) of the device instead of the pdev->name.
> 
> Signed-off-by: Venkata Narendra Kumar Gutta <vnkgutta@codeaurora.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/base/platform.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Please drop this from everywhere as it was reverted from Linus's tree
because it causes big problems.

thanks,

greg k-h
