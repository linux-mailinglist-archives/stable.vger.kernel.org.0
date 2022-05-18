Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD3152B984
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 14:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236119AbiERMGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 08:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236177AbiERMFx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 08:05:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 49E003B7
        for <stable@vger.kernel.org>; Wed, 18 May 2022 05:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652875548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tau4qa1wQeGvOeefxl39ZkROcFzCeP2pJ6BA0k6LMPU=;
        b=hMGZUzP6+EOeabJfp8wWsNWAEGVkgObhx7h4Pbmqa1t6YFjBK6xiWEjF+w2b8M8YsCrHlm
        JzO1GQd2++Bn8Aq91DA48o/osl/WtOJDom/HOEJ1aoOn2KYvZwn5x/UC99wdY2ubzlDR1F
        HTS/Ht4konRJiHYuSViU9sI1XPHAETc=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-SJSn2-bYPK6pVUtmedENUw-1; Wed, 18 May 2022 08:05:47 -0400
X-MC-Unique: SJSn2-bYPK6pVUtmedENUw-1
Received: by mail-pf1-f198.google.com with SMTP id z19-20020a62d113000000b0050d183adf6fso1095312pfg.19
        for <stable@vger.kernel.org>; Wed, 18 May 2022 05:05:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Tau4qa1wQeGvOeefxl39ZkROcFzCeP2pJ6BA0k6LMPU=;
        b=sztHkjCmzSYW7jfn4ndzb8SOAV1w6RL4YWOhnruIUFQEL+c2RCAAec/jkzoQSJNlpr
         7vsqVhIvNQdrImYTzqKSzQCILheCV5HRbxFzJWpMblgutT9gVxvlqBDk7WkScWvkr/ap
         V1T72HsLkCCBWjFYqfbfqjY27fM5w1yF4XHmg4dk4WDzqHz6DdD335BJCUP1x99HhmG4
         piZVH1HGLBWnpPHHVmyoKraLACS3CgREEap1kl3+gyNRy3gFjwMyhhtdm6Ig8s67X7t0
         y6MssC6CWJAlJnIks3BuETo0R5QiQ3rdctuWVGXeQwxBc58fHkyhXC1zGH/hz0lKboaY
         jZlA==
X-Gm-Message-State: AOAM5329r1EHMfRSJeqo+05vONx0QLh+Hi4lMDsRPnGsbhi6CPjGkewI
        K8s7PckTHFIqSoPNZvQdE3jgkm9mNw42OhuiaiNxpSTRRKhMK7XyElj7LjvN69oicfn7iDaHKGw
        MPpjTsal3DxUPyhtHev6GZ/Z891nOMHjmNVD8FJfiR7qEq3a/cGQe0ikZWF0YVfNjiQ==
X-Received: by 2002:a63:91c2:0:b0:3c6:24ac:9246 with SMTP id l185-20020a6391c2000000b003c624ac9246mr23673573pge.298.1652875545426;
        Wed, 18 May 2022 05:05:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw1IspqL4l6/rCJ8hcAT2iAmap/GyUDE5eljmGh2V185THVwS97F1DmViyB8W6HlXXv+izvzg==
X-Received: by 2002:a63:91c2:0:b0:3c6:24ac:9246 with SMTP id l185-20020a6391c2000000b003c624ac9246mr23673542pge.298.1652875545004;
        Wed, 18 May 2022 05:05:45 -0700 (PDT)
Received: from [10.72.12.136] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id jh9-20020a170903328900b0015e8d4eb1f8sm1526433plb.66.2022.05.18.05.05.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 05:05:44 -0700 (PDT)
Subject: Re: [PATCH] ceph: fix possible NULL pointer dereference of the ci
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Venky Shankar <vshankar@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        stable@vger.kernel.org
References: <20220510032703.588333-1-xiubli@redhat.com>
 <CAOi1vP_9Qz8b6PFJcRKAoC84-741fcxAGok+kfwgSSkHPi9SgQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f1aac895-84d0-428f-8f00-8ff8b4fed30e@redhat.com>
