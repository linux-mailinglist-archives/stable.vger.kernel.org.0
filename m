Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE326E4AFC
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 16:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbjDQOKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 10:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbjDQOKp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 10:10:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890AB7EF2
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 07:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681740550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dq1ZaJrdSpk9YDp+gB/JqY8bgzdWvHUIe3Gl73jkbAI=;
        b=NCLQZAu8GWB6WC07fzAe0KEFn7/F9/2vhQIV4lO/W59J5/F+ZUV+lVtPhXUKTwF3KQn6vz
        YCHLEKP/pQiDM+HaEX6jBKy7Yh2buYb62HxpOOIBIUTOh1XYOM0TDJNurujk6Ti37T6i9g
        ITQdDn2wg+aH3BlleSpQvqBVfiVUEps=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-325-yuJlK1hSNYOJOe91MOXTYg-1; Mon, 17 Apr 2023 10:09:06 -0400
X-MC-Unique: yuJlK1hSNYOJOe91MOXTYg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A5FD102F231;
        Mon, 17 Apr 2023 14:09:05 +0000 (UTC)
Received: from [10.18.17.153] (dhcp-17-153.bos.redhat.com [10.18.17.153])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05EE440C83AC;
        Mon, 17 Apr 2023 14:09:05 +0000 (UTC)
Message-ID: <88977fec-16f9-a507-c717-709d6288084a@redhat.com>
Date:   Mon, 17 Apr 2023 10:09:04 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2] locking/rwsem: Add __always_inline annotation to
 __down_read_common()
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        John Stultz <jstultz@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Tim Murray <timmurray@google.com>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, kernel-team@android.com,
        stable@vger.kernel.org
References: <20230412023839.2869114-1-jstultz@google.com>
 <20230412035905.3184199-1-jstultz@google.com>
 <20230417111949.GJ83892@hirez.programming.kicks-ass.net>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <20230417111949.GJ83892@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 4/17/23 07:19, Peter Zijlstra wrote:
> On Wed, Apr 12, 2023 at 03:59:05AM +0000, John Stultz wrote:
>> Apparently despite it being marked inline, the compiler
>> may not inline __down_read_common() which makes it difficult
>> to identify the cause of lock contention, as the blocked
>> function will always be listed as __down_read_common().
>>
>> So this patch adds __always_inline annotation to the
>> function to force it to be inlines so the calling function
>> will be listed.
> I'm a wee bit confused; what are you looking at? Wchan? What is stopping
> the compiler from now handing you
> __down_read{,_interruptible,_killable}() instead? Is that fine?
>
My theory is that the compiler may refuse to inline __down_read_common() 
because it is called 3 times in order to reduce overall code size. The 
other __down_read*() functions you listed are only called once.

My 2 cents.

Cheers,
Longman

