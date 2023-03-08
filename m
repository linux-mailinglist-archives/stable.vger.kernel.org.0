Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B5A6AFD8D
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 04:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjCHDnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 22:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjCHDnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 22:43:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78808960B7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:42:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678246952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3CIFBPqlVsgi4mbIetMfKlJgaIVFbV+dfBNFlisMIHI=;
        b=K1vOK/aaSG1dIZoUjhsIGBIXk32zyzewPkE4qWGKG1lFbbqb7b3Pa27aTRlD8hqH7bB1pt
        LMPvdeqPzWxWCbIqUUBg33OTSyVVrkYkaDAZ8NFLpBSttauO8GOsze1s9ED5hgXBeXBNS4
        lLF2bDroY2hEmvyq4PxUG3WNYlajhKc=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-220-oPk9lbL7OT2_PJ1NqSi3Yw-1; Tue, 07 Mar 2023 22:42:31 -0500
X-MC-Unique: oPk9lbL7OT2_PJ1NqSi3Yw-1
Received: by mail-pg1-f200.google.com with SMTP id q68-20020a632a47000000b004f74bc0c71fso3533341pgq.18
        for <stable@vger.kernel.org>; Tue, 07 Mar 2023 19:42:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678246950;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3CIFBPqlVsgi4mbIetMfKlJgaIVFbV+dfBNFlisMIHI=;
        b=Fb7YAATNu7zziPog1XVyneWSzoC9KJlws+MZTSg+9QWxV8NVEI+Ds4lpn8qMEo9wRL
         cCkKax/nctjyJUaFYBtL4CsF3mdgwyX/fpVmeOa383rdJHK2icPcVcIEdZIrMDHrgvGA
         OfbXKkaFJ6yNQlLvsPwYrDiWClXwKdZWYajD/14DpxgrapjZkHq1ePxhRTVPH4OCsZea
         yx0XhYN+SbizZ4Tns/58dhKHeftehgjNul0/WVaR/9r/681wUPFpIBk2a3nUMX4gthg/
         KY7w2Dopvj80kfFbSFrqY6+GMVM0HAdHkTRTPGZR6eUGGw3TVihpar9hpXFmAKQC3CAm
         dzbw==
X-Gm-Message-State: AO0yUKVY41KurU7DZOYklXEF0K2sQvG7YVgEW8E2KF6fX9xTTXWoG0gL
        YOLHD4ZTi8aBmU5k8gZz8h9fh/+wrZUDmQ1LUgjhBxuRxvyl+mcJbS1O7Zqx8y8OIlS1tu66e+2
        wUlICDQxuA3awED97
X-Received: by 2002:a17:90a:e7c6:b0:234:8950:6d1f with SMTP id kb6-20020a17090ae7c600b0023489506d1fmr17707811pjb.11.1678246950033;
        Tue, 07 Mar 2023 19:42:30 -0800 (PST)
X-Google-Smtp-Source: AK7set8UPZv2ZLhfkS7n1EfbO2gitcf4in2vPM0ixlWMSTOQuUAZcsMtdcRJGanwFD1L7yFrBUKJ2w==
X-Received: by 2002:a17:90a:e7c6:b0:234:8950:6d1f with SMTP id kb6-20020a17090ae7c600b0023489506d1fmr17707795pjb.11.1678246949681;
        Tue, 07 Mar 2023 19:42:29 -0800 (PST)
Received: from [10.72.12.78] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id n3-20020a17090ade8300b00233864f21a7sm9868514pjv.51.2023.03.07.19.42.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 19:42:29 -0800 (PST)
Message-ID: <c2f9e0d3-0242-1304-26ea-04f25c3cdee4@redhat.com>
Date:   Wed, 8 Mar 2023 11:42:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] fs/ceph/mds_client: ignore responses for waiting requests
Content-Language: en-US
To:     Max Kellermann <max.kellermann@ionos.com>, idryomov@gmail.com,
        jlayton@kernel.org, ceph-devel@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20230302130650.2209938-1-max.kellermann@ionos.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230302130650.2209938-1-max.kellermann@ionos.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Max,

Sorry for late.

On 02/03/2023 21:06, Max Kellermann wrote:
> If a request is put on the waiting list, its submission is postponed
> until the session becomes ready (e.g. via `mdsc->waiting_for_map` or
> `session->s_waiting`).  If a `CEPH_MSG_CLIENT_REPLY` happens to be
> received before `CEPH_MSG_MDS_MAP`, the request gets freed, and then
> this assertion fails:

