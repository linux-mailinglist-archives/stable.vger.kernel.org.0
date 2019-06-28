Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF4C59D88
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 16:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfF1OL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 10:11:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:59616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726657AbfF1OL0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jun 2019 10:11:26 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 505E8208E3;
        Fri, 28 Jun 2019 14:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561731085;
        bh=oCdjswagAHobZ63isHTznuUFBTZdnoCTi6w01PJYl34=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RY7fx0ksb+ZyuqSmfw6eq13pMpdkgzBscRQ5B1n9yMItpYvIQfIBd8teTqASKEOR7
         PlSNDfylgSn0A9QkGfQXP5ylUk0bGH1DvzQWvXtF1P8APdHO1n68bovpdNXnO6e4nb
         MseQ75verriuBJNKjlk9p4h56gdU1jt740Yj44CQ=
Date:   Fri, 28 Jun 2019 10:11:24 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Kristian Evensen <kristian.evensen@gmail.com>
Cc:     stable <stable@vger.kernel.org>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: [PATCH] qmi_wwan: Fix out-of-bounds read
Message-ID: <20190628141124.GE11506@sasha-vm>
References: <20190627100105.11517-1-kristian.evensen@gmail.com>
 <CAKfDRXhHWCxKK6gDciar5eQg9Ojv4+0C7tgaSOmQFFGLCL9gqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKfDRXhHWCxKK6gDciar5eQg9Ojv4+0C7tgaSOmQFFGLCL9gqw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 28, 2019 at 06:14:33AM +0200, Kristian Evensen wrote:
>Hi,
>
>On Thu, Jun 27, 2019 at 12:01 PM Kristian Evensen
><kristian.evensen@gmail.com> wrote:
>>
>> commit 904d88d743b0c94092c5117955eab695df8109e8 upstream.
>>
>> The syzbot reported
>>
>>  Call Trace:
>>   __dump_stack lib/dump_stack.c:77 [inline]
>>   dump_stack+0xca/0x13e lib/dump_stack.c:113
>>   print_address_description+0x67/0x231 mm/kasan/report.c:188
>>   __kasan_report.cold+0x1a/0x32 mm/kasan/report.c:317
>>   kasan_report+0xe/0x20 mm/kasan/common.c:614
>>   qmi_wwan_probe+0x342/0x360 drivers/net/usb/qmi_wwan.c:1417
>>   usb_probe_interface+0x305/0x7a0 drivers/usb/core/driver.c:361
>>   really_probe+0x281/0x660 drivers/base/dd.c:509
>>   driver_probe_device+0x104/0x210 drivers/base/dd.c:670
>>   __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:777
>>   bus_for_each_drv+0x15c/0x1e0 drivers/base/bus.c:454
>>
>> Caused by too many confusing indirections and casts.
>> id->driver_info is a pointer stored in a long.  We want the
>> pointer here, not the address of it.
>>
>> Thanks-to: Hillf Danton <hdanton@sina.com>
>> Reported-by: syzbot+b68605d7fadd21510de1@syzkaller.appspotmail.com
>> Cc: Kristian Evensen <kristian.evensen@gmail.com>
>> Fixes: e4bf63482c30 ("qmi_wwan: Add quirk for Quectel dynamic config")
>> Signed-off-by: Bjørn Mork <bjorn@mork.no>
>>
>> [Upstream commit did not apply because I shuffled two lines in the
>> backport. The fixes tag for 4.14 is 3a6a5107ceb3.]
>>
>> Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
>> ---
>
>I see now that I forgot to set the correct prefix for the patch. The
>prefix should be PATCH 4.14. Sorry about that. Please let me know if I
>should resubmit.

I've queued it for 4.14, thank you.

--
Thanks,
Sasha
