Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E298524BE9F
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbgHTN3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:29:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728770AbgHTN3Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 09:29:25 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A631208A9;
        Thu, 20 Aug 2020 13:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597930165;
        bh=TCYmLgf6ZeWa82TBbBiddjDcFsiYAq77Gs/NAYzu4RQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hSd2v8g7NzQcHTqpKc4MRnc3is4Z/W4nds9K2D9wx1uFlDRELkaHfG46pprMNl0qQ
         B/Ckq6ME9DSu0O226AGuDw79ue3YjbjiQnQ5vzcFuq4VdL+OTR45om/YxxdJaH06IQ
         wOUJjgMfT8Ezg6bZW8cSDDGylSNcvwwARkVRYacg=
Date:   Thu, 20 Aug 2020 09:29:24 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Wei Hu <weh@microsoft.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH 5.8 164/232] PCI: hv: Fix a timing issue which causes
 kdump to fail occasionally
Message-ID: <20200820132924.GA8670@sasha-vm>
References: <20200820091612.692383444@linuxfoundation.org>
 <20200820091620.754492308@linuxfoundation.org>
 <MW2PR2101MB10522B1242B1309BF35EFFEED75A0@MW2PR2101MB1052.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB10522B1242B1309BF35EFFEED75A0@MW2PR2101MB1052.namprd21.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 01:00:51PM +0000, Michael Kelley wrote:
>From: Greg Kroah-Hartman <gregkh@linuxfoundation.org> Sent: Thursday, August 20, 2020 2:20 AM
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
>This patch came through three days ago, and I indicated then that we don't want
>it backported to 5.8 and earlier.

Uh, I re-added it by mistake, sorry.

-- 
Thanks,
Sasha
