Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D78F4687F14
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 14:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbjBBNs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 08:48:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjBBNsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 08:48:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7453B8C42B
        for <stable@vger.kernel.org>; Thu,  2 Feb 2023 05:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675345650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eAbt5OtJuHIAXkaq+m0Iqxz3Igr5grGu87eY0mhkgew=;
        b=DrUvT9Ohun4DGHZjpYnRaKk7coi9BSeLhpjx59AUabDg5nF9y1ATcxO6lTkC/4TibWUijY
        uChhpbeDFPWe+zWpuAVjB/8a8ubIq0TyRfYUAJZ9QkgK8lUXV7p3EFf7+uTkdQIYgcydVG
        55a0AOepUbTlSIg+0zwx6gPJJ5nqzE0=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-408-Fp9XVhv0PXqX-_TR2Fb-zA-1; Thu, 02 Feb 2023 08:47:29 -0500
X-MC-Unique: Fp9XVhv0PXqX-_TR2Fb-zA-1
Received: by mail-pj1-f71.google.com with SMTP id dt6-20020a17090afa4600b00230183006c3so1032019pjb.7
        for <stable@vger.kernel.org>; Thu, 02 Feb 2023 05:47:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eAbt5OtJuHIAXkaq+m0Iqxz3Igr5grGu87eY0mhkgew=;
        b=KUMkGmX0qylYvzCG/tNcKAU2dD4qGrtCh8gF8RwhgSJNhsfJLy2iM7+Eb1TULJVv6+
         LVUtFTMCM0GHe4608TrYnXXpGdrnmzA7AKUxgO2wDIijHJP9JHQzTt0fH7L48xDRKfYA
         GiIyCbdEdAuQGpJM+mNIM6yDjs9ZnSnw5zvhXBrog3gXHsg7ZmMm1I0P1Jqe7VsxfTRJ
         0+a+VccungYEKlSH/7QywMG4Gb1BjSfDaKGt40609KxJ6qdbKExs0FbnU1Qkyeu1j9Y0
         7QW5/7ktH8gnw7S1jeECqomoPO6rWC+CwqB0kDE+Sq6+3jivEPqreurDkG9lRmUyypXE
         uxxg==
X-Gm-Message-State: AO0yUKU9eesyi+asTMgjgD8eGTUxN/4l3Tj8lSW6cmmmMOKYYM5T8Yx+
        CzDdhCtfOE1T9pz4a3/tfae2cZ+UuBdvt21GG26A5sCvz3XtKuw+dqMFtikEkUZ3OGAPYyQB3Vj
        5sXdfI0el+E3DgDyl
X-Received: by 2002:a17:903:22c4:b0:188:6a62:9d89 with SMTP id y4-20020a17090322c400b001886a629d89mr2265234plg.54.1675345648582;
        Thu, 02 Feb 2023 05:47:28 -0800 (PST)
X-Google-Smtp-Source: AK7set9hpEQsjhJs6g1oESB+NQpO7vyVwQ5n/DxiSDRyuH6zY29ijUVELaTFFvtNMSrnFqX4rsUU1A==
X-Received: by 2002:a17:903:22c4:b0:188:6a62:9d89 with SMTP id y4-20020a17090322c400b001886a629d89mr2265220plg.54.1675345648227;
        Thu, 02 Feb 2023 05:47:28 -0800 (PST)
Received: from [10.72.13.217] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v21-20020a1709028d9500b001967afdbcb8sm2555011plo.212.2023.02.02.05.47.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 05:47:27 -0800 (PST)
Message-ID: <fd42a194-cd96-6a12-2bad-19136f1f29eb@redhat.com>
Date:   Thu, 2 Feb 2023 21:47:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v7 2/2] ceph: blocklist the kclient when receiving
 corrupted snap trace
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, vshankar@redhat.com, lhenriques@suse.de,
        stable@vger.kernel.org
