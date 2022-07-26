Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90AF4581200
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 13:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbiGZLc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 07:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbiGZLc5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 07:32:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9149332073
        for <stable@vger.kernel.org>; Tue, 26 Jul 2022 04:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658835174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iLV5eywyB/Q9GMQl7UuLpbFqXb2FtM3pBpyBw7Z5iWU=;
        b=Pc++i3jM1QjXMwiiwuPha2RONqxaMNa6kgCDW+qjvQCzn6LxTOLDjq/t1sDtbpIj516oWz
        GbslngyqWABFt4oYNjGb0DoiJW9/GvjLqt1A35MRXESNv3CuDJVaX55aq9LhhmtCjIMtXI
        nvunni9OeyPO2BhXN7CIVxKUMurm0cI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-231-3BuHiRTdNYefafMbU-MZug-1; Tue, 26 Jul 2022 07:32:53 -0400
X-MC-Unique: 3BuHiRTdNYefafMbU-MZug-1
Received: by mail-wr1-f72.google.com with SMTP id s16-20020adf9790000000b0021e36810385so2052668wrb.15
        for <stable@vger.kernel.org>; Tue, 26 Jul 2022 04:32:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=iLV5eywyB/Q9GMQl7UuLpbFqXb2FtM3pBpyBw7Z5iWU=;
        b=6NDeMVmMdQgTQqbWqsDEQIT13KglrjdcB8219ZZljtcq2EMth6HZBpZQKKs/b/qozv
         PB7kV7E9/3fDoeTqo6KT4hdrvVL2dVij6KyfY7x4vHmFxmMxmZf1N7QgNUPI121fU40v
         XjfHNV/Al5If/HqMKWGO2Xg8urT02SQx7NXpn39mLTo112Hoj6YXXxuKO5c0RBtg+yFx
         YA1N56Kwz1HJJWgKsGjPrpcT6BUa6IZptXPUfDn56FClJbrScmxxVXK7qcRzHuawCQUa
         +CKdXD1geoPu0cUNUlAjQzZ72aEl9xtZXXiopc5fgEODZzx0gg5A4V5cJ9YIv74/XKI/
         3kmQ==
X-Gm-Message-State: AJIora+dSlJPEsv6QtBl6gezL0kFedXdYPiB/7/XKWMS44bexBXUfrIx
        yFwUgeesH537bV6nuvXnGlx8T9eNpsgcF7y+WBpcBkqxz53MYg4H4oHJcVCvg43F0YayinobAzR
        9KJeGL6bzM74UhzV4
X-Received: by 2002:a05:600c:1d8a:b0:3a3:1104:88ad with SMTP id p10-20020a05600c1d8a00b003a3110488admr11419849wms.179.1658835172032;
        Tue, 26 Jul 2022 04:32:52 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t5TJQWN4Gs3XMULGkUxXsc6Ya6Q5/M/TSkKMiZ24qpRjtIVQ2eT8AeoFxuwfzY0cHqW34Vhw==
X-Received: by 2002:a05:600c:1d8a:b0:3a3:1104:88ad with SMTP id p10-20020a05600c1d8a00b003a3110488admr11419831wms.179.1658835171764;
        Tue, 26 Jul 2022 04:32:51 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id co28-20020a0560000a1c00b0021ea1bcc300sm1489067wrb.56.2022.07.26.04.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 04:32:51 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-wireless@vger.kernel.org, kvalo@kernel.org,
        stable@vger.kernel.org, Gregory Erwin <gregerwin256@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "Eric W . Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH RESEND v11] hwrng: core - let sleep be interrupted when
 unregistering hwrng
In-Reply-To: <Yt+/HvfC+OYRVrr+@zx2c4.com>
References: <20220725215536.767961-1-Jason@zx2c4.com>
 <Yt+3ic4YYpAsUHMF@gondor.apana.org.au> <Yt+/HvfC+OYRVrr+@zx2c4.com>
Date:   Tue, 26 Jul 2022 12:32:50 +0100
Message-ID: <xhsmhpmhsds7x.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26/07/22 12:17, Jason A. Donenfeld wrote:
>>                 if (rc <= 0) {
>> -                       pr_warn("hwrng: no data available\n");
>> -                       msleep_interruptible(10000);
>> +                       set_current_state(TASK_INTERRUPTIBLE);
>> +                       if (kthread_should_stop())
>> +                               __set_current_state(TASK_RUNNING);
>> +                       schedule_timeout(10 * HZ);
>>                         continue;
>>                 }
>
> Here you made a change whose utility I don't understand. My original
> hunk was:
>
> +                       if (kthread_should_stop())
> +                               break;
> +                       schedule_timeout_interruptible(HZ * 10);
>
> Which I think is a bit cleaner, as schedule_timeout_interruptible sets
> the state to INTERRUPTIBLE and such.
>

For any sort of wait loop, you need the state write to happen before the
loop-break condition is checked.

Consider:

  READ kthread_should_stop() == false
                                                  kthread_stop()
                                                    set_bit(KTHREAD_SHOULD_STOP, &kthread->flags);
                                                    wake_up_process(k); // Reads TASK_RUNNING,
  schedule_timeout_interruptible();                                     // does nothing
  // We're now blocked, having missed a wakeup

That's why the canonical wait loop pattern is:

   for (;;) {
      set_current_state(TASK_UNINTERRUPTIBLE);

      if (CONDITION)
         break;

      schedule();
   }
   __set_current_state(TASK_RUNNING);

(grep "wait loop" in kernel/sched/core.c)

> Regards,
> Jason

