Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 336DA6459E5
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 13:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiLGMgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 07:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiLGMgg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 07:36:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B868445A14
        for <stable@vger.kernel.org>; Wed,  7 Dec 2022 04:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670416539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8pDtQ9nm2wZqYnBy49v2PpqXkl7rY/mR/RZTTzt+8gE=;
        b=iRRRnmBzKv+WCU/s62p0wQD4aN5sDAXS7UiI8SZIH4ZPKqEOVipMzSymrPTKzu+woQJLFe
        68E2UPH7Tfq/NCR/qvv0L6rM3KsYKJGgBwC8BPFodA+prBgrDMoZF3/8um42QuyhpYUrFo
        3FGaqzKRL0/ExCJEmOQ1iYiWiegdJpc=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-20-jNvQwDApMtWsrNxTH5Cu6A-1; Wed, 07 Dec 2022 07:35:39 -0500
X-MC-Unique: jNvQwDApMtWsrNxTH5Cu6A-1
Received: by mail-pf1-f198.google.com with SMTP id y23-20020aa78057000000b00574277cb386so15182969pfm.16
        for <stable@vger.kernel.org>; Wed, 07 Dec 2022 04:35:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8pDtQ9nm2wZqYnBy49v2PpqXkl7rY/mR/RZTTzt+8gE=;
        b=m511IVIzxwFIQZsp7Z8G2a4hgNP9Q8eRJAiRcNEMOCCM8iUacK5hvVaA83rg+JaSBf
         cmPkgdc7ardScOrlsbbjLrumyMGw4/a/PoEzqSrXXOe8NcrgOlNQItOkPlrUW+/jWltm
         W9NQlzKYBkth3gKoEvYutLeSozsYri0vWWJ2pM1a/rG4TAqkfN1daDY1MjqwW4SJiWtp
         MTL+8g1kqCWe/NehVPKLeJgOJoqlEf36ci5SWqzeA8Fgnb3cvlZv1W/S7+nUGpkoKgv4
         8q79/VIMKh9aOk8shjRzGOqbPDp5jMzrG/DPjzqPUescQa5heeQ968CVgm0n7qYtp5JT
         y6fg==
X-Gm-Message-State: ANoB5pljr+qMfbnDgDRnrGkOS/PVQr4lFLT49LOFYPIe9oJaqB1wRc+t
        jje5NmF+GjKgpFsBCfqivnmvw1n/Ztmub5KdJyJIlxwu0cyOMpkyZn+OoJ1odoDXvbrkDUNi2ox
        huhfLI1LrgPJauxvTz/Dx0MhyBwEdBfaEuoV0HOatGUr6K70tCMjsP4TJPpQeD9nkKA==
X-Received: by 2002:a62:31c4:0:b0:56e:989d:7410 with SMTP id x187-20020a6231c4000000b0056e989d7410mr74685180pfx.1.1670416537810;
        Wed, 07 Dec 2022 04:35:37 -0800 (PST)
X-Google-Smtp-Source: AA0mqf43DuTnk73egDoSsoqVCVggHzcN08GJa+C4OxymGz7MS4siJ1w3hG42XH4MGeCvfWM9Xbn77Q==
X-Received: by 2002:a62:31c4:0:b0:56e:989d:7410 with SMTP id x187-20020a6231c4000000b0056e989d7410mr74685135pfx.1.1670416537403;
        Wed, 07 Dec 2022 04:35:37 -0800 (PST)
Received: from [10.72.12.134] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 194-20020a6300cb000000b00476b165ff8bsm7381658pga.57.2022.12.07.04.35.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 04:35:37 -0800 (PST)
Subject: Re: [PATCH v3] ceph: blocklist the kclient when receiving corrupted
 snap trace
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, atomlin@atomlin.com, stable@vger.kernel.org
References: <20221206125915.37404-1-xiubli@redhat.com>
 <CAOi1vP8hkXZ7w9D5LnMViyjqVCmsKo3H2dg1QpzgHCPuNfvACQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <897fc89b-775f-88ce-1550-90c47220dc18@redhat.com>
