Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 419D96A796F
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 03:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjCBCUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 21:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjCBCUm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 21:20:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16C0532B7
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677723594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dWZgyA1HWsAha7bzZoO1xP10Gw4rBTI1UXsZ3cZm+YQ=;
        b=Tgzw94Uf0ZW8kbQizr27sX/9moDXimskyOgSULYOzJSRaT51aDMBR7DbhQyD0igGOaVsve
        mNF5nvT19OLP975/VblPlhEjhc8x9VqFvOi9CktA7ZT7oHIfHBZS20CPQ2Y0r/G3EVHuEn
        UnvtoYeG8lpEeapHUgy0jDg0ddKOOuk=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-474-MLe7rSD5MsCMeHjB97ISqw-1; Wed, 01 Mar 2023 21:19:53 -0500
X-MC-Unique: MLe7rSD5MsCMeHjB97ISqw-1
Received: by mail-pf1-f197.google.com with SMTP id t12-20020aa7938c000000b005ac41980708so7809234pfe.7
        for <stable@vger.kernel.org>; Wed, 01 Mar 2023 18:19:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677723592;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dWZgyA1HWsAha7bzZoO1xP10Gw4rBTI1UXsZ3cZm+YQ=;
        b=Z3EDaG3Z9bikYEkx5Ucs5C9FEVe0HtTYaCYWhzCrRe8wK6imp/Yh3Xp1cQ/i92elKt
         6zBNDT9QsUOW2Npm3/gD7MIndh+iDZ2vly+rIDkqWXarjksjOY2OJn9wq+kTwthLlizQ
         RV5rSlGz5otGPyWBL7AmK0x5PUlLbA9/gnAduMpmN1kUVDoVBNC/1wB/6Fw8jAFguECN
         ZOVDH5AtoeW6s3e8PWq8mkqxlMIE/U6OeEBc0opfwr2LNN0SpRYTcgMy7g0AkB4C+PJc
         7UsTJT+Uyv97xFpufo6r+azIcCJ17D0aEXuVgUTOhmL+nFt1jIhQDrYAaaz4kU6HNEch
         Z+qQ==
X-Gm-Message-State: AO0yUKXoWpq+Pm8gIdjpW6uWYqXJnsgb3sbJZ1UtMhJkcgtI0/n2ndGj
        6PbslYgNsNv0Q714bcU2LHte8K6VhldFNWv0S6srycKKQEHTaB2Ca9SMTPIS5v/v4EfTFV2dWNV
        ilwEQQwnM8pcJZYc3
X-Received: by 2002:a17:902:e54f:b0:19d:ab83:ec70 with SMTP id n15-20020a170902e54f00b0019dab83ec70mr10236914plf.45.1677723592489;
        Wed, 01 Mar 2023 18:19:52 -0800 (PST)
X-Google-Smtp-Source: AK7set9Af82dngybkI+6/rqJHkqK8CxpHzin5Bu0VijckfAh+RlSTmk78DY/55d70DgDg49eBfq4/w==
X-Received: by 2002:a17:902:e54f:b0:19d:ab83:ec70 with SMTP id n15-20020a170902e54f00b0019dab83ec70mr10236895plf.45.1677723592181;
        Wed, 01 Mar 2023 18:19:52 -0800 (PST)
Received: from [10.72.12.72] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c4-20020a170902d90400b00198ac2769aesm9000332plz.135.2023.03.01.18.19.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 18:19:51 -0800 (PST)
Message-ID: <6627386e-0f7e-c23f-0589-cd5b22384e43@redhat.com>
Date:   Thu, 2 Mar 2023 10:19:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2] ceph: do not print the whole xattr value if it's too
 long
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org, lhenriques@suse.de,
        vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
References: <20230301011918.64629-1-xiubli@redhat.com>
 <CAOi1vP8i6EY-m-bGDNp5QhmHDepvgCAQ1FTnySVg7Bb=6h5uqw@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP8i6EY-m-bGDNp5QhmHDepvgCAQ1FTnySVg7Bb=6h5uqw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 01/03/2023 19:54, Ilya Dryomov wrote:
> On Wed, Mar 1, 2023 at 2:19 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> If the xattr's value size is long enough the kernel will warn and
>> then will fail the xfstests test case.
>>
>> Just print part of the value string if it's too long.
>>
>> Cc: stable@vger.kernel.org
>> URL: https://tracker.ceph.com/issues/58404
> Hi Xiubo,
>
> Does this really need to go to stable kernels?  None of the douts are
> printed by default.

Ilya,

That's okay, not a must.

>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> V2:
>> - switch to use min() from Jeff's comment
>> - s/XATTR_MAX_VAL/MAX_XATTR_VAL/g
>>
>>
>>   fs/ceph/xattr.c | 12 ++++++++----
>>   1 file changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
>> index b10d459c2326..887a65279fcf 100644
>> --- a/fs/ceph/xattr.c
>> +++ b/fs/ceph/xattr.c
>> @@ -561,6 +561,7 @@ static struct ceph_vxattr *ceph_match_vxattr(struct inode *inode,
>>          return NULL;
>>   }
>>
>> +#define MAX_XATTR_VAL 256
> Perhaps MAX_XATTR_VAL_PRINT_LEN?  Also, I'd add a blank like after the
> define -- it's used by more than one function.

Looks better.

I will revise this.

Thanks

- Xiubo


> Thanks,
>
>                  Ilya
>
-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li

