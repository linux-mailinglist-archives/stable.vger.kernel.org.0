Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D03645AA9
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 14:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiLGNUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 08:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiLGNUh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 08:20:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4341408A
        for <stable@vger.kernel.org>; Wed,  7 Dec 2022 05:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670419180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rEY8tGYEjnNoOVm+8lWI3i1gdYr125wtjmJM/wJadAc=;
        b=VMBuFE1hUaU+Xm45McsVpcDTYYEEFO5upOZ2fcPcNAwyxCLPTjJZIT7rn4UYsTferVkuRY
        cKDyAXZ1H287MUk+fHHmVtzYyBvRFgqYkho7uEQn9EHA9KlC2pAlf2+S9Ul8mtIJADQb14
        h2p/J5QvvvopuE3vyrMex3HSmhfhqxs=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-202-FGVIN4QQO82ZX5JcvSB4Tw-1; Wed, 07 Dec 2022 08:19:39 -0500
X-MC-Unique: FGVIN4QQO82ZX5JcvSB4Tw-1
Received: by mail-pl1-f198.google.com with SMTP id l10-20020a170902f68a00b00189d1728848so9077330plg.2
        for <stable@vger.kernel.org>; Wed, 07 Dec 2022 05:19:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rEY8tGYEjnNoOVm+8lWI3i1gdYr125wtjmJM/wJadAc=;
        b=6d2kvRCrE7D2WSOsKqi5G4+PuzOzwTu2VpezNpzFCJ2bRM9umskxGWVuguGF7MH2WF
         ggPxKZYtwOREm84LyMRH9ONrDZ1Wz+yKNQL93/EN20PxDeMYkRFilBZNr2rCmPUwB3rL
         +MOV2OUK3D8cW4686rsocnT2XQB1tubbKOd3YHiVSxC+xbO4mOTnQimqmCyCExa5/VHt
         2Y0D89r6DJWNLoTeSuxYV53hDZyVqedy/8e/g3udz4NeCKB9Zj+hj/Igc4mBY+F0b7/e
         V8fRS9IQF3YqjTP80Spj7Riw8/6oJlKjKzSa99smnjFP2xoT8iWcJMisVuCdv6OjBBb+
         pvAA==
X-Gm-Message-State: ANoB5pnlMXVQccSR6cxOl3WAK5Pw3PEfX1ycW35tYt562cIncqr+bqas
        JRnWy9OB7FZZ0GDmGnljxrQRMBi3uMP0uZbgORX7V5Sx3OECb+BTeg7Sbxoshd54eRCIQTmo/dG
        z3Oz7awJVXzO+BRzqMXni8FDHyUJqPZVJtlF7QGyg1Exuq3c37NYSsgNHaPlISITVKA==
X-Received: by 2002:a17:902:e352:b0:189:c592:a4f4 with SMTP id p18-20020a170902e35200b00189c592a4f4mr21311406plc.82.1670419178035;
        Wed, 07 Dec 2022 05:19:38 -0800 (PST)
X-Google-Smtp-Source: AA0mqf41tmPmsi7A/dpr27ysoYGNtPfJK+J5L5DWpxjFZDDc2XpvcgoNV67xV4SPY5khktBxAA+Kjg==
X-Received: by 2002:a17:902:e352:b0:189:c592:a4f4 with SMTP id p18-20020a170902e35200b00189c592a4f4mr21311374plc.82.1670419177614;
        Wed, 07 Dec 2022 05:19:37 -0800 (PST)
Received: from [10.72.12.134] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id l7-20020a63da47000000b0046f56534d9fsm11462742pgj.21.2022.12.07.05.19.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 05:19:37 -0800 (PST)
Subject: Re: [PATCH v3] ceph: blocklist the kclient when receiving corrupted
 snap trace
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, atomlin@atomlin.com, stable@vger.kernel.org
References: <20221206125915.37404-1-xiubli@redhat.com>
 <CAOi1vP8hkXZ7w9D5LnMViyjqVCmsKo3H2dg1QpzgHCPuNfvACQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <baa681e9-4472-bcfb-601f-132dc6658888@redhat.com>
Date:   Wed, 7 Dec 2022 21:19:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP8hkXZ7w9D5LnMViyjqVCmsKo3H2dg1QpzgHCPuNfvACQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
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

The following patch seems working. Let me do more test to make sure 
there is not further crash.

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index c1c452afa84d..cd487f8a4cb5 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -767,6 +767,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
         struct ceph_snap_realm *realm;
         struct ceph_snap_realm *first_realm = NULL;
         struct ceph_snap_realm *realm_to_rebuild = NULL;
+       struct super_block *sb = mdsc->fsc->sb;
         int rebuild_snapcs;
         int err = -ENOMEM;
         LIST_HEAD(dirty_realms);
@@ -885,6 +886,9 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
         if (first_realm)
                 ceph_put_snap_realm(mdsc, first_realm);
         pr_err("%s error %d\n", __func__, err);
+       pr_err("Remounting filesystem read-only\n");
+       sb->s_flags |= SB_RDONLY;
+
         return err;
  }




>
> Or, perhaps, all in-memory snap contexts could somehow be invalidated
> in this case, making writes fail naturally -- on the client side,
> without actually being sent to OSDs just to be nixed by the blocklist
> hammer.
>
> But further, what makes a failure to decode a snap trace special?
> AFAIK we don't do anything close to this for any other decoding
> failure.  Wouldn't "when received corrupted XYZ we don't know what
> exactly has happened in MDS side" argument apply to pretty much all
> decoding failures?
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
>
> Thanks,
>
>                  Ilya
>