Date:   Wed, 7 Dec 2022 20:35:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP8hkXZ7w9D5LnMViyjqVCmsKo3H2dg1QpzgHCPuNfvACQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 07/12/2022 18:59, Ilya Dryomov wrote:
> On Tue, Dec 6, 2022 at 1:59 PM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When received corrupted snap trace we don't know what exactly has
>> happened in MDS side. And we shouldn't continue writing to OSD,
>> which may corrupt the snapshot contents.
>>
>> Just try to blocklist this client and If fails we need to crash the
>> client instead of leaving it writeable to OSDs.
>>
>> Cc: stable@vger.kernel.org
>> URL: https://tracker.ceph.com/issues/57686
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> Thanks Aaron's feedback.
>>
>> V3:
>> - Fixed ERROR: spaces required around that ':' (ctx:VxW)
>>
>> V2:
>> - Switched to WARN() to taint the Linux kernel.
>>
>>   fs/ceph/mds_client.c |  3 ++-
>>   fs/ceph/mds_client.h |  1 +
>>   fs/ceph/snap.c       | 25 +++++++++++++++++++++++++
>>   3 files changed, 28 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index cbbaf334b6b8..59094944af28 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -5648,7 +5648,8 @@ static void mds_peer_reset(struct ceph_connection *con)
>>          struct ceph_mds_client *mdsc = s->s_mdsc;
>>
>>          pr_warn("mds%d closed our session\n", s->s_mds);
>> -       send_mds_reconnect(mdsc, s);
>> +       if (!mdsc->no_reconnect)
>> +               send_mds_reconnect(mdsc, s);
>>   }
>>
>>   static void mds_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>> index 728b7d72bf76..8e8f0447c0ad 100644
>> --- a/fs/ceph/mds_client.h
>> +++ b/fs/ceph/mds_client.h
>> @@ -413,6 +413,7 @@ struct ceph_mds_client {
>>          atomic_t                num_sessions;
>>          int                     max_sessions;  /* len of sessions array */
>>          int                     stopping;      /* true if shutting down */
>> +       int                     no_reconnect;  /* true if snap trace is corrupted */
>>
>>          atomic64_t              quotarealms_count; /* # realms with quota */
>>          /*
>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>> index c1c452afa84d..023852b7c527 100644
>> --- a/fs/ceph/snap.c
>> +++ b/fs/ceph/snap.c
>> @@ -767,8 +767,10 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>>          struct ceph_snap_realm *realm;
>>          struct ceph_snap_realm *first_realm = NULL;
>>          struct ceph_snap_realm *realm_to_rebuild = NULL;
>> +       struct ceph_client *client = mdsc->fsc->client;
>>          int rebuild_snapcs;
>>          int err = -ENOMEM;
>> +       int ret;
>>          LIST_HEAD(dirty_realms);
>>
>>          lockdep_assert_held_write(&mdsc->snap_rwsem);
>> @@ -885,6 +887,29 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>>          if (first_realm)
>>                  ceph_put_snap_realm(mdsc, first_realm);
>>          pr_err("%s error %d\n", __func__, err);
>> +
>> +       /*
>> +        * When receiving a corrupted snap trace we don't know what
>> +        * exactly has happened in MDS side. And we shouldn't continue
>> +        * writing to OSD, which may corrupt the snapshot contents.
>> +        *
>> +        * Just try to blocklist this kclient and if it fails we need
>> +        * to crash the kclient instead of leaving it writeable.
> Hi Xiubo,
>
> I'm not sure I understand this "let's blocklist ourselves" concept.
> If the kernel client shouldn't continue writing to OSDs in this case,
> why not just stop issuing writes -- perhaps initiating some equivalent
> of a read-only remount like many local filesystems would do on I/O
> errors (e.g. errors=remount-ro mode)?

I still haven't found how could I handle it this way from ceph layer. I 
saw they are just marking the inodes as EIO when this happens.

>
> Or, perhaps, all in-memory snap contexts could somehow be invalidated
> in this case, making writes fail naturally -- on the client side,
> without actually being sent to OSDs just to be nixed by the blocklist
> hammer.
>
> But further, what makes a failure to decode a snap trace special?

 From the known tracker the snapid was corrupted in one inode in MDS and 
then when trying to build the snap trace with the corrupted snapid it 
will corrupt.

And also there maybe other cases.

> AFAIK we don't do anything close to this for any other decoding
> failure.  Wouldn't "when received corrupted XYZ we don't know what
> exactly has happened in MDS side" argument apply to pretty much all
> decoding failures?

The snap trace is different from other cases. The corrupted snap trace 
will affect the whole snap realm hierarchy, which will affect the whole 
inodes in the mount in worst case.

This is why I was trying to evict the mount to prevent further IOs.

>
>> +        *
>> +        * Then this kclient must be remounted to continue after the
>> +        * corrupted metadata fixed in the MDS side.
>> +        */
>> +       mdsc->no_reconnect = 1;
>> +       ret = ceph_monc_blocklist_add(&client->monc, &client->msgr.inst.addr);
>> +       if (ret) {
>> +               pr_err("%s blocklist of %s failed: %d", __func__,
>> +                      ceph_pr_addr(&client->msgr.inst.addr), ret);
>> +               BUG();
> ... and this is a rough equivalent of errors=panic mode.
>
> Is there a corresponding userspace client PR that can be referenced?
> This needs additional background and justification IMO.

Not yet. Any way we shouldn't let it continue do the IOs if fails to add 
it to the blocklist.

- Xiubo

>
> Thanks,
>
>                  Ilya
>

