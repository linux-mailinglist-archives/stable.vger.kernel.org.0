Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B30247BA6
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 02:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgHRAyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 20:54:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbgHRAyw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 20:54:52 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCC5A2078B;
        Tue, 18 Aug 2020 00:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597712092;
        bh=VD62CXPwCkmJuAeTqgY5XHb25Dy+4IXcXfQdlHKK0QQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s/BluTh/RbG2VQ8rEX/6UD+ZEOQBaI/hrDYl1dl+fO8GFvb3oXr8WPPJQxWhw16VU
         dR3HZ1i63xGJ9NBqIrTVYhuuYJZ0jqd9m9Fliy8pAm1zEvL8tg0BIsk+h1ODXDpEHm
         TJCYdK5v3IMWbkw9r6gfzQ0V8WbCfBcLY22eUme8=
Date:   Mon, 17 Aug 2020 20:54:50 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Wei Hu <weh@microsoft.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH 5.8 298/464] PCI: hv: Fix a timing issue which causes
 kdump to fail occasionally
Message-ID: <20200818005450.GF4122976@sasha-vm>
References: <20200817143833.737102804@linuxfoundation.org>
 <20200817143848.081418490@linuxfoundation.org>
 <MW2PR2101MB1052E21C566EA4F1C31F356FD75F0@MW2PR2101MB1052.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB1052E21C566EA4F1C31F356FD75F0@MW2PR2101MB1052.namprd21.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 11:27:49PM +0000, Michael Kelley wrote:
>From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>  Sent: Monday, August 17, 2020 8:14 AM
>>
>> From: Wei Hu <weh@microsoft.com>
>>
>> [ Upstream commit d6af2ed29c7c1c311b96dac989dcb991e90ee195 ]
>>
>> Kdump could fail sometime on Hyper-V guest because the retry in
>> hv_pci_enter_d0() releases child device structures in hv_pci_bus_exit().
>>
>> Although there is a second asynchronous device relations message sending
>> from the host, if this message arrives to the guest after
>> hv_send_resource_allocated() is called, the retry would fail.
>>
>> Fix the problem by moving retry to hv_pci_probe() and start the retry
>> from hv_pci_query_relations() call.  This will cause a device relations
>> message to arrive to the guest synchronously; the guest would then be
>> able to rebuild the child device structures before calling
>> hv_send_resource_allocated().
>>
>> Link:
>> https://lore.kernel.org/linux-hyperv/20200727071731.18516-1-weh@microsoft.com/
>> Fixes: c81992e7f4aa ("PCI: hv: Retry PCI bus D0 entry on invalid device state")
>> Signed-off-by: Wei Hu <weh@microsoft.com>
>> [lorenzo.pieralisi@arm.com: fixed a comment and commit log]
>> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
>> Reviewed-by: Michael Kelley <mikelley@microsoft.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/pci/controller/pci-hyperv.c | 71 +++++++++++++++--------------
>>  1 file changed, 37 insertions(+), 34 deletions(-)
>>
>
>Greg --
>
>Don't backport this patch to 5.8 and earlier.  It doesn't break anything,
>but it doesn't fully accomplish what was intended either.  As such it will
>probably need a revision in 5.9.  Wei Hu is unavailable for a few days
>for personal reasons, so I'm jumping in here on his behalf.

I've dropped it, will wait for the fix.

-- 
Thanks,
Sasha
