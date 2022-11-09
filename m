Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 880BB6227FB
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 11:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiKIKH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 05:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiKIKHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 05:07:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A633D248D3
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 02:06:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667988386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nMDMmRYM4227Ys41E71h4nHLnDfbg+d4lpTyVTZsa2U=;
        b=WXWQKbWVzKugmVn7ifnHeafivWuzDPtg4gGBW9M2ywMO5EGRZ+U83I0AYonHZ00jXOFWSg
        iHO/y8VEzk8CxvcSOvT88xm1pZ7khacLKHtc/528VSJl2U4Qb4zUfbnjuVCInU/UPaylMY
        ceoLTfWUq2cwBpaPt9LpLZzwAylDNzI=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-331-hMuBuqWXNBWEjN4ZNDg7Lg-1; Wed, 09 Nov 2022 05:06:25 -0500
X-MC-Unique: hMuBuqWXNBWEjN4ZNDg7Lg-1
Received: by mail-pg1-f200.google.com with SMTP id k71-20020a63844a000000b004701e90da0dso9265779pgd.22
        for <stable@vger.kernel.org>; Wed, 09 Nov 2022 02:06:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nMDMmRYM4227Ys41E71h4nHLnDfbg+d4lpTyVTZsa2U=;
        b=nI7wWqdq+X9zDT2txDc0jhLAKiyDWHsNj6PYqq1DzcLjsLhtOdv6E+M9v7ljssBn7J
         R/0Re7FQBIcvJuutxT4mQHz5WWuTeRut/UV+xgx68Qd25jcx/xUCZq71MRtZrr0gUBiV
         +ieq7Us+XD4gsQhoCN5f2Y6pjqxaooG4G5yjyxIBg8FWQdVuV5wJC7qbxicXkpxA3iXs
         MHpBB1W9FC837oJ8VLd8WmOQeq245nQ3JwBdeza/nK7btx+r18ku+WzUi65Uaf/v1OHY
         3dj2CGkKlNnDhCiDoLYgwcAiESQQvaQKmW+b1H0O8avzMWO6ilVL8K8MhNqanZSr3QJl
         MACw==
X-Gm-Message-State: ACrzQf0yMvNWlb+ZVRDa4WBGmuFAun4zDCHLOWh90BfvHHbfr0KIZltb
        nke//L+B54gOF1NFEFXoIflBUIYAj5v/9XQ+GctXtPbGqH0nNxRijYTKtPug2/+Kcaf+TrbNcCO
        d/CrrbKGSwE1n3jEvr+YXv9cY1Roc01wprKMMciw2+ioNAi5Ved3CpadMyW/850uKeA==
X-Received: by 2002:a17:902:ccc2:b0:178:29e1:899e with SMTP id z2-20020a170902ccc200b0017829e1899emr59532399ple.114.1667988384620;
        Wed, 09 Nov 2022 02:06:24 -0800 (PST)
X-Google-Smtp-Source: AMsMyM6QjdtUgzJl9o14cumiOT6ouM3eVud5paPq4W5C+HqCRe/6rG5lBHb2GuOpaX0FO19iHn3sHg==
X-Received: by 2002:a17:902:ccc2:b0:178:29e1:899e with SMTP id z2-20020a170902ccc200b0017829e1899emr59532373ple.114.1667988384275;
        Wed, 09 Nov 2022 02:06:24 -0800 (PST)
Received: from [10.72.12.148] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id h4-20020a170902680400b00186efc56ab9sm8599002plk.221.2022.11.09.02.06.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 02:06:23 -0800 (PST)
Subject: Re: [PATCH v4] ceph: avoid putting the realm twice when decoding
 snaps fails
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, lhenriques@suse.de, jlayton@kernel.org,
        mchangir@redhat.com, stable@vger.kernel.org
References: <20221109030039.592830-1-xiubli@redhat.com>
 <CAOi1vP-jbuyQ4AROR3cj9ybeT8mZT6w9J+yuVOi8ASdOZo8=xA@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <81252038-f123-a6b9-7012-bf451ad4f294@redhat.com>
Date:   Wed, 9 Nov 2022 18:06:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP-jbuyQ4AROR3cj9ybeT8mZT6w9J+yuVOi8ASdOZo8=xA@mail.gmail.com>
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


On 09/11/2022 18:03, Ilya Dryomov wrote:
> On Wed, Nov 9, 2022 at 4:00 AM <xiubli@redhat.com> wrote:
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
>>
>> Changed in V4:
>> - remove initilizing of 'realm'.
>>
>>   fs/ceph/snap.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>> index 9bceed2ebda3..c1c452afa84d 100644
>> --- a/fs/ceph/snap.c
>> +++ b/fs/ceph/snap.c
>> @@ -764,7 +764,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>>          struct ceph_mds_snap_realm *ri;    /* encoded */
>>          __le64 *snaps;                     /* encoded */
>>          __le64 *prior_parent_snaps;        /* encoded */
>> -       struct ceph_snap_realm *realm = NULL;
>> +       struct ceph_snap_realm *realm;
>>          struct ceph_snap_realm *first_realm = NULL;
>>          struct ceph_snap_realm *realm_to_rebuild = NULL;
>>          int rebuild_snapcs;
>> @@ -775,6 +775,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>>
>>          dout("%s deletion=%d\n", __func__, deletion);
>>   more:
>> +       realm = NULL;
>>          rebuild_snapcs = 0;
>>          ceph_decode_need(&p, e, sizeof(*ri), bad);
>>          ri = p;
>> --
>> 2.31.1
>>
> Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Thanks very much Ilya!
>
> Thanks,
>
>                  Ilya
>

