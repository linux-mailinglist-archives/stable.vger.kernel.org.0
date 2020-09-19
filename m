Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B79270E38
	for <lists+stable@lfdr.de>; Sat, 19 Sep 2020 15:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgISNxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Sep 2020 09:53:11 -0400
Received: from aibo.runbox.com ([91.220.196.211]:46090 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbgISNxL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Sep 2020 09:53:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:References:Cc:To:Subject:From;
        bh=x4PvldqpBh6r5oG1qvZNgwCA+P5SnAhYQfcqcPXTvb0=; b=ODqOnMPPHj2lewdreRBtovUFB4
        /bj0uxyny/sbG5NruPIuFgfYGERTUPpcBpk1dEvIpqzWhwPROTNvkMG7Yd3BuTr7p2qKEcu9g8+M0
        HVHa8JHLb3QUtOlYqQ3RJbSaZ4+CgTUDAsV/km4S9pX0YYt/BmSpEfun+mwEPiNV2JnkqcJb6k3iM
        4oGxuvYQ7nUV5+bT0y8+YFodCFS+2Jl6NQ8dqr9WoOAFaFAcNuU4oA9iNpwCc7Yuvq8VHMjVzW0dN
        bojm1QYc3sK5n+ocGVqMsOEvBYzRfq9pA5xcFBpwglmJ7LlKozwe0CEb8mlJCy5AlDdMSqVOXqxI4
        rrAJOOzg==;
Received: from [10.9.9.74] (helo=submission03.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1kJdIY-0006kP-Mu; Sat, 19 Sep 2020 15:53:06 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated alias (536975)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1kJdIJ-0000zW-PL; Sat, 19 Sep 2020 15:52:51 +0200
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
Subject: Re: [PATCH 1/3] usbcore/driver: Fix specific driver selection
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     linux-usb@vger.kernel.org,
        Andrey Konovalov <andreyknvl@google.com>,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bastien Nocera <hadess@hadess.net>, syzkaller@googlegroups.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <a6e14983a8849d5f75a43f403c7cc721b6e4a420.camel@hadess.net>
 <20200917144151.355848-1-m.v.b@runbox.com>
 <363eab9a-c32a-4c60-4d6b-14ae8d873c52@runbox.com>
 <20200918145231.GA1130146@rowland.harvard.edu>
Message-ID: <50d2232f-cb08-5881-828d-cb9e465d5d05@runbox.com>
Date:   Sat, 19 Sep 2020 16:52:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200918145231.GA1130146@rowland.harvard.edu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/09/2020 17.52, Alan Stern wrote:
> On Fri, Sep 18, 2020 at 05:31:26PM +0300, M. Vefa Bicakci wrote:
>> Hello all,
>>
>> I noticed that applying this patch on its own to the kernel causes the following
>> unexpected behaviour: As soon as the usbip_host module is loaded, all of the
>> USB devices are re-probed() by their drivers, and this causes the USB devices
>> connected to my system to be momentarily unavailable. This happens because
>> *without* the third patch in this patch set, the match function for the usbip_host
>> device driver unconditionally returns true.
>>
>> The third patch in this patch set [1] makes this unexpected behaviour go
>> away, as it makes the usbip device driver's match function only match devices
>> that were requested by user-space to be used with USB-IP.
>>
>> Is this something to be concerned about? I was thinking of people who might be
>> using git-bisect, who might encounter this issue in an unexpected manner.
>>
>> As a potential solution, I can prepare another patch to revert commit
>> 7a2f2974f2 ("usbip: Implement a match function to fix usbip") so that this
>> unexpected behaviour will not be observed. This revert would be placed as
>> the first patch in the patch series.
> 
> Yes, that sounds like a good solution.
> 
> Alan Stern

Thanks for the feedback, Alan!

Given Shuah's answer to my other question, it looks like there is a need for
further work.

Vefa
