Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D368511A8C
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 16:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238001AbiD0OgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 10:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238027AbiD0OgY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 10:36:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4BF5413D51
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 07:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651069991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pCszdxGtpE1ozcn4mZloZJWxhovKrd6sE3m0QUQcezY=;
        b=KHM522vAqW5YlYhVROlL1ykFj+obrSloZko7efXqFHscQrykt4p4gtkEG+nresV7Ktd/QU
        MIlstMabkI/VKMAaQipYcEJMfCzIewYiMEctaZffEmD7WxIW+MF6eWV+KVj0kmuxVRsWn2
        ICHvwwtPceQCzFTZuFyOVvAgueGGb1k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-Ntlq1A14PxCINLPDU2k1Ag-1; Wed, 27 Apr 2022 10:33:07 -0400
X-MC-Unique: Ntlq1A14PxCINLPDU2k1Ag-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 199A818A6592;
        Wed, 27 Apr 2022 14:33:06 +0000 (UTC)
Received: from [10.22.11.205] (unknown [10.22.11.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E09257D274;
        Wed, 27 Apr 2022 14:33:04 +0000 (UTC)
Message-ID: <3791e950-d997-23c0-07ff-909fd170d0a7@redhat.com>
Date:   Wed, 27 Apr 2022 10:33:04 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2] cgroup/cpuset: Remove cpus_allowed/mems_allowed setup
 in cpuset_init_smp()
Content-Language: en-US
To:     =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc:     Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>, ying.huang@intel.com,
        stable@vger.kernel.org
References: <20220425155505.1292896-1-longman@redhat.com>
 <20220427135324.GB9823@blackbody.suse.cz>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <20220427135324.GB9823@blackbody.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,TVD_SUBJ_WIPE_DEBT
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/27/22 09:53, Michal Koutný wrote:
> Hello.
>
> On Mon, Apr 25, 2022 at 11:55:05AM -0400, Waiman Long <longman@redhat.com> wrote:
>> smp_init() is called after the first two init functions.  So we don't
>> have a complete list of active cpus and memory nodes until later in
>> cpuset_init_smp() which is the right time to set up effective_cpus
>> and effective_mems.
> Yes.
>
> 	setup_arch
> 	  prefill_possible_map
> 	cpuset_init (1)
> 	cgroup_init
> 	  cpuset_bind (2a)
> 	...
> 	kernel_init
> 	  kernel_init_freeable
> 	    ...
> 	      cpuset_init_smp (3)
> 	...
> 	...
> 	cpuset_bind (2b)
>
>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 9390bfd9f1cd..6bd8f5ef40fe 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -3390,8 +3390,9 @@ static struct notifier_block cpuset_track_online_nodes_nb = {
>>    */
>>   void __init cpuset_init_smp(void)
>>   {
>> -	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
>> -	top_cpuset.mems_allowed = node_states[N_MEMORY];
>> +	/*
>> +	 * cpus_allowd/mems_allowed will be properly set up in cpuset_bind().
>> +	 */
> IIUC, the comment should say
>
>> +	 * cpus_allowed/mems_allowed were (v2) or will be (v1) properly set up in cpuset_bind().
> (nit)
>
> Reviewed-by: Michal Koutný <mkoutny@suse.com>
>
Thanks for the review. I plan to post v3 with updated commit log and 
comment soon.

Cheers,
Longman

