Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3AE7803C
	for <lists+stable@lfdr.de>; Sun, 28 Jul 2019 17:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbfG1Phc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jul 2019 11:37:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbfG1Phc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Jul 2019 11:37:32 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4A3A2075E;
        Sun, 28 Jul 2019 15:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564328250;
        bh=dtpU0JvrhpmoMYOOkgibEwwTx2ITKEaj/zaUT14NMXY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e7+0iwwQS6zexQs9n1mZQqR2usI1hB7F3+6QneIJaBy2NftphI4L0qR4SIx3Q9+Vz
         dUTsOKQ5LtocYpvFHRFzQqT1ehu7Hyb3yQE/ZpQ1JdYvso09pFNRAvH8rwE932CwHd
         8dN2F1VOIKhd0rHnT3oQEUw6is3bVqQqL+sKjvgM=
Date:   Sun, 28 Jul 2019 11:37:29 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        EJ Hsu <ejh@nvidia.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.1 054/141] usb: gadget: storage: Remove warning
 message
Message-ID: <20190728153729.GG8637@sasha-vm>
References: <20190719040246.15945-1-sashal@kernel.org>
 <20190719040246.15945-54-sashal@kernel.org>
 <CY4PR1201MB003731626E6A487A7CFC0E33AACB0@CY4PR1201MB0037.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CY4PR1201MB003731626E6A487A7CFC0E33AACB0@CY4PR1201MB0037.namprd12.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 19, 2019 at 05:27:31AM +0000, Thinh Nguyen wrote:
>Hi Sasha,
>
>Sasha Levin wrote:
>> From: EJ Hsu <ejh@nvidia.com>
>>
>> [ Upstream commit e70b3f5da00119e057b7faa557753fee7f786f17 ]
>>
>> This change is to fix below warning message in following scenario:
>> usb_composite_setup_continue: Unexpected call
>>
>> When system tried to enter suspend, the fsg_disable() will be called to
>> disable fsg driver and send a signal to fsg_main_thread. However, at
>> this point, the fsg_main_thread has already been frozen and can not
>> respond to this signal. So, this signal will be pended until
>> fsg_main_thread wakes up.
>>
>> Once system resumes from suspend, fsg_main_thread will detect a signal
>> pended and do some corresponding action (in handle_exception()). Then,
>> host will send some setup requests (get descriptor, set configuration...)
>> to UDC driver trying to enumerate this device. During the handling of "set
>> configuration" request, it will try to sync up with fsg_main_thread by
>> sending a signal (which is the same as the signal sent by fsg_disable)
>> to it. In a similar manner, once the fsg_main_thread receives this
>> signal, it will call handle_exception() to handle the request.
>>
>> However, if the fsg_main_thread wakes up from suspend a little late and
>> "set configuration" request from Host arrives a little earlier,
>> fsg_main_thread might come across the request from "set configuration"
>> when it handles the signal from fsg_disable(). In this case, it will
>> handle this request as well. So, when fsg_main_thread tries to handle
>> the signal sent from "set configuration" later, there will nothing left
>> to do and warning message "Unexpected call" is printed.
>>
>> Acked-by: Alan Stern <stern@rowland.harvard.edu>
>> Signed-off-by: EJ Hsu <ejh@nvidia.com>
>> Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/usb/gadget/function/f_mass_storage.c | 21 ++++++++++++++------
>>  drivers/usb/gadget/function/storage_common.h |  1 +
>>  2 files changed, 16 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/gadget/function/f_mass_storage.c
>> index 043f97ad8f22..982c3e89eb0d 100644
>> --- a/drivers/usb/gadget/function/f_mass_storage.c
>> +++ b/drivers/usb/gadget/function/f_mass_storage.c
>>
>
>This patch may have issue. It was reverted upstream. Please don't queue
>to stable.

I've dropped it, thanks!

--
Thanks,
Sasha
