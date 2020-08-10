Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71AB1241257
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 23:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgHJV1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 17:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgHJV1l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 17:27:41 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1656C061756
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 14:27:41 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id u20so6435410pfn.0
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 14:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T2E7fCvhQoo0EKuY1FkMZBe1majHfS5x70JwOP7viT8=;
        b=tzGSJhUgo4Stqg9m9fYFe7STsyxf8ORpMXITj1eoKNW+rlNiLHmHVFnWhB9uRaBltL
         nJrL5MHelQug50ljagID8IC/Lv+xrZgjys9bSyFSkRgURcdxg/wmnCRQIyXrMvGr1pVZ
         BsVu5eqmu79ENC7QSQCucNa8nRw6WQoeC5ZXxjFycNVUfYluPUy7mmX/ZD6rknkz96vY
         TbcfVepb4ICWmtu3kJNOV26qyd/RdIGgrbJm6TcIJ83Yg4uN1IrwMgHy0CNf8N47RbJM
         FSeMCTX3DJHI2YvrmJZYbyru7/AAfuiY+QV/xHJVkbolYuYkv2YFPrEAiyxgq42D4GT7
         PohA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T2E7fCvhQoo0EKuY1FkMZBe1majHfS5x70JwOP7viT8=;
        b=GgdHsvV9UyIgghMpEVDS0Xj9ALAcC9bNgzAar8agmnCfICyAg8kEuxezSNY0zt8IDh
         OLctOTQg2/AVacnpLfpVtrD5RONj9g+8dDsgYymk+IZ1P6Mmcf3Y3q6mddsF2RGvk+bq
         0mW4jfPvfGnXBbgR5b8nyx23BbnT9GrG9+wX9WaXH10fU6vktXAlJmMMbBN6/vIJqQTK
         uXW3b160UDs6ro+tGKkerZwl85qHcHGkDpcVfOwtoq/7U6g3nQ4fU0r7+tLj50mY/8T6
         PODoYTg1k6MzgD76OTT5xFFvKa+g6PcOI1gsoxTHROwqekfTPPrkgxw85znbIozJ4Vwt
         ZuAw==
X-Gm-Message-State: AOAM533UK7iSoiy5IdihJ7oc0/x468I7CezSIWLqnjEblznpQ0GloZQ4
        4CRqEaAcIekFRQiG3I3m2g9ICw==
X-Google-Smtp-Source: ABdhPJxWy9kFcHKZD4+kX79bsTsRG6xCqaSMGz3d06TeHL4bji+UoEUpbzMGRsk1HYVowyBi7mCnXg==
X-Received: by 2002:a63:b18:: with SMTP id 24mr24447320pgl.406.1597094861192;
        Mon, 10 Aug 2020 14:27:41 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id a17sm23611786pfk.29.2020.08.10.14.27.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 14:27:40 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
From:   Jens Axboe <axboe@kernel.dk>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Jann Horn <jannh@google.com>, io-uring <io-uring@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Josef <josef.grieb@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
References: <20200808183439.342243-1-axboe@kernel.dk>
 <20200808183439.342243-3-axboe@kernel.dk>
 <20200810114256.GS2674@hirez.programming.kicks-ass.net>
 <a6ee0a6d-5136-4fe9-8906-04fe6420aad9@kernel.dk>
 <07df8ab4-16a8-8537-b4fe-5438bd8110cf@kernel.dk>
 <20200810201213.GB3982@worktop.programming.kicks-ass.net>
 <4a8fa719-330f-d380-522f-15d79c74ca9a@kernel.dk>
 <faf2c2ae-834e-8fa2-12f3-ae07f8a68e14@kernel.dk>
 <CAG48ez0+=+Q0tjdFxjbbZbZJNkimYL9Bd5odr0T9oWwty6qgoQ@mail.gmail.com>
 <03c0e282-5317-ea45-8760-2c3f56eec0c0@kernel.dk>
 <20200810211057.GG3982@worktop.programming.kicks-ass.net>
 <5628f79b-6bfb-b054-742a-282663cb2565@kernel.dk>
Message-ID: <2bc8fdf8-4dc4-9c71-4f7e-2271506b1c3c@kernel.dk>
Date:   Mon, 10 Aug 2020 15:27:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5628f79b-6bfb-b054-742a-282663cb2565@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/10/20 3:12 PM, Jens Axboe wrote:
> On 8/10/20 3:10 PM, Peter Zijlstra wrote:
>> On Mon, Aug 10, 2020 at 03:06:49PM -0600, Jens Axboe wrote:
>>
>>> should work as far as I can tell, but I don't even know if there's a
>>> reliable way to do task_in_kernel().
>>
>> Only on NOHZ_FULL, and tracking that is one of the things that makes it
>> so horribly expensive.
> 
> Probably no other way than to bite the bullet and just use TWA_SIGNAL
> unconditionally...

Is there a safe way to make TWA_SIGNAL notification cheaper? I won't
pretend to fully understand the ordering, Oleg probably has a much
better idea then me...

diff --git a/kernel/task_work.c b/kernel/task_work.c
index 5c0848ca1287..ea2c683c8563 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -42,7 +42,8 @@ task_work_add(struct task_struct *task, struct callback_head *work, int notify)
 		set_notify_resume(task);
 		break;
 	case TWA_SIGNAL:
-		if (lock_task_sighand(task, &flags)) {
+		if (!(task->jobctl & JOBCTL_TASK_WORK) &&
+		    lock_task_sighand(task, &flags)) {
 			task->jobctl |= JOBCTL_TASK_WORK;
 			signal_wake_up(task, 0);
 			unlock_task_sighand(task, &flags);

-- 
Jens Axboe

