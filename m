Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBE1647E3F
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 08:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiLIHFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 02:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiLIHEc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 02:04:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD08A658D
        for <stable@vger.kernel.org>; Thu,  8 Dec 2022 22:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670569169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5VplosntwlyyUCGTkJoAHRP9XXRanBvCLWkoX739VbM=;
        b=Q0G2t7Bam4S9RNwPa3GmTlCgV31EbiqjDUir3Js4h4sI49A8SEAjg6MHhh0A2AhczM5fk5
        vZrC224kFbPOrmAur21dBKiEvOd1NRUrpkQDzVPnJlWWnsRABcQTsjpZ1qyIJNEHSIiEQE
        lxzV1zZOeFIAVsGOVcz/yg6qte3riXM=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-665-sbOHsxSzOtK3qUMzYZzrwg-1; Fri, 09 Dec 2022 01:59:28 -0500
X-MC-Unique: sbOHsxSzOtK3qUMzYZzrwg-1
Received: by mail-pl1-f200.google.com with SMTP id d2-20020a170902cec200b001899479b1d8so3560749plg.22
        for <stable@vger.kernel.org>; Thu, 08 Dec 2022 22:59:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5VplosntwlyyUCGTkJoAHRP9XXRanBvCLWkoX739VbM=;
        b=bHTW/SnNw7Hn/R+MNJxFeW/hoputYWjoUIfrT6/lMaGzIpO96F57FvW7D2fj1Jol9v
         o0Py6CYiAyBwLbtnahI+YxTXStVyfkUINRyh1mAMHaGBJO+57VFSSJ0mmi4/8KBdo8GD
         STwv6Nifgmk4XrFc+9mCk5gQsexnCchz1W+ejGf7CEClTgLD3mbpuxfjEUQkrVhO2/gI
         StpiDjwjrH8vnT2+QBZnc90zfvAMfP9VwZCMomrX3yUNmyuGwG9aUUkCMETaUzWMqa/4
         89R0A26MRJ+WjFizBsK0cawAkV2iEFzICUsJ+tpuWvdVgM+Td652Bd00OCGO66DUyq/f
         OBuw==
X-Gm-Message-State: ANoB5pn8YR8cv07bn2Te9R/ii9od1E3n5XZGEHE8yhJi9o01vaB0apN3
        lacNHYQyug1NNzXtFf09egncVzJ08ONXKCuImgIXFNdkbLe7wXuAmCflkeI18Vt3WvsdYTdy3Ia
        8Ue7d4DbycbKmWbCaHGJv5bsLv/PkHiNT3aYCvlQAsUj9odtMFInb5HE6qFIE2f8ZiA==
X-Received: by 2002:a05:6a21:8cc9:b0:a4:255b:f3b8 with SMTP id ta9-20020a056a218cc900b000a4255bf3b8mr5900460pzb.45.1670569166885;
        Thu, 08 Dec 2022 22:59:26 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5s4QZLohyrZm/OCx3E4is84gZlOzVfpzO6DhQkCf2n7IGwnGLD6wa3jAReUdSzdmmjQWlK9w==
X-Received: by 2002:a05:6a21:8cc9:b0:a4:255b:f3b8 with SMTP id ta9-20020a056a218cc900b000a4255bf3b8mr5900435pzb.45.1670569166479;
        Thu, 08 Dec 2022 22:59:26 -0800 (PST)
Received: from [10.72.12.134] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i134-20020a62878c000000b005761c4754e7sm569130pfe.144.2022.12.08.22.59.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 22:59:26 -0800 (PST)
Subject: Re: [PATCH v3] ceph: blocklist the kclient when receiving corrupted
 snap trace
To:     Venky Shankar <vshankar@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        jlayton@kernel.org, mchangir@redhat.com, atomlin@atomlin.com,
        stable@vger.kernel.org
References: <20221206125915.37404-1-xiubli@redhat.com>
 <CAOi1vP8hkXZ7w9D5LnMViyjqVCmsKo3H2dg1QpzgHCPuNfvACQ@mail.gmail.com>
 <baa681e9-4472-bcfb-601f-132dc6658888@redhat.com>
 <ac1e95e6-f8fa-e243-97bd-a280b8e0fa66@redhat.com>
 <CAOi1vP_=2wOSYmrzfdm3k__dVONjXspjV15gbZ+Yq247xmpnXQ@mail.gmail.com>
 <d8a35b3a-e0b9-8ee8-9b0e-dc77ddc9c312@redhat.com>
 <CACPzV1k=L0GyhK5c0Jgce=s02wqxa20qMuTzHhZvJB6cgnSQcw@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <487811e4-ffba-cfe5-db2b-5379602e7b26@redhat.com>
