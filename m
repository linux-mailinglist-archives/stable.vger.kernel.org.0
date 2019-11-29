Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8B810D823
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 16:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfK2P4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 10:56:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56927 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727004AbfK2P4r (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 10:56:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575043005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=djhg4BuIO+PiyYCw/WWgSBGEwGxGvzdmktY+j79qkjw=;
        b=ZOscrZGNBOrI2BXqFY7g6NKGaA1bGiowkaKLhRmA+cuvWypo5YpspQiQA9TNOshEDvWhds
        aO/EMV7VAfIwEQBPje0FUF3TKZqjKiq1O8fBqVyGByR7zilCBKyFQhopx0ktExeCmgcMC9
        RWF+jmigbVjnJSykiaBcH5D2ETguy3Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-ZXkoMX_jNue7Mwnb9Tq-fw-1; Fri, 29 Nov 2019 10:56:43 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 784DC107ACC4;
        Fri, 29 Nov 2019 15:56:42 +0000 (UTC)
Received: from [10.33.36.147] (unknown [10.33.36.147])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 29E1E600C8;
        Fri, 29 Nov 2019 15:56:40 +0000 (UTC)
Subject: Re: [PATCH 02/12] fs_parse: fix fs_param_v_optional handling
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        stable <stable@vger.kernel.org>
References: <20191128155940.17530-1-mszeredi@redhat.com>
 <20191128155940.17530-3-mszeredi@redhat.com>
 <8694f75f-e947-d369-6be3-b08287c381e9@redhat.com>
 <CAOssrKccHtfwg4SYbQRwoaz_WcWJWNM3JXk7BHv=SPpsKOdkuQ@mail.gmail.com>
From:   Andrew Price <anprice@redhat.com>
Message-ID: <74a0ccaa-4235-6c68-0f6f-a8954a827e06@redhat.com>
Date:   Fri, 29 Nov 2019 15:56:39 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CAOssrKccHtfwg4SYbQRwoaz_WcWJWNM3JXk7BHv=SPpsKOdkuQ@mail.gmail.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: ZXkoMX_jNue7Mwnb9Tq-fw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29/11/2019 14:43, Miklos Szeredi wrote:
> On Fri, Nov 29, 2019 at 12:31 PM Andrew Price <anprice@redhat.com> wrote:
>>
>> On 28/11/2019 15:59, Miklos Szeredi wrote:
>>> String options always have parameters, hence the check for optional
>>> parameter will never trigger.
>>>
>>> Check for param type being a flag first (flag is the only type that does
>>> not have a parameter) and report "Missing value" if the parameter is
>>> mandatory.
>>>
>>> Tested with gfs2's "quota" option, which is currently the only user of
>>> fs_param_v_optional.
>>
>> It's not clear to me what the bug is here. My tests with the quota
>> option are giving expected results. Perhaps I missed a case?
> 
> fsopen-test-2: fsconfig(3, FSCONFIG_SET_FLAG, "quota", NULL, 0):
> Invalid argument
> fsopen-test-2: context log: <e gfs2: Bad value for 'quota'>
> 
> kernel: 5.4.0-08836-g81b6b96475ac

Ah right, gotcha. My tests were relying on the same codepaths being used 
from the legacy/monolithic parsing code.

Reviewed-by: Andrew Price <anprice@redhat.com>

Andy

