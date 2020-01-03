Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 891F112F25A
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 01:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgACArC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 19:47:02 -0500
Received: from ale.deltatee.com ([207.54.116.67]:33988 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgACArC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 19:47:02 -0500
Received: from s0106ac1f6bb1ecac.cg.shawcable.net ([70.73.163.230] helo=[192.168.11.155])
        by ale.deltatee.com with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <logang@deltatee.com>)
        id 1inB7E-0006Jy-Bv; Thu, 02 Jan 2020 17:47:01 -0700
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Doug Meyer <dmeyer@gigaio.com>,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org,
        Kelvin Cao <Kelvin.Cao@microchip.com>
References: <20191219182747.28917-1-logang@deltatee.com>
 <20200101170406.GE2712976@kroah.com> <20200103001812.GL16372@sasha-vm>
From:   Logan Gunthorpe <logang@deltatee.com>
Message-ID: <cf1a1886-6073-e136-ac36-0abba954556e@deltatee.com>
Date:   Thu, 2 Jan 2020 17:46:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200103001812.GL16372@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 70.73.163.230
X-SA-Exim-Rcpt-To: Kelvin.Cao@microchip.com, stable@vger.kernel.org, bhelgaas@google.com, dmeyer@gigaio.com, gregkh@linuxfoundation.org, sashal@kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on ale.deltatee.com
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.2
Subject: Re: [PATCH] PCI/switchtec: Read all 64 bits of part_event_bitmap
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2020-01-02 5:18 p.m., Sasha Levin wrote:
> On Wed, Jan 01, 2020 at 06:04:06PM +0100, Greg Kroah-Hartman wrote:
>> On Thu, Dec 19, 2019 at 11:27:47AM -0700, Logan Gunthorpe wrote:
>>> commit 6acdf7e19b37cb3a9258603d0eab315079c19c5e upstream.
>>>
>>> The part_event_bitmap register is 64 bits wide, so read it with
>>> ioread64()
>>> instead of the 32-bit ioread32().
>>>
>>> Fixes: 52eabba5bcdb ("switchtec: Add IOCTLs to the Switchtec driver")
>>> Link:
>>> https://lore.kernel.org/r/20190910195833.3891-1-logang@deltatee.com
>>> Reported-by: Doug Meyer <dmeyer@gigaio.com>
>>> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
>>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>>> Cc: stable@vger.kernel.org    # v4.12+
>>> Cc: Kelvin Cao <Kelvin.Cao@microchip.com>
>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> ---
>>>
>>> ioread64() was introduced in v5.1 so the upstream patch won't compile on
>>> stable versions 4.14 or 4.19. This is the same patch but uses readq()
>>> which should be equivalent.
>>
>> Now queued up, thanks.
> 
> Hey Logan,
> 
> As Guenter has pointed out, readq() is only defined for 64 bits, so this
> breaks compilation in i386. I've dropped this backport for now, if you
> could fix it up we could queue it up again.

Not quiet true. It is in fact defined for 32-bit architectures as two
readl() calls in "linux/io-64-nonatomic-lo-hi.h".

So, unless I'm missing something the patch should be fine.

Logan



