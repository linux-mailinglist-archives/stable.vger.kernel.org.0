Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C683A12F211
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 01:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbgACASN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 19:18:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:57232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgACASN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 19:18:13 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2239D217F4;
        Fri,  3 Jan 2020 00:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578010693;
        bh=MVUP7UxzNWYsV7E1huzXJAYU5eEDVn8gQTkQQUPC8yU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H0E9WMnDjNdfuDv7Q7BF96Ub0avyKCgqAe2XwKqMV3uAAZj0DZMi/14U2bqKh27/A
         oW/aThn8RVn9quC1sECATfc051UBY63WwC2sZTkvXmcBruoLQc9MwIRjEetQ30ZQRP
         SjheTd3rZ8mp2zz03Dwrv6oLQsMS6zHUbyKvkjj4=
Date:   Thu, 2 Jan 2020 19:18:12 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>,
        Doug Meyer <dmeyer@gigaio.com>,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org,
        Kelvin Cao <Kelvin.Cao@microchip.com>
Subject: Re: [PATCH] PCI/switchtec: Read all 64 bits of part_event_bitmap
Message-ID: <20200103001812.GL16372@sasha-vm>
References: <20191219182747.28917-1-logang@deltatee.com>
 <20200101170406.GE2712976@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200101170406.GE2712976@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 01, 2020 at 06:04:06PM +0100, Greg Kroah-Hartman wrote:
>On Thu, Dec 19, 2019 at 11:27:47AM -0700, Logan Gunthorpe wrote:
>> commit 6acdf7e19b37cb3a9258603d0eab315079c19c5e upstream.
>>
>> The part_event_bitmap register is 64 bits wide, so read it with ioread64()
>> instead of the 32-bit ioread32().
>>
>> Fixes: 52eabba5bcdb ("switchtec: Add IOCTLs to the Switchtec driver")
>> Link: https://lore.kernel.org/r/20190910195833.3891-1-logang@deltatee.com
>> Reported-by: Doug Meyer <dmeyer@gigaio.com>
>> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>> Cc: stable@vger.kernel.org	# v4.12+
>> Cc: Kelvin Cao <Kelvin.Cao@microchip.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>
>> ioread64() was introduced in v5.1 so the upstream patch won't compile on
>> stable versions 4.14 or 4.19. This is the same patch but uses readq()
>> which should be equivalent.
>
>Now queued up, thanks.

Hey Logan,

As Guenter has pointed out, readq() is only defined for 64 bits, so this
breaks compilation in i386. I've dropped this backport for now, if you
could fix it up we could queue it up again.

-- 
Thanks,
Sasha
