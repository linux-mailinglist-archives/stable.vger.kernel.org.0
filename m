Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7A5622133
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 02:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiKIBKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 20:10:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiKIBKn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 20:10:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325C95E9DA
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 17:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667956182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=McFP/+5bITM5OnBR9OZLa+HPDT9BYNRFp9NoXFLGg4U=;
        b=JgXL0x1XCsl6RN4/JcAjtmtpLN6m050S4etbEbPyqUeG3RY2kMWCQnJ03jg6acwfnHGegw
        OZ4hmWj3rrvP5f1HF2XGmLg12vI+7hb18rOwZbB71ZuuEiC1a+a0ASM8iVOcjwNhCIpfaH
        j7zXykUfwu4flqs9AiEf4w+3hlI6/XM=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-630-_9wklsIkOVm_5F799JvvqA-1; Tue, 08 Nov 2022 20:09:41 -0500
X-MC-Unique: _9wklsIkOVm_5F799JvvqA-1
Received: by mail-pl1-f198.google.com with SMTP id c1-20020a170902d48100b0018723580343so12365706plg.15
        for <stable@vger.kernel.org>; Tue, 08 Nov 2022 17:09:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=McFP/+5bITM5OnBR9OZLa+HPDT9BYNRFp9NoXFLGg4U=;
        b=2UHhH82l9QclZf7zBSdYo7sOT1W7Cnixa9VwWOELbKluQbgNbaVXneMRmWK7b5CGrV
         HOjyjhwcVMMU6ZO2FgH62Gtu11XqSDYL3P8mbLeTKG3Nhbrjx7LUHyclFr7ziYtgHHGc
         CIlhs5/h0FSfoY1jq1s5+KW1qKvagIIN8t7RihvwtRinBh5wRll7Qn5P/sQq2eHtxRKO
         MZXPL2aa5BGEgW1RL05omDT7Ui3dLfZopPgCctwbJly+BCzEKC5vrAD1OQKvQDwd+yoN
         JgOx/feshgHg+MiOLaO8XbKj1taf9w2PDjuNgHshjheaTInuQWNX1/Q9aiAAr+jpL6n7
         fU4A==
X-Gm-Message-State: ACrzQf0c/CtIv48sfI0BiAFHL/TXVNmw/oH64PiPAwybavu55nQt1T11
        7oKRTPtKxw4m3DFNkh5D/lD/3x3mhpM/yC+HC2gh/HmDOKxThikEQEzWPUEKSOQLE2ldPHyo4jZ
        DaIx3/9SIBsbhjxFf3NW//p7ORLg8eYVw8+5rBKbCoYexgLDhmZ7qe6M3iEgqFPJ5Kw==
X-Received: by 2002:a17:902:edd5:b0:187:1e83:8b96 with SMTP id q21-20020a170902edd500b001871e838b96mr50434200plk.1.1667956180372;
        Tue, 08 Nov 2022 17:09:40 -0800 (PST)
X-Google-Smtp-Source: AMsMyM69v6/3vAneEbNTrMQFiZ+59A7sf4Lit2RU2a+MIZM4tKQ0ZdfeWTiBycH4tv4O4TC89lq6iQ==
X-Received: by 2002:a17:902:edd5:b0:187:1e83:8b96 with SMTP id q21-20020a170902edd500b001871e838b96mr50434169plk.1.1667956179988;
        Tue, 08 Nov 2022 17:09:39 -0800 (PST)
Received: from [10.72.12.88] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y8-20020a17090a104800b002137d3da760sm8497049pjd.39.2022.11.08.17.09.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 17:09:39 -0800 (PST)
Subject: Re: [PATCH v3] ceph: avoid putting the realm twice when decoding
 snaps fails
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, lhenriques@suse.de, jlayton@kernel.org,
        mchangir@redhat.com, stable@vger.kernel.org
References: <20221108134633.557928-1-xiubli@redhat.com>
 <CAOi1vP-XiSj35RDbc3zkoNvHfwRujAA8_BEFW3C=5fo+rPWfiQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <62c7c610-3090-4029-fe5b-37326169d647@redhat.com>
Date:   Wed, 9 Nov 2022 09:09:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP-XiSj35RDbc3zkoNvHfwRujAA8_BEFW3C=5fo+rPWfiQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 08/11/2022 23:10, Ilya Dryomov wrote:
> On Tue, Nov 8, 2022 at 2:46 PM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When decoding the snaps fails it maybe leaving the 'first_realm'
>> and 'realm' pointing to the same snaprealm memory. And then it'll
>> put it twice and could cause random use-after-free, BUG_ON, etc
>> issues.
>>
>> Cc: stable@vger.kernel.org
>> URL: https://tracker.ceph.com/issues/57686
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/snap.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>> index 9bceed2ebda3..f5b0fa1ff705 100644
>> --- a/fs/ceph/snap.c
>> +++ b/fs/ceph/snap.c
>> @@ -775,6 +775,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>>
>>          dout("%s deletion=%d\n", __func__, deletion);
>>   more:
>> +       realm = NULL;
> Nit: realm doesn't need to be initialized anymore, I would drop that.

I noticed that. Sure will remove that.

Thanks!

- Xiubo

> Thanks,
>
>                  Ilya
>