References: <20230201013645.404251-1-xiubli@redhat.com>
 <20230201013645.404251-3-xiubli@redhat.com>
 <CAOi1vP-4VF1XukTdhESgHHZbWK6A-p1yZ3_x3viSUfm_vu58rA@mail.gmail.com>
 <b3abcaaf-f48a-5666-733d-073f2cf876bd@redhat.com>
 <CAOi1vP_cKdoiThzu-GM2isauzVN2rvCjo+ViRr4qmMSs+1Op=A@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP_cKdoiThzu-GM2isauzVN2rvCjo+ViRr4qmMSs+1Op=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 02/02/2023 21:11, Ilya Dryomov wrote:
> On Thu, Feb 2, 2023 at 3:30 AM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 01/02/2023 21:12, Ilya Dryomov wrote:
>>> On Wed, Feb 1, 2023 at 2:37 AM <xiubli@redhat.com> wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> When received corrupted snap trace we don't know what exactly has
>>>> happened in MDS side. And we shouldn't continue IOs and metadatas
>>>> access to MDS, which may corrupt or get incorrect contents.
>>>>
>>>> This patch will just block all the further IO/MDS requests
>>>> immediately and then evict the kclient itself.
>>>>
>>>> The reason why we still need to evict the kclient just after
>>>> blocking all the further IOs is that the MDS could revoke the caps
>>>> faster.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> URL: https://tracker.ceph.com/issues/57686
>>>> Reviewed-by: Venky Shankar <vshankar@redhat.com>
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/addr.c       | 17 +++++++++++++++--
>>>>    fs/ceph/caps.c       | 16 +++++++++++++---
>>>>    fs/ceph/file.c       |  9 +++++++++
>>>>    fs/ceph/mds_client.c | 28 +++++++++++++++++++++++++---
>>>>    fs/ceph/snap.c       | 38 ++++++++++++++++++++++++++++++++++++--
>>>>    fs/ceph/super.h      |  1 +
>>>>    6 files changed, 99 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>>>> index 8c74871e37c9..cac4083e387a 100644
>>>> --- a/fs/ceph/addr.c
>>>> +++ b/fs/ceph/addr.c
>>>> @@ -305,7 +305,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
>>>>           struct inode *inode = rreq->inode;
>>>>           struct ceph_inode_info *ci = ceph_inode(inode);
>>>>           struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
>>>> -       struct ceph_osd_request *req;
>>>> +       struct ceph_osd_request *req = NULL;
>>>>           struct ceph_vino vino = ceph_vino(inode);
>>>>           struct iov_iter iter;
>>>>           struct page **pages;
>>>> @@ -313,6 +313,11 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
>>>>           int err = 0;
>>>>           u64 len = subreq->len;
>>>>
>>>> +       if (ceph_inode_is_shutdown(inode)) {
>>>> +               err = -EIO;
>>>> +               goto out;
>>>> +       }
>>>> +
>>>>           if (ceph_has_inline_data(ci) && ceph_netfs_issue_op_inline(subreq))
>>>>                   return;
>>>>
>>>> @@ -563,6 +568,9 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>>>>
>>>>           dout("writepage %p idx %lu\n", page, page->index);
>>>>
>>>> +       if (ceph_inode_is_shutdown(inode))
>>>> +               return -EIO;
>>>> +
>>>>           /* verify this is a writeable snap context */
>>>>           snapc = page_snap_context(page);
>>>>           if (!snapc) {
>>>> @@ -1643,7 +1651,7 @@ int ceph_uninline_data(struct file *file)
>>>>           struct ceph_inode_info *ci = ceph_inode(inode);
>>>>           struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
>>>>           struct ceph_osd_request *req = NULL;
>>>> -       struct ceph_cap_flush *prealloc_cf;
>>>> +       struct ceph_cap_flush *prealloc_cf = NULL;
>>>>           struct folio *folio = NULL;
>>>>           u64 inline_version = CEPH_INLINE_NONE;
>>>>           struct page *pages[1];
>>>> @@ -1657,6 +1665,11 @@ int ceph_uninline_data(struct file *file)
>>>>           dout("uninline_data %p %llx.%llx inline_version %llu\n",
>>>>                inode, ceph_vinop(inode), inline_version);
>>>>
>>>> +       if (ceph_inode_is_shutdown(inode)) {
>>>> +               err = -EIO;
>>>> +               goto out;
>>>> +       }
>>>> +
>>>>           if (inline_version == CEPH_INLINE_NONE)
>>>>                   return 0;
>>>>
>>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>>> index f75ad432f375..210e40037881 100644
>>>> --- a/fs/ceph/caps.c
>>>> +++ b/fs/ceph/caps.c
>>>> @@ -4078,6 +4078,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>>>>           void *p, *end;
>>>>           struct cap_extra_info extra_info = {};
>>>>           bool queue_trunc;
>>>> +       bool close_sessions = false;
>>>>
>>>>           dout("handle_caps from mds%d\n", session->s_mds);
>>>>
>>>> @@ -4215,9 +4216,13 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>>>>                   realm = NULL;
>>>>                   if (snaptrace_len) {
>>>>                           down_write(&mdsc->snap_rwsem);
>>>> -                       ceph_update_snap_trace(mdsc, snaptrace,
>>>> -                                              snaptrace + snaptrace_len,
>>>> -                                              false, &realm);
>>>> +                       if (ceph_update_snap_trace(mdsc, snaptrace,
>>>> +                                                  snaptrace + snaptrace_len,
>>>> +                                                  false, &realm)) {
>>>> +                               up_write(&mdsc->snap_rwsem);
>>>> +                               close_sessions = true;
>>>> +                               goto done;
>>>> +                       }
>>>>                           downgrade_write(&mdsc->snap_rwsem);
>>>>                   } else {
>>>>                           down_read(&mdsc->snap_rwsem);
>>>> @@ -4277,6 +4282,11 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>>>>           iput(inode);
>>>>    out:
>>>>           ceph_put_string(extra_info.pool_ns);
>>>> +
>>>> +       /* Defer closing the sessions after s_mutex lock being released */
>>>> +       if (close_sessions)
>>>> +               ceph_mdsc_close_sessions(mdsc);
>>>> +
>>>>           return;
>>>>
>>>>    flush_cap_releases:
>>>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>>>> index 764598e1efd9..3fbf4993d15d 100644
>>>> --- a/fs/ceph/file.c
>>>> +++ b/fs/ceph/file.c
>>>> @@ -943,6 +943,9 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>>>>           dout("sync_read on file %p %llu~%u %s\n", file, off, (unsigned)len,
>>>>                (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
>>>>
>>>> +       if (ceph_inode_is_shutdown(inode))
>>>> +               return -EIO;
>>> Hi Xiubo,
>>>
>>> ceph_sync_read() is called only from ceph_read_iter() which already
>>> checks for ceph_inode_is_shutdown() (although the generated error is
>>> ESTALE instead of EIO).  Is the new one in ceph_sync_read() actually
>>> needed?
>>>
>>> If the answer is yes, why hasn't a corresponding check been added to
>>> ceph_sync_write()?
>> Before I generated this patch based on the fscrypt patches,  this will
>> be renamed to __ceph_sync_read() and also will be called by
>> fill_fscrypt_truncate(). I just forgot this and after rebasing I didn't
>> adjust it.
>>
>> I have updated the 'wip-snap-trace-blocklist' branch by removing it from
>> here and ceph_direct_read_write(). And I will fix this later in the
>> fscrypt patches.
> Hi Xiubo,
>
> The latest revision looks fine.  I folded the "ceph: dump the msg when
> receiving a corrupt snap trace" follow-up into this patch and pulled the
> result into master.
>
> I also rebased testing appropriately, feel free to perform the necessary
> fscrypt-related fixups there!

Sure. Thanks Ilya.

-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li

