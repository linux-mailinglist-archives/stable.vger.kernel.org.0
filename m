Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA9D265AA28
	for <lists+stable@lfdr.de>; Sun,  1 Jan 2023 15:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbjAAOQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Jan 2023 09:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjAAOQg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Jan 2023 09:16:36 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D9E264A
        for <stable@vger.kernel.org>; Sun,  1 Jan 2023 06:16:34 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id c11so20642912qtn.11
        for <stable@vger.kernel.org>; Sun, 01 Jan 2023 06:16:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RW5jWyZz8/3sO2rr7DBwG5+wsjocCd9/cH402FJ/K7M=;
        b=iBp2mi+JxiKIZPj5QLWfDaCUG6AcKXfXKyxNV9DmV4pgBPOu3McO5qJsqP/h2zFy3C
         9cLWSN8d21RXJ8z9cEyQtI4tV2rh//zYszg9I/KW6k0BJS4/xNW1ivvAe9bsLHET8pie
         GFZ/HT/uyzORGR28uNy8j6ULZjIOMSsKRGJIo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RW5jWyZz8/3sO2rr7DBwG5+wsjocCd9/cH402FJ/K7M=;
        b=iCsi48o1vd5I1KPVJ/Fcnxm84YSFSe/xoVTHBORU514Db7DhX4O5UsRLs/BbM5qeVl
         7Sdhdvg43m+SZYNFy4cGA0DKZLflHNZpf+M7jRIJ1paihQTMT1U0cVRB481OgxAtrXgE
         YrY/mZ+MF7VZrHBjKCSucnV/3nB0kRMjbDIwPfQ6CrrceWiKD/TXollD1wWbVUnO2XAh
         +AeyBjG7Peyguzv+pxB8pnDrWdu/iZSBKnOSr9XQ20mjQufmOJ07wKqoqwVZnGLaG+OV
         6+GgQ6Th/Gh75NnbM41e5Ne8S1qU1S+ubMDZ+6iA3S2kWM2qihs+pMpzpomT1gmZAals
         GLaA==
X-Gm-Message-State: AFqh2kpV4ttqI19zaXuMWAPB8feKxwoPChw/gaYxz72SnxRoB90o64vR
        cb5wW6iZSqBcCJmQ/CQsxnihqA==
X-Google-Smtp-Source: AMrXdXsnD4zrvDHsbXWTWGOn+OQhNfENC3iogKE8eMX0iVwSRWIaQERdmCYzhlasmrkyK2VaLGHpQw==
X-Received: by 2002:ac8:5453:0:b0:3a8:25be:ba5b with SMTP id d19-20020ac85453000000b003a825beba5bmr47765354qtq.23.1672582593718;
        Sun, 01 Jan 2023 06:16:33 -0800 (PST)
Received: from smtpclient.apple (c-98-249-43-138.hsd1.va.comcast.net. [98.249.43.138])
        by smtp.gmail.com with ESMTPSA id x10-20020a05620a448a00b006ea7f9d8644sm19157688qkp.96.2023.01.01.06.16.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Jan 2023 06:16:32 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Joel Fernandes <joel@joelfernandes.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] torture: Fix hang during kthread shutdown phase
Date:   Sun, 1 Jan 2023 09:16:22 -0500
Message-Id: <C3D1D5E5-B6A7-4D40-B920-8E2AE9BFE22C@joelfernandes.org>
References: <CAABZP2wSoEzfMWRdxGb6TmWVeN4xDUu5qjnG0d8RfaO7AovGZQ@mail.gmail.com>
Cc:     linux-kernel@vger.kernel.org, Paul McKenney <paulmck@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        stable@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>,
        Josh Triplett <josh@joshtriplett.org>
In-Reply-To: <CAABZP2wSoEzfMWRdxGb6TmWVeN4xDUu5qjnG0d8RfaO7AovGZQ@mail.gmail.com>
To:     Zhouyi Zhou <zhouzhouyi@gmail.com>
X-Mailer: iPhone Mail (20B101)
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NORMAL_HTTP_TO_IP,
        NUMERIC_HTTP_ADDR,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Jan 1, 2023, at 8:02 AM, Zhouyi Zhou <zhouzhouyi@gmail.com> wrote:
>=20
> =EF=BB=BFOn Sun, Jan 1, 2023 at 2:16 PM Joel Fernandes (Google)
> <joel@joelfernandes.org> wrote:
>>=20
>> During shutdown of rcutorture, the shutdown thread in
>> rcu_torture_cleanup() calls torture_cleanup_begin() which sets fullstop
>> to FULLSTOP_RMMOD. This is enough to cause the rcutorture threads for
>> readers and fakewriters to breakout of their main while loop and start
>> shutting down.
>>=20
>> Once out of their main loop, they then call torture_kthread_stopping()
>> which in turn waits for kthread_stop() to be called, however
>> rcu_torture_cleanup() has not even called kthread_stop() on those
>> threads yet, it does that a bit later.  However, before it gets a chance
>> to do so, torture_kthread_stopping() calls
>> schedule_timeout_interruptible(1) in a tight loop. Tracing confirmed
>> this makes the timer softirq constantly execute timer callbacks, while
>> never returning back to the softirq exit path and is essentially "locked
>> up" because of that. If the softirq preempts the shutdown thread,
>> kthread_stop() may never be called.
>>=20
>> This commit improves the situation dramatically, by increasing timeout
>> passed to schedule_timeout_interruptible() 1/20th of a second. This
>> causes the timer softirq to not lock up a CPU and everything works fine.
>> Testing has shown 100 runs of TREE07 passing reliably, which was not the
>> case before because of RCU stalls.
> On my Dell PowerEdge R720 with two Intel(R) Xeon(R) CPU E5-2660 128G memor=
y:
> 1) before this patch:
> 3 of 80 rounds failed with "rcu: INFO: rcu_sched detected stalls on
> CPUs/tasks" [1]
> 2) after this patch
> all 80 rounds passed
>=20
> Tested-by: Zhouyi Zhou <zhouzhouyi@gmail.com>
>=20

Thanks! Glad to see your tests look good now.

 - Joel


> Thanks
> Zhouyi
>=20
> [1] http://154.220.3.115/logs/20230101/console.log
>>=20
>> Cc: Paul McKenney <paulmck@kernel.org>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>
>> Cc: <stable@vger.kernel.org> # 6.0.x
>> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
>> ---
>> kernel/torture.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/kernel/torture.c b/kernel/torture.c
>> index 29afc62f2bfe..d024f3b7181f 100644
>> --- a/kernel/torture.c
>> +++ b/kernel/torture.c
>> @@ -915,7 +915,7 @@ void torture_kthread_stopping(char *title)
>>        VERBOSE_TOROUT_STRING(buf);
>>        while (!kthread_should_stop()) {
>>                torture_shutdown_absorb(title);
>> -               schedule_timeout_uninterruptible(1);
>> +               schedule_timeout_uninterruptible(HZ/20);
>>        }
>> }
>> EXPORT_SYMBOL_GPL(torture_kthread_stopping);
>> --
>> 2.39.0.314.g84b9a713c41-goog
>>=20
