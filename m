Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3754C6946D9
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 14:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjBMNWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 08:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbjBMNWJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 08:22:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 308141A673
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 05:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676294490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=65vM63lCBcwwtvqyvQJB4Hp4/XOpXjbqPy1l0v1Y41c=;
        b=DNwGfqPl0vUUQc1Jdj5Kywoxx+QXPRFi8jgSxPwPPQ2UPzu2X4xk0j09RAsnVFV15ZAY3F
        yBZZrbUqma0E+1K7HtYJzGQtZaku6WoGSkpXK01bGmQQgHQmmBLImTTr6/JU8vE4Sr5ypo
        nL9GxcXGpKP9dC8CYORq2F9fhuts7SY=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-329-EGyhiO0tPQeLGiV42-kNnA-1; Mon, 13 Feb 2023 08:21:29 -0500
X-MC-Unique: EGyhiO0tPQeLGiV42-kNnA-1
Received: by mail-pl1-f200.google.com with SMTP id k14-20020a170902ce0e00b001992e19d3beso7300720plg.5
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 05:21:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=65vM63lCBcwwtvqyvQJB4Hp4/XOpXjbqPy1l0v1Y41c=;
        b=H85k0rBw8IOlVQ8PHRmGYjDlSGW//FFQ1hnXraXyct1eeBKuBxzesM8NfhqxzbhwqK
         u5eNmsTrtXa3+lKp6rRAWX7v/9zeI1QJXtE464+PB2AxZimEskjNJpOvapb9QnF3TdwU
         XwInB3TFTTroIUfSYJAvSP0HJ47jxb9JAevlBydbw1O5TtBnMxS0dzlIHGE3QkSi2ewc
         3Q4LPJncp7UYG1MauaMMla8oRIEeDfbTdhHp7vZ++v8i0z7zY5vfcrNFcXucOI+wXtCU
         fTAvBhl/uTIY3eby1YwbnXrc7maT9dVX2Gf9tHcC9OLlfjawsiZVWSqXFQtgsUXAFAlj
         rtzQ==
X-Gm-Message-State: AO0yUKU/Mea9C+A7SBoXslx0onuZFZlrV/6V8w3zB/dF4/emq26x7zDu
        eCF/y2ypcBOC5S7wDsGPnEQI/+TcDINjSgNI39ukx0mI3sn3Y6id4Xw+h9AzlNw3/oqn57FNdsb
        0GnQgaelFEZcTw2Of
X-Received: by 2002:a17:902:ce83:b0:193:38ce:7bb8 with SMTP id f3-20020a170902ce8300b0019338ce7bb8mr29574660plg.37.1676294487853;
        Mon, 13 Feb 2023 05:21:27 -0800 (PST)
X-Google-Smtp-Source: AK7set+CORiANb5b65jMqxT74Ajb8vATVgklpmnL7Uqt/65WgENCsfuvSm2KUNr++8mlcl2HRrt9eA==
X-Received: by 2002:a17:902:ce83:b0:193:38ce:7bb8 with SMTP id f3-20020a170902ce8300b0019338ce7bb8mr29574643plg.37.1676294487584;
        Mon, 13 Feb 2023 05:21:27 -0800 (PST)
Received: from [10.72.13.220] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id jg2-20020a17090326c200b001946a3f4d9csm5511466plb.38.2023.02.13.05.21.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 05:21:27 -0800 (PST)
Message-ID: <9741848e-4fa6-9c70-8189-4b8614389501@redhat.com>
Date:   Mon, 13 Feb 2023 21:21:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] ceph: update the time stamps and try to drop the
 suid/sgid
Content-Language: en-US
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        Ceph Development <ceph-devel@vger.kernel.org>
Cc:     vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
References: <20230213111038.15021-1-xiubli@redhat.com>
 <732e55f69d06c4e0de3c5c7eee10f254253391f6.camel@kernel.org>
 <0700f314-63fa-9324-94d2-5815daca2734@redhat.com>
 <3225027aae8a868ae8b57441c28047710c5356e4.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <3225027aae8a868ae8b57441c28047710c5356e4.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 13/02/2023 21:09, Jeff Layton wrote:
> On Mon, 2023-02-13 at 20:59 +0800, Xiubo Li wrote:
>> On 13/02/2023 20:37, Jeff Layton wrote:
>>> On Mon, 2023-02-13 at 19:10 +0800, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> The fallocate will try to clear the suid/sgid if a unprevileged user
>>>> changed the file.
>>>>
>>>> There is no Posix item requires that we should clear the suid/sgid
>>>> in fallocate code path but this is the default behaviour for most of
>>>> the filesystems and the VFS layer. And also the same for the write
>>>> code path, which have already support it.
>>>>
>>> Huh, you're right. It really doesn't say anything about the timestamps
>>> or setuid bits:
>>>
>>>       https://pubs.opengroup.org/onlinepubs/9699919799/functions/posix_fallocate.html
>>>
>>>
>>> That's arguably a bug in the spec. It really does need to do those
>>> things.
>> Yeah.
>>
> Actually, posix_fallocate doesn't do hole punching. It just ensures that
> blocks are reserved to back future writes. Given that that's not
> something "observable" and won't change the contents of the file, then
> there really is no need to change the times and clear set{u,g}id bits
> there.
>
> Linux' fallocate is different. It's a GNU API not covered by POSIX, and
> can result in an observable change to the contents of the file. There,
> we _must_ clear the setuid/setgid bits and update timestamps, at least
> in the cases where the content can change.
>
Okay, get it.

Thank you Jeff for detailed explaining about this.

- Xiubo


>> Also the kernel fuse code and libfuse also need to be improved to make
>> ceph-fuse work.
>>
>> Thanks Jeff.
>>
>> - Xiubo
>>
>>>> And also we need to update the time stamps since the fallocate will
>>>> change the file contents.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> URL: https://tracker.ceph.com/issues/58054
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/file.c | 8 ++++++++
>>>>    1 file changed, 8 insertions(+)
>>>>
>>>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>>>> index 903de296f0d3..dee3b445f415 100644
>>>> --- a/fs/ceph/file.c
>>>> +++ b/fs/ceph/file.c
>>>> @@ -2502,6 +2502,9 @@ static long ceph_fallocate(struct file *file, int mode,
>>>>    	loff_t endoff = 0;
>>>>    	loff_t size;
>>>>    
>>>> +	dout("%s %p %llx.%llx mode %x, offset %llu length %llu\n", __func__,
>>>> +	     inode, ceph_vinop(inode), mode, offset, length);
>>>> +
>>>>    	if (mode != (FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
>>>>    		return -EOPNOTSUPP;
>>>>    
>>>> @@ -2539,6 +2542,10 @@ static long ceph_fallocate(struct file *file, int mode,
>>>>    	if (ret < 0)
>>>>    		goto unlock;
>>>>    
>>>> +	ret = file_modified(file);
>>>> +	if (ret)
>>>> +		goto put_caps;
>>>> +
>>>>    	filemap_invalidate_lock(inode->i_mapping);
>>>>    	ceph_fscache_invalidate(inode, false);
>>>>    	ceph_zero_pagecache_range(inode, offset, length);
>>>> @@ -2554,6 +2561,7 @@ static long ceph_fallocate(struct file *file, int mode,
>>>>    	}
>>>>    	filemap_invalidate_unlock(inode->i_mapping);
>>>>    
>>>> +put_caps:
>>>>    	ceph_put_cap_refs(ci, got);
>>>>    unlock:
>>>>    	inode_unlock(inode);
>>> Reviewed-by: Jeff Layton <jlayton@kernel.org>
>>>
-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li

