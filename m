Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0240962383F
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 01:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbiKJAlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 19:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbiKJAlT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 19:41:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6C61A3B9
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 16:40:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668040824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jb+GWG4SzKFOnPzGT0XrHEOZTpBZHmVwqAFCx+Hy5kI=;
        b=amt1pM6xaahF8KPVaduRFNEGhcTEeO0CtVmtIjn930Dks8WiI4E9W+6dmB9ryJagKRqbQD
        jliMezjA3pKOvCo/irwxlL4wjb2Ax56oLr/mkesB68DALJ4J6ALxGJSgSspsGuGCPQXlpw
        vmi6iAo73cpp4uFcTLQR73C2fMPW7TU=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-313-FMEWEkM2M5aoTfrDPmi65A-1; Wed, 09 Nov 2022 19:40:23 -0500
X-MC-Unique: FMEWEkM2M5aoTfrDPmi65A-1
Received: by mail-pj1-f72.google.com with SMTP id q1-20020a17090aa00100b002139a592adbso2350831pjp.1
        for <stable@vger.kernel.org>; Wed, 09 Nov 2022 16:40:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jb+GWG4SzKFOnPzGT0XrHEOZTpBZHmVwqAFCx+Hy5kI=;
        b=jgO3T0VqpbOVHmR6ZTrlqoO1I69Uh7cP0161C8lWV7TZfOUi3TNea53jQ3NeabJMpT
         RNMLzmqws6j1IpzJdNNv+eLWUEK0y8upnxUE3r5TbR24dVlgaDqpD+sZNeuJ0CM/11eR
         tLhGO3VAp3qWk8YYlco2HycNGBrnPNkCwBWTud8rK6GGIsWog2kkzCyFHGURPdhbqawb
         ItkeN6kGGMu5lAgI1iUXV/Cxxwih/ZC+0hSfuoOkgxp/i5XR2QptxCsItrBx91oDkD0+
         wGnr6R/dctnCzwj3fKaT3wcZQyKSYnHZaXKDLQrTwLgc6BdW+b6KegaHq8EL46KbZWs6
         cw2Q==
X-Gm-Message-State: ACrzQf1YEeBj5dJpSAYaqUhUget3QaaAyCnPdGt8v+1ckMtzTWrgt3Nz
        l81nFjrEUWgx4HxxwwDQdEQkz8KquTd/e00iTa4MN6AgisQ8fUHR3hTByL+u3doDD3152pYOe5n
        7UMl2pe3MXzKPXuoixTMbdRDC3PKwAKQqWhsRW5JS2jXbgOLrrrXzcVKum81R7/x/mQ==
X-Received: by 2002:a05:6a00:24cb:b0:56c:7815:bc7d with SMTP id d11-20020a056a0024cb00b0056c7815bc7dmr63590794pfv.44.1668040822669;
        Wed, 09 Nov 2022 16:40:22 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7ZpgS7/OFbLbJ+1mazloO3fkN7FvJ/RHkaTNd1GWeJSzUBIYvORYdPKhiE7Q2TQ49onDSPWg==
X-Received: by 2002:a05:6a00:24cb:b0:56c:7815:bc7d with SMTP id d11-20020a056a0024cb00b0056c7815bc7dmr63590772pfv.44.1668040822254;
        Wed, 09 Nov 2022 16:40:22 -0800 (PST)
Received: from [10.72.12.148] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id h4-20020a170902680400b00186efc56ab9sm9667549plk.221.2022.11.09.16.40.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 16:40:21 -0800 (PST)
Subject: Re: [PATCH v3] ceph: fix NULL pointer dereference for req->r_session
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, lhenriques@suse.de, jlayton@kernel.org,
        mchangir@redhat.com, stable@vger.kernel.org
References: <20221108135554.558278-1-xiubli@redhat.com>
 <CAOi1vP8Fkzq542St9od7G_JnQyS93=BgLLRUE86-E-Zw4MEt3g@mail.gmail.com>
 <c905be56-ba74-9a86-1aff-3fb17a157932@redhat.com>
 <CAOi1vP91fd=TpnPio0rtMcpepqz4u3r1HsXmp8+WC7dfy2rZ2w@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d0afa98d-b37a-94f5-398d-de8401d96e4d@redhat.com>
Date:   Thu, 10 Nov 2022 08:40:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP91fd=TpnPio0rtMcpepqz4u3r1HsXmp8+WC7dfy2rZ2w@mail.gmail.com>
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


