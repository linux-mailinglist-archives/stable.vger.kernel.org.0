Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A77E86206B4
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 03:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbiKHCZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 21:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbiKHCZU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 21:25:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F9217ABC
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 18:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667874260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7szDA3aJA2JeppTlYEmPkBUWEjAHUFnJ9ELoQFnSRV8=;
        b=SQPyDkfB46ZAXueXEm5Soy+iOQjm9Z5H2ACAp1wNCEkJeGWIUH1um9OdP2SEcc1hGBnzTd
        RhsBFBOQN6a+TUu1YkKAy1HB48kMkkLIkwp+Bf2yVXeCfo1bQCKNx3s5wH6PSi78yCUCEw
        nUD/n3QSNzlNiOal9TT7j38KzS5j46M=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-219-zp6o96kuM6G-BYlau44XFg-1; Mon, 07 Nov 2022 21:24:19 -0500
X-MC-Unique: zp6o96kuM6G-BYlau44XFg-1
Received: by mail-pg1-f199.google.com with SMTP id s16-20020a632c10000000b0047084b16f23so1160795pgs.7
        for <stable@vger.kernel.org>; Mon, 07 Nov 2022 18:24:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7szDA3aJA2JeppTlYEmPkBUWEjAHUFnJ9ELoQFnSRV8=;
        b=Mneisd+cu16al0SckCXqNKnjQ6BJ/IW99EwsvlcH4eHJbUAn9MYn273kwbgHNs/J8x
         bjTSV5Z1XPRKKnb1KDKTS94MKkUZj9UrqQyHcgUU1lVa+df4Surhek7a8E9Pn1ICZhQv
         sTQzLFo/rsAQmfioWzipnuatZ99hJ3bjUEwRmZGHTeZfmav66RV1Ld0ndHJqL2hG5EEa
         IuDuq17B0Rw0NqEQcJm9t3HLym6CZkgDPMNwdjXYNOI5w/xPP1S7EPYULuTVUY1q4Tlv
         Y9UXlp3y7j0y/H+r623soXwPjBOD4nSO882RnLVsMskreToGiUgy4l0fknfvMekziX8R
         +aqA==
X-Gm-Message-State: ACrzQf0ywpFjhj6mQmSclC0yaij5ahmq5o98SlX0Ejpi4YFFiGktPmY5
        maa8oIMWLCCXRw3Vj7tFb3cnxMJ0TOTrShQkfcQ+Sa4gKnwmHotORG5jMS7tdnGls//cuq/B2kM
        vRkiImyTqvM2hdW5He4hHlhRpd4OV7I4aHwMAF1k7GehNmViI5OTsHF/kTopM+WfV7Q==
X-Received: by 2002:a63:2b41:0:b0:46e:9364:eb07 with SMTP id r62-20020a632b41000000b0046e9364eb07mr45892063pgr.46.1667874258494;
        Mon, 07 Nov 2022 18:24:18 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4Bcif+i8EW3zXFsuWf77/tbMGzhhakJk/4GRcDIQOMAwm0itgnnSv7a1F/Nkz0mcG6db/y6A==
X-Received: by 2002:a63:2b41:0:b0:46e:9364:eb07 with SMTP id r62-20020a632b41000000b0046e9364eb07mr45892043pgr.46.1667874258106;
        Mon, 07 Nov 2022 18:24:18 -0800 (PST)
Received: from [10.72.12.88] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h11-20020a170902f70b00b00182a9c27acfsm5616075plo.227.2022.11.07.18.24.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 18:24:17 -0800 (PST)
Subject: Re: [PATCH] ceph: avoid putting the realm twice when docoding snaps
 fails
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, lhenriques@suse.de, jlayton@kernel.org,
        mchangir@redhat.com, stable@vger.kernel.org
References: <20221107071759.32000-1-xiubli@redhat.com>
 <CAOi1vP-orfs-CK+KjWyMXiRRQqZxcw=r_yvLRDAVMEvrrOw8vg@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <efa85d3a-92e0-56e0-49af-d94f5a49bd13@redhat.com>
Date:   Tue, 8 Nov 2022 10:24:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP-orfs-CK+KjWyMXiRRQqZxcw=r_yvLRDAVMEvrrOw8vg@mail.gmail.com>
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


On 07/11/2022 23:21, Ilya Dryomov wrote:
> On Mon, Nov 7, 2022 at 8:18 AM <xiubli@redhat.com> wrote:
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
>>   fs/ceph/snap.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>> index 9bceed2ebda3..baf17df05107 100644
>> --- a/fs/ceph/snap.c
>> +++ b/fs/ceph/snap.c
>> @@ -849,10 +849,12 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>>          if (realm_to_rebuild && p >= e)
>>                  rebuild_snap_realms(realm_to_rebuild, &dirty_realms);
>>
>> -       if (!first_realm)
>> +       if (!first_realm) {
>>                  first_realm = realm;
>> -       else
>> +               realm = NULL;
> Hi Xiubo,
>
> I wonder why realm is cleared only in !first_realm branch?  Can't
> the same issue occur with realm?
>
>      first_realm is already set, ceph_put_snap_realm(realm)
>      p < e, goto more
>      decoding fails, goto bad
>      realm is still set and not IS_ERR, ceph_put_snap_realm(realm)
>      <realm is put twice>

Yeah, makes sense.

I will fix this.

Thanks Ilya!


>
> Thanks,
>
>                  Ilya
>

