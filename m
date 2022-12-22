Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C26D4654708
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 21:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235519AbiLVURM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 15:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235503AbiLVURJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 15:17:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC532FD06
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 12:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671740183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e6xBxYFAMVlhbpKMfEQCPQ1Pgjllc4ppXfabrgMIyFA=;
        b=HSyYNCEd1J/M/RcuSuKVjzyVXHDmpwK9+gEUKl+NK8P2b1IVzXRdUuYlGRVOYR1VUBGZqV
        RUYbXOFjX57LQQmt8zR8i+0HaFbs5z+dXKoSC2f9mCH5PSInav0mnieA+BDF4NysM6KbGh
        5zcg1i1zOt7ay+j2YdQRPT1SCwznK9s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-572-xbPFMbCcPDWhbwxhLollgw-1; Thu, 22 Dec 2022 15:16:17 -0500
X-MC-Unique: xbPFMbCcPDWhbwxhLollgw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF6398533AE;
        Thu, 22 Dec 2022 20:16:16 +0000 (UTC)
Received: from [10.22.33.48] (unknown [10.22.33.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1DBB8492B00;
        Thu, 22 Dec 2022 20:16:16 +0000 (UTC)
Message-ID: <0b70f4c8-55ce-a5cd-cab7-7dfe70e60e99@redhat.com>
Date:   Thu, 22 Dec 2022 15:16:15 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH-tip v2] sched: Fix use-after-free bug in
 dup_user_cpus_ptr()
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Phil Auld <pauld@redhat.com>,
        Wenjie Li <wenjieli@qti.qualcomm.com>,
        =?UTF-8?B?RGF2aWQgV2FuZyDnjovmoIc=?= <wangbiao3@xiaomi.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20221205164832.2151247-1-longman@redhat.com>
 <Y6SxNwUn7/4/8IQa@hirez.programming.kicks-ass.net>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <Y6SxNwUn7/4/8IQa@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 12/22/22 14:34, Peter Zijlstra wrote:
> On Mon, Dec 05, 2022 at 11:48:32AM -0500, Waiman Long wrote:
>> Since commit 07ec77a1d4e8 ("sched: Allow task CPU affinity to be
>> restricted on asymmetric systems"), the setting and clearing of
>> user_cpus_ptr are done under pi_lock for arm64 architecture. However,
>> dup_user_cpus_ptr() accesses user_cpus_ptr without any lock
>> protection. When racing with the clearing of user_cpus_ptr in
>> __set_cpus_allowed_ptr_locked(), it can lead to user-after-free and
>> double-free in arm64 kernel.
> How? the task cannot be in migrate_enable() and fork() at the same time,
> no?
>
I believe a task A can call sched_setaffinity() to modify the cpu 
affinity of a different task, say B, which can be under fork() at the 
same time. So we need to use the pi_lock to synchronize the access of 
user_cpus_ptr to avoid the kind of race that can cause double-free.

Cheers,
Longman