Date:   Wed, 18 May 2022 20:05:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP_9Qz8b6PFJcRKAoC84-741fcxAGok+kfwgSSkHPi9SgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 5/18/22 7:53 PM, Ilya Dryomov wrote:
> On Tue, May 10, 2022 at 5:27 AM Xiubo Li <xiubli@redhat.com> wrote:
>> When unmounting and if there still have some caps or capsnaps flushing
>> still not get the acks it will wait and dump them, but for the capsnaps
>> they didn't initialize the ->ci, so when deferencing the ->ci we will
>> see the kernel crash:
>>
>> kernel: ceph: dump_cap_flushes: still waiting for cap flushes through 45572:
>> kernel: ceph: 5000000008b:fffffffffffffffe Fw 23183 0 0
>> kernel: ceph: 5000000008a:fffffffffffffffe Fw 23184 0 0
>> kernel: ceph: 50000000089:fffffffffffffffe Fw 23185 0 0
>> kernel: ceph: 50000000084:fffffffffffffffe Fw 23189 0 0
>> kernel: ceph: 5000000007a:fffffffffffffffe Fw 23199 0 0
>> kernel: ceph: 50000000094:fffffffffffffffe Fw 23374 0 0
>> kernel: ceph: 50000000092:fffffffffffffffe Fw 23377 0 0
>> kernel: ceph: 50000000091:fffffffffffffffe Fw 23378 0 0
>> kernel: ceph: 5000000008e:fffffffffffffffe Fw 23380 0 0
>> kernel: ceph: 50000000087:fffffffffffffffe Fw 23382 0 0
>> kernel: ceph: 50000000086:fffffffffffffffe Fw 23383 0 0
>> kernel: ceph: 50000000083:fffffffffffffffe Fw 23384 0 0
>> kernel: ceph: 50000000082:fffffffffffffffe Fw 23385 0 0
>> kernel: ceph: 50000000081:fffffffffffffffe Fw 23386 0 0
>> kernel: ceph: 50000000080:fffffffffffffffe Fw 23387 0 0
>> kernel: ceph: 5000000007e:fffffffffffffffe Fw 23389 0 0
>> kernel: ceph: 5000000007b:fffffffffffffffe Fw 23392 0 0
>> kernel: BUG: kernel NULL pointer dereference, address: 0000000000000780
>> kernel: #PF: supervisor read access in kernel mode
>> kernel: #PF: error_code(0x0000) - not-present page
>> kernel: PGD 0 P4D 0
>> kernel: Oops: 0000 [#1] PREEMPT SMP PTI
>> kernel: CPU: 3 PID: 46268 Comm: umount Tainted: G S                5.18.0-rc2-ceph-g1771083b2f18 #1
>> kernel: Hardware name: Supermicro SYS-5018R-WR/X10SRW-F, BIOS 2.0 12/17/2015
>> kernel: RIP: 0010:ceph_mdsc_sync.cold.64+0x77/0xc3 [ceph]
>> kernel: RSP: 0018:ffffc90009c4fda8 EFLAGS: 00010212
>> kernel: RAX: 0000000000000000 RBX: ffff8881abf63000 RCX: 0000000000000000
>> kernel: RDX: 0000000000000000 RSI: ffffffff823932ad RDI: 0000000000000000
>> kernel: RBP: ffff8881abf634f0 R08: 0000000000005dc7 R09: c0000000ffffdfff
>> kernel: R10: 0000000000000001 R11: ffffc90009c4fbc8 R12: 0000000000000001
>> kernel: R13: 000000000000b204 R14: ffffffffa0ab3598 R15: ffff88815d36a110
>> kernel: FS:  00007f50eb25e080(0000) GS:ffff88885fcc0000(0000) knlGS:0000000000000000
>> kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> kernel: CR2: 0000000000000780 CR3: 0000000116ea2003 CR4: 00000000003706e0
>> kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> kernel: Call Trace:
>> kernel: <TASK>
>> kernel: ? schedstat_stop+0x10/0x10
>> kernel: ceph_sync_fs+0x2c/0x100 [ceph]
>> kernel: sync_filesystem+0x6d/0x90
>> kernel: generic_shutdown_super+0x22/0x120
>> kernel: kill_anon_super+0x14/0x30
>> kernel: ceph_kill_sb+0x36/0x90 [ceph]
>> kernel: deactivate_locked_super+0x29/0x60
>> kernel: cleanup_mnt+0xb8/0x140
>> kernel: task_work_run+0x6d/0xb0
>> kernel: exit_to_user_mode_prepare+0x226/0x230
>> kernel: syscall_exit_to_user_mode+0x25/0x60
>> kernel: do_syscall_64+0x40/0x80
>> kernel: entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> Cc: stable@vger.kernel.org
>> https://tracker.ceph.com/issues/55332
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c | 5 +++--
>>   fs/ceph/snap.c       | 1 +
>>   2 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 46a13ea9d284..e8c87dea0551 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -2001,10 +2001,11 @@ static void dump_cap_flushes(struct ceph_mds_client *mdsc, u64 want_tid)
>>          list_for_each_entry(cf, &mdsc->cap_flush_list, g_list) {
>>                  if (cf->tid > want_tid)
>>                          break;
>> -               pr_info("%llx:%llx %s %llu %llu %d\n",
>> +               pr_info("%llx:%llx %s %llu %llu %d%s\n",
>>                          ceph_vinop(&cf->ci->vfs_inode),
>>                          ceph_cap_string(cf->caps), cf->tid,
>> -                       cf->ci->i_last_cap_flush_ack, cf->wake);
>> +                       cf->ci->i_last_cap_flush_ack, cf->wake,
>> +                       cf->is_capsnap ? " is_capsnap" : "");
>>          }
>>          spin_unlock(&mdsc->cap_dirty_lock);
>>   }
>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>> index 322ee5add942..db1433ce666e 100644
>> --- a/fs/ceph/snap.c
>> +++ b/fs/ceph/snap.c
>> @@ -585,6 +585,7 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci,
>>               ceph_cap_string(dirty), capsnap->need_flush ? "" : "no_flush");
>>          ihold(inode);
>>
>> +       capsnap->cap_flush.ci = ci;
>>          capsnap->follows = old_snapc->seq;
>>          capsnap->issued = __ceph_caps_issued(ci, NULL);
>>          capsnap->dirty = dirty;
>> --
>> 2.36.0.rc1
>>
> Hi Xiubo,
>
> dump_cap_flushes() is not upstream.  Can this NULL dereference occur
> elsewhere or only when printing cap flushes?  In the latter case, this
> should just be folded into "ceph: dump info about cap flushes when
> we're waiting too long for them" in the testing branch.

Okay, checked this again only occur in the dump_cap_flushes() case.

Let's fold it to the previous one in testing branch.

-- Xiubo

> Thanks,
>
>                  Ilya
>

