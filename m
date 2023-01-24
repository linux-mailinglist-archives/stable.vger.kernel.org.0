Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA84679E2E
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 17:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233371AbjAXQGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 11:06:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234011AbjAXQGQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 11:06:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4970146D78
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 08:05:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674576328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3EL7POKx8Wvv5sOQhkGmRPJq/3pYFCs6vacmuLV9dJ8=;
        b=WTa2m+hce02LgqI5kY9/HOZqMh0A7znHKE2L24/U4uXZBLvCaHntfcZWrHQYBaN11ZRLYX
        mewU0ZjFIRJMHu+TOGG84HnNs37w7Pat+6ycsoYqv5dPR+MmOIjpGMBYBc7Ketwgrlaplw
        RQoPzfDFOLmwe3J6e4H+iYYW96j+gCY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-424--JgdwinYNOScQyZrbrSZOg-1; Tue, 24 Jan 2023 11:05:22 -0500
X-MC-Unique: -JgdwinYNOScQyZrbrSZOg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1829C8067FC;
        Tue, 24 Jan 2023 16:05:02 +0000 (UTC)
Received: from [10.22.10.191] (unknown [10.22.10.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C3AA2026D4B;
        Tue, 24 Jan 2023 16:04:59 +0000 (UTC)
Message-ID: <ae90e931-df19-9d60-610c-57dc34494d8e@redhat.com>
Date:   Tue, 24 Jan 2023 11:04:58 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] Fix data race in mark_rt_mutex_waiters
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Hernan Ponce de Leon <hernan.poncedeleon@huaweicloud.com>,
        paulmck@kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        mingo@redhat.com, will@kernel.org, boqun.feng@gmail.com,
        akpm@osdl.org, tglx@linutronix.de, joel@joelfernandes.org,
        stern@rowland.harvard.edu, diogo.behrens@huawei.com,
        jonas.oberhauser@huawei.com, linux-kernel@vger.kernel.org,
        Hernan Ponce de Leon <hernanl.leon@huawei.com>,
        stable@vger.kernel.org
References: <20230120135525.25561-1-hernan.poncedeleon@huaweicloud.com>
 <562c883b-b2c3-3a27-f045-97e7e3281e0b@linux.intel.com>
 <20230120155439.GI2948950@paulmck-ThinkPad-P17-Gen-1>
 <9a1c7959-4b8c-94df-a3e2-e69be72bfd7d@huaweicloud.com>
 <20230123164014.GN2948950@paulmck-ThinkPad-P17-Gen-1>
 <f17dcce0-d510-a112-3127-984e8e73f480@huaweicloud.com>
 <d1e28124-b7a7-ae19-87ec-b1dcd3701b61@redhat.com>
 <Y8/+2YBRD4rFySjh@hirez.programming.kicks-ass.net>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <Y8/+2YBRD4rFySjh@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 1/24/23 10:52, Peter Zijlstra wrote:
> On Tue, Jan 24, 2023 at 10:42:24AM -0500, Waiman Long wrote:
>
>> I would suggest to do it as suggested by PeterZ. Instead of set_bit(),
>> however, it is probably better to use atomic_long_or() like
>>
>> atomic_long_or_relaxed(RT_MUTEX_HAS_WAITERS, (atomic_long_t *)&lock->owner)
> That function doesn't exist, atomic_long_or() is implicitly relaxed for
> not returning a value.
>
You are right. atomic_long_or() doesn't have variants like some others.

Cheers,
Longman

