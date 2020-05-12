Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 380411CEBE6
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 06:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgELEYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 00:24:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:50014 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgELEYW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 May 2020 00:24:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A3E99AEDF;
        Tue, 12 May 2020 04:24:23 +0000 (UTC)
Subject: Re: [PATCH] xen/pvcalls-back: test for errors when calling
 backend_connect()
To:     Stefano Stabellini <sstabellini@kernel.org>
Cc:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        stable@vger.kernel.org
References: <20200511074231.19794-1-jgross@suse.com>
 <alpine.DEB.2.21.2005111440210.26167@sstabellini-ThinkPad-T480s>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <17512c98-b309-7b83-8c9c-cc8d43a495a2@suse.com>
Date:   Tue, 12 May 2020 06:24:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.2005111440210.26167@sstabellini-ThinkPad-T480s>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11.05.20 23:41, Stefano Stabellini wrote:
> On Mon, 11 May 2020, Juergen Gross wrote:
>> backend_connect() can fail, so switch the device to connected only if
>> no error occurred.
>>
>> Fixes: 0a9c75c2c7258f2 ("xen/pvcalls: xenbus state handling")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Juergen Gross <jgross@suse.com>
> 
> Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
> 
> 
>> ---
>>   drivers/xen/pvcalls-back.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/xen/pvcalls-back.c b/drivers/xen/pvcalls-back.c
>> index cf4ce3e9358d..41a18ece029a 100644
>> --- a/drivers/xen/pvcalls-back.c
>> +++ b/drivers/xen/pvcalls-back.c
>> @@ -1088,7 +1088,8 @@ static void set_backend_state(struct xenbus_device *dev,
>>   		case XenbusStateInitialised:
>>   			switch (state) {
>>   			case XenbusStateConnected:
>> -				backend_connect(dev);
>> +				if (backend_connect(dev))
>> +					return;
> 
> Do you think it would make sense to WARN?

There already should be an error message (either due to a failed
grant mapping or a failed memory allocation).


Juergen
