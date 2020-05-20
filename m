Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9AD1DB3EE
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 14:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgETMoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 08:44:08 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:35072 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727024AbgETMoI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 08:44:08 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1589978647; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=nLaK/ohEQ1OzRdH5EY+kSAjwbEK+2E1W0vY/2r749BI=;
 b=MKnmHRhpYVFnCfaTJXkyVzzmiByiQkb6QeYCj9873YxAaFJ/OPX9cHzKJ8flkElaY4M/QQPr
 XFmLmKuKyamj20SWTnM0kZJxP4xrUFos1WOzeA42Y/A+NTrJCGNAmQtHhUOBkfyM7+rhDt6A
 uUiBPGg+xmxfw3hjtFSsq+9aXvU=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5ec526044c3faf51e2931686 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 20 May 2020 12:43:48
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 83CE0C433A0; Wed, 20 May 2020 12:43:47 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: rananta)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B5A10C433C8;
        Wed, 20 May 2020 12:43:46 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 20 May 2020 05:43:46 -0700
From:   rananta@codeaurora.org
To:     Jiri Slaby <jslaby@suse.cz>
Cc:     gregkh@linuxfoundation.org, andrew@daynix.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] tty: hvc: Fix data abort due to race in hvc_open
In-Reply-To: <f84a9da7-bb0f-7538-fa00-968c9625335b@suse.cz>
References: <20200520064708.24278-1-rananta@codeaurora.org>
 <f84a9da7-bb0f-7538-fa00-968c9625335b@suse.cz>
Message-ID: <5895803be5c8fd4c5e7725b57ffe79e4@codeaurora.org>
X-Sender: rananta@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-05-20 01:59, Jiri Slaby wrote:
> On 20. 05. 20, 8:47, Raghavendra Rao Ananta wrote:
>> Potentially, hvc_open() can be called in parallel when two tasks calls
>> open() on /dev/hvcX. In such a scenario, if the 
>> hp->ops->notifier_add()
>> callback in the function fails, where it sets the tty->driver_data to
>> NULL, the parallel hvc_open() can see this NULL and cause a memory 
>> abort.
>> Hence, do a NULL check at the beginning, before proceeding ahead.
>> 
>> The issue can be easily reproduced by launching two tasks 
>> simultaneously
>> that does an open() call on /dev/hvcX.
>> For example:
>> $ cat /dev/hvc0 & cat /dev/hvc0 &
>> 
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Raghavendra Rao Ananta <rananta@codeaurora.org>
>> ---
>>  drivers/tty/hvc/hvc_console.c | 3 +++
>>  1 file changed, 3 insertions(+)
>> 
>> diff --git a/drivers/tty/hvc/hvc_console.c 
>> b/drivers/tty/hvc/hvc_console.c
>> index 436cc51c92c3..80709f754cc8 100644
>> --- a/drivers/tty/hvc/hvc_console.c
>> +++ b/drivers/tty/hvc/hvc_console.c
>> @@ -350,6 +350,9 @@ static int hvc_open(struct tty_struct *tty, struct 
>> file * filp)
>>  	unsigned long flags;
>>  	int rc = 0;
>> 
>> +	if (!hp)
>> +		return -ENODEV;
>> +
> 
> This is still not fixing the bug properly. See:
> https://lore.kernel.org/linuxppc-dev/0f7791f5-0a53-59f6-7277-247a789f30c2@suse.cz/
> 
> In particular, the paragraph starting "IOW".
> 
You are right. This doesn't fix the problem entirely. There are other 
parts to it which is
not handled in a clean way by the driver. Apart from the things you've 
mentioned, it doesn't
seem to handle the hp->port.count correctly as well.

hvc_open:
   hp->port.count++
   hp->ops->notifier_add(hp, hp->data) fails
   tty->driver_data = NULL

hvc_close:
   returns immediately as tty->driver_data == NULL, without 
hp->port.count--

This would leave the port in a stale state, and the second caller of 
hvc_open doesn't get
a chance to call/retry hp->ops->notifier_add(hp, hp->data);

However, the patch is not trying to address the logical issues with 
hvc_open and hvc_close.
It's only trying to eliminate the potential NULL pointer dereference, 
leading to a panic.
 From what I see, the hvc_open is serialized by tty_lock, and adding a 
NULL check here is
preventing the second caller.
> thanks,

Thank you.
Raghavendra
