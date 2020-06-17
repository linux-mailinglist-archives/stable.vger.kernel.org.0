Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48D11FCEB8
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 15:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgFQNnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 09:43:23 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:52202 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgFQNnW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 09:43:22 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1592401402; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=0rJg/220vt9zUyvHiVMMZNyLy4HIJD5Z/P1Mdz9z7JQ=; b=YNd1ALVPX6IUiAcOJNMCvW+0WR4DdMbLXS8przMQ19Gbh1SC7OCWEqqRLMITZvCW99aAJDW6
 2PerUqjswgy9Wnh9yFJu7XuGhHRgHARMPK+HSYyiWK2ZJ5cwV7yeUEBSCx+jt4aj5pZ05hBj
 5sa6zHVlU4EXyyEQyUpsoMj0Uok=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n13.prod.us-west-2.postgun.com with SMTP id
 5eea1df6e144dd511574ddfb (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 17 Jun 2020 13:43:18
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9BA25C4339C; Wed, 17 Jun 2020 13:43:18 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [192.168.1.102] (unknown [183.83.143.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: charante)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 625E8C433C8;
        Wed, 17 Jun 2020 13:43:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 625E8C433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=charante@codeaurora.org
Subject: Re: [PATCH] dmabuf: use spinlock to access dmabuf->name
To:     David Laight <David.Laight@ACULAB.COM>,
        "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Cc:     Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
        "vinmenon@codeaurora.org" <vinmenon@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <316a5cf9-ca71-6506-bf8b-e79ded9055b2@codeaurora.org>
 <14063C7AD467DE4B82DEDB5C278E8663010F365EF5@fmsmsx107.amr.corp.intel.com>
 <14063C7AD467DE4B82DEDB5C278E8663010F365F7D@fmsmsx107.amr.corp.intel.com>
 <5b960c9a-ef9d-b43d-716d-113efc793fe5@codeaurora.org>
 <b686a288cff640acaea1111fed650b02@AcuMS.aculab.com>
From:   Charan Teja Kalla <charante@codeaurora.org>
Message-ID: <dcf2bdd6-d6fd-96f0-c6e7-6788ea282e35@codeaurora.org>
Date:   Wed, 17 Jun 2020 19:13:12 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <b686a288cff640acaea1111fed650b02@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/17/2020 1:51 PM, David Laight wrote:
> From: Charan Teja Kalla
>> Sent: 17 June 2020 07:29
> ...
>>>> If name is freed you will copy garbage, but the only way
>>>> for that to happen is that _set_name or _release have to be called
>>>> at just the right time.
>>>>
>>>> And the above would probably only be an issue if the set_name
>>>> was called, so you will get NULL or a real name.
>>
>> And there exists a use-after-free to avoid which requires the lock. Say
>> that memcpy() in dmabuffs_dname is in progress and in parallel _set_name
>> will free the same buffer that memcpy is operating on.
> 
> If the name is being looked at while the item is being freed
> you almost certainly have much bigger problems that just
> the name being a 'junk' pointer.

True, thus needs the lock.

> 
> 	David.
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum, a Linux Foundation Collaborative Project
