Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3541F15FAB2
	for <lists+stable@lfdr.de>; Sat, 15 Feb 2020 00:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbgBNXgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 18:36:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:58560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727529AbgBNXgx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 18:36:53 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 072F620848;
        Fri, 14 Feb 2020 23:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581723412;
        bh=CQufoR7vHijqQ6Q1/0cEdB0Ync1D9nO2IZkeI2H75Sc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yrgmy2q8EpweD7RUkFgiP8HX+Qp1QWR8CzgtZf5aGrXo1Vdar0+Idl9I1sraSBoWV
         tjuBzFH0WwkRBq9QqLyUV8ngZhQxffr3nY1hqpgeQkh0SaQGwFw2dOqFmGxC2B2efv
         OXZZdEqJhCLqWa3xB2PDpmEw8YE3nz1+/r0FUj+8=
Date:   Fri, 14 Feb 2020 18:36:50 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH AUTOSEL 4.4 080/100] char: hpet: Use flexible-array member
Message-ID: <20200214233650.GF1734@sasha-vm>
References: <20200214162425.21071-1-sashal@kernel.org>
 <20200214162425.21071-80-sashal@kernel.org>
 <20200214174314.GA250980@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200214174314.GA250980@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 09:43:14AM -0800, Eric Biggers wrote:
>On Fri, Feb 14, 2020 at 11:24:04AM -0500, Sasha Levin wrote:
>> From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
>>
>> [ Upstream commit 987f028b8637cfa7658aa456ae73f8f21a7a7f6f ]
>>
>> Old code in the kernel uses 1-byte and 0-byte arrays to indicate the
>> presence of a "variable length array":
>>
>> struct something {
>>     int length;
>>     u8 data[1];
>> };
>>
>> struct something *instance;
>>
>> instance = kmalloc(sizeof(*instance) + size, GFP_KERNEL);
>> instance->length = size;
>> memcpy(instance->data, source, size);
>>
>> There is also 0-byte arrays. Both cases pose confusion for things like
>> sizeof(), CONFIG_FORTIFY_SOURCE, etc.[1] Instead, the preferred mechanism
>> to declare variable-length types such as the one above is a flexible array
>> member[2] which need to be the last member of a structure and empty-sized:
>>
>> struct something {
>>         int stuff;
>>         u8 data[];
>> };
>>
>> Also, by making use of the mechanism above, we will get a compiler warning
>> in case the flexible array does not occur last in the structure, which
>> will help us prevent some kind of undefined behavior bugs from being
>> unadvertenly introduced[3] to the codebase from now on.
>>
>> [1] https://github.com/KSPP/linux/issues/21
>> [2] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
>> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> Link: https://lore.kernel.org/r/20200120235326.GA29231@embeddedor.com
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/char/hpet.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
>> index 5b38d7a8202a1..38c2ae93ce492 100644
>> --- a/drivers/char/hpet.c
>> +++ b/drivers/char/hpet.c
>> @@ -112,7 +112,7 @@ struct hpets {
>>  	unsigned long hp_delta;
>>  	unsigned int hp_ntimer;
>>  	unsigned int hp_which;
>> -	struct hpet_dev hp_dev[1];
>> +	struct hpet_dev hp_dev[];
>>  };
>>
>
>Umm, why are you backporting this without the commit that fixes it?  Does your

mhm, for some reason it failed to apply to 4.19 and older. I can look at
that.

>AUTOSEL process really still not pay attention to Fixes tags?  They are there
>for a reason.

Yes, it looks at the Fixes tag, thank you for the explanation.

>And for that matter, why are you backporting it all, given that this is a
>cleanup and not a fix?

If I recall correctly CONFIG_FORTIFY_SOURCE=y results in user visible
warnings, which we try to fix in the stable kernel.

-- 
Thanks,
Sasha