Date:   Fri, 9 Dec 2022 14:59:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CACPzV1k=L0GyhK5c0Jgce=s02wqxa20qMuTzHhZvJB6cgnSQcw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 09/12/2022 14:14, Venky Shankar wrote:
> On Thu, Dec 8, 2022 at 6:10 AM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 07/12/2022 22:20, Ilya Dryomov wrote:
>>> On Wed, Dec 7, 2022 at 2:31 PM Xiubo Li <xiubli@redhat.com> wrote:
>>>> On 07/12/2022 21:19, Xiubo Li wrote:
>>>>> On 07/12/2022 18:59, Ilya Dryomov wrote:
>>>>>> On Tue, Dec 6, 2022 at 1:59 PM <xiubli@redhat.com> wrote:
>>>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>>>
>>>>>>> When received corrupted snap trace we don't know what exactly has
>>>>>>> happened in MDS side. And we shouldn't continue writing to OSD,
>>>>>>> which may corrupt the snapshot contents.
>>>>>>>
>>>>>>> Just try to blocklist this client and If fails we need to crash the
>>>>>>> client instead of leaving it writeable to OSDs.
>>>>>>>
>>>>>>> Cc: stable@vger.kernel.org
>>>>>>> URL: https://tracker.ceph.com/issues/57686
>>>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>>>>> ---
>>>>>>>
>>>>>>> Thanks Aaron's feedback.
>>>>>>>
>>>>>>> V3:
>>>>>>> - Fixed ERROR: spaces required around that ':' (ctx:VxW)
>>>>>>>
>>>>>>> V2:
>>>>>>> - Switched to WARN() to taint the Linux kernel.
>>>>>>>
>>>>>>>     fs/ceph/mds_client.c |  3 ++-
>>>>>>>     fs/ceph/mds_client.h |  1 +
>>>>>>>     fs/ceph/snap.c       | 25 +++++++++++++++++++++++++
>>>>>>>     3 files changed, 28 insertions(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>>>>> index cbbaf334b6b8..59094944af28 100644
>>>>>>> --- a/fs/ceph/mds_client.c
>>>>>>> +++ b/fs/ceph/mds_client.c
>>>>>>> @@ -5648,7 +5648,8 @@ static void mds_peer_reset(struct
>>>>>>> ceph_connection *con)
>>>>>>>            struct ceph_mds_client *mdsc = s->s_mdsc;
>>>>>>>
>>>>>>>            pr_warn("mds%d closed our session\n", s->s_mds);
>>>>>>> -       send_mds_reconnect(mdsc, s);
>>>>>>> +       if (!mdsc->no_reconnect)
>>>>>>> +               send_mds_reconnect(mdsc, s);
>>>>>>>     }
>>>>>>>
>>>>>>>     static void mds_dispatch(struct ceph_connection *con, struct
>>>>>>> ceph_msg *msg)
>>>>>>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>>>>>>> index 728b7d72bf76..8e8f0447c0ad 100644
>>>>>>> --- a/fs/ceph/mds_client.h
>>>>>>> +++ b/fs/ceph/mds_client.h
>>>>>>> @@ -413,6 +413,7 @@ struct ceph_mds_client {
>>>>>>>            atomic_t                num_sessions;
>>>>>>>            int                     max_sessions;  /* len of sessions
>>>>>>> array */
>>>>>>>            int                     stopping;      /* true if shutting
>>>>>>> down */
>>>>>>> +       int                     no_reconnect;  /* true if snap trace
>>>>>>> is corrupted */
>>>>>>>
>>>>>>>            atomic64_t              quotarealms_count; /* # realms with
>>>>>>> quota */
>>>>>>>            /*
>>>>>>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>>>>>>> index c1c452afa84d..023852b7c527 100644
>>>>>>> --- a/fs/ceph/snap.c
>>>>>>> +++ b/fs/ceph/snap.c
>>>>>>> @@ -767,8 +767,10 @@ int ceph_update_snap_trace(struct
>>>>>>> ceph_mds_client *mdsc,
>>>>>>>            struct ceph_snap_realm *realm;
>>>>>>>            struct ceph_snap_realm *first_realm = NULL;
>>>>>>>            struct ceph_snap_realm *realm_to_rebuild = NULL;
>>>>>>> +       struct ceph_client *client = mdsc->fsc->client;
>>>>>>>            int rebuild_snapcs;
>>>>>>>            int err = -ENOMEM;
>>>>>>> +       int ret;
>>>>>>>            LIST_HEAD(dirty_realms);
>>>>>>>
>>>>>>>            lockdep_assert_held_write(&mdsc->snap_rwsem);
>>>>>>> @@ -885,6 +887,29 @@ int ceph_update_snap_trace(struct
>>>>>>> ceph_mds_client *mdsc,
>>>>>>>            if (first_realm)
>>>>>>>                    ceph_put_snap_realm(mdsc, first_realm);
>>>>>>>            pr_err("%s error %d\n", __func__, err);
>>>>>>> +
>>>>>>> +       /*
>>>>>>> +        * When receiving a corrupted snap trace we don't know what
>>>>>>> +        * exactly has happened in MDS side. And we shouldn't continue
>>>>>>> +        * writing to OSD, which may corrupt the snapshot contents.
>>>>>>> +        *
>>>>>>> +        * Just try to blocklist this kclient and if it fails we need
>>>>>>> +        * to crash the kclient instead of leaving it writeable.
>>>>>> Hi Xiubo,
>>>>>>
>>>>>> I'm not sure I understand this "let's blocklist ourselves" concept.
>>>>>> If the kernel client shouldn't continue writing to OSDs in this case,
>>>>>> why not just stop issuing writes -- perhaps initiating some equivalent
>>>>>> of a read-only remount like many local filesystems would do on I/O
>>>>>> errors (e.g. errors=remount-ro mode)?
>>>>> The following patch seems working. Let me do more test to make sure
>>>>> there is not further crash.
>>>>>
>>>>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>>>>> index c1c452afa84d..cd487f8a4cb5 100644
>>>>> --- a/fs/ceph/snap.c
>>>>> +++ b/fs/ceph/snap.c
>>>>> @@ -767,6 +767,7 @@ int ceph_update_snap_trace(struct ceph_mds_client
>>>>> *mdsc,
>>>>>           struct ceph_snap_realm *realm;
>>>>>           struct ceph_snap_realm *first_realm = NULL;
>>>>>           struct ceph_snap_realm *realm_to_rebuild = NULL;
>>>>> +       struct super_block *sb = mdsc->fsc->sb;
>>>>>           int rebuild_snapcs;
>>>>>           int err = -ENOMEM;
>>>>>           LIST_HEAD(dirty_realms);
>>>>> @@ -885,6 +886,9 @@ int ceph_update_snap_trace(struct ceph_mds_client
>>>>> *mdsc,
>>>>>           if (first_realm)
>>>>>                   ceph_put_snap_realm(mdsc, first_realm);
>>>>>           pr_err("%s error %d\n", __func__, err);
>>>>> +       pr_err("Remounting filesystem read-only\n");
>>>>> +       sb->s_flags |= SB_RDONLY;
>>>>> +
>>>>>           return err;
>>>>>    }
>>>>>
>>>>>
>>>> For readonly approach is also my first thought it should be, but I was
>>>> just not very sure whether it would be the best approach.
>>>>
>>>> Because by evicting the kclient we could prevent the buffer to be wrote
>>>> to OSDs. But the readonly one seems won't ?
>>> The read-only setting is more for the VFS and the user.  Technically,
>>> the kernel client could just stop issuing writes (i.e. OSD requests
>>> containing a write op) and not set SB_RDONLY.  That should cover any
>>> buffered data as well.
>>   From reading the local exit4 and other fs, they all doing it this way
>> and the VFS will help stop further writing. Tested the above patch and
>> it worked as expected.
>>
>> I think to stop the following OSD requests we can just check the
>> SB_RDONLY flag to prevent the buffer writeback.
>>
>>> By employing self-blocklisting, you are shifting the responsibility
>>> of rejecting OSD requests to the OSDs.  I'm saying that not issuing
>>> OSD requests from a potentially busted client in the first place is
>>> probably a better idea.  At the very least you wouldn't need to BUG
>>> on ceph_monc_blocklist_add() errors.
>> I found an issue for the read-only approach:
>>
>> In read-only mode it still can access to the MDSs and OSDs, which will
>> continue trying to update the snap realms with the corrupted snap trace
>> as before when reading. What if users try to read or backup the
>> snapshots by using the corrupted snap realms ?
>>
>> Isn't that a problem ?
> Yeh - this might end up in more problems in various places than what
> this change is supposed to handle.
>
> Maybe we could track affected realms (although, not that granular) and
> disallow reads to them (and its children), but I think it might not be
> worth putting in the effort.

IMO this doesn't make much sense.

When reading we need to use the inodes to get the corresponding realms, 
once the metadatas are corrupted and aborted here the inodes' 
corresponding realms could be incorrect. That's because when updating 
the snap realms here it's possible that the snap realm hierarchy will be 
adjusted and some inodes' realms will be changed.

Thanks

- Xiubo

>> Thanks
>>
>> - Xiubo
>>
>>> Thanks,
>>>
>>>                   Ilya
>>>
>

