Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBAD431F6E
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbhJRO0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbhJRO0N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 10:26:13 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF01FC06161C;
        Mon, 18 Oct 2021 07:24:01 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrewsh)
        with ESMTPSA id 6F0D71F42D2D
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrewsh)
        with ESMTPSA id 3D42D1F42B99
Message-ID: <z-9040e3ff-4fb2-97ba-3830-d32586385bf6@collabora.co.uk>
Date:   Mon, 18 Oct 2021 16:17:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH v2 1/2] HID: u2fzero: explicitly check for errors
Content-Language: en-GB
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     =?UTF-8?B?SmnFmcOtIEtvc2luYQ==?= <jikos@kernel.org>,
        linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        stable@vger.kernel.org, kernel@collabora.com
References: <20211018122144.25131-1-andrew.shadura@collabora.co.uk>
 <20211018141527.GA1048431@rowland.harvard.edu>
From:   Andrej Shadura <andrew.shadura@collabora.co.uk>
Organization: Collabora
In-Reply-To: <20211018141527.GA1048431@rowland.harvard.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/10/2021 16:15, Alan Stern wrote:
> On Mon, Oct 18, 2021 at 02:21:43PM +0200, Andrej Shadura wrote:
>> The previous commit fixed handling of incomplete packets but broke error
>> handling: offsetof returns an unsigned value (size_t), but when compared
>> against the signed return value, the return value is interpreted as if
>> it were unsigned, so negative return values are never less than the
>> offset.
>>
>> Fixes: 22d65765f211 ("HID: u2fzero: ignore incomplete packets without data")
>> Fixes: 42337b9d4d95 ("HID: add driver for U2F Zero built-in LED and RNG")
>> Signed-off-by: Andrej Shadura <andrew.shadura@collabora.co.uk>
>> ---
>>   drivers/hid/hid-u2fzero.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/hid/hid-u2fzero.c b/drivers/hid/hid-u2fzero.c
>> index d70cd3d7f583..5145d758bea0 100644
>> --- a/drivers/hid/hid-u2fzero.c
>> +++ b/drivers/hid/hid-u2fzero.c
>> @@ -200,7 +200,7 @@ static int u2fzero_rng_read(struct hwrng *rng, void *data,
>>   	ret = u2fzero_recv(dev, &req, &resp);
>>   
>>   	/* ignore errors or packets without data */
>> -	if (ret < offsetof(struct u2f_hid_msg, init.data))
>> +	if (ret < 0 || ret < offsetof(struct u2f_hid_msg, init.data))
> 
> Although the patch description does a good job of explaining what's
> happening, someone merely reading the code will most likely not
> understand.
> 
> One alternative is to add a comment.  Another is simply to force a
> signed integer comparison:
> 
> 	if (ret < (ssize_t) offsetof(...

I have considered that, but I thought that is actually less readable 
than having two conditions. I’m curious that you say "ignore errors or 
packets without data" is not clear enough — how would you reword that 
without inflating it too much?

-- 
Cheers,
   Andrej
