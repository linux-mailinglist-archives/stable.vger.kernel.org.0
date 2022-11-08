Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1AF1620792
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 04:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbiKHDgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 22:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbiKHDgV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 22:36:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4C7B71
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 19:35:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667878524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yNarhJeT6YdXHNKcFdUkb4AIgII3HIYgN+PG9QXlJDQ=;
        b=TG0jFcLO5kqLqpQIp0muhxKxOJhUuLvotEwEvz/6rXqIzjMXhh+3hYnnbKFliLaBdh/vWG
        wL1nbqy7xx+/pq8F6P0NH7PBgo9A38htLJFLnMGPtRjS+bSOAOo63kddPeh94pa3UDjbnL
        owSFiq4jrphZWhtSlQranx00AiAdLyM=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-635-G7rs2GcRPTS72nCyFtKLZA-1; Mon, 07 Nov 2022 22:35:23 -0500
X-MC-Unique: G7rs2GcRPTS72nCyFtKLZA-1
Received: by mail-pg1-f200.google.com with SMTP id l63-20020a639142000000b0046f5bbb7372so7290631pge.23
        for <stable@vger.kernel.org>; Mon, 07 Nov 2022 19:35:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yNarhJeT6YdXHNKcFdUkb4AIgII3HIYgN+PG9QXlJDQ=;
        b=KgS7hOPpwQVVau4gp2RnsoMXhbSAscKjlD4rgKDQkh/FKodWiUPtms0F+F6O28zVSp
         6/5YGe0kMMaraUj9ZRfolXzeS6CAzx5HxHeI3GQus+Rii33PM54SuK/j93IYQu4euWfG
         XNJqUuyMVYt0biLHGoSYW1VRXF+xXntLQRwrrCRSDINkraR/nmA7DOcx8DES9TR8hguE
         hmnS1VPsrLWHiCkfUZ/K6d4eIypfsg+8qqV+i73s8aYiUuzksFYzRzxU7z8nIsoZ5wfI
         IAZBI090a6cIWhkycljRWqhyl/8s4fJ/TH/PTfpCj3OypdP/OcxhBPo2iKYY7Tsg22Bq
         b3tg==
X-Gm-Message-State: ACrzQf0COdItN13Ehqz1pT/iZimzQAA6Vebg7pv268+7KXEGFb8K/if0
        geid4lTq5rIZReupoSBBvsrZQ4s9UOzS1PZGEBlB7V0tyUq1Wk1MFsLYQk4qEOCoCvJlK5j9Ap9
        Bp0PW09jkM/Fd4/I9oE4U7rbvQWlqnGy7y+ekGv/yy694YryBg1rIl62fw9Y2Kh7vZw==
X-Received: by 2002:a17:90a:f507:b0:211:e623:da5b with SMTP id cs7-20020a17090af50700b00211e623da5bmr73561355pjb.37.1667878521990;
        Mon, 07 Nov 2022 19:35:21 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5oaruYoonZHMXaJcBPq6uOgnyLDshiZYvCyWJywrvwu1uUKqbKNpnxiNpctHgLar7r9qNg3g==
X-Received: by 2002:a17:90a:f507:b0:211:e623:da5b with SMTP id cs7-20020a17090af50700b00211e623da5bmr73561330pjb.37.1667878521650;
        Mon, 07 Nov 2022 19:35:21 -0800 (PST)
Received: from [10.72.12.88] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w7-20020a170902e88700b00187197c4999sm5752587plg.167.2022.11.07.19.35.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 19:35:21 -0800 (PST)
Subject: Re: [PATCH] ceph: fix NULL pointer dereference for req->r_session
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, lhenriques@suse.de, jlayton@kernel.org,
        mchangir@redhat.com, stable@vger.kernel.org
References: <20221027091155.334178-1-xiubli@redhat.com>
 <CAOi1vP9g1PkeOoxNwGBZ3QX=Hx+YxpCXDw28roiTmq8P2uHQtw@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <32b14817-9011-d1a6-0029-b5a4005814b7@redhat.com>
Date:   Tue, 8 Nov 2022 11:35:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP9g1PkeOoxNwGBZ3QX=Hx+YxpCXDw28roiTmq8P2uHQtw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 07/11/2022 22:55, Ilya Dryomov wrote:
> On Thu, Oct 27, 2022 at 11:12 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The request's r_session maybe changed when it was forwarded or
>> resent.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/caps.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 894adfb4a092..d34ac716d7fe 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -2341,6 +2341,7 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>                          goto out;
>>                  }
>>
>> +               mutex_lock(&mdsc->mutex);
> Hi Xiubo,
>
> A few lines above, there is the following comment:
>
>          /*
>           * The mdsc->max_sessions is unlikely to be changed
>           * mostly, here we will retry it by reallocating the
>           * sessions array memory to get rid of the mdsc->mutex
>           * lock.
>           */
>
> Does retry label and gotos still make sense if mdsc->mutex is
> introduced?  Would it make sense to move it up and get rid of
> retry code?

I'm okay to remove the label since we will introduce the mdsc->mutex.

Thanks!

- Xiubo

> Thanks,
>
>                  Ilya
>