How could this happen ?

Since the req hasn't been submitted yet, how could it receive a reply 
normally ?

>   WARN_ON_ONCE(!list_empty(&req->r_wait));
>
> This occurred on a server after the Ceph MDS connection failed, and a
> corrupt reply packet was received for a waiting request:
>
>   libceph: mds1 (1)10.0.0.10:6801 socket error on write
>   libceph: mds1 (1)10.0.0.10:6801 session reset
>   ceph: mds1 closed our session
>   ceph: mds1 reconnect start
>   ceph: mds1 reconnect success
>   ceph: problem parsing mds trace -5
>   ceph: mds parse_reply err -5
>   ceph: mdsc_handle_reply got corrupt reply mds1(tid:5530222)

It should be a corrupted reply and it lead us to get a incorrect req, 
which hasn't been submitted yet.

BTW, do you have the dump of the corrupted msg by 'ceph_msg_dump(msg)' ?

We can check what have corrupted exactly.

Thanks

- Xiubo

>   [...]
>   ------------[ cut here ]------------
>   WARNING: CPU: 9 PID: 229180 at fs/ceph/mds_client.c:966 ceph_mdsc_release_request+0x17a/0x180
>   Modules linked in:
>   CPU: 9 PID: 229180 Comm: kworker/9:3 Not tainted 6.1.8-cm4all1 #45
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
>   Workqueue: ceph-msgr ceph_con_workfn
>   RIP: 0010:ceph_mdsc_release_request+0x17a/0x180
>   Code: 39 d8 75 26 5b 48 89 ee 48 8b 3d f9 2d 04 02 5d e9 fb 01 c9 ff e8 56 85 ab ff eb 9c 48 8b 7f 58 e8 db 4d ff ff e9 a4 fe ff ff <0f> 0b eb d6 66 90 0f 1f 44 00 00 41 54 48 8d 86 b8 03 00 00 55 4c
>   RSP: 0018:ffffa6f2c0e2bd20 EFLAGS: 00010287
>   RAX: ffff8f58b93687f8 RBX: ffff8f592f6374a8 RCX: 0000000000000aed
>   RDX: 0000000000000ac0 RSI: 0000000000000000 RDI: 0000000000000000
>   RBP: ffff8f592f637148 R08: 0000000000000001 R09: ffffffffa901de00
>   R10: 0000000000000001 R11: ffffd630ad09dfc8 R12: ffff8f58b9368000
>   R13: ffff8f5806b33800 R14: ffff8f58894f6780 R15: 000000000054626e
>   FS:  0000000000000000(0000) GS:ffff8f630f040000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 00007ffc2926df68 CR3: 0000000218dce002 CR4: 00000000001706e0
>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>   Call Trace:
>    <TASK>
>    mds_dispatch+0xec5/0x1460
>    ? inet_recvmsg+0x4d/0xf0
>    ceph_con_process_message+0x6b/0x80
>    ceph_con_v1_try_read+0xb92/0x1400
>    ceph_con_workfn+0x383/0x4e0
>    process_one_work+0x1da/0x370
>    ? process_one_work+0x370/0x370
>    worker_thread+0x4d/0x3c0
>    ? process_one_work+0x370/0x370
>    kthread+0xbb/0xe0
>    ? kthread_complete_and_exit+0x20/0x20
>    ret_from_fork+0x22/0x30
>    </TASK>
>   ---[ end trace 0000000000000000 ]---
>   ceph: mds1 caps renewed
>
> If we know that a request has not yet been submitted, we should ignore
> all responses for it, just like we ignore responses for unknown TIDs.
>
> To: ceph-devel@vger.kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
>   fs/ceph/mds_client.c | 7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 27a245d959c0..fa74fdb2cbfb 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -3275,6 +3275,13 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
>   	}
>   	dout("handle_reply %p\n", req);
>   
> +	/* waiting, not yet submitted? */
> +	if (!list_empty(&req->r_wait)) {
> +		pr_err("mdsc_handle_reply on waiting request tid %llu\n", tid);
> +		mutex_unlock(&mdsc->mutex);
> +		goto out;
> +	}
> +
>   	/* correct session? */
>   	if (req->r_session != session) {
>   		pr_err("mdsc_handle_reply got %llu on session mds%d"

-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li

