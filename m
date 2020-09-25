Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A13B278E9E
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbgIYQcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:32:06 -0400
Received: from aibo.runbox.com ([91.220.196.211]:39406 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727733AbgIYQcG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 12:32:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject;
        bh=LfKcGhf2cACSxd2zObI/ozoleyZsnV0Tjc0U/dCvQLo=; b=J1UHe5sTsCAKJ5CAnanA5IYoin
        6GZMnzuYV4DHp38lSA+noHt6MpHNnrWefgR2ibHGqcytuM0H+Y4QVh9n/j4jbmaonQm3C0/QeYjOi
        WauVbh7l5mybn8xaFVaixL5aAUqQW7q+AeRKhh+rd5TCGxVT3LANgFEK0cONmcvHYustqIgZTv9p9
        bC0wipl4DnLRoP8I5+4wE7hr3qllLCuxd6VDwr/RfvNrlQek8QRgEdlpXZ0DPhzJCCEaqGmqiHRcn
        BzygJaTqFNoeATLn4xQrHF1isI4HEjMrMFuCUWlorwL7Ht3eSpGrRdtoSuUhoRsvLfDpAePJJx4Ee
        WRsA2NkQ==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1kLqdc-0000kb-8o; Fri, 25 Sep 2020 18:32:00 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated alias (536975)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1kLqdN-0000AF-US; Fri, 25 Sep 2020 18:31:46 +0200
Subject: Re: [PATCH v3 3/4] usbcore/driver: Fix incorrect downcast
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Bastien Nocera <hadess@hadess.net>,
        Shuah Khan <shuah@kernel.org>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        syzkaller@googlegroups.com
References: <20200922110703.720960-1-m.v.b@runbox.com>
 <20200922110703.720960-4-m.v.b@runbox.com>
 <20200925145118.GA3114228@kroah.com>
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
Message-ID: <40bf9432-d878-5c16-2dc1-3f03964a8057@runbox.com>
Date:   Fri, 25 Sep 2020 19:31:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.0
MIME-Version: 1.0
In-Reply-To: <20200925145118.GA3114228@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/25/20 5:51 PM, Greg Kroah-Hartman wrote:
> On Tue, Sep 22, 2020 at 02:07:02PM +0300, M. Vefa Bicakci wrote:
>> This commit resolves a minor bug in the selection/discovery of more
>> specific USB device drivers for devices that are currently bound to
>> generic USB device drivers.
>>
>> The bug is related to the way a candidate USB device driver is
>> compared against the generic USB device driver. The code in
>> is_dev_usb_generic_driver() assumes that the device driver in question
>> is a USB device driver by calling to_usb_device_driver(dev->driver)
>> to downcast; however I have observed that this assumption is not always
>> true, through code instrumentation.
>>
>> This commit avoids the incorrect downcast altogether by comparing
>> the USB device's driver (i.e., dev->driver) to the generic USB
>> device driver directly. This method was suggested by Alan Stern.
>>
>> This bug was found while investigating Andrey Konovalov's report
>> indicating usbip device driver misbehaviour with the recently merged
>> generic USB device driver selection feature. The report is linked
>> below.
>>
>> Fixes: d5643d2249 ("USB: Fix device driver race")
> 
> Nit, this should have been:
> 	Fixes: d5643d2249b2 ("USB: Fix device driver race")
> 
> I'll go fix it up as my scripts are rejecting it as-is...

Noted; sorry for missing this. I will use 12 characters from now on.

I also wanted to thank you for committing the patches.

Vefa