On 09/11/2022 22:16, Ilya Dryomov wrote:
> On Wed, Nov 9, 2022 at 3:12 PM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 09/11/2022 20:56, Ilya Dryomov wrote:
>>> On Tue, Nov 8, 2022 at 2:56 PM <xiubli@redhat.com> wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> The request's r_session maybe changed when it was forwarded or
>>>> resent.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> URL: https://bugzilla.redhat.com/show_bug.cgi?id=2137955
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/caps.c | 60 ++++++++++++++++----------------------------------
>>>>    1 file changed, 19 insertions(+), 41 deletions(-)
>>>>
>>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>>> index 894adfb4a092..83f9e18e3169 100644
>>>> --- a/fs/ceph/caps.c
>>>> +++ b/fs/ceph/caps.c
>>>> @@ -2297,8 +2297,10 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>>>           struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
>>>>           struct ceph_inode_info *ci = ceph_inode(inode);
>>>>           struct ceph_mds_request *req1 = NULL, *req2 = NULL;
>>>> +       struct ceph_mds_session **sessions = NULL;
>>>> +       struct ceph_mds_session *s;
>>>>           unsigned int max_sessions;
>>>> -       int ret, err = 0;
>>>> +       int i, ret, err = 0;
>>>>
>>>>           spin_lock(&ci->i_unsafe_lock);
>>>>           if (S_ISDIR(inode->i_mode) && !list_empty(&ci->i_unsafe_dirops)) {
>>>> @@ -2315,28 +2317,19 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>>>           }
>>>>           spin_unlock(&ci->i_unsafe_lock);
>>>>
>>>> -       /*
>>>> -        * The mdsc->max_sessions is unlikely to be changed
>>>> -        * mostly, here we will retry it by reallocating the
>>>> -        * sessions array memory to get rid of the mdsc->mutex
>>>> -        * lock.
>>>> -        */
>>>> -retry:
>>>> -       max_sessions = mdsc->max_sessions;
>>>> -
>>>>           /*
>>>>            * Trigger to flush the journal logs in all the relevant MDSes
>>>>            * manually, or in the worst case we must wait at most 5 seconds
>>>>            * to wait the journal logs to be flushed by the MDSes periodically.
>>>>            */
>>>> -       if ((req1 || req2) && likely(max_sessions)) {
>>>> -               struct ceph_mds_session **sessions = NULL;
>>>> -               struct ceph_mds_session *s;
>>>> +       mutex_lock(&mdsc->mutex);
>>>> +       max_sessions = mdsc->max_sessions;
>>>> +       if (req1 || req2) {
>>>>                   struct ceph_mds_request *req;
>>>> -               int i;
>>>>
>>>>                   sessions = kcalloc(max_sessions, sizeof(s), GFP_KERNEL);
>>>>                   if (!sessions) {
>>>> +                       mutex_unlock(&mdsc->mutex);
>>>>                           err = -ENOMEM;
>>>>                           goto out;
>>>>                   }
>>>> @@ -2346,18 +2339,8 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>>>                           list_for_each_entry(req, &ci->i_unsafe_dirops,
>>>>                                               r_unsafe_dir_item) {
>>>>                                   s = req->r_session;
>>>> -                               if (!s)
>>>> +                               if (!s || unlikely(s->s_mds >= max_sessions))
>>>>                                           continue;
>>>> -                               if (unlikely(s->s_mds >= max_sessions)) {
>>>> -                                       spin_unlock(&ci->i_unsafe_lock);
>>>> -                                       for (i = 0; i < max_sessions; i++) {
>>>> -                                               s = sessions[i];
>>>> -                                               if (s)
>>>> -                                                       ceph_put_mds_session(s);
>>>> -                                       }
>>>> -                                       kfree(sessions);
>>>> -                                       goto retry;
>>>> -                               }
>>>>                                   if (!sessions[s->s_mds]) {
>>>>                                           s = ceph_get_mds_session(s);
>>>>                                           sessions[s->s_mds] = s;
>>>> @@ -2368,18 +2351,8 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>>>                           list_for_each_entry(req, &ci->i_unsafe_iops,
>>>>                                               r_unsafe_target_item) {
>>>>                                   s = req->r_session;
>>>> -                               if (!s)
>>>> +                               if (!s || unlikely(s->s_mds >= max_sessions))
>>>>                                           continue;
>>>> -                               if (unlikely(s->s_mds >= max_sessions)) {
>>>> -                                       spin_unlock(&ci->i_unsafe_lock);
>>>> -                                       for (i = 0; i < max_sessions; i++) {
>>>> -                                               s = sessions[i];
>>>> -                                               if (s)
>>>> -                                                       ceph_put_mds_session(s);
>>>> -                                       }
>>>> -                                       kfree(sessions);
>>>> -                                       goto retry;
>>>> -                               }
>>>>                                   if (!sessions[s->s_mds]) {
>>>>                                           s = ceph_get_mds_session(s);
>>>>                                           sessions[s->s_mds] = s;
>>>> @@ -2391,13 +2364,18 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>>>                   /* the auth MDS */
>>>>                   spin_lock(&ci->i_ceph_lock);
>>>>                   if (ci->i_auth_cap) {
>>>> -                     s = ci->i_auth_cap->session;
>>>> -                     if (!sessions[s->s_mds])
>>>> -                             sessions[s->s_mds] = ceph_get_mds_session(s);
>>>> +                       s = ci->i_auth_cap->session;
>>>> +                       if (likely(s->s_mds < max_sessions)
>>>> +                           && !sessions[s->s_mds]) {
>>> Hi Xiubo,
>>>
>>> Nit: keep && on the previous line for style consistency.
>> Sure. Will fix it.
>>
>>
>>>> +                               sessions[s->s_mds] = ceph_get_mds_session(s);
>>>> +                       }
>>>>                   }
>>>>                   spin_unlock(&ci->i_ceph_lock);
>>>> +       }
>>>> +       mutex_unlock(&mdsc->mutex);
>>>>
>>>> -               /* send flush mdlog request to MDSes */
>>>> +       /* send flush mdlog request to MDSes */
>>>> +       if (sessions) {
>>> Since mdlog is flushed only in "if (req1 || req2)" case, why not keep
>>> max_sessions loop there and avoid sessions != NULL check?
>> This is because I must drop the mdsc->mutex before calling
>> "send_flush_mdlog()" in the max_sessions loop.
> If you move mdsc->mutex acquisition and max_sessions assignment
> into "if (req1 || req2)" branch, it can be trivially dropped before
> the loop.

Okay, sounds good.

Thanks!

- Xiubo


> Thanks,
>
>                  Ilya
>

