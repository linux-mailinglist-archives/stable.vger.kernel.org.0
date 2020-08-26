Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F38253000
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 15:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730335AbgHZNcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 09:32:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730289AbgHZNcl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 09:32:41 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 656F2208E4;
        Wed, 26 Aug 2020 13:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598448760;
        bh=b1nmyfPK5FQ7cjqNh+7j1qIyG/iexxlz9aw19IXSc24=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tL+y8cFx68cVj/yVRenvmIZEEKy9hGzoiqxQdyuSQZ+isFRgrSnJXt0VWCkLRp8iR
         ZHAsWilvx7FAxEBcpf2aXVgBsK+TolYL3TYHW44mW4q8bkqk/V6OAtFJBNzh/gEFeW
         0lucH461F4WvGvITYPOsZwVziOE4hG8PHrScxR88=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kAvXa-006rI6-9y; Wed, 26 Aug 2020 14:32:38 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 26 Aug 2020 14:32:38 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] Input; Sanitize event code before modifying bitmaps
In-Reply-To: <20200824195102.GY1665100@dtor-ws>
References: <20200817112700.468743-1-maz@kernel.org>
 <20200817112700.468743-2-maz@kernel.org> <20200824195102.GY1665100@dtor-ws>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <bcf65dce766d0376027e80bf205b095d@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: dmitry.torokhov@gmail.com, jikos@kernel.org, benjamin.tissoires@redhat.com, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Dmitry,

On 2020-08-24 20:51, Dmitry Torokhov wrote:
> Hi Marc,
> 
> On Mon, Aug 17, 2020 at 12:26:59PM +0100, Marc Zyngier wrote:
>> When calling into input_set_capability(), the passed event code is
>> blindly used to set a bit in a number of bitmaps, without checking
>> whether this actually fits the expected size of the bitmap.
>> 
>> This event code can come from a variety of sources, including devices
>> masquerading as input devices, only a bit more "programmable".
>> 
>> Instead of taking the raw event code, sanitize it to the actual bitmap
>> size and output a warning to let the user know.
>> 
>> These checks are, at least in spirit, in keeping with cb222aed03d7
>> ("Input: add safety guards to input_set_keycode()").
>> 
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  drivers/input/input.c | 16 +++++++++++++++-
>>  1 file changed, 15 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/input/input.c b/drivers/input/input.c
>> index 3cfd2c18eebd..1e77cf47aa44 100644
>> --- a/drivers/input/input.c
>> +++ b/drivers/input/input.c
>> @@ -1974,14 +1974,18 @@ EXPORT_SYMBOL(input_get_timestamp);
>>   * In addition to setting up corresponding bit in appropriate 
>> capability
>>   * bitmap the function also adjusts dev->evbit.
>>   */
>> -void input_set_capability(struct input_dev *dev, unsigned int type, 
>> unsigned int code)
>> +void input_set_capability(struct input_dev *dev, unsigned int type, 
>> unsigned int raw_code)
>>  {
>> +	unsigned int code = raw_code;
>> +
>>  	switch (type) {
>>  	case EV_KEY:
>> +		code &= KEY_MAX;
>>  		__set_bit(code, dev->keybit);
> 
> 
> I would much rather prefer we did not simply set some random bits in
> this case, but instead complained loudly and refused to alter anything.
> 
> The function is not exported directly to userspace, so we expect 
> callers
> to give us sane inputs, and I believe WARN() splash in case of bad
> inputs would be the best solution here.

Fair enough. I've moved the checking to the HID layer (using
hid_map_usage() as the validation primitive), which makes
changing input_set_capability() irrelevant.

I'll post v2 shortly in the form of a single patch.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
