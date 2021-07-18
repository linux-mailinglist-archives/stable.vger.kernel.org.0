Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450AE3CC716
	for <lists+stable@lfdr.de>; Sun, 18 Jul 2021 02:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbhGRArI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 20:47:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230259AbhGRArH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Jul 2021 20:47:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5863F61153;
        Sun, 18 Jul 2021 00:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626569050;
        bh=a7B7C7EZMES8UQL7DNwDMK2KcW1llD9/i0LUiJ1YGLY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T/OLmGQB8errsV6U1abggA6QQgDSh/V+Y59pDZahYXR7XuKdtfebg6rfIUsMfTDJO
         zwfQJXZR0loR7tQJKW6RGTIi7daZ8AhDCZN+yMf5KXVvck64T8d4l/Aescy6X+w4ka
         sPFSdZBzZ8tkM0D0t5oGOdaxxwSRFEIgRfc7CEMwG0As+Gh8xfcNxdBNs/v+vfRueV
         OL+aXsLvSiLT+X7eOsODUEQJKd+p9oa2VHElMX6oZfkUQpijbw+IF/2O0zV9rCZapb
         c9+V+W/4FquVyKLumd046YR9zMuzulQvRKErG6PpDkgbxHe1yZLmvSLGdMCOlYQV0F
         sU8y4/APGlyOg==
Date:   Sat, 17 Jul 2021 20:44:09 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Johan Hovold <johan@kernel.org>,
        syzbot+7dbcd9ff34dc4ed45240@syzkaller.appspotmail.com,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.13 062/114] USB: core: Avoid WARNings for
 0-length descriptor requests
Message-ID: <YPN5WVw3c1Xy4sdB@sashalap>
References: <20210710021748.3167666-1-sashal@kernel.org>
 <20210710021748.3167666-62-sashal@kernel.org>
 <YOk89mYb8p0Dm23k@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YOk89mYb8p0Dm23k@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 10, 2021 at 08:23:50AM +0200, Greg Kroah-Hartman wrote:
>On Fri, Jul 09, 2021 at 10:16:56PM -0400, Sasha Levin wrote:
>> From: Alan Stern <stern@rowland.harvard.edu>
>>
>> [ Upstream commit 60dfe484cef45293e631b3a6e8995f1689818172 ]
>>
>> The USB core has utility routines to retrieve various types of
>> descriptors.  These routines will now provoke a WARN if they are asked
>> to retrieve 0 bytes (USB "receive" requests must not have zero
>> length), so avert this by checking the size argument at the start.
>>
>> CC: Johan Hovold <johan@kernel.org>
>> Reported-and-tested-by: syzbot+7dbcd9ff34dc4ed45240@syzkaller.appspotmail.com
>> Reviewed-by: Johan Hovold <johan@kernel.org>
>> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
>> Link: https://lore.kernel.org/r/20210607152307.GD1768031@rowland.harvard.edu
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/usb/core/message.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
>> index 30e9e680c74c..4d59d927ae3e 100644
>> --- a/drivers/usb/core/message.c
>> +++ b/drivers/usb/core/message.c
>> @@ -783,6 +783,9 @@ int usb_get_descriptor(struct usb_device *dev, unsigned char type,
>>  	int i;
>>  	int result;
>>
>> +	if (size <= 0)		/* No point in asking for no data */
>> +		return -EINVAL;
>> +
>>  	memset(buf, 0, size);	/* Make sure we parse really received data */
>>
>>  	for (i = 0; i < 3; ++i) {
>> @@ -832,6 +835,9 @@ static int usb_get_string(struct usb_device *dev, unsigned short langid,
>>  	int i;
>>  	int result;
>>
>> +	if (size <= 0)		/* No point in asking for no data */
>> +		return -EINVAL;
>> +
>>  	for (i = 0; i < 3; ++i) {
>>  		/* retry on length 0 or stall; some devices are flakey */
>>  		result = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
>> --
>> 2.30.2
>>
>
>This patch should be dropped from all of the autosel branches it was
>picked to, as I do not think the USB core has been fixed up, along with
>all of the different drivers that we noticed doing this, in the stable
>trees.
>
>So please drop from everywhere at this time.

Will do, thanks!

-- 
Thanks,
Sasha
