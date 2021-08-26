Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6983F7F52
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 02:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhHZAfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 20:35:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37867 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234288AbhHZAfI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 20:35:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629938061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7f4CGx5tr8q0PFpiv4T7FjHbazfwVPlPQyfcOeu4ZME=;
        b=eJUTWxwBEU6S5qEthdCwlTqSt9dF+AtUTSFnEwG4kTTGW156TB1McVECAJ1HC1R6eLknnU
        uAawgdvv0fHKLRd6l7H7zlWdM9MqKvJkgX9Fubp7Sw3Oyk+RID4g78wizPNMXK8KKk88Lr
        zRGHttZ1k/mbwMXNoDLyTeh8wiS6BbI=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-1N953RsPNO6BlWveL8qJgg-1; Wed, 25 Aug 2021 20:34:20 -0400
X-MC-Unique: 1N953RsPNO6BlWveL8qJgg-1
Received: by mail-pl1-f198.google.com with SMTP id p21-20020a1709028a95b029012c31764588so227438plo.12
        for <stable@vger.kernel.org>; Wed, 25 Aug 2021 17:34:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=7f4CGx5tr8q0PFpiv4T7FjHbazfwVPlPQyfcOeu4ZME=;
        b=EPm0sFThbYb0r9x8evD8e2ALEcv5X/1G6y7zIGSCSbizXjglFDgtice8H3eeOvC8Pr
         mnZROIOJz7guZYH/Jtd2soq1bu+u+5HstbhRdgkvaMR+6FasBtpRkkCkm1DiK11IQE28
         BIyadyvIQNAkHHiZFcfOyZoDWFp7gjUolPmeH7RgVgZf+K/nieuhWUGABoLlzXHSzLOx
         j/51YA7Op9KDN8pmZsOQ5B0bizJN3BP9KZFYqobSurIiZQYRdsfGepjs2PjP4xjpDpLT
         wSjyTEjBtANOne5+Tu09GczltUZI5GrChZlfiK7krsPWIVuJAKbFDFCUaaXMWJ1+d1Cy
         aFTA==
X-Gm-Message-State: AOAM530S0ksrieOhO9ModJgq5qwBBADC6KTlY0Qa+0B/miISWkUUgi9M
        LqVPBm756Y+PIDaJT5B/61IkWjimFGnkPDrK8YucF4/uxRXXTDS0VMZ5oyYNzqPnaO1+JmpOyed
        uXdYxHzJfvOhrjwRuhoTJeJwwXqqTTwOSddOKv36Ce9FzEgUe/H2IqChuZ4YWChqxMA==
X-Received: by 2002:a17:90a:de04:: with SMTP id m4mr13278378pjv.187.1629938058813;
        Wed, 25 Aug 2021 17:34:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrBtWHDWaYkUGHCZsGzMtW9bMIiBSExuZuC12xu1v8zJCbQIkgfz0/+b+4Jm2cooCDV7H/uA==
X-Received: by 2002:a17:90a:de04:: with SMTP id m4mr13278342pjv.187.1629938058445;
        Wed, 25 Aug 2021 17:34:18 -0700 (PDT)
Received: from [10.72.12.157] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u24sm818608pfm.81.2021.08.25.17.34.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 17:34:17 -0700 (PDT)
Subject: Re: [PATCH] ceph: init the i_list/g_list for cap flush
To:     Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>
Cc:     "Yan, Zheng" <ukernel@gmail.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        stable@vger.kernel.org
References: <20210825052212.19625-1-xiubli@redhat.com>
 <da7fe11c497e61573434591fe1dc07424eca0399.camel@kernel.org>
 <CAOi1vP9ED1ZaPuueDPjeWx_b-Nsu_B8FqnRq49NyzMLgD99c9g@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f7e06785-1d04-c396-fd2b-72ab5d0da123@redhat.com>
Date:   Thu, 26 Aug 2021 08:34:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP9ED1ZaPuueDPjeWx_b-Nsu_B8FqnRq49NyzMLgD99c9g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 8/25/21 10:31 PM, Ilya Dryomov wrote:
> On Wed, Aug 25, 2021 at 12:50 PM Jeff Layton <jlayton@kernel.org> wrote:
>> On Wed, 2021-08-25 at 13:22 +0800, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> Always init the i_list/g_list in the begining to make sure it won't
>>> crash the kernel if someone want to delete the cap_flush from the
>>> lists.
>>>
>>> Cc: stable@vger.kernel.org
>>> URL: https://tracker.ceph.com/issues/52401
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>>   fs/ceph/caps.c | 2 +-
>>>   fs/ceph/snap.c | 2 ++
>>>   2 files changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>> index 4f0dbc640b0b..60f60260cf42 100644
>>> --- a/fs/ceph/caps.c
>>> +++ b/fs/ceph/caps.c
>>> @@ -3666,7 +3666,7 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
>>>        while (!list_empty(&to_remove)) {
>>>                cf = list_first_entry(&to_remove,
>>>                                      struct ceph_cap_flush, i_list);
>>> -             list_del(&cf->i_list);
>>> +             list_del_init(&cf->i_list);
>>>                if (!cf->is_capsnap)
>>>                        ceph_free_cap_flush(cf);
>>>        }
>>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>>> index 62fab59bbf96..b41e6724c591 100644
>>> --- a/fs/ceph/snap.c
>>> +++ b/fs/ceph/snap.c
>>> @@ -488,6 +488,8 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
>>>                return;
>>>        }
>>>        capsnap->cap_flush.is_capsnap = true;
>>> +     INIT_LIST_HEAD(&capsnap->cap_flush.i_list);
>>> +     INIT_LIST_HEAD(&capsnap->cap_flush.g_list);
>>>
>>>        spin_lock(&ci->i_ceph_lock);
>>>        used = __ceph_caps_used(ci);
>> I'm not certain the second hunk is strictly needed. These either end up
>> on the list or they just get freed. That said, they shouldn't hurt
>> anything and it is more consistent. Merged into testing.
>>
>> Ilya, since this is marked for stable, this probably ought to go to
>> Linus in the last v5.14 pile.
> I'm inclined to fold this into "ceph: correctly handle releasing an
> embedded cap flush" which is already queued for 5.14.

Yeah, that's will be better.


>
> Thanks,
>
>                  Ilya
>

