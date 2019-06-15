Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4F647265
	for <lists+stable@lfdr.de>; Sun, 16 Jun 2019 00:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfFOW0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 18:26:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbfFOW0a (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Jun 2019 18:26:30 -0400
Received: from localhost (unknown [107.242.116.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58D2121473;
        Sat, 15 Jun 2019 22:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560637589;
        bh=9O6Q/YpH9T0Jy87acBbGfMKLCZ9nwn4uy+CqzEuR9Nk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rWU6g7DnvdoLoOVs2HJ8GPVaG7D94We3EXY9tksIdbBZpjomLqcqusRyez95eQLX4
         zioll8nc2dm4sSb4dfzKbTOf/EX2BTTVnfnS4gN2sOB10lagu7plZMF1uUlOZeGsZe
         v0M9DHAy1BrF8UnrFWdWp0Xd2Ofu+8bra6IdxiGs=
Date:   Sat, 15 Jun 2019 18:26:27 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Venkata Narendra Kumar Gutta <vnkgutta@codeaurora.org>
Subject: Re: [PATCH AUTOSEL 5.1 06/60] driver core: platform: Fix the usage
 of platform device name(pdev->name)
Message-ID: <20190615222626.GR1513@sasha-vm>
References: <20190604232212.6753-1-sashal@kernel.org>
 <20190604232212.6753-6-sashal@kernel.org>
 <20190605045846.GA21363@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190605045846.GA21363@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 05, 2019 at 06:58:46AM +0200, Greg Kroah-Hartman wrote:
>On Tue, Jun 04, 2019 at 07:21:16PM -0400, Sasha Levin wrote:
>> From: Venkata Narendra Kumar Gutta <vnkgutta@codeaurora.org>
>>
>> [ Upstream commit edb16da34b084c66763f29bee42b4e6bb33c3d66 ]
>>
>> Platform core is using pdev->name as the platform device name to do
>> the binding of the devices with the drivers. But, when the platform
>> driver overrides the platform device name with dev_set_name(),
>> the pdev->name is pointing to a location which is freed and becomes
>> an invalid parameter to do the binding match.
>>
>> use-after-free instance:
>>
>> [   33.325013] BUG: KASAN: use-after-free in strcmp+0x8c/0xb0
>> [   33.330646] Read of size 1 at addr ffffffc10beae600 by task modprobe
>> [   33.339068] CPU: 5 PID: 518 Comm: modprobe Tainted:
>> 			G S      W  O      4.19.30+ #3
>> [   33.346835] Hardware name: MTP (DT)
>> [   33.350419] Call trace:
>> [   33.352941]  dump_backtrace+0x0/0x3b8
>> [   33.356713]  show_stack+0x24/0x30
>> [   33.360119]  dump_stack+0x160/0x1d8
>> [   33.363709]  print_address_description+0x84/0x2e0
>> [   33.368549]  kasan_report+0x26c/0x2d0
>> [   33.372322]  __asan_report_load1_noabort+0x2c/0x38
>> [   33.377248]  strcmp+0x8c/0xb0
>> [   33.380306]  platform_match+0x70/0x1f8
>> [   33.384168]  __driver_attach+0x78/0x3a0
>> [   33.388111]  bus_for_each_dev+0x13c/0x1b8
>> [   33.392237]  driver_attach+0x4c/0x58
>> [   33.395910]  bus_add_driver+0x350/0x560
>> [   33.399854]  driver_register+0x23c/0x328
>> [   33.403886]  __platform_driver_register+0xd0/0xe0
>>
>> So, use dev_name(&pdev->dev), which fetches the platform device name from
>> the kobject(dev->kobj->name) of the device instead of the pdev->name.
>>
>> Signed-off-by: Venkata Narendra Kumar Gutta <vnkgutta@codeaurora.org>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/base/platform.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>
>Please drop this from everywhere as it was reverted from Linus's tree
>because it causes big problems.

Dropped from all branches, thanks!

--
Thanks,
Sasha
