Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF856757E2
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 15:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbjATO66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 09:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbjATO65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 09:58:57 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D34141B72;
        Fri, 20 Jan 2023 06:58:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674226736; x=1705762736;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gBOkIamQG9QHF/G+o/K7jdNTIqklSm7vqXdeE00im04=;
  b=mKUXBmlskJvFvotzlt/RmAf/zPmcbzAgksE51uLigMaSTbIgtyxjr6M9
   GeJjHzVcF2Iz2d6H7fw2CdDnhz1ZPuFiIN5Mozx6Fxg7bS2NIszLUdIZN
   w4AvrP2FVpx3taGNUATqMlXjB79toy7RXf29FMNSXF/qQ3GDMKHJ1SEv/
   S3gPOB0Z9X8N5D3FgGvIswgU9rlWhCP425aZI9Olhn8LXC93XiwpeGEka
   DvUYv5BHzcT/PQp7GExVRH6WShAVRgvW/TCYIR6LnX9ZUDEWqxO2e7WN9
   N7GgFbG++xDZyh+csLGL9/yUATD8LsKN8guJZLhK01ybq1/2tLOaQMJpA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="352849378"
X-IronPort-AV: E=Sophos;i="5.97,232,1669104000"; 
   d="scan'208";a="352849378"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 06:58:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="638175957"
X-IronPort-AV: E=Sophos;i="5.97,232,1669104000"; 
   d="scan'208";a="638175957"
Received: from avandeve-mobl.amr.corp.intel.com (HELO [10.209.102.161]) ([10.209.102.161])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 06:58:21 -0800
Message-ID: <562c883b-b2c3-3a27-f045-97e7e3281e0b@linux.intel.com>
Date:   Fri, 20 Jan 2023 06:58:20 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] Fix data race in mark_rt_mutex_waiters
Content-Language: en-US
To:     Hernan Ponce de Leon <hernan.poncedeleon@huaweicloud.com>,
        peterz@infradead.org, mingo@redhat.com, will@kernel.org,
        longman@redhat.com, boqun.feng@gmail.com, akpm@osdl.org,
        tglx@linutronix.de, joel@joelfernandes.org, paulmck@kernel.org,
        stern@rowland.harvard.edu, diogo.behrens@huawei.com,
        jonas.oberhauser@huawei.com
Cc:     linux-kernel@vger.kernel.org,
        Hernan Ponce de Leon <hernanl.leon@huawei.com>,
        stable@vger.kernel.org
References: <20230120135525.25561-1-hernan.poncedeleon@huaweicloud.com>
From:   Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <20230120135525.25561-1-hernan.poncedeleon@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/20/2023 5:55 AM, Hernan Ponce de Leon wrote:
> From: Hernan Ponce de Leon <hernanl.leon@huawei.com>
> 

>   kernel/locking/rtmutex.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
> index 010cf4e6d0b8..7ed9472edd48 100644
> --- a/kernel/locking/rtmutex.c
> +++ b/kernel/locking/rtmutex.c
> @@ -235,7 +235,7 @@ static __always_inline void mark_rt_mutex_waiters(struct rt_mutex_base *lock)
>   	unsigned long owner, *p = (unsigned long *) &lock->owner;
>   
>   	do {
> -		owner = *p;
> +		owner = READ_ONCE(*p);
>   	} while (cmpxchg_relaxed(p, owner,


I don't see how this makes any difference at all.
*p can be read a dozen times and it's fine; cmpxchg has barrier semantics for compilers afaics


