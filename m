Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27FFD620FB0
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 13:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbiKHMBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 07:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233298AbiKHMBU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 07:01:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CF11E3E3
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 04:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667908821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/7gN4WWN2OPeuv9WBAWTuHaagDVzXh71rZEDmMP2Ok8=;
        b=chPOlcaVobfv/jvM+C0MTvcsW5qWxKqFlepHz57z5dG9CZmMO+nHzO9ynMfd8iGdvN86gw
        PoNjuIY24tOLA1k97w39KSi75ksP7ml7tGRUbcaYOSysv85FgC/BxA69n2eVBRg6PRS1nQ
        UnQLq4XBa0GlwARX+HjuJnRJLZ1xx3Q=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-635-UU5qVnFIO1Gh9Tr9KKgqqQ-1; Tue, 08 Nov 2022 07:00:20 -0500
X-MC-Unique: UU5qVnFIO1Gh9Tr9KKgqqQ-1
Received: by mail-pj1-f70.google.com with SMTP id q93-20020a17090a1b6600b0021311ab9082so6879894pjq.7
        for <stable@vger.kernel.org>; Tue, 08 Nov 2022 04:00:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/7gN4WWN2OPeuv9WBAWTuHaagDVzXh71rZEDmMP2Ok8=;
        b=OoqrSeryFHJ/FViV8GQFIW+ywajfa4dCIdSE2ugvSufDV6xyZvekv/ff+DplvUJsHD
         xaC4wfGQHNdjgyvgqJcqpe3+rXj8Y0gjl3CFXn3JLfWtWEkkBVk/f5c7u6k+4iwHIunv
         zCu+ErZ+eUMVwT1RbJYzPzRrfwRwtflmRCqdUQ1D4KORZMHRnbG9cIPQseFrH4Usz31+
         e6zf/p1oytLPFxZmF0aiIQjgFSC1p8Lv3H4Vtcx4QeqxYYZQKPtBRtKwk47TI6NMI/HM
         ICVsm5wVT0QGGUEwvReHx8jZeFylmudzTKTmQLbTVjguFDwsa6tMCpbrpAv6aPwwIpw4
         5K8A==
X-Gm-Message-State: ACrzQf1r61sgK4PQJLYHOyVEC5ANy8gU3sJZW8VsqwQmTmNHL+avWzOb
        mjplaRnCUWL67MOOPXZ3WKJVDuIfYy7jVDspKdDEu3mKrDnpCzBZghmiOIkupApVqrb/qAFKMPr
        JyT2+AYPBSND5vjdNZ4Bs8M+O9HMwJwRGDv7XD64xYo7QrCIISPb4NA4Re9Ga9aDKQw==
X-Received: by 2002:a17:903:1d0:b0:187:1305:39d5 with SMTP id e16-20020a17090301d000b00187130539d5mr49850630plh.93.1667908819252;
        Tue, 08 Nov 2022 04:00:19 -0800 (PST)
X-Google-Smtp-Source: AMsMyM6Mi9JGVFoo5BBkNVdYOm/E0XxX52sM7xr1s+pffjw+n4RskUAkxxKsbubVF1Qv5t+AGC6b5Q==
X-Received: by 2002:a17:903:1d0:b0:187:1305:39d5 with SMTP id e16-20020a17090301d000b00187130539d5mr49850592plh.93.1667908818894;
        Tue, 08 Nov 2022 04:00:18 -0800 (PST)
Received: from [10.72.12.88] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id z8-20020a170903018800b0017ec1b1bf9fsm6762576plg.217.2022.11.08.04.00.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 04:00:18 -0800 (PST)
Subject: Re: [PATCH v2] ceph: avoid putting the realm twice when decoding
 snaps fails
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, lhenriques@suse.de, jlayton@kernel.org,
        mchangir@redhat.com, stable@vger.kernel.org
References: <20221108023141.64972-1-xiubli@redhat.com>
 <CAOi1vP9MamdH5im1bMZGQTr0ubbMeanHSw5bCZ8Ud+FEG152Zg@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <71b6f0ff-744a-9a96-5935-f77ca5aa0075@redhat.com>
Date:   Tue, 8 Nov 2022 20:00:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP9MamdH5im1bMZGQTr0ubbMeanHSw5bCZ8Ud+FEG152Zg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
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


On 08/11/2022 17:56, Ilya Dryomov wrote:
> On Tue, Nov 8, 2022 at 3:32 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When decoding the snaps fails it maybe leaving the 'first_realm'
>> and 'realm' pointing to the same snaprealm memory. And then it'll
>> put it twice and could cause random use-after-free, BUG_ON, etc
>> issues.
>>
>> Cc: stable@vger.kernel.org
>> URL: https://tracker.ceph.com/issues/57686
>> Reviewed-by: Luís Henriques <lhenriques@suse.de>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/snap.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>> index 9bceed2ebda3..77b948846d4d 100644
>> --- a/fs/ceph/snap.c
>> +++ b/fs/ceph/snap.c
>> @@ -854,6 +854,8 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>>          else
>>                  ceph_put_snap_realm(mdsc, realm);
>>
>> +       realm = NULL;
> Hi Xiubo,
>
> Nit: I think it would be better to clear realm in the part of
> the function that actually needs it to be cleared -- otherwise
> this assignment can be easily lost in refactoring.
>
>          dout("%s deletion=%d\n", __func__, deletion);
> more:
>          realm = NULL;
>          rebuild_snapcs = 0;
>
> And then realm wouldn't need to be initialized.

Okay, will fix it.

Thanks!

- Xiubo


>
> Thanks,
>
>                  Ilya
>

