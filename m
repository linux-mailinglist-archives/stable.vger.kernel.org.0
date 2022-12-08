Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A41C6465F7
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 01:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiLHAhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 19:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiLHAhI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 19:37:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B178DBD2
        for <stable@vger.kernel.org>; Wed,  7 Dec 2022 16:36:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670459771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IawXlv79on0ZXUN1vTohJGdBzPbkrwlmuvMu7MEzOqA=;
        b=JWHmQi8zWtcFkCevjzJ0ysOu5TqnL5xq82mXmu0zgZ+A/t/fFgNTefqHndWxPhXU4P3mwu
        ZtZ6PtM/vQ7HKiqEiEl1BtfAq5MpAUnkkX3feJEY31d4RK9g1mBPH+4oeZfFIBnb27LTiO
        svgXqYKd0EhYfgWSX5sF+KxhnDZlx2M=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-310-KMFNYx_cPP2auUnTeaybSQ-1; Wed, 07 Dec 2022 19:36:10 -0500
X-MC-Unique: KMFNYx_cPP2auUnTeaybSQ-1
Received: by mail-pl1-f199.google.com with SMTP id k18-20020a170902c41200b001896d523dc8so20600262plk.19
        for <stable@vger.kernel.org>; Wed, 07 Dec 2022 16:36:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IawXlv79on0ZXUN1vTohJGdBzPbkrwlmuvMu7MEzOqA=;
        b=hUVN9kiTSltCL44xr/KS6b3JWySNqT+Iubev/KwjYc+B5xhjNt6cRXFpJhXoJxvIA9
         vP0eXZ2GKimjCm1Pz5CHsfDUiY0OCBFOttzbEGWUuj1ljkZ/yGX+MCYYOHu5GLoqCtVB
         OodpS99WoxXZmR9Bk4/6qEUJHXY3gpZsUVEa7IBU87fMsW/5hbXl++Jpvk/nzGA1f73U
         31+KxlSeJtV2nlja66oe/xeDew87Ouvrm/pja2NzB9fCJnWhJVIwt0A1/w2I0xHzQaEI
         8tBsrXAqUgqNAG1YdAx4DfQrrsHlatJGGxvNLd+x5WHrS/tZEBMKgJ7knIfH5AhkM+SA
         bN9g==
X-Gm-Message-State: ANoB5plXzhNM5HNy4ZwzvdzgKXLfAB4DP/m3jzAIEoHy7bj+67VEVJ0o
        Im1PZhBVLLzcXo0vU0Tbramox18F6vkqdJ8tk068dXgzMJZV03YqDL6/zOixJr3sEjnmvPeEmLw
        IYZG0YNRlVL86sGu5fqFEbF0F6A7j0tRGn0tF9yfRaEl4Bn9rvpttVpHUXqfW7alk2A==
X-Received: by 2002:a17:90a:bd83:b0:219:ba34:a60 with SMTP id z3-20020a17090abd8300b00219ba340a60mr1250155pjr.43.1670459768951;
        Wed, 07 Dec 2022 16:36:08 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5ExtTezAhXVXkpAnLiK4Ur+PkeltM8TKjGWjNfGtLzNM0YWrmZjhEAO9IOngdmpN7S/hxgEA==
X-Received: by 2002:a17:90a:bd83:b0:219:ba34:a60 with SMTP id z3-20020a17090abd8300b00219ba340a60mr1250142pjr.43.1670459768467;
        Wed, 07 Dec 2022 16:36:08 -0800 (PST)
Received: from [10.72.12.134] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id g7-20020a17090a300700b00218e8a0d7f0sm1700611pjb.22.2022.12.07.16.36.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 16:36:08 -0800 (PST)
Subject: Re: [PATCH v3] ceph: blocklist the kclient when receiving corrupted
 snap trace
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, atomlin@atomlin.com, stable@vger.kernel.org
References: <20221206125915.37404-1-xiubli@redhat.com>
 <CAOi1vP8hkXZ7w9D5LnMViyjqVCmsKo3H2dg1QpzgHCPuNfvACQ@mail.gmail.com>
 <baa681e9-4472-bcfb-601f-132dc6658888@redhat.com>
 <ac1e95e6-f8fa-e243-97bd-a280b8e0fa66@redhat.com>
 <CAOi1vP_=2wOSYmrzfdm3k__dVONjXspjV15gbZ+Yq247xmpnXQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d8a35b3a-e0b9-8ee8-9b0e-dc77ddc9c312@redhat.com>
