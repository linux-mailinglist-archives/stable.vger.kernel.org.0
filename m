Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9260312F38E
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 04:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgACDbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 22:31:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:58314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgACDbi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 22:31:38 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30D00222C3;
        Fri,  3 Jan 2020 03:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578022297;
        bh=Hoxz1RSrdZfuqw22MIYYc3rp6ahs0DFIzN8Dwk9BWvg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VNVWDC9wyiHtGQVSUmaHU7R50x+AP5pwKuf37YxxTQ7o+2MIAVaz+t3nYR+dtGJv3
         7dPW1jRuQx42OrcmuRUn2kGuAUzEu2VYa/XQp+aMVsDFVx71UEk8rkATqUVozTiMnA
         gwAf3a805FrlNf2MSlTa6Wb0WxnCQ4i6adSe7yUM=
Date:   Thu, 2 Jan 2020 22:31:36 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Doug Meyer <dmeyer@gigaio.com>,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org,
        Kelvin Cao <Kelvin.Cao@microchip.com>
Subject: Re: [PATCH] PCI/switchtec: Read all 64 bits of part_event_bitmap
Message-ID: <20200103033136.GN16372@sasha-vm>
References: <20191219182747.28917-1-logang@deltatee.com>
 <20200101170406.GE2712976@kroah.com>
 <20200103001812.GL16372@sasha-vm>
 <cf1a1886-6073-e136-ac36-0abba954556e@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cf1a1886-6073-e136-ac36-0abba954556e@deltatee.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 02, 2020 at 05:46:58PM -0700, Logan Gunthorpe wrote:
>
>
>On 2020-01-02 5:18 p.m., Sasha Levin wrote:
>> On Wed, Jan 01, 2020 at 06:04:06PM +0100, Greg Kroah-Hartman wrote:
>>> On Thu, Dec 19, 2019 at 11:27:47AM -0700, Logan Gunthorpe wrote:
>>>> commit 6acdf7e19b37cb3a9258603d0eab315079c19c5e upstream.
>>>>
>>>> The part_event_bitmap register is 64 bits wide, so read it with
>>>> ioread64()
>>>> instead of the 32-bit ioread32().
>>>>
>>>> Fixes: 52eabba5bcdb ("switchtec: Add IOCTLs to the Switchtec driver")
>>>> Link:
>>>> https://lore.kernel.org/r/20190910195833.3891-1-logang@deltatee.com
>>>> Reported-by: Doug Meyer <dmeyer@gigaio.com>
>>>> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
>>>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>>>> Cc: stable@vger.kernel.org    # v4.12+
>>>> Cc: Kelvin Cao <Kelvin.Cao@microchip.com>
>>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>> ---
>>>>
>>>> ioread64() was introduced in v5.1 so the upstream patch won't compile on
>>>> stable versions 4.14 or 4.19. This is the same patch but uses readq()
>>>> which should be equivalent.
>>>
>>> Now queued up, thanks.
>>
>> Hey Logan,
>>
>> As Guenter has pointed out, readq() is only defined for 64 bits, so this
>> breaks compilation in i386. I've dropped this backport for now, if you
>> could fix it up we could queue it up again.
>
>Not quiet true. It is in fact defined for 32-bit architectures as two
>readl() calls in "linux/io-64-nonatomic-lo-hi.h".
>
>So, unless I'm missing something the patch should be fine.

This is an actual error we're seeing:

drivers/pci/switch/switchtec.c: In function ‘ioctl_event_summary’:
drivers/pci/switch/switchtec.c:636:18: error: implicit declaration of function ‘readq’; did you mean ‘readl’? [-Werror=implicit-function-declaration]
  636 |  s.part_bitmap = readq(&stdev->mmio_sw_event->part_event_bitmap);
      |                  ^~~~~
      |                  readl
cc1: some warnings being treated as errors
make[1]: *** [scripts/Makefile.build:310: drivers/pci/switch/switchtec.o] Error 1
make: *** [Makefile:1695: drivers/pci/switch/] Error 2

So the patch isn't fine :)

You're correct about linux/io-64-nonatomic-lo-hi.h, but sadly it isn't
included in drivers/pci/switch/switchtec.c so it's not getting used.
Something like the following has fixed compilation for me:

diff --git a/drivers/pci/switch/switchtec.c b/drivers/pci/switch/switchtec.c
index 4042fe1e7361..5035b17fe399 100644
--- a/drivers/pci/switch/switchtec.c
+++ b/drivers/pci/switch/switchtec.c
@@ -16,6 +16,8 @@

 #include <linux/nospec.h>

+#include <linux/io-64-nonatomic-lo-hi.h>
+
 MODULE_DESCRIPTION("Microsemi Switchtec(tm) PCIe Management Driver");
 MODULE_VERSION("0.1");
 MODULE_LICENSE("GPL");

-- 
Thanks,
Sasha
