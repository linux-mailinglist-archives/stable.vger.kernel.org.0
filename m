Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC5624250D
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 07:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgHLFrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 01:47:49 -0400
Received: from aibo.runbox.com ([91.220.196.211]:49772 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726430AbgHLFrt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Aug 2020 01:47:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:References:Cc:To:Subject:From;
        bh=wsrb6xDEoSQ6++8Jvlsfl6n6XGZ9DYMcpQfBMRBqS5U=; b=aRY7hqTA5IMUYvBJSCRlJnZzgL
        rGGaRgO+qQncaBMDAKGW9YUnr+cSvbFUdKSqk9ZLGPslurQtM+GQ4XBXlghFE3WZW/1rq0dxGamjw
        rvekx2te5RlPMj7EzGezxlrC3EHfAwG5BOW+eD39y0SFaBsITbBWLuJY/5INbyINvw24i66LjK4UT
        PKbQrYtlrY9Xqi22bVedAFlHQne7Tz2bI+hL4iDemSiVmg3rSzUkjD/ZmVq44vup2RrQcxkQrkeyj
        jt/zLiWNCidFK0HlPLLhko+oHRqDaazaTWlP6LROjcXSFT94BDhsBNPZkJ3PI4opjgQD1yZRY/zwv
        47Z9xiJQ==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1k5jbp-0002ip-UJ; Wed, 12 Aug 2020 07:47:34 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated alias (536975)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1k5jbg-00073V-9F; Wed, 12 Aug 2020 07:47:24 +0200
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
Subject: Re: [PATCH] usbip: Implement a match function to fix usbip
To:     Shuah Khan <skhan@linuxfoundation.org>,
        Bastien Nocera <hadess@hadess.net>, linux-usb@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Shuah Khan <shuah@kernel.org>
References: <20200810160017.46002-1-m.v.b@runbox.com>
 <6e450e16117afb9e1dd1e4270ef5c2e0d5885348.camel@hadess.net>
 <a7351706-9933-a3e1-4e7d-b7ab6f289938@linuxfoundation.org>
Message-ID: <99330f61-ed16-7e27-6852-d3486f331ef5@runbox.com>
Date:   Wed, 12 Aug 2020 08:47:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <a7351706-9933-a3e1-4e7d-b7ab6f289938@linuxfoundation.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/08/2020 22.09, Shuah Khan wrote:
> On 8/10/20 11:31 AM, Bastien Nocera wrote:
>> On Mon, 2020-08-10 at 19:00 +0300, M. Vefa Bicakci wrote:
>>> Commit 88b7381a939d ("USB: Select better matching USB drivers when
>>> available") introduced the use of a "match" function to select a
>>> non-generic/better driver for a particular USB device. This
>>> unfortunately breaks the operation of usbip in general, as reported
>>> in
>>> the kernel bugzilla with bug 208267 (linked below).
>>>
>>> Upon inspecting the aforementioned commit, one can observe that the
>>> original code in the usb_device_match function used to return 1
>>> unconditionally, but the aforementioned commit makes the
>>> usb_device_match
>>> function use identifier tables and "match" virtual functions, if
>>> either of
>>> them are available.
>>>
>>> Hence, this commit implements a match function for usbip that
>>> unconditionally returns true to ensure that usbip is functional
>>> again.
>>>
>>> This change has been verified to restore usbip functionality, with a
>>> v5.7.y kernel on an up-to-date version of Qubes OS 4.0, which uses
>>> usbip to redirect USB devices between VMs.
>>>
>>> Thanks to Jonathan Dieter for the effort in bisecting this issue down
>>> to the aforementioned commit.
>>
>> Looks correct. Thanks for root causing the problem.
>>
>> Reviewed-by: Bastien Nocera <hadess@hadess.net>
>>
> 
> Thank you for finding and fixing the problem.
> 
> Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

Hello Shuah and Bastien,

Thank you for reviewing the patch!

Just to confirm, should I re-publish this patch after having added your
Reviewed-by tags to the commit message? My current understanding is that
a re-spin of a patch is only necessary when changes are requested during
the code review. The development process documentation in the kernel
repository does not mention this aspect, but I might have missed it during
my quick search.

Thanks again,

Vefa
