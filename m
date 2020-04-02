Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4084219BB30
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 06:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgDBEr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 00:47:27 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:47327 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726617AbgDBEr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 00:47:27 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1585802846; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=59P6EAAUU6IHvsrVuS92TdywCF819skz/knlehoKg18=; b=LaRYKzbJ3u7V8aZ1cR0+wJRntXJG4tDv6stm3KpSB0XxTm+EzDx+nBw10YXSbwDN7C3HJZM+
 YC8nvMh41puyu/7eYFIKbYblEGx60n8xaVoFZTAK0+RDOUIqaDD6r6TYpCA+7/VZz7gYgQG5
 2rh77mAIYX91z0ivxbHowpFd0dw=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e856e50.7f4a188f43b0-smtp-out-n04;
 Thu, 02 Apr 2020 04:47:12 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8C6D5C44788; Thu,  2 Apr 2020 04:47:12 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [192.168.0.101] (unknown [192.140.155.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sallenki)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 94FF3C43637;
        Thu,  2 Apr 2020 04:47:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 94FF3C43637
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=sallenki@codeaurora.org
Subject: Re: [PATCH] usb: f_fs: Clear OS Extended descriptor counts to zero in
 ffs_data_reset()
To:     Manu Gautam <mgautam@codeaurora.org>, balbi@kernel.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        ugoswami@codeaurora.org
Cc:     jackp@codeaurora.org, stable@vger.kernel.org
References: <20200402043210.2342-1-sallenki@codeaurora.org>
 <1040af70-2298-df80-614d-a4d3cf6cca57@codeaurora.org>
From:   Sriharsha Allenki <sallenki@codeaurora.org>
Message-ID: <ad787648-6349-fd23-711e-be607e53b768@codeaurora.org>
Date:   Thu, 2 Apr 2020 10:17:07 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <1040af70-2298-df80-614d-a4d3cf6cca57@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,
On 4/2/2020 10:10 AM, Manu Gautam wrote:
> On 4/2/2020 10:02 AM, Sriharsha Allenki wrote:
>> From: Udipto Goswami <ugoswami@codeaurora.org>
>>
>> For userspace functions using OS Descriptors, if a function also supplies
>> Extended Property descriptors currently the counts and lengths stored in
>> the ms_os_descs_ext_prop_{count,name_len,data_len} variables are not
>> getting reset to 0 during an unbind or when the epfiles are closed. If
>> the same function is re-bound and the descriptors are re-written, this
>> results in those count/length variables to monotonically increase
>> causing the VLA allocation in _ffs_func_bind() to grow larger and larger
>> at each bind/unbind cycle and eventually fail to allocate.
>>
>> Fix this by clearing the ms_os_descs_ext_prop count & lengths to 0 in
>> ffs_data_reset().
>>
>> Change-Id: I3b292fe5386ab54b53df2b9f15f07430dc3df24a
> Please remove this.
Thanks Manu, sent v2 after removing it.
>> Fixes: f0175ab51993 ("usb: gadget: f_fs: OS descriptors support")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Udipto Goswami <ugoswami@codeaurora.org>
>> Signed-off-by: Sriharsha Allenki <sallenki@codeaurora.org>
>> ---
>>  drivers/usb/gadget/function/f_fs.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
>> index c81023b195c3..10f01f974f67 100644
>> --- a/drivers/usb/gadget/function/f_fs.c
>> +++ b/drivers/usb/gadget/function/f_fs.c
>> @@ -1813,6 +1813,10 @@ static void ffs_data_reset(struct ffs_data *ffs)
>>  	ffs->state = FFS_READ_DESCRIPTORS;
>>  	ffs->setup_state = FFS_NO_SETUP;
>>  	ffs->flags = 0;
>> +
>> +	ffs->ms_os_descs_ext_prop_count = 0;
>> +	ffs->ms_os_descs_ext_prop_name_len = 0;
>> +	ffs->ms_os_descs_ext_prop_data_len = 0;
>>  }
>>  
>>  
> Reviewed-by: Manu Gautam <mgautam@codeaurora.org>
Thanks,
Sriharsha