Date:   Thu, 8 Dec 2022 08:36:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP_=2wOSYmrzfdm3k__dVONjXspjV15gbZ+Yq247xmpnXQ@mail.gmail.com>
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


On 07/12/2022 22:20, Ilya Dryomov wrote:
> On Wed, Dec 7, 2022 at 2:31 PM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 07/12/2022 21:19, Xiubo Li wrote:
>>> On 07/12/2022 18:59, Ilya Dryomov wrote:
>>>> On Tue, Dec 6, 2022 at 1:59 PM <xiubli@redhat.com> wrote:
>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>
>>>>> When received corrupted snap trace we don't know what exactly has
>>>>> happened in MDS side. And we shouldn't continue writing to OSD,
>>>>> which may corrupt the snapshot contents.
>>>>>
>>>>> Just try to blocklist this client and If fails we need to crash the
>>>>> client instead of leaving it writeable to OSDs.
>>>>>
>>>>> Cc: stable@vger.kernel.org
>>>>> URL: https://tracker.ceph.com/issues/57686
>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>>> ---
>>>>>
>>>>> Thanks Aaron's feedback.
>>>>>
>>>>> V3:
>>>>> - Fixed ERROR: spaces required around that ':' (ctx:VxW)
>>>>>
>>>>> V2:
>>>>> - Switched to WARN() to taint the Linux kernel.
>>>>>
>>>>>    fs/ceph/mds_client.c |  3 ++-
>>>>>    fs/ceph/mds_client.h |  1 +
>>>>>    fs/ceph/snap.c       | 25 +++++++++++++++++++++++++
>>>>>    3 files changed, 28 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>>> index cbbaf334b6b8..59094944af28 100644
>>>>> --- a/fs/ceph/mds_client.c
>>>>> +++ b/fs/ceph/mds_client.c
>>>>> @@ -5648,7 +5648,8 @@ static void mds_peer_reset(struct
>>>>> ceph_connection *con)
>>>>>           struct ceph_mds_client *mdsc = s->s_mdsc;
>>>>>
>>>>>           pr_warn("mds%d closed our session\n", s->s_mds);
>>>>> -       send_mds_reconnect(mdsc, s);
>>>>> +       if (!mdsc->no_reconnect)
>>>>> +               send_mds_reconnect(mdsc, s);
>>>>>    }
>>>>>
>>>>>    static void mds_dispatch(struct ceph_connection *con, struct
>>>>> ceph_msg *msg)
>>>>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>>>>> index 728b7d72bf76..8e8f0447c0ad 100644
>>>>> --- a/fs/ceph/mds_client.h
>>>>> +++ b/fs/ceph/mds_client.h
>>>>> @@ -413,6 +413,7 @@ struct ceph_mds_client {
>>>>>           atomic_t                num_sessions;
>>>>>           int                     max_sessions;  /* len of sessions
>>>>> array */
>>>>>           int                     stopping;      /* true if shutting
>>>>> down */
>>>>> +       int                     no_reconnect;  /* true if snap trace
>>>>> is corrupted */
>>>>>
>>>>>           atomic64_t              quotarealms_count; /* # realms with
>>>>> quota */
>>>>>           /*
>>>>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>>>>> index c1c452afa84d..023852b7c527 100644
>>>>> --- a/fs/ceph/snap.c
>>>>> +++ b/fs/ceph/snap.c
>>>>> @@ -767,8 +767,10 @@ int ceph_update_snap_trace(struct
>>>>> ceph_mds_client *mdsc,
>>>>>           struct ceph_snap_realm *realm;
>>>>>           struct ceph_snap_realm *first_realm = NULL;
>>>>>           struct ceph_snap_realm *realm_to_rebuild = NULL;
>>>>> +       struct ceph_client *client = mdsc->fsc->client;
>>>>>           int rebuild_snapcs;
>>>>>           int err = -ENOMEM;
>>>>> +       int ret;
>>>>>           LIST_HEAD(dirty_realms);
>>>>>
>>>>>           lockdep_assert_held_write(&mdsc->snap_rwsem);
>>>>> @@ -885,6 +887,29 @@ int ceph_update_snap_trace(struct
>>>>> ceph_mds_client *mdsc,
>>>>>           if (first_realm)
>>>>>                   ceph_put_snap_realm(mdsc, first_realm);
>>>>>           pr_err("%s error %d\n", __func__, err);
>>>>> +
>>>>> +       /*
>>>>> +        * When receiving a corrupted snap trace we don't know what
>>>>> +        * exactly has happened in MDS side. And we shouldn't continue
>>>>> +        * writing to OSD, which may corrupt the snapshot contents.
>>>>> +        *
>>>>> +        * Just try to blocklist this kclient and if it fails we need
>>>>> +        * to crash the kclient instead of leaving it writeable.
>>>> Hi Xiubo,
>>>>
>>>> I'm not sure I understand this "let's blocklist ourselves" concept.
>>>> If the kernel client shouldn't continue writing to OSDs in this case,
>>>> why not just stop issuing writes -- perhaps initiating some equivalent
>>>> of a read-only remount like many local filesystems would do on I/O
>>>> errors (e.g. errors=remount-ro mode)?
>>> The following patch seems working. Let me do more test to make sure
>>> there is not further crash.
>>>
>>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>>> index c1c452afa84d..cd487f8a4cb5 100644
>>> --- a/fs/ceph/snap.c
>>> +++ b/fs/ceph/snap.c
>>> @@ -767,6 +767,7 @@ int ceph_update_snap_trace(struct ceph_mds_client
>>> *mdsc,
>>>          struct ceph_snap_realm *realm;
>>>          struct ceph_snap_realm *first_realm = NULL;
>>>          struct ceph_snap_realm *realm_to_rebuild = NULL;
>>> +       struct super_block *sb = mdsc->fsc->sb;
>>>          int rebuild_snapcs;
>>>          int err = -ENOMEM;
>>>          LIST_HEAD(dirty_realms);
>>> @@ -885,6 +886,9 @@ int ceph_update_snap_trace(struct ceph_mds_client
>>> *mdsc,
>>>          if (first_realm)
>>>                  ceph_put_snap_realm(mdsc, first_realm);
>>>          pr_err("%s error %d\n", __func__, err);
>>> +       pr_err("Remounting filesystem read-only\n");
>>> +       sb->s_flags |= SB_RDONLY;
>>> +
>>>          return err;
>>>   }
>>>
>>>
>> For readonly approach is also my first thought it should be, but I was
>> just not very sure whether it would be the best approach.
>>
>> Because by evicting the kclient we could prevent the buffer to be wrote
>> to OSDs. But the readonly one seems won't ?
> The read-only setting is more for the VFS and the user.  Technically,
> the kernel client could just stop issuing writes (i.e. OSD requests
> containing a write op) and not set SB_RDONLY.  That should cover any
> buffered data as well.

 From reading the local exit4 and other fs, they all doing it this way 
and the VFS will help stop further writing. Tested the above patch and 
it worked as expected.

I think to stop the following OSD requests we can just check the 
SB_RDONLY flag to prevent the buffer writeback.

> By employing self-blocklisting, you are shifting the responsibility
> of rejecting OSD requests to the OSDs.  I'm saying that not issuing
> OSD requests from a potentially busted client in the first place is
> probably a better idea.  At the very least you wouldn't need to BUG
> on ceph_monc_blocklist_add() errors.

I found an issue for the read-only approach:

In read-only mode it still can access to the MDSs and OSDs, which will 
continue trying to update the snap realms with the corrupted snap trace 
as before when reading. What if users try to read or backup the 
snapshots by using the corrupted snap realms ?

Isn't that a problem ?

Thanks

- Xiubo

> Thanks,
>
>                  Ilya
>

