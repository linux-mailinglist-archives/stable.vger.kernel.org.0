Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125C96DE9BD
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 04:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjDLC7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 22:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDLC7p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 22:59:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF19E5245
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 19:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681268332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qARMtEZ0RiQtHOJb7ePJUZ0m60eyXWotzhsryqgO/vo=;
        b=N/0MpTr3w1iG2fVTlfHR2HYc88PAwUndjZuemh7cP5mBb/YqxmjP9mmjAgNl81Vr8BC97M
        1CDo7vQYihRERyQG/MEyLH/axeZOkaiHL064zPw+E1J/LVNzJ7AfSW0qJn70MvHj2vlLdi
        dt9W3doIsHZVoXHJGPexRzMWDigAuAA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-106-nuHn94c1OY-FTW1BBqmwVA-1; Tue, 11 Apr 2023 22:58:48 -0400
X-MC-Unique: nuHn94c1OY-FTW1BBqmwVA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 352992807D62;
        Wed, 12 Apr 2023 02:58:48 +0000 (UTC)
Received: from [10.22.33.155] (unknown [10.22.33.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF9E1202701E;
        Wed, 12 Apr 2023 02:58:47 +0000 (UTC)
Message-ID: <5e7d733c-7272-d202-c80a-f8e8f23478d0@redhat.com>
Date:   Tue, 11 Apr 2023 22:58:47 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC][PATCH] locking/rwsem: Add __sched annotation to
 __down_read_common()
Content-Language: en-US
To:     John Stultz <jstultz@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Minchan Kim <minchan@kernel.org>,
        Tim Murray <timmurray@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, kernel-team@android.com,
        stable@vger.kernel.org
References: <20230412023839.2869114-1-jstultz@google.com>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <20230412023839.2869114-1-jstultz@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/11/23 22:38, John Stultz wrote:
> Apparently despite it being marked inline, the compiler
> may not inline __down_read_common() which makes it difficult
> to identify the cause of lock contention, as the blocked
> function will always be listed as __down_read_common().
>
> So this patch adds __sched annotation to the function so
> the calling function will instead be listed.
>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Tim Murray <timmurray@google.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Waiman Long <longman@redhat.com>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: kernel-team@android.com
> Cc: stable@vger.kernel.org
> Fixes: c995e638ccbb ("locking/rwsem: Fold __down_{read,write}*()")
> Reported-by: Tim Murray <timmurray@google.com>
> Signed-off-by: John Stultz <jstultz@google.com>
> ---
>   kernel/locking/rwsem.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
> index acb5a50309a1..cde2f22e65a8 100644
> --- a/kernel/locking/rwsem.c
> +++ b/kernel/locking/rwsem.c
> @@ -1240,7 +1240,7 @@ static struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
>   /*
>    * lock for reading
>    */
> -static inline int __down_read_common(struct rw_semaphore *sem, int state)
> +static inline __sched int __down_read_common(struct rw_semaphore *sem, int state)
>   {
>   	int ret = 0;
>   	long count;

Change inline to __always_inline instead of adding __sched. 
__down_read_common() is not supposed to be a standalone function.

Cheers,
Longman

